import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/phase0/sodium_spike.dart';

void main() {
  test('libsodium native asset encrypts and decrypts a frame', () async {
    expect(await runSodiumNativeAssetSpike(), isTrue);
  });
}
