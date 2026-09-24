import 'dart:io';

import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';

const int maximumVisiblePeers = 10;
const int maximumStoredObservations = 64;
const Duration defaultPresenceLifetime = Duration(seconds: 15);

final class DiscoveryRecord {
  const DiscoveryRecord({
    required this.serviceName,
    required this.deviceId,
    required this.profileRevision,
    required this.endpoints,
    this.advertisedName,
  });

  final String serviceName;
  final DeviceId deviceId;
  final int profileRevision;
  final List<PeerEndpoint> endpoints;
  final String? advertisedName;

  static DiscoveryRecord? parse({
    required String serviceName,
    required String type,
    required int port,
    required Map<String, String> attributes,
    required List<String> hostAddresses,
  }) {
    if (serviceName.isEmpty ||
        serviceName.length > 255 ||
        type != '_localmsg._tcp' ||
        port < 1 ||
        port > 65535 ||
        (attributes.length != 4 && attributes.length != 5) ||
        !attributes.keys.toSet().containsAll(const <String>{
          'v',
          'id',
          'caps',
          'profile',
        }) ||
        (attributes.length == 5 && !attributes.containsKey('name')) ||
        attributes['v'] != '1.0') {
      return null;
    }
    final id = attributes['id']!;
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(id)) {
      return null;
    }
    final revision = int.tryParse(attributes['profile']!);
    if (revision == null || revision < 1 || revision > 2147483647) {
      return null;
    }
    final caps = attributes['caps']!;
    if (caps.isEmpty ||
        caps.length > 64 ||
        !RegExp(r'^[a-z0-9]+(?:,[a-z0-9]+)*$').hasMatch(caps)) {
      return null;
    }
    final advertisedName = _validatedAdvertisedName(attributes['name']);
    final endpoints = <PeerEndpoint>{};
    for (final candidate in hostAddresses.take(32)) {
      final normalized = _validatedIpAddress(candidate);
      if (normalized != null) {
        endpoints.add(PeerEndpoint(address: normalized, port: port));
      }
    }
    if (endpoints.isEmpty) {
      return null;
    }
    return DiscoveryRecord(
      serviceName: serviceName,
      deviceId: DeviceId(<int>[
        for (var index = 0; index < id.length; index += 2)
          int.parse(id.substring(index, index + 2), radix: 16),
      ]),
      profileRevision: revision,
      advertisedName: advertisedName,
      endpoints: List<PeerEndpoint>.unmodifiable(endpoints),
    );
  }
}

String? _validatedAdvertisedName(String? candidate) {
  if (candidate == null || candidate.length > maximumDisplayNameBytes) {
    return null;
  }
  try {
    final parsed = DisplayName.parse(candidate);
    if (parsed.value != candidate) {
      return null;
    }
    return parsed.value;
  } on DisplayNameValidationException {
    return null;
  }
}

String? _validatedIpAddress(String candidate) {
  if (candidate.isEmpty || candidate.length > 96) {
    return null;
  }
  final scopeSeparator = candidate.indexOf('%');
  final addressPart = scopeSeparator < 0
      ? candidate
      : candidate.substring(0, scopeSeparator);
  final scope = scopeSeparator < 0
      ? null
      : candidate.substring(scopeSeparator + 1);
  if (scope != null &&
      (scope.isEmpty || !RegExp(r'^[A-Za-z0-9_.-]{1,32}$').hasMatch(scope))) {
    return null;
  }
  final parsed = InternetAddress.tryParse(addressPart);
  if (parsed == null ||
      parsed.isLoopback ||
      parsed.address == '0.0.0.0' ||
      parsed.address == '::' ||
      (scope != null && parsed.type != InternetAddressType.IPv6)) {
    return null;
  }
  final raw = parsed.rawAddress;
  final isLinkLocalV6 =
      parsed.type == InternetAddressType.IPv6 &&
      raw[0] == 0xfe &&
      (raw[1] & 0xc0) == 0x80;
  if (isLinkLocalV6 && scope == null) {
    return null;
  }
  return scope == null ? parsed.address : '$addressPart%$scope';
}

final class PresenceRegistry {
  PresenceRegistry({
    required this.localDeviceId,
    this.lifetime = defaultPresenceLifetime,
    this.maxPeers = maximumVisiblePeers,
  });

  final DeviceId localDeviceId;
  final Duration lifetime;
  final int maxPeers;
  final Map<_ObservationKey, _Observation> _observations =
      <_ObservationKey, _Observation>{};

