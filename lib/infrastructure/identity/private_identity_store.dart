import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class PrivateIdentityEnvelope {
  PrivateIdentityEnvelope({
    required Uint8List publicKey,
    required Uint8List secretKey,
    required this.displayName,
    required this.profileRevision,
    required this.createdAtMicros,
    required this.updatedAtMicros,
  }) : _publicKey = Uint8List.fromList(publicKey),
       _secretKey = Uint8List.fromList(secretKey);

  factory PrivateIdentityEnvelope.fromJson(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, Object?> || json['version'] != 1) {
      throw const FormatException('Unsupported private identity envelope.');
    }
    return PrivateIdentityEnvelope(
      publicKey: base64Decode(json['publicKey']! as String),
      secretKey: base64Decode(json['secretKey']! as String),
      displayName: json['displayName']! as String,
      profileRevision: json['profileRevision']! as int,
      createdAtMicros: json['createdAtMicros']! as int,
      updatedAtMicros: json['updatedAtMicros']! as int,
    );
  }

  final Uint8List _publicKey;
  final Uint8List _secretKey;
  Uint8List get publicKey => Uint8List.fromList(_publicKey);
  Uint8List get secretKey => Uint8List.fromList(_secretKey);
  final String displayName;
  final int profileRevision;
  final int createdAtMicros;
  final int updatedAtMicros;

  String toJson() => jsonEncode(<String, Object>{
    'version': 1,
    'publicKey': base64Encode(publicKey),
    'secretKey': base64Encode(secretKey),
    'displayName': displayName,
    'profileRevision': profileRevision,
    'createdAtMicros': createdAtMicros,
    'updatedAtMicros': updatedAtMicros,
  });
}

abstract interface class PrivateIdentityStore {
  Future<PrivateIdentityEnvelope?> read();
  Future<void> write(PrivateIdentityEnvelope envelope);
}

final class FlutterSecurePrivateIdentityStore implements PrivateIdentityStore {
  factory FlutterSecurePrivateIdentityStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(
      mOptions: MacOsOptions(usesDataProtectionKeychain: false),
    ),
  }) => FlutterSecurePrivateIdentityStore._(storage);

  FlutterSecurePrivateIdentityStore._(this._storage);

  static const String _storageKey = 'local_messenger.identity.v1';
  final FlutterSecureStorage _storage;

  @override
  Future<PrivateIdentityEnvelope?> read() async {
    final value = await _storage.read(key: _storageKey);
    return value == null ? null : PrivateIdentityEnvelope.fromJson(value);
  }

  @override
  Future<void> write(PrivateIdentityEnvelope envelope) =>
      _storage.write(key: _storageKey, value: envelope.toJson());
}

final class MemoryPrivateIdentityStore implements PrivateIdentityStore {
  PrivateIdentityEnvelope? value;

  @override
  Future<PrivateIdentityEnvelope?> read() async => value;

  @override
  Future<void> write(PrivateIdentityEnvelope envelope) async {
    value = envelope;
  }
}
