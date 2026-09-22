import 'dart:async';

import 'package:bonsoir/bonsoir.dart';

import 'constants.dart';

BonsoirService createDiscoverySpikeService({
  required String deviceId,
  int port = localMessengerDefaultPort,
}) {
  return BonsoirService(
    name: 'local-messenger-$deviceId',
    type: localMessengerServiceType,
    port: port,
    attributes: <String, String>{
      'v': '$localMessengerProtocolMajor.$localMessengerProtocolMinor',
      'id': deviceId,
      'caps': 'text',
      'profile': '1',
    },
  );
}

class DiscoverySpikeSession {
  DiscoverySpikeSession({
    required this.deviceId,
    this.port = localMessengerDefaultPort,
  });

  final String deviceId;
  final int port;
  final List<BonsoirService> resolvedServices = <BonsoirService>[];

  BonsoirBroadcast? _broadcast;
  BonsoirDiscovery? _discovery;
  StreamSubscription<BonsoirDiscoveryEvent>? _events;

  Future<void> start() async {
    final service = createDiscoverySpikeService(deviceId: deviceId, port: port);
    final broadcast = BonsoirBroadcast(service: service, printLogs: false);
    final discovery = BonsoirDiscovery(
      type: localMessengerServiceType,
      printLogs: false,
    );

    await broadcast.initialize();
    await discovery.initialize();
    _events = discovery.eventStream?.listen((BonsoirDiscoveryEvent event) {
      if (event case BonsoirDiscoveryServiceFoundEvent(:final service)) {
        discovery.serviceResolver.resolveService(service);
      } else if (event case BonsoirDiscoveryServiceResolvedEvent(
        :final service,
      )) {
        resolvedServices.add(service);
      }
    });
    await broadcast.start();
    await discovery.start();
    _broadcast = broadcast;
    _discovery = discovery;
  }

  Future<void> stop() async {
    await _events?.cancel();
    await _discovery?.stop();
    await _broadcast?.stop();
  }
}