  bool observe(DiscoveryRecord record, DateTime now) {
    if (record.deviceId == localDeviceId) {
      return false;
    }
    var changed = false;
    final currentEndpoints = record.endpoints.toSet();
    final removed = _observations.keys
        .where(
          (key) =>
              key.serviceName == record.serviceName &&
              !currentEndpoints.contains(key.endpoint),
        )
        .toList();
    for (final key in removed) {
      _observations.remove(key);
    }
    changed = removed.isNotEmpty;
    for (final endpoint in record.endpoints) {
      final key = _ObservationKey(record.serviceName, endpoint);
      final previous = _observations[key];
      _observations[key] = _Observation(
        record.deviceId,
        record.profileRevision,
        record.advertisedName,
        now.toUtc(),
      );
      changed |=
          previous == null ||
          previous.deviceId != record.deviceId ||
          previous.profileRevision != record.profileRevision ||
          previous.advertisedName != record.advertisedName;
    }
    while (_observations.length > maximumStoredObservations) {
      final oldest = _observations.entries.reduce(
        (left, right) =>
            left.value.seenAt.isBefore(right.value.seenAt) ? left : right,
      );
      _observations.remove(oldest.key);
      changed = true;
    }
    return changed;
  }

  bool lose(String serviceName, {List<PeerEndpoint>? endpoints}) {
    final keys = _observations.keys
        .where(
          (_ObservationKey key) =>
              key.serviceName == serviceName &&
              (endpoints == null ||
                  endpoints.isEmpty ||
                  endpoints.contains(key.endpoint)),
        )
        .toList();
    for (final key in keys) {
      _observations.remove(key);
    }
    return keys.isNotEmpty;
  }

  bool expire(DateTime now) {
    final cutoff = now.toUtc().subtract(lifetime);
    final keys = _observations.entries
        .where((entry) => entry.value.seenAt.isBefore(cutoff))
        .map((entry) => entry.key)
        .toList();
    for (final key in keys) {
      _observations.remove(key);
    }
    return keys.isNotEmpty;
  }

  bool clear() {
    final hadEntries = _observations.isNotEmpty;
    _observations.clear();
    return hadEntries;
  }

  List<PeerPresence> get peers {
    final byDevice =
        <DeviceId, List<MapEntry<_ObservationKey, _Observation>>>{};
    for (final entry in _observations.entries) {
      byDevice.putIfAbsent(entry.value.deviceId, () => []).add(entry);
    }
    final sortedIds = byDevice.keys.toList()
      ..sort((left, right) => left.hex.compareTo(right.hex));
    return <PeerPresence>[
      for (final deviceId in sortedIds.take(maxPeers))
        _peerPresence(deviceId, byDevice[deviceId]!),
    ];
  }

  PeerPresence _peerPresence(
    DeviceId deviceId,
    List<MapEntry<_ObservationKey, _Observation>> observations,
  ) {
    final profileRevision = observations
        .map((entry) => entry.value.profileRevision)
        .reduce((left, right) => left > right ? left : right);
    final named =
        observations
            .where(
              (entry) =>
                  entry.value.profileRevision == profileRevision &&
                  entry.value.advertisedName != null,
            )
            .toList()
          ..sort((left, right) {
            final byTime = right.value.seenAt.compareTo(left.value.seenAt);
            if (byTime != 0) return byTime;
            return left.key.serviceName.compareTo(right.key.serviceName);
          });
    return PeerPresence(
      deviceId: deviceId,
      isAvailable: true,
      endpoints: List<PeerEndpoint>.unmodifiable(
        observations.map((entry) => entry.key.endpoint).toSet().toList()..sort(
          (left, right) => left.address.compareTo(right.address) != 0
              ? left.address.compareTo(right.address)
              : left.port.compareTo(right.port),
        ),
      ),
      profileRevision: profileRevision,
      advertisedName: named.isEmpty ? null : named.first.value.advertisedName,
    );
  }
}

final class _ObservationKey {
  const _ObservationKey(this.serviceName, this.endpoint);

  final String serviceName;
  final PeerEndpoint endpoint;

  @override
  bool operator ==(Object other) =>
      other is _ObservationKey &&
      other.serviceName == serviceName &&
      other.endpoint == endpoint;

  @override
  int get hashCode => Object.hash(serviceName, endpoint);
}

final class _Observation {
  const _Observation(
    this.deviceId,
    this.profileRevision,
    this.advertisedName,
    this.seenAt,
  );

  final DeviceId deviceId;
  final int profileRevision;
  final String? advertisedName;
  final DateTime seenAt;
}
