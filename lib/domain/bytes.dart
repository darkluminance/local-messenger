import 'dart:typed_data';

bool bytesEqual(List<int> left, List<int> right) {
  if (left.length != right.length) {
    return false;
  }
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

int compareBytes(List<int> left, List<int> right) {
  final sharedLength = left.length < right.length ? left.length : right.length;
  for (var index = 0; index < sharedLength; index++) {
    final comparison = left[index].compareTo(right[index]);
    if (comparison != 0) {
      return comparison;
    }
  }
  return left.length.compareTo(right.length);
}

String encodeHex(List<int> bytes) =>
    bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

abstract class FixedBytes {
  FixedBytes(List<int> bytes, {required int length})
    : _bytes = Uint8List.fromList(bytes) {
    if (bytes.length != length) {
      throw ArgumentError.value(
        bytes.length,
        'bytes.length',
        'must be $length',
      );
    }
  }

  final Uint8List _bytes;

  Uint8List get bytes => Uint8List.fromList(_bytes);

  String get hex => encodeHex(_bytes);

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is FixedBytes &&
      bytesEqual(_bytes, other._bytes);

  @override
  int get hashCode => Object.hashAll(_bytes);

  @override
  String toString() => hex;
}
