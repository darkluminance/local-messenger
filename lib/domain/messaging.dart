import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:local_messenger/domain/bytes.dart';
import 'package:local_messenger/domain/identity.dart';

const int maximumMessageTextBytes = 8 * 1024;

final class ConversationId extends FixedBytes {
  ConversationId(super.bytes) : super(length: 32);

  factory ConversationId.forParticipants(DeviceId first, DeviceId second) {
    if (first == second) {
      throw ArgumentError('A direct conversation needs two distinct devices.');
    }
    final participants = [first.bytes, second.bytes]..sort(compareBytes);
    final canonical = Uint8List.fromList([
      ...participants.first,
      ...participants.last,
    ]);
    return ConversationId(sha256.convert(canonical).bytes);
  }
}

final class OperationId extends FixedBytes {
  OperationId(super.bytes) : super(length: 32);

  factory OperationId.fromCanonicalBytes(List<int> bytes) =>
      OperationId(sha256.convert(bytes).bytes);
}

final class DirectConversation {
  DirectConversation({
    required this.id,
    required this.firstParticipant,
    required this.secondParticipant,
    required this.createdAt,
  }) {
    if (firstParticipant == secondParticipant) {
      throw ArgumentError('Conversation participants must be distinct.');
    }
    if (id !=
        ConversationId.forParticipants(firstParticipant, secondParticipant)) {
      throw ArgumentError('Conversation ID does not match its participants.');
    }
  }

  final ConversationId id;
  final DeviceId firstParticipant;
  final DeviceId secondParticipant;
  final DateTime createdAt;

  bool includes(DeviceId deviceId) =>
      firstParticipant == deviceId || secondParticipant == deviceId;
}

final class MessageOperation {
  MessageOperation({
    required this.id,
    required this.protocolVersion,
    required this.conversationId,
    required this.authorDeviceId,
    required this.recipientDeviceId,
    required this.authorSequence,
    required this.previousOperationId,
    required this.authoredAt,
    required this.text,
    required Uint8List signature,
    required Uint8List canonicalBytes,
  }) : _signature = Uint8List.fromList(signature),
       _canonicalBytes = Uint8List.fromList(canonicalBytes);

  final OperationId id;
  final int protocolVersion;
  final ConversationId conversationId;
  final DeviceId authorDeviceId;
  final DeviceId recipientDeviceId;
  final int authorSequence;
  final OperationId? previousOperationId;
  final DateTime authoredAt;
  final String text;
  final Uint8List _signature;
  final Uint8List _canonicalBytes;

  Uint8List get signature => Uint8List.fromList(_signature);
  Uint8List get canonicalBytes => Uint8List.fromList(_canonicalBytes);
}

final class FeedHead {
  const FeedHead({
    required this.conversationId,
    required this.authorDeviceId,
    required this.sequence,
    required this.operationId,
    required this.isQuarantined,
  });

  final ConversationId conversationId;
  final DeviceId authorDeviceId;
  final int sequence;
  final OperationId operationId;
  final bool isQuarantined;
}

final class VisibleMessage {
  const VisibleMessage({required this.operation, required this.deliveryState});

  final MessageOperation operation;
  final DeliveryState deliveryState;
}

final class RetentionFloor {
  const RetentionFloor({
    required this.conversationId,
    required this.authorDeviceId,
    required this.retainedThroughSequence,
  });

  final ConversationId conversationId;
  final DeviceId authorDeviceId;
  final int retainedThroughSequence;
}

final class DeliveryAcknowledgement {
  const DeliveryAcknowledgement({
    required this.conversationId,
    required this.authorDeviceId,
    required this.recipientDeviceId,
    required this.highestSequence,
    required this.updatedAt,
  });

  final ConversationId conversationId;
  final DeviceId authorDeviceId;
  final DeviceId recipientDeviceId;
  final int highestSequence;
  final DateTime updatedAt;
}

enum DeliveryState { queued, delivered }

enum OperationInsertResult { inserted, duplicate, forkQuarantined }

enum OperationValidationCode {
  invalidParticipants,
  invalidConversationId,
  invalidOperationId,
  invalidSequence,
  invalidPreviousOperation,
  textTooLarge,
  invalidText,
  quarantinedFeed,
}

final class OperationValidationException implements Exception {
  const OperationValidationException(this.code, this.message);

  final OperationValidationCode code;
  final String message;

  @override
  String toString() => message;
}

abstract interface class OperationValidator {
  void validateStatic(
    MessageOperation operation,
    DirectConversation conversation,
  );
}

final class StructuralOperationValidator implements OperationValidator {
  const StructuralOperationValidator();

  @override
  void validateStatic(
    MessageOperation operation,
    DirectConversation conversation,
  ) {
    if (operation.protocolVersion != 1) {
      throw const OperationValidationException(
        OperationValidationCode.invalidOperationId,
        'Unsupported operation protocol version.',
      );
    }
    if (!conversation.includes(operation.authorDeviceId) ||
        !conversation.includes(operation.recipientDeviceId) ||
        operation.authorDeviceId == operation.recipientDeviceId) {
      throw const OperationValidationException(
        OperationValidationCode.invalidParticipants,
        'Operation participants do not match the conversation.',
      );
    }
    if (operation.conversationId != conversation.id) {
      throw const OperationValidationException(
        OperationValidationCode.invalidConversationId,
        'Operation conversation ID is invalid.',
      );
    }
    if (operation.id !=
        OperationId.fromCanonicalBytes(operation.canonicalBytes)) {
      throw const OperationValidationException(
        OperationValidationCode.invalidOperationId,
        'Operation ID does not match its canonical bytes.',
      );
    }
    if (operation.authorSequence < 1) {
      throw const OperationValidationException(
        OperationValidationCode.invalidSequence,
        'Operation sequence must begin at one.',
      );
    }
    if (utf8.encode(operation.text).length > maximumMessageTextBytes) {
      throw const OperationValidationException(
        OperationValidationCode.textTooLarge,
        'Message text exceeds the 8 KiB limit.',
      );
    }
    if (operation.text.runes.any((rune) => rune == 0)) {
      throw const OperationValidationException(
        OperationValidationCode.invalidText,
        'Message text cannot contain a null character.',
      );
    }
  }
}
