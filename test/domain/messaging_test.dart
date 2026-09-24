import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/domain/identity.dart';
import 'package:local_messenger/domain/messaging.dart';

void main() {
  final first = DeviceId(List<int>.filled(32, 1));
  final second = DeviceId(List<int>.filled(32, 2));

  test('conversation ID is independent of participant order', () {
    expect(
      ConversationId.forParticipants(first, second),
      ConversationId.forParticipants(second, first),
    );
  });

  test('structural validator accepts matching bounded operation', () {
    final conversation = DirectConversation(
      id: ConversationId.forParticipants(first, second),
      firstParticipant: first,
      secondParticipant: second,
      createdAt: DateTime.utc(2026),
    );
    final canonical = Uint8List.fromList(utf8.encode('canonical operation'));
    final operation = MessageOperation(
      id: OperationId.fromCanonicalBytes(canonical),
      protocolVersion: 1,
      conversationId: conversation.id,
      authorDeviceId: first,
      recipientDeviceId: second,
      authorSequence: 1,
      previousOperationId: null,
      authoredAt: DateTime.utc(2026),
      text: 'Hello',
      signature: Uint8List(64),
      canonicalBytes: canonical,
    );

    expect(
      () => const StructuralOperationValidator().validateStatic(
        operation,
        conversation,
      ),
      returnsNormally,
    );
  });

  test('structural validator rejects a forged operation ID', () {
    final conversation = DirectConversation(
      id: ConversationId.forParticipants(first, second),
      firstParticipant: first,
      secondParticipant: second,
      createdAt: DateTime.utc(2026),
    );
    final operation = MessageOperation(
      id: OperationId(List<int>.filled(32, 9)),
      protocolVersion: 1,
      conversationId: conversation.id,
      authorDeviceId: first,
      recipientDeviceId: second,
      authorSequence: 1,
      previousOperationId: null,
      authoredAt: DateTime.utc(2026),
      text: 'Hello',
      signature: Uint8List(64),
      canonicalBytes: Uint8List.fromList(utf8.encode('different')),
    );

    expect(
      () => const StructuralOperationValidator().validateStatic(
        operation,
        conversation,
      ),
      throwsA(
        isA<OperationValidationException>().having(
          (OperationValidationException error) => error.code,
          'code',
          OperationValidationCode.invalidOperationId,
        ),
      ),
    );
  });

  test('operation byte buffers are defensive copies', () {
    final conversation = DirectConversation(
      id: ConversationId.forParticipants(first, second),
      firstParticipant: first,
      secondParticipant: second,
      createdAt: DateTime.utc(2026),
    );
    final canonical = Uint8List.fromList(utf8.encode('immutable'));
    final signature = Uint8List.fromList(<int>[1, 2, 3]);
    final operation = MessageOperation(
      id: OperationId.fromCanonicalBytes(canonical),
      protocolVersion: 1,
      conversationId: conversation.id,
      authorDeviceId: first,
      recipientDeviceId: second,
      authorSequence: 1,
      previousOperationId: null,
      authoredAt: DateTime.utc(2026),
      text: 'Hello',
      signature: signature,
      canonicalBytes: canonical,
    );
    canonical[0] = 0;
    signature[0] = 9;
    operation.canonicalBytes[0] = 0;

    expect(operation.signature.first, 1);
    expect(
      operation.id,
      OperationId.fromCanonicalBytes(operation.canonicalBytes),
    );
  });
}
