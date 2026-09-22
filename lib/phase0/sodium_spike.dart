import 'dart:convert';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

Future<bool> runSodiumNativeAssetSpike() async {
  final sodium = await SodiumInit.init();
  final secretBox = sodium.crypto.secretBox;
  final key = secretBox.keygen();
  try {
    final nonce = sodium.randombytes.buf(secretBox.nonceBytes);
    final message = Uint8List.fromList(utf8.encode('phase-0-encrypted-frame'));
    final cipherText = secretBox.easy(message: message, nonce: nonce, key: key);
    final opened = secretBox.openEasy(
      cipherText: cipherText,
      nonce: nonce,
      key: key,
    );
    return _bytesEqual(message, opened);
  } finally {
    key.dispose();
  }
}

bool _bytesEqual(Uint8List left, Uint8List right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}
