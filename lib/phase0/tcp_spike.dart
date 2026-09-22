import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const int phase0MaximumFrameBytes = 64 * 1024;

Future<List<String>> runSimultaneousTcpPeerSpike() async {
  final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final handled = <Future<void>>[];
  final subscription = server.listen((Socket socket) {
    handled.add(_echoOneFrame(socket));
  });

  try {
    final results = await Future.wait(<Future<String>>[
      _exchangeFrame(server.port, 'peer-a'),
      _exchangeFrame(server.port, 'peer-b'),
    ]);
    await Future.wait(handled);
    return results;
  } finally {
    await subscription.cancel();
    await server.close();
  }
}

Future<void> _echoOneFrame(Socket socket) async {
  try {
    final frame = await readBoundedFrame(socket);
    socket.add(encodeBoundedFrame(frame));
    await socket.flush();
  } finally {
    await socket.close();
  }
}

Future<String> _exchangeFrame(int port, String value) async {
  final socket = await Socket.connect(InternetAddress.loopbackIPv4, port);
  try {
    socket.add(encodeBoundedFrame(Uint8List.fromList(utf8.encode(value))));
    await socket.flush();
    return utf8.decode(await readBoundedFrame(socket));
  } finally {
    await socket.close();
  }
}

Uint8List encodeBoundedFrame(Uint8List payload) {
  if (payload.length > phase0MaximumFrameBytes) {
    throw const FormatException('Frame exceeds the 64 KiB Phase 0 bound.');
  }
  final frame = Uint8List(4 + payload.length);
  ByteData.sublistView(frame).setUint32(0, payload.length, Endian.big);
  frame.setRange(4, frame.length, payload);
  return frame;
}

Future<Uint8List> readBoundedFrame(Stream<List<int>> stream) async {
  final iterator = StreamIterator<List<int>>(stream);
  final bytes = <int>[];
  int? payloadLength;
  try {
    while (await iterator.moveNext()) {
      bytes.addAll(iterator.current);
      if (payloadLength == null && bytes.length >= 4) {
        payloadLength = ByteData.sublistView(
          Uint8List.fromList(bytes),
          0,
          4,
        ).getUint32(0, Endian.big);
        if (payloadLength > phase0MaximumFrameBytes) {
          throw const FormatException(
            'Frame exceeds the 64 KiB Phase 0 bound.',
          );
        }
      }
      if (payloadLength != null && bytes.length >= 4 + payloadLength) {
        return Uint8List.fromList(bytes.sublist(4, 4 + payloadLength));
      }
    }
  } finally {
    await iterator.cancel();
  }
  throw const FormatException('Connection ended before the frame completed.');
}
