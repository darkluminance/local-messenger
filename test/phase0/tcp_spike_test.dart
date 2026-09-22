import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/phase0/tcp_spike.dart';

void main() {
  test('two TCP peers exchange frames concurrently', () async {
    expect(await runSimultaneousTcpPeerSpike(), <String>['peer-a', 'peer-b']);
  });

  test('oversized frames are rejected before transmission', () {
    expect(
      () => encodeBoundedFrame(Uint8List(phase0MaximumFrameBytes + 1)),
      throwsFormatException,
    );
  });
}
