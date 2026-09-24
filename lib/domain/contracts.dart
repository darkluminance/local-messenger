import 'dart:typed_data';

import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/domain/messaging.dart';

abstract interface class IdentityRepository {
  Stream<LocalIdentity?> watchIdentity();
  Future<LocalIdentity?> load();
  Future<LocalIdentity> create(DisplayName displayName);
  Future<LocalIdentity> updateDisplayName(DisplayName displayName);
  Future<Uint8List> sign(Uint8List message);
}

abstract interface class OperationStore {
  Future<OperationInsertResult> insert(MessageOperation operation);
  Future<List<FeedHead>> readFrontier(ConversationId conversationId);
  Future<List<MessageOperation>> readRange({
    required ConversationId conversationId,
    required DeviceId authorDeviceId,
    required int afterSequence,
    required int limit,
  });
  Future<void> rebuildMessageProjections();
  Stream<List<VisibleMessage>> watchMessages(ConversationId conversationId);
  Future<void> recordAcknowledgement(DeliveryAcknowledgement acknowledgement);
  Future<void> setRetentionFloor(RetentionFloor floor);
}

abstract interface class ConversationRepository {
  Stream<List<DirectConversation>> watchConversations();
  Future<DirectConversation> openDirectConversation(
    DeviceId localDeviceId,
    DeviceId peerDeviceId,
  );
  Future<MessageOperation> sendText(ConversationId conversationId, String text);
  Future<void> clearLocalHistory(ConversationId conversationId);
}

final class PeerPresence {
  const PeerPresence({
    required this.deviceId,
    required this.isAvailable,
    required this.endpoints,
    required this.profileRevision,
    this.advertisedName,
  });

  final DeviceId deviceId;
  final bool isAvailable;
  final List<PeerEndpoint> endpoints;
  final int profileRevision;

  /// Unauthenticated DNS-SD presentation hint; never use for trust decisions.
  final String? advertisedName;

  String get advertisedFingerprint => deviceId.shortFingerprint;
}

final class PeerEndpoint {
  const PeerEndpoint({required this.address, required this.port});

  final String address;
  final int port;

  @override
  bool operator ==(Object other) =>
      other is PeerEndpoint && other.address == address && other.port == port;

  @override
  int get hashCode => Object.hash(address, port);
}

enum DiscoveryIssue {
  none,
  noNetwork,
  permissionDenied,
  serviceUnavailable,
  resolveFailed,
  interrupted,
}

final class DiscoveryStatus {
  const DiscoveryStatus({
    required this.advertising,
    required this.browsing,
    required this.activeInterfaceCount,
    required this.issue,
    this.detail,
  });

  final bool advertising;
  final bool browsing;
  final int activeInterfaceCount;
  final DiscoveryIssue issue;
  final String? detail;

  bool get isActive => advertising && browsing;
}

abstract interface class PeerDiscovery {
  Stream<List<PeerPresence>> watchPeers();
  Stream<DiscoveryStatus> watchStatus();
  Future<void> advertise({
    required IdentityProfile profile,
    required int port,
    required Set<String> capabilities,
  });
  Future<void> browse();
  Future<void> refreshNetwork({bool restart = false});
  Future<void> stopAdvertising();
  Future<void> stopBrowsing();
}

enum PeerConnectionState { disconnected, connecting, connected, failed }

final class AuthenticatedPeerFrame {
  const AuthenticatedPeerFrame({
    required this.peerDeviceId,
    required this.payload,
  });

  final DeviceId peerDeviceId;
  final Uint8List payload;
}

abstract interface class SecurePeerTransport {
  Stream<PeerConnectionState> watchConnection(DeviceId peerDeviceId);
  Stream<AuthenticatedPeerFrame> watchIncomingFrames();
  Future<void> listen();
  Future<void> connect(DeviceId peerDeviceId, List<PeerEndpoint> endpoints);
  Future<void> send(DeviceId peerDeviceId, Uint8List frame);
  Future<void> disconnect(DeviceId peerDeviceId);
}

abstract interface class SyncEngine {
  Future<void> synchronize(DeviceId peerDeviceId);
  Stream<bool> watchSynchronizing(DeviceId peerDeviceId);
  Future<void> applyOperationBatch(
    DeviceId peerDeviceId,
    List<MessageOperation> operations,
  );
  Future<void> acknowledgeDurableReceipt(
    DeviceId peerDeviceId,
    DeliveryAcknowledgement acknowledgement,
  );
}

enum AvailabilityState { stopped, starting, available, unavailable }

final class AvailabilityDiagnostics {
  const AvailabilityDiagnostics({
    required this.state,
    required this.permissionDenied,
    required this.discoveryActive,
    required this.detail,
  });

  final AvailabilityState state;
  final bool permissionDenied;
  final bool discoveryActive;
  final String? detail;
}

abstract interface class AvailabilityController {
  Stream<AvailabilityState> watchState();
  Stream<AvailabilityDiagnostics> watchDiagnostics();
  Future<void> enable();
  Future<void> disable();
}
