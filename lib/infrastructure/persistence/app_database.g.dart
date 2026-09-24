// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalProfilesTable extends LocalProfiles
    with TableInfo<$LocalProfilesTable, LocalProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _singletonMeta = const VerificationMeta(
    'singleton',
  );
  @override
  late final GeneratedColumn<int> singleton = GeneratedColumn<int>(
    'singleton',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant<int>(1),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> deviceId = GeneratedColumn<Uint8List>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publicKeyMeta = const VerificationMeta(
    'publicKey',
  );
  @override
  late final GeneratedColumn<Uint8List> publicKey = GeneratedColumn<Uint8List>(
    'public_key',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMicrosMeta = const VerificationMeta(
    'createdAtMicros',
  );
  @override
  late final GeneratedColumn<int> createdAtMicros = GeneratedColumn<int>(
    'created_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMicrosMeta = const VerificationMeta(
    'updatedAtMicros',
  );
  @override
  late final GeneratedColumn<int> updatedAtMicros = GeneratedColumn<int>(
    'updated_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    singleton,
    deviceId,
    publicKey,
    displayName,
    revision,
    createdAtMicros,
    updatedAtMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('singleton')) {
      context.handle(
        _singletonMeta,
        singleton.isAcceptableOrUnknown(data['singleton']!, _singletonMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(
        _publicKeyMeta,
        publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionMeta);
    }
    if (data.containsKey('created_at_micros')) {
      context.handle(
        _createdAtMicrosMeta,
        createdAtMicros.isAcceptableOrUnknown(
          data['created_at_micros']!,
          _createdAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMicrosMeta);
    }
    if (data.containsKey('updated_at_micros')) {
      context.handle(
        _updatedAtMicrosMeta,
        updatedAtMicros.isAcceptableOrUnknown(
          data['updated_at_micros']!,
          _updatedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singleton};
  @override
  LocalProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProfileRow(
      singleton: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}device_id'],
      )!,
      publicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}public_key'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      createdAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_micros'],
      )!,
      updatedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_micros'],
      )!,
    );
  }

  @override
  $LocalProfilesTable createAlias(String alias) {
    return $LocalProfilesTable(attachedDatabase, alias);
  }
}

class LocalProfileRow extends DataClass implements Insertable<LocalProfileRow> {
  final int singleton;
  final Uint8List deviceId;
  final Uint8List publicKey;
  final String displayName;
  final int revision;
  final int createdAtMicros;
  final int updatedAtMicros;
  const LocalProfileRow({
    required this.singleton,
    required this.deviceId,
    required this.publicKey,
    required this.displayName,
    required this.revision,
    required this.createdAtMicros,
    required this.updatedAtMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton'] = Variable<int>(singleton);
    map['device_id'] = Variable<Uint8List>(deviceId);
    map['public_key'] = Variable<Uint8List>(publicKey);
    map['display_name'] = Variable<String>(displayName);
    map['revision'] = Variable<int>(revision);
    map['created_at_micros'] = Variable<int>(createdAtMicros);
    map['updated_at_micros'] = Variable<int>(updatedAtMicros);
    return map;
  }

  LocalProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalProfilesCompanion(
      singleton: Value(singleton),
      deviceId: Value(deviceId),
      publicKey: Value(publicKey),
      displayName: Value(displayName),
      revision: Value(revision),
      createdAtMicros: Value(createdAtMicros),
      updatedAtMicros: Value(updatedAtMicros),
    );
  }

  factory LocalProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProfileRow(
      singleton: serializer.fromJson<int>(json['singleton']),
      deviceId: serializer.fromJson<Uint8List>(json['deviceId']),
      publicKey: serializer.fromJson<Uint8List>(json['publicKey']),
      displayName: serializer.fromJson<String>(json['displayName']),
      revision: serializer.fromJson<int>(json['revision']),
      createdAtMicros: serializer.fromJson<int>(json['createdAtMicros']),
      updatedAtMicros: serializer.fromJson<int>(json['updatedAtMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singleton': serializer.toJson<int>(singleton),
      'deviceId': serializer.toJson<Uint8List>(deviceId),
      'publicKey': serializer.toJson<Uint8List>(publicKey),
      'displayName': serializer.toJson<String>(displayName),
      'revision': serializer.toJson<int>(revision),
      'createdAtMicros': serializer.toJson<int>(createdAtMicros),
      'updatedAtMicros': serializer.toJson<int>(updatedAtMicros),
    };
  }

  LocalProfileRow copyWith({
    int? singleton,
    Uint8List? deviceId,
    Uint8List? publicKey,
    String? displayName,
    int? revision,
    int? createdAtMicros,
    int? updatedAtMicros,
  }) => LocalProfileRow(
    singleton: singleton ?? this.singleton,
    deviceId: deviceId ?? this.deviceId,
    publicKey: publicKey ?? this.publicKey,
    displayName: displayName ?? this.displayName,
    revision: revision ?? this.revision,
    createdAtMicros: createdAtMicros ?? this.createdAtMicros,
    updatedAtMicros: updatedAtMicros ?? this.updatedAtMicros,
  );
  LocalProfileRow copyWithCompanion(LocalProfilesCompanion data) {
    return LocalProfileRow(
      singleton: data.singleton.present ? data.singleton.value : this.singleton,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      revision: data.revision.present ? data.revision.value : this.revision,
      createdAtMicros: data.createdAtMicros.present
          ? data.createdAtMicros.value
          : this.createdAtMicros,
      updatedAtMicros: data.updatedAtMicros.present
          ? data.updatedAtMicros.value
          : this.updatedAtMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfileRow(')
          ..write('singleton: $singleton, ')
          ..write('deviceId: $deviceId, ')
          ..write('publicKey: $publicKey, ')
          ..write('displayName: $displayName, ')
          ..write('revision: $revision, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('updatedAtMicros: $updatedAtMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    singleton,
    $driftBlobEquality.hash(deviceId),
    $driftBlobEquality.hash(publicKey),
    displayName,
    revision,
    createdAtMicros,
    updatedAtMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProfileRow &&
          other.singleton == this.singleton &&
          $driftBlobEquality.equals(other.deviceId, this.deviceId) &&
          $driftBlobEquality.equals(other.publicKey, this.publicKey) &&
          other.displayName == this.displayName &&
          other.revision == this.revision &&
          other.createdAtMicros == this.createdAtMicros &&
          other.updatedAtMicros == this.updatedAtMicros);
}

class LocalProfilesCompanion extends UpdateCompanion<LocalProfileRow> {
  final Value<int> singleton;
  final Value<Uint8List> deviceId;
  final Value<Uint8List> publicKey;
  final Value<String> displayName;
  final Value<int> revision;
  final Value<int> createdAtMicros;
  final Value<int> updatedAtMicros;
  const LocalProfilesCompanion({
    this.singleton = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.revision = const Value.absent(),
    this.createdAtMicros = const Value.absent(),
    this.updatedAtMicros = const Value.absent(),
  });
  LocalProfilesCompanion.insert({
    this.singleton = const Value.absent(),
    required Uint8List deviceId,
    required Uint8List publicKey,
    required String displayName,
    required int revision,
    required int createdAtMicros,
    required int updatedAtMicros,
  }) : deviceId = Value(deviceId),
       publicKey = Value(publicKey),
       displayName = Value(displayName),
       revision = Value(revision),
       createdAtMicros = Value(createdAtMicros),
       updatedAtMicros = Value(updatedAtMicros);
  static Insertable<LocalProfileRow> custom({
    Expression<int>? singleton,
    Expression<Uint8List>? deviceId,
    Expression<Uint8List>? publicKey,
    Expression<String>? displayName,
    Expression<int>? revision,
    Expression<int>? createdAtMicros,
    Expression<int>? updatedAtMicros,
  }) {
    return RawValuesInsertable({
      if (singleton != null) 'singleton': singleton,
      if (deviceId != null) 'device_id': deviceId,
      if (publicKey != null) 'public_key': publicKey,
      if (displayName != null) 'display_name': displayName,
      if (revision != null) 'revision': revision,
      if (createdAtMicros != null) 'created_at_micros': createdAtMicros,
      if (updatedAtMicros != null) 'updated_at_micros': updatedAtMicros,
    });
  }

  LocalProfilesCompanion copyWith({
    Value<int>? singleton,
    Value<Uint8List>? deviceId,
    Value<Uint8List>? publicKey,
    Value<String>? displayName,
    Value<int>? revision,
    Value<int>? createdAtMicros,
    Value<int>? updatedAtMicros,
  }) {
    return LocalProfilesCompanion(
      singleton: singleton ?? this.singleton,
      deviceId: deviceId ?? this.deviceId,
      publicKey: publicKey ?? this.publicKey,
      displayName: displayName ?? this.displayName,
      revision: revision ?? this.revision,
      createdAtMicros: createdAtMicros ?? this.createdAtMicros,
      updatedAtMicros: updatedAtMicros ?? this.updatedAtMicros,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singleton.present) {
      map['singleton'] = Variable<int>(singleton.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<Uint8List>(deviceId.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<Uint8List>(publicKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (createdAtMicros.present) {
      map['created_at_micros'] = Variable<int>(createdAtMicros.value);
    }
    if (updatedAtMicros.present) {
      map['updated_at_micros'] = Variable<int>(updatedAtMicros.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProfilesCompanion(')
          ..write('singleton: $singleton, ')
          ..write('deviceId: $deviceId, ')
          ..write('publicKey: $publicKey, ')
          ..write('displayName: $displayName, ')
          ..write('revision: $revision, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('updatedAtMicros: $updatedAtMicros')
          ..write(')'))
        .toString();
  }
}

class $PinnedPeersTable extends PinnedPeers
    with TableInfo<$PinnedPeersTable, PinnedPeerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedPeersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> deviceId = GeneratedColumn<Uint8List>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publicKeyMeta = const VerificationMeta(
    'publicKey',
  );
  @override
  late final GeneratedColumn<Uint8List> publicKey = GeneratedColumn<Uint8List>(
    'public_key',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileRevisionMeta = const VerificationMeta(
    'profileRevision',
  );
  @override
  late final GeneratedColumn<int> profileRevision = GeneratedColumn<int>(
    'profile_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileCreatedAtMicrosMeta =
      const VerificationMeta('profileCreatedAtMicros');
  @override
  late final GeneratedColumn<int> profileCreatedAtMicros = GeneratedColumn<int>(
    'profile_created_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileUpdatedAtMicrosMeta =
      const VerificationMeta('profileUpdatedAtMicros');
  @override
  late final GeneratedColumn<int> profileUpdatedAtMicros = GeneratedColumn<int>(
    'profile_updated_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinnedAtMicrosMeta = const VerificationMeta(
    'pinnedAtMicros',
  );
  @override
  late final GeneratedColumn<int> pinnedAtMicros = GeneratedColumn<int>(
    'pinned_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastVerifiedAtMicrosMeta =
      const VerificationMeta('lastVerifiedAtMicros');
  @override
  late final GeneratedColumn<int> lastVerifiedAtMicros = GeneratedColumn<int>(
    'last_verified_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trustStateMeta = const VerificationMeta(
    'trustState',
  );
  @override
  late final GeneratedColumn<String> trustState = GeneratedColumn<String>(
    'trust_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    publicKey,
    displayName,
    profileRevision,
    profileCreatedAtMicros,
    profileUpdatedAtMicros,
    pinnedAtMicros,
    lastVerifiedAtMicros,
    trustState,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pinned_peers';
  @override
  VerificationContext validateIntegrity(
    Insertable<PinnedPeerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(
        _publicKeyMeta,
        publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('profile_revision')) {
      context.handle(
        _profileRevisionMeta,
        profileRevision.isAcceptableOrUnknown(
          data['profile_revision']!,
          _profileRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileRevisionMeta);
    }
    if (data.containsKey('profile_created_at_micros')) {
      context.handle(
        _profileCreatedAtMicrosMeta,
        profileCreatedAtMicros.isAcceptableOrUnknown(
          data['profile_created_at_micros']!,
          _profileCreatedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileCreatedAtMicrosMeta);
    }
    if (data.containsKey('profile_updated_at_micros')) {
      context.handle(
        _profileUpdatedAtMicrosMeta,
        profileUpdatedAtMicros.isAcceptableOrUnknown(
          data['profile_updated_at_micros']!,
          _profileUpdatedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileUpdatedAtMicrosMeta);
    }
    if (data.containsKey('pinned_at_micros')) {
      context.handle(
        _pinnedAtMicrosMeta,
        pinnedAtMicros.isAcceptableOrUnknown(
          data['pinned_at_micros']!,
          _pinnedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pinnedAtMicrosMeta);
    }
    if (data.containsKey('last_verified_at_micros')) {
      context.handle(
        _lastVerifiedAtMicrosMeta,
        lastVerifiedAtMicros.isAcceptableOrUnknown(
          data['last_verified_at_micros']!,
          _lastVerifiedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastVerifiedAtMicrosMeta);
    }
    if (data.containsKey('trust_state')) {
      context.handle(
        _trustStateMeta,
        trustState.isAcceptableOrUnknown(data['trust_state']!, _trustStateMeta),
      );
    } else if (isInserting) {
      context.missing(_trustStateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  PinnedPeerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedPeerRow(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}device_id'],
      )!,
      publicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}public_key'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      profileRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_revision'],
      )!,
      profileCreatedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_created_at_micros'],
      )!,
      profileUpdatedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_updated_at_micros'],
      )!,
      pinnedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinned_at_micros'],
      )!,
      lastVerifiedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_verified_at_micros'],
      )!,
      trustState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trust_state'],
      )!,
    );
  }

  @override
  $PinnedPeersTable createAlias(String alias) {
    return $PinnedPeersTable(attachedDatabase, alias);
  }
}

class PinnedPeerRow extends DataClass implements Insertable<PinnedPeerRow> {
  final Uint8List deviceId;
  final Uint8List publicKey;
  final String displayName;
  final int profileRevision;
  final int profileCreatedAtMicros;
  final int profileUpdatedAtMicros;
  final int pinnedAtMicros;
  final int lastVerifiedAtMicros;
  final String trustState;
  const PinnedPeerRow({
    required this.deviceId,
    required this.publicKey,
    required this.displayName,
    required this.profileRevision,
    required this.profileCreatedAtMicros,
    required this.profileUpdatedAtMicros,
    required this.pinnedAtMicros,
    required this.lastVerifiedAtMicros,
    required this.trustState,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<Uint8List>(deviceId);
    map['public_key'] = Variable<Uint8List>(publicKey);
    map['display_name'] = Variable<String>(displayName);
    map['profile_revision'] = Variable<int>(profileRevision);
    map['profile_created_at_micros'] = Variable<int>(profileCreatedAtMicros);
    map['profile_updated_at_micros'] = Variable<int>(profileUpdatedAtMicros);
    map['pinned_at_micros'] = Variable<int>(pinnedAtMicros);
    map['last_verified_at_micros'] = Variable<int>(lastVerifiedAtMicros);
    map['trust_state'] = Variable<String>(trustState);
    return map;
  }

  PinnedPeersCompanion toCompanion(bool nullToAbsent) {
    return PinnedPeersCompanion(
      deviceId: Value(deviceId),
      publicKey: Value(publicKey),
      displayName: Value(displayName),
      profileRevision: Value(profileRevision),
      profileCreatedAtMicros: Value(profileCreatedAtMicros),
      profileUpdatedAtMicros: Value(profileUpdatedAtMicros),
      pinnedAtMicros: Value(pinnedAtMicros),
      lastVerifiedAtMicros: Value(lastVerifiedAtMicros),
      trustState: Value(trustState),
    );
  }

  factory PinnedPeerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedPeerRow(
      deviceId: serializer.fromJson<Uint8List>(json['deviceId']),
      publicKey: serializer.fromJson<Uint8List>(json['publicKey']),
      displayName: serializer.fromJson<String>(json['displayName']),
      profileRevision: serializer.fromJson<int>(json['profileRevision']),
      profileCreatedAtMicros: serializer.fromJson<int>(
        json['profileCreatedAtMicros'],
      ),
      profileUpdatedAtMicros: serializer.fromJson<int>(
        json['profileUpdatedAtMicros'],
      ),
      pinnedAtMicros: serializer.fromJson<int>(json['pinnedAtMicros']),
      lastVerifiedAtMicros: serializer.fromJson<int>(
        json['lastVerifiedAtMicros'],
      ),
      trustState: serializer.fromJson<String>(json['trustState']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<Uint8List>(deviceId),
      'publicKey': serializer.toJson<Uint8List>(publicKey),
      'displayName': serializer.toJson<String>(displayName),
      'profileRevision': serializer.toJson<int>(profileRevision),
      'profileCreatedAtMicros': serializer.toJson<int>(profileCreatedAtMicros),
      'profileUpdatedAtMicros': serializer.toJson<int>(profileUpdatedAtMicros),
      'pinnedAtMicros': serializer.toJson<int>(pinnedAtMicros),
      'lastVerifiedAtMicros': serializer.toJson<int>(lastVerifiedAtMicros),
      'trustState': serializer.toJson<String>(trustState),
    };
  }

  PinnedPeerRow copyWith({
    Uint8List? deviceId,
    Uint8List? publicKey,
    String? displayName,
    int? profileRevision,
    int? profileCreatedAtMicros,
    int? profileUpdatedAtMicros,
    int? pinnedAtMicros,
    int? lastVerifiedAtMicros,
    String? trustState,
  }) => PinnedPeerRow(
    deviceId: deviceId ?? this.deviceId,
    publicKey: publicKey ?? this.publicKey,
    displayName: displayName ?? this.displayName,
    profileRevision: profileRevision ?? this.profileRevision,
    profileCreatedAtMicros:
        profileCreatedAtMicros ?? this.profileCreatedAtMicros,
    profileUpdatedAtMicros:
        profileUpdatedAtMicros ?? this.profileUpdatedAtMicros,
    pinnedAtMicros: pinnedAtMicros ?? this.pinnedAtMicros,
    lastVerifiedAtMicros: lastVerifiedAtMicros ?? this.lastVerifiedAtMicros,
    trustState: trustState ?? this.trustState,
  );
  PinnedPeerRow copyWithCompanion(PinnedPeersCompanion data) {
    return PinnedPeerRow(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      profileRevision: data.profileRevision.present
          ? data.profileRevision.value
          : this.profileRevision,
      profileCreatedAtMicros: data.profileCreatedAtMicros.present
          ? data.profileCreatedAtMicros.value
          : this.profileCreatedAtMicros,
      profileUpdatedAtMicros: data.profileUpdatedAtMicros.present
          ? data.profileUpdatedAtMicros.value
          : this.profileUpdatedAtMicros,
      pinnedAtMicros: data.pinnedAtMicros.present
          ? data.pinnedAtMicros.value
          : this.pinnedAtMicros,
      lastVerifiedAtMicros: data.lastVerifiedAtMicros.present
          ? data.lastVerifiedAtMicros.value
          : this.lastVerifiedAtMicros,
      trustState: data.trustState.present
          ? data.trustState.value
          : this.trustState,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinnedPeerRow(')
          ..write('deviceId: $deviceId, ')
          ..write('publicKey: $publicKey, ')
          ..write('displayName: $displayName, ')
          ..write('profileRevision: $profileRevision, ')
          ..write('profileCreatedAtMicros: $profileCreatedAtMicros, ')
          ..write('profileUpdatedAtMicros: $profileUpdatedAtMicros, ')
          ..write('pinnedAtMicros: $pinnedAtMicros, ')
          ..write('lastVerifiedAtMicros: $lastVerifiedAtMicros, ')
          ..write('trustState: $trustState')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(deviceId),
    $driftBlobEquality.hash(publicKey),
    displayName,
    profileRevision,
    profileCreatedAtMicros,
    profileUpdatedAtMicros,
    pinnedAtMicros,
    lastVerifiedAtMicros,
    trustState,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedPeerRow &&
          $driftBlobEquality.equals(other.deviceId, this.deviceId) &&
          $driftBlobEquality.equals(other.publicKey, this.publicKey) &&
          other.displayName == this.displayName &&
          other.profileRevision == this.profileRevision &&
          other.profileCreatedAtMicros == this.profileCreatedAtMicros &&
          other.profileUpdatedAtMicros == this.profileUpdatedAtMicros &&
          other.pinnedAtMicros == this.pinnedAtMicros &&
          other.lastVerifiedAtMicros == this.lastVerifiedAtMicros &&
          other.trustState == this.trustState);
}

class PinnedPeersCompanion extends UpdateCompanion<PinnedPeerRow> {
  final Value<Uint8List> deviceId;
  final Value<Uint8List> publicKey;
  final Value<String> displayName;
  final Value<int> profileRevision;
  final Value<int> profileCreatedAtMicros;
  final Value<int> profileUpdatedAtMicros;
  final Value<int> pinnedAtMicros;
  final Value<int> lastVerifiedAtMicros;
  final Value<String> trustState;
  final Value<int> rowid;
  const PinnedPeersCompanion({
    this.deviceId = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.displayName = const Value.absent(),
    this.profileRevision = const Value.absent(),
    this.profileCreatedAtMicros = const Value.absent(),
    this.profileUpdatedAtMicros = const Value.absent(),
    this.pinnedAtMicros = const Value.absent(),
    this.lastVerifiedAtMicros = const Value.absent(),
    this.trustState = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PinnedPeersCompanion.insert({
    required Uint8List deviceId,
    required Uint8List publicKey,
    required String displayName,
    required int profileRevision,
    required int profileCreatedAtMicros,
    required int profileUpdatedAtMicros,
    required int pinnedAtMicros,
    required int lastVerifiedAtMicros,
    required String trustState,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       publicKey = Value(publicKey),
       displayName = Value(displayName),
       profileRevision = Value(profileRevision),
       profileCreatedAtMicros = Value(profileCreatedAtMicros),
       profileUpdatedAtMicros = Value(profileUpdatedAtMicros),
       pinnedAtMicros = Value(pinnedAtMicros),
       lastVerifiedAtMicros = Value(lastVerifiedAtMicros),
       trustState = Value(trustState);
  static Insertable<PinnedPeerRow> custom({
    Expression<Uint8List>? deviceId,
    Expression<Uint8List>? publicKey,
    Expression<String>? displayName,
    Expression<int>? profileRevision,
    Expression<int>? profileCreatedAtMicros,
    Expression<int>? profileUpdatedAtMicros,
    Expression<int>? pinnedAtMicros,
    Expression<int>? lastVerifiedAtMicros,
    Expression<String>? trustState,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (publicKey != null) 'public_key': publicKey,
      if (displayName != null) 'display_name': displayName,
      if (profileRevision != null) 'profile_revision': profileRevision,
      if (profileCreatedAtMicros != null)
        'profile_created_at_micros': profileCreatedAtMicros,
      if (profileUpdatedAtMicros != null)
        'profile_updated_at_micros': profileUpdatedAtMicros,
      if (pinnedAtMicros != null) 'pinned_at_micros': pinnedAtMicros,
      if (lastVerifiedAtMicros != null)
        'last_verified_at_micros': lastVerifiedAtMicros,
      if (trustState != null) 'trust_state': trustState,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PinnedPeersCompanion copyWith({
    Value<Uint8List>? deviceId,
    Value<Uint8List>? publicKey,
    Value<String>? displayName,
    Value<int>? profileRevision,
    Value<int>? profileCreatedAtMicros,
    Value<int>? profileUpdatedAtMicros,
    Value<int>? pinnedAtMicros,
    Value<int>? lastVerifiedAtMicros,
    Value<String>? trustState,
    Value<int>? rowid,
  }) {
    return PinnedPeersCompanion(
      deviceId: deviceId ?? this.deviceId,
      publicKey: publicKey ?? this.publicKey,
      displayName: displayName ?? this.displayName,
      profileRevision: profileRevision ?? this.profileRevision,
      profileCreatedAtMicros:
          profileCreatedAtMicros ?? this.profileCreatedAtMicros,
      profileUpdatedAtMicros:
          profileUpdatedAtMicros ?? this.profileUpdatedAtMicros,
      pinnedAtMicros: pinnedAtMicros ?? this.pinnedAtMicros,
      lastVerifiedAtMicros: lastVerifiedAtMicros ?? this.lastVerifiedAtMicros,
      trustState: trustState ?? this.trustState,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<Uint8List>(deviceId.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<Uint8List>(publicKey.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (profileRevision.present) {
      map['profile_revision'] = Variable<int>(profileRevision.value);
    }
    if (profileCreatedAtMicros.present) {
      map['profile_created_at_micros'] = Variable<int>(
        profileCreatedAtMicros.value,
      );
    }
    if (profileUpdatedAtMicros.present) {
      map['profile_updated_at_micros'] = Variable<int>(
        profileUpdatedAtMicros.value,
      );
    }
    if (pinnedAtMicros.present) {
      map['pinned_at_micros'] = Variable<int>(pinnedAtMicros.value);
    }
    if (lastVerifiedAtMicros.present) {
      map['last_verified_at_micros'] = Variable<int>(
        lastVerifiedAtMicros.value,
      );
    }
    if (trustState.present) {
      map['trust_state'] = Variable<String>(trustState.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedPeersCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('publicKey: $publicKey, ')
          ..write('displayName: $displayName, ')
          ..write('profileRevision: $profileRevision, ')
          ..write('profileCreatedAtMicros: $profileCreatedAtMicros, ')
          ..write('profileUpdatedAtMicros: $profileUpdatedAtMicros, ')
          ..write('pinnedAtMicros: $pinnedAtMicros, ')
          ..write('lastVerifiedAtMicros: $lastVerifiedAtMicros, ')
          ..write('trustState: $trustState, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationsTable extends Conversations
    with TableInfo<$ConversationsTable, ConversationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<Uint8List> conversationId =
      GeneratedColumn<Uint8List>(
        'conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _firstParticipantIdMeta =
      const VerificationMeta('firstParticipantId');
  @override
  late final GeneratedColumn<Uint8List> firstParticipantId =
      GeneratedColumn<Uint8List>(
        'first_participant_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _secondParticipantIdMeta =
      const VerificationMeta('secondParticipantId');
  @override
  late final GeneratedColumn<Uint8List> secondParticipantId =
      GeneratedColumn<Uint8List>(
        'second_participant_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMicrosMeta = const VerificationMeta(
    'createdAtMicros',
  );
  @override
  late final GeneratedColumn<int> createdAtMicros = GeneratedColumn<int>(
    'created_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    conversationId,
    firstParticipantId,
    secondParticipantId,
    createdAtMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('first_participant_id')) {
      context.handle(
        _firstParticipantIdMeta,
        firstParticipantId.isAcceptableOrUnknown(
          data['first_participant_id']!,
          _firstParticipantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstParticipantIdMeta);
    }
    if (data.containsKey('second_participant_id')) {
      context.handle(
        _secondParticipantIdMeta,
        secondParticipantId.isAcceptableOrUnknown(
          data['second_participant_id']!,
          _secondParticipantIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_secondParticipantIdMeta);
    }
    if (data.containsKey('created_at_micros')) {
      context.handle(
        _createdAtMicrosMeta,
        createdAtMicros.isAcceptableOrUnknown(
          data['created_at_micros']!,
          _createdAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conversationId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {firstParticipantId, secondParticipantId},
  ];
  @override
  ConversationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationRow(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}conversation_id'],
      )!,
      firstParticipantId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}first_participant_id'],
      )!,
      secondParticipantId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}second_participant_id'],
      )!,
      createdAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_micros'],
      )!,
    );
  }

  @override
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class ConversationRow extends DataClass implements Insertable<ConversationRow> {
  final Uint8List conversationId;
  final Uint8List firstParticipantId;
  final Uint8List secondParticipantId;
  final int createdAtMicros;
  const ConversationRow({
    required this.conversationId,
    required this.firstParticipantId,
    required this.secondParticipantId,
    required this.createdAtMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<Uint8List>(conversationId);
    map['first_participant_id'] = Variable<Uint8List>(firstParticipantId);
    map['second_participant_id'] = Variable<Uint8List>(secondParticipantId);
    map['created_at_micros'] = Variable<int>(createdAtMicros);
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      conversationId: Value(conversationId),
      firstParticipantId: Value(firstParticipantId),
      secondParticipantId: Value(secondParticipantId),
      createdAtMicros: Value(createdAtMicros),
    );
  }

  factory ConversationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationRow(
      conversationId: serializer.fromJson<Uint8List>(json['conversationId']),
      firstParticipantId: serializer.fromJson<Uint8List>(
        json['firstParticipantId'],
      ),
      secondParticipantId: serializer.fromJson<Uint8List>(
        json['secondParticipantId'],
      ),
      createdAtMicros: serializer.fromJson<int>(json['createdAtMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<Uint8List>(conversationId),
      'firstParticipantId': serializer.toJson<Uint8List>(firstParticipantId),
      'secondParticipantId': serializer.toJson<Uint8List>(secondParticipantId),
      'createdAtMicros': serializer.toJson<int>(createdAtMicros),
    };
  }

  ConversationRow copyWith({
    Uint8List? conversationId,
    Uint8List? firstParticipantId,
    Uint8List? secondParticipantId,
    int? createdAtMicros,
  }) => ConversationRow(
    conversationId: conversationId ?? this.conversationId,
    firstParticipantId: firstParticipantId ?? this.firstParticipantId,
    secondParticipantId: secondParticipantId ?? this.secondParticipantId,
    createdAtMicros: createdAtMicros ?? this.createdAtMicros,
  );
  ConversationRow copyWithCompanion(ConversationsCompanion data) {
    return ConversationRow(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      firstParticipantId: data.firstParticipantId.present
          ? data.firstParticipantId.value
          : this.firstParticipantId,
      secondParticipantId: data.secondParticipantId.present
          ? data.secondParticipantId.value
          : this.secondParticipantId,
      createdAtMicros: data.createdAtMicros.present
          ? data.createdAtMicros.value
          : this.createdAtMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationRow(')
          ..write('conversationId: $conversationId, ')
          ..write('firstParticipantId: $firstParticipantId, ')
          ..write('secondParticipantId: $secondParticipantId, ')
          ..write('createdAtMicros: $createdAtMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(conversationId),
    $driftBlobEquality.hash(firstParticipantId),
    $driftBlobEquality.hash(secondParticipantId),
    createdAtMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationRow &&
          $driftBlobEquality.equals(
            other.conversationId,
            this.conversationId,
          ) &&
          $driftBlobEquality.equals(
            other.firstParticipantId,
            this.firstParticipantId,
          ) &&
          $driftBlobEquality.equals(
            other.secondParticipantId,
            this.secondParticipantId,
          ) &&
          other.createdAtMicros == this.createdAtMicros);
}

class ConversationsCompanion extends UpdateCompanion<ConversationRow> {
  final Value<Uint8List> conversationId;
  final Value<Uint8List> firstParticipantId;
  final Value<Uint8List> secondParticipantId;
  final Value<int> createdAtMicros;
  final Value<int> rowid;
  const ConversationsCompanion({
    this.conversationId = const Value.absent(),
    this.firstParticipantId = const Value.absent(),
    this.secondParticipantId = const Value.absent(),
    this.createdAtMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsCompanion.insert({
    required Uint8List conversationId,
    required Uint8List firstParticipantId,
    required Uint8List secondParticipantId,
    required int createdAtMicros,
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       firstParticipantId = Value(firstParticipantId),
       secondParticipantId = Value(secondParticipantId),
       createdAtMicros = Value(createdAtMicros);
  static Insertable<ConversationRow> custom({
    Expression<Uint8List>? conversationId,
    Expression<Uint8List>? firstParticipantId,
    Expression<Uint8List>? secondParticipantId,
    Expression<int>? createdAtMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (firstParticipantId != null)
        'first_participant_id': firstParticipantId,
      if (secondParticipantId != null)
        'second_participant_id': secondParticipantId,
      if (createdAtMicros != null) 'created_at_micros': createdAtMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsCompanion copyWith({
    Value<Uint8List>? conversationId,
    Value<Uint8List>? firstParticipantId,
    Value<Uint8List>? secondParticipantId,
    Value<int>? createdAtMicros,
    Value<int>? rowid,
  }) {
    return ConversationsCompanion(
      conversationId: conversationId ?? this.conversationId,
      firstParticipantId: firstParticipantId ?? this.firstParticipantId,
      secondParticipantId: secondParticipantId ?? this.secondParticipantId,
      createdAtMicros: createdAtMicros ?? this.createdAtMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<Uint8List>(conversationId.value);
    }
    if (firstParticipantId.present) {
      map['first_participant_id'] = Variable<Uint8List>(
        firstParticipantId.value,
      );
    }
    if (secondParticipantId.present) {
      map['second_participant_id'] = Variable<Uint8List>(
        secondParticipantId.value,
      );
    }
    if (createdAtMicros.present) {
      map['created_at_micros'] = Variable<int>(createdAtMicros.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('firstParticipantId: $firstParticipantId, ')
          ..write('secondParticipantId: $secondParticipantId, ')
          ..write('createdAtMicros: $createdAtMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredOperationsTable extends StoredOperations
    with TableInfo<$StoredOperationsTable, StoredOperationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<Uint8List> operationId =
      GeneratedColumn<Uint8List>(
        'operation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _protocolVersionMeta = const VerificationMeta(
    'protocolVersion',
  );
  @override
  late final GeneratedColumn<int> protocolVersion = GeneratedColumn<int>(
    'protocol_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<Uint8List> conversationId =
      GeneratedColumn<Uint8List>(
        'conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _authorDeviceIdMeta = const VerificationMeta(
    'authorDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> authorDeviceId =
      GeneratedColumn<Uint8List>(
        'author_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _recipientDeviceIdMeta = const VerificationMeta(
    'recipientDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> recipientDeviceId =
      GeneratedColumn<Uint8List>(
        'recipient_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _authorSequenceMeta = const VerificationMeta(
    'authorSequence',
  );
  @override
  late final GeneratedColumn<int> authorSequence = GeneratedColumn<int>(
    'author_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousOperationIdMeta =
      const VerificationMeta('previousOperationId');
  @override
  late final GeneratedColumn<Uint8List> previousOperationId =
      GeneratedColumn<Uint8List>(
        'previous_operation_id',
        aliasedName,
        true,
        type: DriftSqlType.blob,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _authoredAtMicrosMeta = const VerificationMeta(
    'authoredAtMicros',
  );
  @override
  late final GeneratedColumn<int> authoredAtMicros = GeneratedColumn<int>(
    'authored_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageTextMeta = const VerificationMeta(
    'messageText',
  );
  @override
  late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
    'message_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _signatureMeta = const VerificationMeta(
    'signature',
  );
  @override
  late final GeneratedColumn<Uint8List> signature = GeneratedColumn<Uint8List>(
    'signature',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalBytesMeta = const VerificationMeta(
    'canonicalBytes',
  );
  @override
  late final GeneratedColumn<Uint8List> canonicalBytes =
      GeneratedColumn<Uint8List>(
        'canonical_bytes',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _receivedAtMicrosMeta = const VerificationMeta(
    'receivedAtMicros',
  );
  @override
  late final GeneratedColumn<int> receivedAtMicros = GeneratedColumn<int>(
    'received_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    protocolVersion,
    conversationId,
    authorDeviceId,
    recipientDeviceId,
    authorSequence,
    previousOperationId,
    authoredAtMicros,
    messageText,
    signature,
    canonicalBytes,
    receivedAtMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredOperationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('protocol_version')) {
      context.handle(
        _protocolVersionMeta,
        protocolVersion.isAcceptableOrUnknown(
          data['protocol_version']!,
          _protocolVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_protocolVersionMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('author_device_id')) {
      context.handle(
        _authorDeviceIdMeta,
        authorDeviceId.isAcceptableOrUnknown(
          data['author_device_id']!,
          _authorDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorDeviceIdMeta);
    }
    if (data.containsKey('recipient_device_id')) {
      context.handle(
        _recipientDeviceIdMeta,
        recipientDeviceId.isAcceptableOrUnknown(
          data['recipient_device_id']!,
          _recipientDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientDeviceIdMeta);
    }
    if (data.containsKey('author_sequence')) {
      context.handle(
        _authorSequenceMeta,
        authorSequence.isAcceptableOrUnknown(
          data['author_sequence']!,
          _authorSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorSequenceMeta);
    }
    if (data.containsKey('previous_operation_id')) {
      context.handle(
        _previousOperationIdMeta,
        previousOperationId.isAcceptableOrUnknown(
          data['previous_operation_id']!,
          _previousOperationIdMeta,
        ),
      );
    }
    if (data.containsKey('authored_at_micros')) {
      context.handle(
        _authoredAtMicrosMeta,
        authoredAtMicros.isAcceptableOrUnknown(
          data['authored_at_micros']!,
          _authoredAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authoredAtMicrosMeta);
    }
    if (data.containsKey('message_text')) {
      context.handle(
        _messageTextMeta,
        messageText.isAcceptableOrUnknown(
          data['message_text']!,
          _messageTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_messageTextMeta);
    }
    if (data.containsKey('signature')) {
      context.handle(
        _signatureMeta,
        signature.isAcceptableOrUnknown(data['signature']!, _signatureMeta),
      );
    } else if (isInserting) {
      context.missing(_signatureMeta);
    }
    if (data.containsKey('canonical_bytes')) {
      context.handle(
        _canonicalBytesMeta,
        canonicalBytes.isAcceptableOrUnknown(
          data['canonical_bytes']!,
          _canonicalBytesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalBytesMeta);
    }
    if (data.containsKey('received_at_micros')) {
      context.handle(
        _receivedAtMicrosMeta,
        receivedAtMicros.isAcceptableOrUnknown(
          data['received_at_micros']!,
          _receivedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {conversationId, authorDeviceId, authorSequence},
  ];
  @override
  StoredOperationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredOperationRow(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}operation_id'],
      )!,
      protocolVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protocol_version'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}conversation_id'],
      )!,
      authorDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}author_device_id'],
      )!,
      recipientDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}recipient_device_id'],
      )!,
      authorSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}author_sequence'],
      )!,
      previousOperationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}previous_operation_id'],
      ),
      authoredAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}authored_at_micros'],
      )!,
      messageText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_text'],
      )!,
      signature: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}signature'],
      )!,
      canonicalBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}canonical_bytes'],
      )!,
      receivedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received_at_micros'],
      )!,
    );
  }

  @override
  $StoredOperationsTable createAlias(String alias) {
    return $StoredOperationsTable(attachedDatabase, alias);
  }
}

class StoredOperationRow extends DataClass
    implements Insertable<StoredOperationRow> {
  final Uint8List operationId;
  final int protocolVersion;
  final Uint8List conversationId;
  final Uint8List authorDeviceId;
  final Uint8List recipientDeviceId;
  final int authorSequence;
  final Uint8List? previousOperationId;
  final int authoredAtMicros;
  final String messageText;
  final Uint8List signature;
  final Uint8List canonicalBytes;
  final int receivedAtMicros;
  const StoredOperationRow({
    required this.operationId,
    required this.protocolVersion,
    required this.conversationId,
    required this.authorDeviceId,
    required this.recipientDeviceId,
    required this.authorSequence,
    this.previousOperationId,
    required this.authoredAtMicros,
    required this.messageText,
    required this.signature,
    required this.canonicalBytes,
    required this.receivedAtMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<Uint8List>(operationId);
    map['protocol_version'] = Variable<int>(protocolVersion);
    map['conversation_id'] = Variable<Uint8List>(conversationId);
    map['author_device_id'] = Variable<Uint8List>(authorDeviceId);
    map['recipient_device_id'] = Variable<Uint8List>(recipientDeviceId);
    map['author_sequence'] = Variable<int>(authorSequence);
    if (!nullToAbsent || previousOperationId != null) {
      map['previous_operation_id'] = Variable<Uint8List>(previousOperationId);
    }
    map['authored_at_micros'] = Variable<int>(authoredAtMicros);
    map['message_text'] = Variable<String>(messageText);
    map['signature'] = Variable<Uint8List>(signature);
    map['canonical_bytes'] = Variable<Uint8List>(canonicalBytes);
    map['received_at_micros'] = Variable<int>(receivedAtMicros);
    return map;
  }

  StoredOperationsCompanion toCompanion(bool nullToAbsent) {
    return StoredOperationsCompanion(
      operationId: Value(operationId),
      protocolVersion: Value(protocolVersion),
      conversationId: Value(conversationId),
      authorDeviceId: Value(authorDeviceId),
      recipientDeviceId: Value(recipientDeviceId),
      authorSequence: Value(authorSequence),
      previousOperationId: previousOperationId == null && nullToAbsent
          ? const Value.absent()
          : Value(previousOperationId),
      authoredAtMicros: Value(authoredAtMicros),
      messageText: Value(messageText),
      signature: Value(signature),
      canonicalBytes: Value(canonicalBytes),
      receivedAtMicros: Value(receivedAtMicros),
    );
  }

  factory StoredOperationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredOperationRow(
      operationId: serializer.fromJson<Uint8List>(json['operationId']),
      protocolVersion: serializer.fromJson<int>(json['protocolVersion']),
      conversationId: serializer.fromJson<Uint8List>(json['conversationId']),
      authorDeviceId: serializer.fromJson<Uint8List>(json['authorDeviceId']),
      recipientDeviceId: serializer.fromJson<Uint8List>(
        json['recipientDeviceId'],
      ),
      authorSequence: serializer.fromJson<int>(json['authorSequence']),
      previousOperationId: serializer.fromJson<Uint8List?>(
        json['previousOperationId'],
      ),
      authoredAtMicros: serializer.fromJson<int>(json['authoredAtMicros']),
      messageText: serializer.fromJson<String>(json['messageText']),
      signature: serializer.fromJson<Uint8List>(json['signature']),
      canonicalBytes: serializer.fromJson<Uint8List>(json['canonicalBytes']),
      receivedAtMicros: serializer.fromJson<int>(json['receivedAtMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<Uint8List>(operationId),
      'protocolVersion': serializer.toJson<int>(protocolVersion),
      'conversationId': serializer.toJson<Uint8List>(conversationId),
      'authorDeviceId': serializer.toJson<Uint8List>(authorDeviceId),
      'recipientDeviceId': serializer.toJson<Uint8List>(recipientDeviceId),
      'authorSequence': serializer.toJson<int>(authorSequence),
      'previousOperationId': serializer.toJson<Uint8List?>(previousOperationId),
      'authoredAtMicros': serializer.toJson<int>(authoredAtMicros),
      'messageText': serializer.toJson<String>(messageText),
      'signature': serializer.toJson<Uint8List>(signature),
      'canonicalBytes': serializer.toJson<Uint8List>(canonicalBytes),
      'receivedAtMicros': serializer.toJson<int>(receivedAtMicros),
    };
  }

  StoredOperationRow copyWith({
    Uint8List? operationId,
    int? protocolVersion,
    Uint8List? conversationId,
    Uint8List? authorDeviceId,
    Uint8List? recipientDeviceId,
    int? authorSequence,
    Value<Uint8List?> previousOperationId = const Value.absent(),
    int? authoredAtMicros,
    String? messageText,
    Uint8List? signature,
    Uint8List? canonicalBytes,
    int? receivedAtMicros,
  }) => StoredOperationRow(
    operationId: operationId ?? this.operationId,
    protocolVersion: protocolVersion ?? this.protocolVersion,
    conversationId: conversationId ?? this.conversationId,
    authorDeviceId: authorDeviceId ?? this.authorDeviceId,
    recipientDeviceId: recipientDeviceId ?? this.recipientDeviceId,
    authorSequence: authorSequence ?? this.authorSequence,
    previousOperationId: previousOperationId.present
        ? previousOperationId.value
        : this.previousOperationId,
    authoredAtMicros: authoredAtMicros ?? this.authoredAtMicros,
    messageText: messageText ?? this.messageText,
    signature: signature ?? this.signature,
    canonicalBytes: canonicalBytes ?? this.canonicalBytes,
    receivedAtMicros: receivedAtMicros ?? this.receivedAtMicros,
  );
  StoredOperationRow copyWithCompanion(StoredOperationsCompanion data) {
    return StoredOperationRow(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      protocolVersion: data.protocolVersion.present
          ? data.protocolVersion.value
          : this.protocolVersion,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      authorDeviceId: data.authorDeviceId.present
          ? data.authorDeviceId.value
          : this.authorDeviceId,
      recipientDeviceId: data.recipientDeviceId.present
          ? data.recipientDeviceId.value
          : this.recipientDeviceId,
      authorSequence: data.authorSequence.present
          ? data.authorSequence.value
          : this.authorSequence,
      previousOperationId: data.previousOperationId.present
          ? data.previousOperationId.value
          : this.previousOperationId,
      authoredAtMicros: data.authoredAtMicros.present
          ? data.authoredAtMicros.value
          : this.authoredAtMicros,
      messageText: data.messageText.present
          ? data.messageText.value
          : this.messageText,
      signature: data.signature.present ? data.signature.value : this.signature,
      canonicalBytes: data.canonicalBytes.present
          ? data.canonicalBytes.value
          : this.canonicalBytes,
      receivedAtMicros: data.receivedAtMicros.present
          ? data.receivedAtMicros.value
          : this.receivedAtMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredOperationRow(')
          ..write('operationId: $operationId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('recipientDeviceId: $recipientDeviceId, ')
          ..write('authorSequence: $authorSequence, ')
          ..write('previousOperationId: $previousOperationId, ')
          ..write('authoredAtMicros: $authoredAtMicros, ')
          ..write('messageText: $messageText, ')
          ..write('signature: $signature, ')
          ..write('canonicalBytes: $canonicalBytes, ')
          ..write('receivedAtMicros: $receivedAtMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(operationId),
    protocolVersion,
    $driftBlobEquality.hash(conversationId),
    $driftBlobEquality.hash(authorDeviceId),
    $driftBlobEquality.hash(recipientDeviceId),
    authorSequence,
    $driftBlobEquality.hash(previousOperationId),
    authoredAtMicros,
    messageText,
    $driftBlobEquality.hash(signature),
    $driftBlobEquality.hash(canonicalBytes),
    receivedAtMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredOperationRow &&
          $driftBlobEquality.equals(other.operationId, this.operationId) &&
          other.protocolVersion == this.protocolVersion &&
          $driftBlobEquality.equals(
            other.conversationId,
            this.conversationId,
          ) &&
          $driftBlobEquality.equals(
            other.authorDeviceId,
            this.authorDeviceId,
          ) &&
          $driftBlobEquality.equals(
            other.recipientDeviceId,
            this.recipientDeviceId,
          ) &&
          other.authorSequence == this.authorSequence &&
          $driftBlobEquality.equals(
            other.previousOperationId,
            this.previousOperationId,
          ) &&
          other.authoredAtMicros == this.authoredAtMicros &&
          other.messageText == this.messageText &&
          $driftBlobEquality.equals(other.signature, this.signature) &&
          $driftBlobEquality.equals(
            other.canonicalBytes,
            this.canonicalBytes,
          ) &&
          other.receivedAtMicros == this.receivedAtMicros);
}

class StoredOperationsCompanion extends UpdateCompanion<StoredOperationRow> {
  final Value<Uint8List> operationId;
  final Value<int> protocolVersion;
  final Value<Uint8List> conversationId;
  final Value<Uint8List> authorDeviceId;
  final Value<Uint8List> recipientDeviceId;
  final Value<int> authorSequence;
  final Value<Uint8List?> previousOperationId;
  final Value<int> authoredAtMicros;
  final Value<String> messageText;
  final Value<Uint8List> signature;
  final Value<Uint8List> canonicalBytes;
  final Value<int> receivedAtMicros;
  final Value<int> rowid;
  const StoredOperationsCompanion({
    this.operationId = const Value.absent(),
    this.protocolVersion = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.authorDeviceId = const Value.absent(),
    this.recipientDeviceId = const Value.absent(),
    this.authorSequence = const Value.absent(),
    this.previousOperationId = const Value.absent(),
    this.authoredAtMicros = const Value.absent(),
    this.messageText = const Value.absent(),
    this.signature = const Value.absent(),
    this.canonicalBytes = const Value.absent(),
    this.receivedAtMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredOperationsCompanion.insert({
    required Uint8List operationId,
    required int protocolVersion,
    required Uint8List conversationId,
    required Uint8List authorDeviceId,
    required Uint8List recipientDeviceId,
    required int authorSequence,
    this.previousOperationId = const Value.absent(),
    required int authoredAtMicros,
    required String messageText,
    required Uint8List signature,
    required Uint8List canonicalBytes,
    required int receivedAtMicros,
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       protocolVersion = Value(protocolVersion),
       conversationId = Value(conversationId),
       authorDeviceId = Value(authorDeviceId),
       recipientDeviceId = Value(recipientDeviceId),
       authorSequence = Value(authorSequence),
       authoredAtMicros = Value(authoredAtMicros),
       messageText = Value(messageText),
       signature = Value(signature),
       canonicalBytes = Value(canonicalBytes),
       receivedAtMicros = Value(receivedAtMicros);
  static Insertable<StoredOperationRow> custom({
    Expression<Uint8List>? operationId,
    Expression<int>? protocolVersion,
    Expression<Uint8List>? conversationId,
    Expression<Uint8List>? authorDeviceId,
    Expression<Uint8List>? recipientDeviceId,
    Expression<int>? authorSequence,
    Expression<Uint8List>? previousOperationId,
    Expression<int>? authoredAtMicros,
    Expression<String>? messageText,
    Expression<Uint8List>? signature,
    Expression<Uint8List>? canonicalBytes,
    Expression<int>? receivedAtMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (protocolVersion != null) 'protocol_version': protocolVersion,
      if (conversationId != null) 'conversation_id': conversationId,
      if (authorDeviceId != null) 'author_device_id': authorDeviceId,
      if (recipientDeviceId != null) 'recipient_device_id': recipientDeviceId,
      if (authorSequence != null) 'author_sequence': authorSequence,
      if (previousOperationId != null)
        'previous_operation_id': previousOperationId,
      if (authoredAtMicros != null) 'authored_at_micros': authoredAtMicros,
      if (messageText != null) 'message_text': messageText,
      if (signature != null) 'signature': signature,
      if (canonicalBytes != null) 'canonical_bytes': canonicalBytes,
      if (receivedAtMicros != null) 'received_at_micros': receivedAtMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredOperationsCompanion copyWith({
    Value<Uint8List>? operationId,
    Value<int>? protocolVersion,
    Value<Uint8List>? conversationId,
    Value<Uint8List>? authorDeviceId,
    Value<Uint8List>? recipientDeviceId,
    Value<int>? authorSequence,
    Value<Uint8List?>? previousOperationId,
    Value<int>? authoredAtMicros,
    Value<String>? messageText,
    Value<Uint8List>? signature,
    Value<Uint8List>? canonicalBytes,
    Value<int>? receivedAtMicros,
    Value<int>? rowid,
  }) {
    return StoredOperationsCompanion(
      operationId: operationId ?? this.operationId,
      protocolVersion: protocolVersion ?? this.protocolVersion,
      conversationId: conversationId ?? this.conversationId,
      authorDeviceId: authorDeviceId ?? this.authorDeviceId,
      recipientDeviceId: recipientDeviceId ?? this.recipientDeviceId,
      authorSequence: authorSequence ?? this.authorSequence,
      previousOperationId: previousOperationId ?? this.previousOperationId,
      authoredAtMicros: authoredAtMicros ?? this.authoredAtMicros,
      messageText: messageText ?? this.messageText,
      signature: signature ?? this.signature,
      canonicalBytes: canonicalBytes ?? this.canonicalBytes,
      receivedAtMicros: receivedAtMicros ?? this.receivedAtMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<Uint8List>(operationId.value);
    }
    if (protocolVersion.present) {
      map['protocol_version'] = Variable<int>(protocolVersion.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<Uint8List>(conversationId.value);
    }
    if (authorDeviceId.present) {
      map['author_device_id'] = Variable<Uint8List>(authorDeviceId.value);
    }
    if (recipientDeviceId.present) {
      map['recipient_device_id'] = Variable<Uint8List>(recipientDeviceId.value);
    }
    if (authorSequence.present) {
      map['author_sequence'] = Variable<int>(authorSequence.value);
    }
    if (previousOperationId.present) {
      map['previous_operation_id'] = Variable<Uint8List>(
        previousOperationId.value,
      );
    }
    if (authoredAtMicros.present) {
      map['authored_at_micros'] = Variable<int>(authoredAtMicros.value);
    }
    if (messageText.present) {
      map['message_text'] = Variable<String>(messageText.value);
    }
    if (signature.present) {
      map['signature'] = Variable<Uint8List>(signature.value);
    }
    if (canonicalBytes.present) {
      map['canonical_bytes'] = Variable<Uint8List>(canonicalBytes.value);
    }
    if (receivedAtMicros.present) {
      map['received_at_micros'] = Variable<int>(receivedAtMicros.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredOperationsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('protocolVersion: $protocolVersion, ')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('recipientDeviceId: $recipientDeviceId, ')
          ..write('authorSequence: $authorSequence, ')
          ..write('previousOperationId: $previousOperationId, ')
          ..write('authoredAtMicros: $authoredAtMicros, ')
          ..write('messageText: $messageText, ')
          ..write('signature: $signature, ')
          ..write('canonicalBytes: $canonicalBytes, ')
          ..write('receivedAtMicros: $receivedAtMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeedHeadsTable extends FeedHeads
    with TableInfo<$FeedHeadsTable, FeedHeadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedHeadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<Uint8List> conversationId =
      GeneratedColumn<Uint8List>(
        'conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _authorDeviceIdMeta = const VerificationMeta(
    'authorDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> authorDeviceId =
      GeneratedColumn<Uint8List>(
        'author_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _headSequenceMeta = const VerificationMeta(
    'headSequence',
  );
  @override
  late final GeneratedColumn<int> headSequence = GeneratedColumn<int>(
    'head_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headOperationIdMeta = const VerificationMeta(
    'headOperationId',
  );
  @override
  late final GeneratedColumn<Uint8List> headOperationId =
      GeneratedColumn<Uint8List>(
        'head_operation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isQuarantinedMeta = const VerificationMeta(
    'isQuarantined',
  );
  @override
  late final GeneratedColumn<bool> isQuarantined = GeneratedColumn<bool>(
    'is_quarantined',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_quarantined" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    conversationId,
    authorDeviceId,
    headSequence,
    headOperationId,
    isQuarantined,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feed_heads';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedHeadRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('author_device_id')) {
      context.handle(
        _authorDeviceIdMeta,
        authorDeviceId.isAcceptableOrUnknown(
          data['author_device_id']!,
          _authorDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorDeviceIdMeta);
    }
    if (data.containsKey('head_sequence')) {
      context.handle(
        _headSequenceMeta,
        headSequence.isAcceptableOrUnknown(
          data['head_sequence']!,
          _headSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_headSequenceMeta);
    }
    if (data.containsKey('head_operation_id')) {
      context.handle(
        _headOperationIdMeta,
        headOperationId.isAcceptableOrUnknown(
          data['head_operation_id']!,
          _headOperationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_headOperationIdMeta);
    }
    if (data.containsKey('is_quarantined')) {
      context.handle(
        _isQuarantinedMeta,
        isQuarantined.isAcceptableOrUnknown(
          data['is_quarantined']!,
          _isQuarantinedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conversationId, authorDeviceId};
  @override
  FeedHeadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedHeadRow(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}conversation_id'],
      )!,
      authorDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}author_device_id'],
      )!,
      headSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}head_sequence'],
      )!,
      headOperationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}head_operation_id'],
      )!,
      isQuarantined: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_quarantined'],
      )!,
    );
  }

  @override
  $FeedHeadsTable createAlias(String alias) {
    return $FeedHeadsTable(attachedDatabase, alias);
  }
}

class FeedHeadRow extends DataClass implements Insertable<FeedHeadRow> {
  final Uint8List conversationId;
  final Uint8List authorDeviceId;
  final int headSequence;
  final Uint8List headOperationId;
  final bool isQuarantined;
  const FeedHeadRow({
    required this.conversationId,
    required this.authorDeviceId,
    required this.headSequence,
    required this.headOperationId,
    required this.isQuarantined,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<Uint8List>(conversationId);
    map['author_device_id'] = Variable<Uint8List>(authorDeviceId);
    map['head_sequence'] = Variable<int>(headSequence);
    map['head_operation_id'] = Variable<Uint8List>(headOperationId);
    map['is_quarantined'] = Variable<bool>(isQuarantined);
    return map;
  }

  FeedHeadsCompanion toCompanion(bool nullToAbsent) {
    return FeedHeadsCompanion(
      conversationId: Value(conversationId),
      authorDeviceId: Value(authorDeviceId),
      headSequence: Value(headSequence),
      headOperationId: Value(headOperationId),
      isQuarantined: Value(isQuarantined),
    );
  }

  factory FeedHeadRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedHeadRow(
      conversationId: serializer.fromJson<Uint8List>(json['conversationId']),
      authorDeviceId: serializer.fromJson<Uint8List>(json['authorDeviceId']),
      headSequence: serializer.fromJson<int>(json['headSequence']),
      headOperationId: serializer.fromJson<Uint8List>(json['headOperationId']),
      isQuarantined: serializer.fromJson<bool>(json['isQuarantined']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<Uint8List>(conversationId),
      'authorDeviceId': serializer.toJson<Uint8List>(authorDeviceId),
      'headSequence': serializer.toJson<int>(headSequence),
      'headOperationId': serializer.toJson<Uint8List>(headOperationId),
      'isQuarantined': serializer.toJson<bool>(isQuarantined),
    };
  }

  FeedHeadRow copyWith({
    Uint8List? conversationId,
    Uint8List? authorDeviceId,
    int? headSequence,
    Uint8List? headOperationId,
    bool? isQuarantined,
  }) => FeedHeadRow(
    conversationId: conversationId ?? this.conversationId,
    authorDeviceId: authorDeviceId ?? this.authorDeviceId,
    headSequence: headSequence ?? this.headSequence,
    headOperationId: headOperationId ?? this.headOperationId,
    isQuarantined: isQuarantined ?? this.isQuarantined,
  );
  FeedHeadRow copyWithCompanion(FeedHeadsCompanion data) {
    return FeedHeadRow(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      authorDeviceId: data.authorDeviceId.present
          ? data.authorDeviceId.value
          : this.authorDeviceId,
      headSequence: data.headSequence.present
          ? data.headSequence.value
          : this.headSequence,
      headOperationId: data.headOperationId.present
          ? data.headOperationId.value
          : this.headOperationId,
      isQuarantined: data.isQuarantined.present
          ? data.isQuarantined.value
          : this.isQuarantined,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedHeadRow(')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('headSequence: $headSequence, ')
          ..write('headOperationId: $headOperationId, ')
          ..write('isQuarantined: $isQuarantined')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(conversationId),
    $driftBlobEquality.hash(authorDeviceId),
    headSequence,
    $driftBlobEquality.hash(headOperationId),
    isQuarantined,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedHeadRow &&
          $driftBlobEquality.equals(
            other.conversationId,
            this.conversationId,
          ) &&
          $driftBlobEquality.equals(
            other.authorDeviceId,
            this.authorDeviceId,
          ) &&
          other.headSequence == this.headSequence &&
          $driftBlobEquality.equals(
            other.headOperationId,
            this.headOperationId,
          ) &&
          other.isQuarantined == this.isQuarantined);
}

class FeedHeadsCompanion extends UpdateCompanion<FeedHeadRow> {
  final Value<Uint8List> conversationId;
  final Value<Uint8List> authorDeviceId;
  final Value<int> headSequence;
  final Value<Uint8List> headOperationId;
  final Value<bool> isQuarantined;
  final Value<int> rowid;
  const FeedHeadsCompanion({
    this.conversationId = const Value.absent(),
    this.authorDeviceId = const Value.absent(),
    this.headSequence = const Value.absent(),
    this.headOperationId = const Value.absent(),
    this.isQuarantined = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeedHeadsCompanion.insert({
    required Uint8List conversationId,
    required Uint8List authorDeviceId,
    required int headSequence,
    required Uint8List headOperationId,
    this.isQuarantined = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       authorDeviceId = Value(authorDeviceId),
       headSequence = Value(headSequence),
       headOperationId = Value(headOperationId);
  static Insertable<FeedHeadRow> custom({
    Expression<Uint8List>? conversationId,
    Expression<Uint8List>? authorDeviceId,
    Expression<int>? headSequence,
    Expression<Uint8List>? headOperationId,
    Expression<bool>? isQuarantined,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (authorDeviceId != null) 'author_device_id': authorDeviceId,
      if (headSequence != null) 'head_sequence': headSequence,
      if (headOperationId != null) 'head_operation_id': headOperationId,
      if (isQuarantined != null) 'is_quarantined': isQuarantined,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeedHeadsCompanion copyWith({
    Value<Uint8List>? conversationId,
    Value<Uint8List>? authorDeviceId,
    Value<int>? headSequence,
    Value<Uint8List>? headOperationId,
    Value<bool>? isQuarantined,
    Value<int>? rowid,
  }) {
    return FeedHeadsCompanion(
      conversationId: conversationId ?? this.conversationId,
      authorDeviceId: authorDeviceId ?? this.authorDeviceId,
      headSequence: headSequence ?? this.headSequence,
      headOperationId: headOperationId ?? this.headOperationId,
      isQuarantined: isQuarantined ?? this.isQuarantined,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<Uint8List>(conversationId.value);
    }
    if (authorDeviceId.present) {
      map['author_device_id'] = Variable<Uint8List>(authorDeviceId.value);
    }
    if (headSequence.present) {
      map['head_sequence'] = Variable<int>(headSequence.value);
    }
    if (headOperationId.present) {
      map['head_operation_id'] = Variable<Uint8List>(headOperationId.value);
    }
    if (isQuarantined.present) {
      map['is_quarantined'] = Variable<bool>(isQuarantined.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedHeadsCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('headSequence: $headSequence, ')
          ..write('headOperationId: $headOperationId, ')
          ..write('isQuarantined: $isQuarantined, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageProjectionsTable extends MessageProjections
    with TableInfo<$MessageProjectionsTable, MessageProjectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageProjectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<Uint8List> operationId =
      GeneratedColumn<Uint8List>(
        'operation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<Uint8List> conversationId =
      GeneratedColumn<Uint8List>(
        'conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _authorDeviceIdMeta = const VerificationMeta(
    'authorDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> authorDeviceId =
      GeneratedColumn<Uint8List>(
        'author_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _recipientDeviceIdMeta = const VerificationMeta(
    'recipientDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> recipientDeviceId =
      GeneratedColumn<Uint8List>(
        'recipient_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _authorSequenceMeta = const VerificationMeta(
    'authorSequence',
  );
  @override
  late final GeneratedColumn<int> authorSequence = GeneratedColumn<int>(
    'author_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authoredAtMicrosMeta = const VerificationMeta(
    'authoredAtMicros',
  );
  @override
  late final GeneratedColumn<int> authoredAtMicros = GeneratedColumn<int>(
    'authored_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageTextMeta = const VerificationMeta(
    'messageText',
  );
  @override
  late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
    'message_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _insertedAtMicrosMeta = const VerificationMeta(
    'insertedAtMicros',
  );
  @override
  late final GeneratedColumn<int> insertedAtMicros = GeneratedColumn<int>(
    'inserted_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    conversationId,
    authorDeviceId,
    recipientDeviceId,
    authorSequence,
    authoredAtMicros,
    messageText,
    insertedAtMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_projections';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageProjectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('author_device_id')) {
      context.handle(
        _authorDeviceIdMeta,
        authorDeviceId.isAcceptableOrUnknown(
          data['author_device_id']!,
          _authorDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorDeviceIdMeta);
    }
    if (data.containsKey('recipient_device_id')) {
      context.handle(
        _recipientDeviceIdMeta,
        recipientDeviceId.isAcceptableOrUnknown(
          data['recipient_device_id']!,
          _recipientDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientDeviceIdMeta);
    }
    if (data.containsKey('author_sequence')) {
      context.handle(
        _authorSequenceMeta,
        authorSequence.isAcceptableOrUnknown(
          data['author_sequence']!,
          _authorSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorSequenceMeta);
    }
    if (data.containsKey('authored_at_micros')) {
      context.handle(
        _authoredAtMicrosMeta,
        authoredAtMicros.isAcceptableOrUnknown(
          data['authored_at_micros']!,
          _authoredAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authoredAtMicrosMeta);
    }
    if (data.containsKey('message_text')) {
      context.handle(
        _messageTextMeta,
        messageText.isAcceptableOrUnknown(
          data['message_text']!,
          _messageTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_messageTextMeta);
    }
    if (data.containsKey('inserted_at_micros')) {
      context.handle(
        _insertedAtMicrosMeta,
        insertedAtMicros.isAcceptableOrUnknown(
          data['inserted_at_micros']!,
          _insertedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_insertedAtMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  MessageProjectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageProjectionRow(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}operation_id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}conversation_id'],
      )!,
      authorDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}author_device_id'],
      )!,
      recipientDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}recipient_device_id'],
      )!,
      authorSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}author_sequence'],
      )!,
      authoredAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}authored_at_micros'],
      )!,
      messageText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_text'],
      )!,
      insertedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inserted_at_micros'],
      )!,
    );
  }

  @override
  $MessageProjectionsTable createAlias(String alias) {
    return $MessageProjectionsTable(attachedDatabase, alias);
  }
}

class MessageProjectionRow extends DataClass
    implements Insertable<MessageProjectionRow> {
  final Uint8List operationId;
  final Uint8List conversationId;
  final Uint8List authorDeviceId;
  final Uint8List recipientDeviceId;
  final int authorSequence;
  final int authoredAtMicros;
  final String messageText;
  final int insertedAtMicros;
  const MessageProjectionRow({
    required this.operationId,
    required this.conversationId,
    required this.authorDeviceId,
    required this.recipientDeviceId,
    required this.authorSequence,
    required this.authoredAtMicros,
    required this.messageText,
    required this.insertedAtMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<Uint8List>(operationId);
    map['conversation_id'] = Variable<Uint8List>(conversationId);
    map['author_device_id'] = Variable<Uint8List>(authorDeviceId);
    map['recipient_device_id'] = Variable<Uint8List>(recipientDeviceId);
    map['author_sequence'] = Variable<int>(authorSequence);
    map['authored_at_micros'] = Variable<int>(authoredAtMicros);
    map['message_text'] = Variable<String>(messageText);
    map['inserted_at_micros'] = Variable<int>(insertedAtMicros);
    return map;
  }

  MessageProjectionsCompanion toCompanion(bool nullToAbsent) {
    return MessageProjectionsCompanion(
      operationId: Value(operationId),
      conversationId: Value(conversationId),
      authorDeviceId: Value(authorDeviceId),
      recipientDeviceId: Value(recipientDeviceId),
      authorSequence: Value(authorSequence),
      authoredAtMicros: Value(authoredAtMicros),
      messageText: Value(messageText),
      insertedAtMicros: Value(insertedAtMicros),
    );
  }

  factory MessageProjectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageProjectionRow(
      operationId: serializer.fromJson<Uint8List>(json['operationId']),
      conversationId: serializer.fromJson<Uint8List>(json['conversationId']),
      authorDeviceId: serializer.fromJson<Uint8List>(json['authorDeviceId']),
      recipientDeviceId: serializer.fromJson<Uint8List>(
        json['recipientDeviceId'],
      ),
      authorSequence: serializer.fromJson<int>(json['authorSequence']),
      authoredAtMicros: serializer.fromJson<int>(json['authoredAtMicros']),
      messageText: serializer.fromJson<String>(json['messageText']),
      insertedAtMicros: serializer.fromJson<int>(json['insertedAtMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<Uint8List>(operationId),
      'conversationId': serializer.toJson<Uint8List>(conversationId),
      'authorDeviceId': serializer.toJson<Uint8List>(authorDeviceId),
      'recipientDeviceId': serializer.toJson<Uint8List>(recipientDeviceId),
      'authorSequence': serializer.toJson<int>(authorSequence),
      'authoredAtMicros': serializer.toJson<int>(authoredAtMicros),
      'messageText': serializer.toJson<String>(messageText),
      'insertedAtMicros': serializer.toJson<int>(insertedAtMicros),
    };
  }

  MessageProjectionRow copyWith({
    Uint8List? operationId,
    Uint8List? conversationId,
    Uint8List? authorDeviceId,
    Uint8List? recipientDeviceId,
    int? authorSequence,
    int? authoredAtMicros,
    String? messageText,
    int? insertedAtMicros,
  }) => MessageProjectionRow(
    operationId: operationId ?? this.operationId,
    conversationId: conversationId ?? this.conversationId,
    authorDeviceId: authorDeviceId ?? this.authorDeviceId,
    recipientDeviceId: recipientDeviceId ?? this.recipientDeviceId,
    authorSequence: authorSequence ?? this.authorSequence,
    authoredAtMicros: authoredAtMicros ?? this.authoredAtMicros,
    messageText: messageText ?? this.messageText,
    insertedAtMicros: insertedAtMicros ?? this.insertedAtMicros,
  );
  MessageProjectionRow copyWithCompanion(MessageProjectionsCompanion data) {
    return MessageProjectionRow(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      authorDeviceId: data.authorDeviceId.present
          ? data.authorDeviceId.value
          : this.authorDeviceId,
      recipientDeviceId: data.recipientDeviceId.present
          ? data.recipientDeviceId.value
          : this.recipientDeviceId,
      authorSequence: data.authorSequence.present
          ? data.authorSequence.value
          : this.authorSequence,
      authoredAtMicros: data.authoredAtMicros.present
          ? data.authoredAtMicros.value
          : this.authoredAtMicros,
      messageText: data.messageText.present
          ? data.messageText.value
          : this.messageText,
      insertedAtMicros: data.insertedAtMicros.present
          ? data.insertedAtMicros.value
          : this.insertedAtMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageProjectionRow(')
          ..write('operationId: $operationId, ')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('recipientDeviceId: $recipientDeviceId, ')
          ..write('authorSequence: $authorSequence, ')
          ..write('authoredAtMicros: $authoredAtMicros, ')
          ..write('messageText: $messageText, ')
          ..write('insertedAtMicros: $insertedAtMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(operationId),
    $driftBlobEquality.hash(conversationId),
    $driftBlobEquality.hash(authorDeviceId),
    $driftBlobEquality.hash(recipientDeviceId),
    authorSequence,
    authoredAtMicros,
    messageText,
    insertedAtMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageProjectionRow &&
          $driftBlobEquality.equals(other.operationId, this.operationId) &&
          $driftBlobEquality.equals(
            other.conversationId,
            this.conversationId,
          ) &&
          $driftBlobEquality.equals(
            other.authorDeviceId,
            this.authorDeviceId,
          ) &&
          $driftBlobEquality.equals(
            other.recipientDeviceId,
            this.recipientDeviceId,
          ) &&
          other.authorSequence == this.authorSequence &&
          other.authoredAtMicros == this.authoredAtMicros &&
          other.messageText == this.messageText &&
          other.insertedAtMicros == this.insertedAtMicros);
}

class MessageProjectionsCompanion
    extends UpdateCompanion<MessageProjectionRow> {
  final Value<Uint8List> operationId;
  final Value<Uint8List> conversationId;
  final Value<Uint8List> authorDeviceId;
  final Value<Uint8List> recipientDeviceId;
  final Value<int> authorSequence;
  final Value<int> authoredAtMicros;
  final Value<String> messageText;
  final Value<int> insertedAtMicros;
  final Value<int> rowid;
  const MessageProjectionsCompanion({
    this.operationId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.authorDeviceId = const Value.absent(),
    this.recipientDeviceId = const Value.absent(),
    this.authorSequence = const Value.absent(),
    this.authoredAtMicros = const Value.absent(),
    this.messageText = const Value.absent(),
    this.insertedAtMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageProjectionsCompanion.insert({
    required Uint8List operationId,
    required Uint8List conversationId,
    required Uint8List authorDeviceId,
    required Uint8List recipientDeviceId,
    required int authorSequence,
    required int authoredAtMicros,
    required String messageText,
    required int insertedAtMicros,
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       conversationId = Value(conversationId),
       authorDeviceId = Value(authorDeviceId),
       recipientDeviceId = Value(recipientDeviceId),
       authorSequence = Value(authorSequence),
       authoredAtMicros = Value(authoredAtMicros),
       messageText = Value(messageText),
       insertedAtMicros = Value(insertedAtMicros);
  static Insertable<MessageProjectionRow> custom({
    Expression<Uint8List>? operationId,
    Expression<Uint8List>? conversationId,
    Expression<Uint8List>? authorDeviceId,
    Expression<Uint8List>? recipientDeviceId,
    Expression<int>? authorSequence,
    Expression<int>? authoredAtMicros,
    Expression<String>? messageText,
    Expression<int>? insertedAtMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (authorDeviceId != null) 'author_device_id': authorDeviceId,
      if (recipientDeviceId != null) 'recipient_device_id': recipientDeviceId,
      if (authorSequence != null) 'author_sequence': authorSequence,
      if (authoredAtMicros != null) 'authored_at_micros': authoredAtMicros,
      if (messageText != null) 'message_text': messageText,
      if (insertedAtMicros != null) 'inserted_at_micros': insertedAtMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageProjectionsCompanion copyWith({
    Value<Uint8List>? operationId,
    Value<Uint8List>? conversationId,
    Value<Uint8List>? authorDeviceId,
    Value<Uint8List>? recipientDeviceId,
    Value<int>? authorSequence,
    Value<int>? authoredAtMicros,
    Value<String>? messageText,
    Value<int>? insertedAtMicros,
    Value<int>? rowid,
  }) {
    return MessageProjectionsCompanion(
      operationId: operationId ?? this.operationId,
      conversationId: conversationId ?? this.conversationId,
      authorDeviceId: authorDeviceId ?? this.authorDeviceId,
      recipientDeviceId: recipientDeviceId ?? this.recipientDeviceId,
      authorSequence: authorSequence ?? this.authorSequence,
      authoredAtMicros: authoredAtMicros ?? this.authoredAtMicros,
      messageText: messageText ?? this.messageText,
      insertedAtMicros: insertedAtMicros ?? this.insertedAtMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<Uint8List>(operationId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<Uint8List>(conversationId.value);
    }
    if (authorDeviceId.present) {
      map['author_device_id'] = Variable<Uint8List>(authorDeviceId.value);
    }
    if (recipientDeviceId.present) {
      map['recipient_device_id'] = Variable<Uint8List>(recipientDeviceId.value);
    }
    if (authorSequence.present) {
      map['author_sequence'] = Variable<int>(authorSequence.value);
    }
    if (authoredAtMicros.present) {
      map['authored_at_micros'] = Variable<int>(authoredAtMicros.value);
    }
    if (messageText.present) {
      map['message_text'] = Variable<String>(messageText.value);
    }
    if (insertedAtMicros.present) {
      map['inserted_at_micros'] = Variable<int>(insertedAtMicros.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessageProjectionsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('recipientDeviceId: $recipientDeviceId, ')
          ..write('authorSequence: $authorSequence, ')
          ..write('authoredAtMicros: $authoredAtMicros, ')
          ..write('messageText: $messageText, ')
          ..write('insertedAtMicros: $insertedAtMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RetentionFloorsTable extends RetentionFloors
    with TableInfo<$RetentionFloorsTable, RetentionFloorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RetentionFloorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<Uint8List> conversationId =
      GeneratedColumn<Uint8List>(
        'conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _authorDeviceIdMeta = const VerificationMeta(
    'authorDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> authorDeviceId =
      GeneratedColumn<Uint8List>(
        'author_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _retainedThroughSequenceMeta =
      const VerificationMeta('retainedThroughSequence');
  @override
  late final GeneratedColumn<int> retainedThroughSequence =
      GeneratedColumn<int>(
        'retained_through_sequence',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    conversationId,
    authorDeviceId,
    retainedThroughSequence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'retention_floors';
  @override
  VerificationContext validateIntegrity(
    Insertable<RetentionFloorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('author_device_id')) {
      context.handle(
        _authorDeviceIdMeta,
        authorDeviceId.isAcceptableOrUnknown(
          data['author_device_id']!,
          _authorDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorDeviceIdMeta);
    }
    if (data.containsKey('retained_through_sequence')) {
      context.handle(
        _retainedThroughSequenceMeta,
        retainedThroughSequence.isAcceptableOrUnknown(
          data['retained_through_sequence']!,
          _retainedThroughSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_retainedThroughSequenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conversationId, authorDeviceId};
  @override
  RetentionFloorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RetentionFloorRow(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}conversation_id'],
      )!,
      authorDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}author_device_id'],
      )!,
      retainedThroughSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retained_through_sequence'],
      )!,
    );
  }

  @override
  $RetentionFloorsTable createAlias(String alias) {
    return $RetentionFloorsTable(attachedDatabase, alias);
  }
}

class RetentionFloorRow extends DataClass
    implements Insertable<RetentionFloorRow> {
  final Uint8List conversationId;
  final Uint8List authorDeviceId;
  final int retainedThroughSequence;
  const RetentionFloorRow({
    required this.conversationId,
    required this.authorDeviceId,
    required this.retainedThroughSequence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<Uint8List>(conversationId);
    map['author_device_id'] = Variable<Uint8List>(authorDeviceId);
    map['retained_through_sequence'] = Variable<int>(retainedThroughSequence);
    return map;
  }

  RetentionFloorsCompanion toCompanion(bool nullToAbsent) {
    return RetentionFloorsCompanion(
      conversationId: Value(conversationId),
      authorDeviceId: Value(authorDeviceId),
      retainedThroughSequence: Value(retainedThroughSequence),
    );
  }

  factory RetentionFloorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RetentionFloorRow(
      conversationId: serializer.fromJson<Uint8List>(json['conversationId']),
      authorDeviceId: serializer.fromJson<Uint8List>(json['authorDeviceId']),
      retainedThroughSequence: serializer.fromJson<int>(
        json['retainedThroughSequence'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<Uint8List>(conversationId),
      'authorDeviceId': serializer.toJson<Uint8List>(authorDeviceId),
      'retainedThroughSequence': serializer.toJson<int>(
        retainedThroughSequence,
      ),
    };
  }

  RetentionFloorRow copyWith({
    Uint8List? conversationId,
    Uint8List? authorDeviceId,
    int? retainedThroughSequence,
  }) => RetentionFloorRow(
    conversationId: conversationId ?? this.conversationId,
    authorDeviceId: authorDeviceId ?? this.authorDeviceId,
    retainedThroughSequence:
        retainedThroughSequence ?? this.retainedThroughSequence,
  );
  RetentionFloorRow copyWithCompanion(RetentionFloorsCompanion data) {
    return RetentionFloorRow(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      authorDeviceId: data.authorDeviceId.present
          ? data.authorDeviceId.value
          : this.authorDeviceId,
      retainedThroughSequence: data.retainedThroughSequence.present
          ? data.retainedThroughSequence.value
          : this.retainedThroughSequence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RetentionFloorRow(')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('retainedThroughSequence: $retainedThroughSequence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(conversationId),
    $driftBlobEquality.hash(authorDeviceId),
    retainedThroughSequence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RetentionFloorRow &&
          $driftBlobEquality.equals(
            other.conversationId,
            this.conversationId,
          ) &&
          $driftBlobEquality.equals(
            other.authorDeviceId,
            this.authorDeviceId,
          ) &&
          other.retainedThroughSequence == this.retainedThroughSequence);
}

class RetentionFloorsCompanion extends UpdateCompanion<RetentionFloorRow> {
  final Value<Uint8List> conversationId;
  final Value<Uint8List> authorDeviceId;
  final Value<int> retainedThroughSequence;
  final Value<int> rowid;
  const RetentionFloorsCompanion({
    this.conversationId = const Value.absent(),
    this.authorDeviceId = const Value.absent(),
    this.retainedThroughSequence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RetentionFloorsCompanion.insert({
    required Uint8List conversationId,
    required Uint8List authorDeviceId,
    required int retainedThroughSequence,
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       authorDeviceId = Value(authorDeviceId),
       retainedThroughSequence = Value(retainedThroughSequence);
  static Insertable<RetentionFloorRow> custom({
    Expression<Uint8List>? conversationId,
    Expression<Uint8List>? authorDeviceId,
    Expression<int>? retainedThroughSequence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (authorDeviceId != null) 'author_device_id': authorDeviceId,
      if (retainedThroughSequence != null)
        'retained_through_sequence': retainedThroughSequence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RetentionFloorsCompanion copyWith({
    Value<Uint8List>? conversationId,
    Value<Uint8List>? authorDeviceId,
    Value<int>? retainedThroughSequence,
    Value<int>? rowid,
  }) {
    return RetentionFloorsCompanion(
      conversationId: conversationId ?? this.conversationId,
      authorDeviceId: authorDeviceId ?? this.authorDeviceId,
      retainedThroughSequence:
          retainedThroughSequence ?? this.retainedThroughSequence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<Uint8List>(conversationId.value);
    }
    if (authorDeviceId.present) {
      map['author_device_id'] = Variable<Uint8List>(authorDeviceId.value);
    }
    if (retainedThroughSequence.present) {
      map['retained_through_sequence'] = Variable<int>(
        retainedThroughSequence.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RetentionFloorsCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('retainedThroughSequence: $retainedThroughSequence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeliveryAcknowledgementsTable extends DeliveryAcknowledgements
    with TableInfo<$DeliveryAcknowledgementsTable, DeliveryAcknowledgementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeliveryAcknowledgementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<Uint8List> conversationId =
      GeneratedColumn<Uint8List>(
        'conversation_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _authorDeviceIdMeta = const VerificationMeta(
    'authorDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> authorDeviceId =
      GeneratedColumn<Uint8List>(
        'author_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _recipientDeviceIdMeta = const VerificationMeta(
    'recipientDeviceId',
  );
  @override
  late final GeneratedColumn<Uint8List> recipientDeviceId =
      GeneratedColumn<Uint8List>(
        'recipient_device_id',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _highestSequenceMeta = const VerificationMeta(
    'highestSequence',
  );
  @override
  late final GeneratedColumn<int> highestSequence = GeneratedColumn<int>(
    'highest_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMicrosMeta = const VerificationMeta(
    'updatedAtMicros',
  );
  @override
  late final GeneratedColumn<int> updatedAtMicros = GeneratedColumn<int>(
    'updated_at_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    conversationId,
    authorDeviceId,
    recipientDeviceId,
    highestSequence,
    updatedAtMicros,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'delivery_acknowledgements';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeliveryAcknowledgementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('author_device_id')) {
      context.handle(
        _authorDeviceIdMeta,
        authorDeviceId.isAcceptableOrUnknown(
          data['author_device_id']!,
          _authorDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_authorDeviceIdMeta);
    }
    if (data.containsKey('recipient_device_id')) {
      context.handle(
        _recipientDeviceIdMeta,
        recipientDeviceId.isAcceptableOrUnknown(
          data['recipient_device_id']!,
          _recipientDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientDeviceIdMeta);
    }
    if (data.containsKey('highest_sequence')) {
      context.handle(
        _highestSequenceMeta,
        highestSequence.isAcceptableOrUnknown(
          data['highest_sequence']!,
          _highestSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_highestSequenceMeta);
    }
    if (data.containsKey('updated_at_micros')) {
      context.handle(
        _updatedAtMicrosMeta,
        updatedAtMicros.isAcceptableOrUnknown(
          data['updated_at_micros']!,
          _updatedAtMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMicrosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    conversationId,
    authorDeviceId,
    recipientDeviceId,
  };
  @override
  DeliveryAcknowledgementRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeliveryAcknowledgementRow(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}conversation_id'],
      )!,
      authorDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}author_device_id'],
      )!,
      recipientDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}recipient_device_id'],
      )!,
      highestSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}highest_sequence'],
      )!,
      updatedAtMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_micros'],
      )!,
    );
  }

  @override
  $DeliveryAcknowledgementsTable createAlias(String alias) {
    return $DeliveryAcknowledgementsTable(attachedDatabase, alias);
  }
}

class DeliveryAcknowledgementRow extends DataClass
    implements Insertable<DeliveryAcknowledgementRow> {
  final Uint8List conversationId;
  final Uint8List authorDeviceId;
  final Uint8List recipientDeviceId;
  final int highestSequence;
  final int updatedAtMicros;
  const DeliveryAcknowledgementRow({
    required this.conversationId,
    required this.authorDeviceId,
    required this.recipientDeviceId,
    required this.highestSequence,
    required this.updatedAtMicros,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<Uint8List>(conversationId);
    map['author_device_id'] = Variable<Uint8List>(authorDeviceId);
    map['recipient_device_id'] = Variable<Uint8List>(recipientDeviceId);
    map['highest_sequence'] = Variable<int>(highestSequence);
    map['updated_at_micros'] = Variable<int>(updatedAtMicros);
    return map;
  }

  DeliveryAcknowledgementsCompanion toCompanion(bool nullToAbsent) {
    return DeliveryAcknowledgementsCompanion(
      conversationId: Value(conversationId),
      authorDeviceId: Value(authorDeviceId),
      recipientDeviceId: Value(recipientDeviceId),
      highestSequence: Value(highestSequence),
      updatedAtMicros: Value(updatedAtMicros),
    );
  }

  factory DeliveryAcknowledgementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeliveryAcknowledgementRow(
      conversationId: serializer.fromJson<Uint8List>(json['conversationId']),
      authorDeviceId: serializer.fromJson<Uint8List>(json['authorDeviceId']),
      recipientDeviceId: serializer.fromJson<Uint8List>(
        json['recipientDeviceId'],
      ),
      highestSequence: serializer.fromJson<int>(json['highestSequence']),
      updatedAtMicros: serializer.fromJson<int>(json['updatedAtMicros']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<Uint8List>(conversationId),
      'authorDeviceId': serializer.toJson<Uint8List>(authorDeviceId),
      'recipientDeviceId': serializer.toJson<Uint8List>(recipientDeviceId),
      'highestSequence': serializer.toJson<int>(highestSequence),
      'updatedAtMicros': serializer.toJson<int>(updatedAtMicros),
    };
  }

  DeliveryAcknowledgementRow copyWith({
    Uint8List? conversationId,
    Uint8List? authorDeviceId,
    Uint8List? recipientDeviceId,
    int? highestSequence,
    int? updatedAtMicros,
  }) => DeliveryAcknowledgementRow(
    conversationId: conversationId ?? this.conversationId,
    authorDeviceId: authorDeviceId ?? this.authorDeviceId,
    recipientDeviceId: recipientDeviceId ?? this.recipientDeviceId,
    highestSequence: highestSequence ?? this.highestSequence,
    updatedAtMicros: updatedAtMicros ?? this.updatedAtMicros,
  );
  DeliveryAcknowledgementRow copyWithCompanion(
    DeliveryAcknowledgementsCompanion data,
  ) {
    return DeliveryAcknowledgementRow(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      authorDeviceId: data.authorDeviceId.present
          ? data.authorDeviceId.value
          : this.authorDeviceId,
      recipientDeviceId: data.recipientDeviceId.present
          ? data.recipientDeviceId.value
          : this.recipientDeviceId,
      highestSequence: data.highestSequence.present
          ? data.highestSequence.value
          : this.highestSequence,
      updatedAtMicros: data.updatedAtMicros.present
          ? data.updatedAtMicros.value
          : this.updatedAtMicros,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryAcknowledgementRow(')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('recipientDeviceId: $recipientDeviceId, ')
          ..write('highestSequence: $highestSequence, ')
          ..write('updatedAtMicros: $updatedAtMicros')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    $driftBlobEquality.hash(conversationId),
    $driftBlobEquality.hash(authorDeviceId),
    $driftBlobEquality.hash(recipientDeviceId),
    highestSequence,
    updatedAtMicros,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeliveryAcknowledgementRow &&
          $driftBlobEquality.equals(
            other.conversationId,
            this.conversationId,
          ) &&
          $driftBlobEquality.equals(
            other.authorDeviceId,
            this.authorDeviceId,
          ) &&
          $driftBlobEquality.equals(
            other.recipientDeviceId,
            this.recipientDeviceId,
          ) &&
          other.highestSequence == this.highestSequence &&
          other.updatedAtMicros == this.updatedAtMicros);
}

class DeliveryAcknowledgementsCompanion
    extends UpdateCompanion<DeliveryAcknowledgementRow> {
  final Value<Uint8List> conversationId;
  final Value<Uint8List> authorDeviceId;
  final Value<Uint8List> recipientDeviceId;
  final Value<int> highestSequence;
  final Value<int> updatedAtMicros;
  final Value<int> rowid;
  const DeliveryAcknowledgementsCompanion({
    this.conversationId = const Value.absent(),
    this.authorDeviceId = const Value.absent(),
    this.recipientDeviceId = const Value.absent(),
    this.highestSequence = const Value.absent(),
    this.updatedAtMicros = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeliveryAcknowledgementsCompanion.insert({
    required Uint8List conversationId,
    required Uint8List authorDeviceId,
    required Uint8List recipientDeviceId,
    required int highestSequence,
    required int updatedAtMicros,
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       authorDeviceId = Value(authorDeviceId),
       recipientDeviceId = Value(recipientDeviceId),
       highestSequence = Value(highestSequence),
       updatedAtMicros = Value(updatedAtMicros);
  static Insertable<DeliveryAcknowledgementRow> custom({
    Expression<Uint8List>? conversationId,
    Expression<Uint8List>? authorDeviceId,
    Expression<Uint8List>? recipientDeviceId,
    Expression<int>? highestSequence,
    Expression<int>? updatedAtMicros,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (authorDeviceId != null) 'author_device_id': authorDeviceId,
      if (recipientDeviceId != null) 'recipient_device_id': recipientDeviceId,
      if (highestSequence != null) 'highest_sequence': highestSequence,
      if (updatedAtMicros != null) 'updated_at_micros': updatedAtMicros,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeliveryAcknowledgementsCompanion copyWith({
    Value<Uint8List>? conversationId,
    Value<Uint8List>? authorDeviceId,
    Value<Uint8List>? recipientDeviceId,
    Value<int>? highestSequence,
    Value<int>? updatedAtMicros,
    Value<int>? rowid,
  }) {
    return DeliveryAcknowledgementsCompanion(
      conversationId: conversationId ?? this.conversationId,
      authorDeviceId: authorDeviceId ?? this.authorDeviceId,
      recipientDeviceId: recipientDeviceId ?? this.recipientDeviceId,
      highestSequence: highestSequence ?? this.highestSequence,
      updatedAtMicros: updatedAtMicros ?? this.updatedAtMicros,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<Uint8List>(conversationId.value);
    }
    if (authorDeviceId.present) {
      map['author_device_id'] = Variable<Uint8List>(authorDeviceId.value);
    }
    if (recipientDeviceId.present) {
      map['recipient_device_id'] = Variable<Uint8List>(recipientDeviceId.value);
    }
    if (highestSequence.present) {
      map['highest_sequence'] = Variable<int>(highestSequence.value);
    }
    if (updatedAtMicros.present) {
      map['updated_at_micros'] = Variable<int>(updatedAtMicros.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryAcknowledgementsCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('authorDeviceId: $authorDeviceId, ')
          ..write('recipientDeviceId: $recipientDeviceId, ')
          ..write('highestSequence: $highestSequence, ')
          ..write('updatedAtMicros: $updatedAtMicros, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalProfilesTable localProfiles = $LocalProfilesTable(this);
  late final $PinnedPeersTable pinnedPeers = $PinnedPeersTable(this);
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $StoredOperationsTable storedOperations = $StoredOperationsTable(
    this,
  );
  late final $FeedHeadsTable feedHeads = $FeedHeadsTable(this);
  late final $MessageProjectionsTable messageProjections =
      $MessageProjectionsTable(this);
  late final $RetentionFloorsTable retentionFloors = $RetentionFloorsTable(
    this,
  );
  late final $DeliveryAcknowledgementsTable deliveryAcknowledgements =
      $DeliveryAcknowledgementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localProfiles,
    pinnedPeers,
    conversations,
    storedOperations,
    feedHeads,
    messageProjections,
    retentionFloors,
    deliveryAcknowledgements,
  ];
}

typedef $$LocalProfilesTableCreateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<int> singleton,
      required Uint8List deviceId,
      required Uint8List publicKey,
      required String displayName,
      required int revision,
      required int createdAtMicros,
      required int updatedAtMicros,
    });
typedef $$LocalProfilesTableUpdateCompanionBuilder =
    LocalProfilesCompanion Function({
      Value<int> singleton,
      Value<Uint8List> deviceId,
      Value<Uint8List> publicKey,
      Value<String> displayName,
      Value<int> revision,
      Value<int> createdAtMicros,
      Value<int> updatedAtMicros,
    });

class $$LocalProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get singleton => $composableBuilder(
    column: $table.singleton,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProfilesTable> {
  $$LocalProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singleton =>
      $composableBuilder(column: $table.singleton, builder: (column) => column);

  GeneratedColumn<Uint8List> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<Uint8List> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => column,
  );
}

class $$LocalProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProfilesTable,
          LocalProfileRow,
          $$LocalProfilesTableFilterComposer,
          $$LocalProfilesTableOrderingComposer,
          $$LocalProfilesTableAnnotationComposer,
          $$LocalProfilesTableCreateCompanionBuilder,
          $$LocalProfilesTableUpdateCompanionBuilder,
          (
            LocalProfileRow,
            BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfileRow>,
          ),
          LocalProfileRow,
          PrefetchHooks Function()
        > {
  $$LocalProfilesTableTableManager(_$AppDatabase db, $LocalProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                Value<Uint8List> deviceId = const Value.absent(),
                Value<Uint8List> publicKey = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> createdAtMicros = const Value.absent(),
                Value<int> updatedAtMicros = const Value.absent(),
              }) => LocalProfilesCompanion(
                singleton: singleton,
                deviceId: deviceId,
                publicKey: publicKey,
                displayName: displayName,
                revision: revision,
                createdAtMicros: createdAtMicros,
                updatedAtMicros: updatedAtMicros,
              ),
          createCompanionCallback:
              ({
                Value<int> singleton = const Value.absent(),
                required Uint8List deviceId,
                required Uint8List publicKey,
                required String displayName,
                required int revision,
                required int createdAtMicros,
                required int updatedAtMicros,
              }) => LocalProfilesCompanion.insert(
                singleton: singleton,
                deviceId: deviceId,
                publicKey: publicKey,
                displayName: displayName,
                revision: revision,
                createdAtMicros: createdAtMicros,
                updatedAtMicros: updatedAtMicros,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalProfilesTable,
      LocalProfileRow,
      $$LocalProfilesTableFilterComposer,
      $$LocalProfilesTableOrderingComposer,
      $$LocalProfilesTableAnnotationComposer,
      $$LocalProfilesTableCreateCompanionBuilder,
      $$LocalProfilesTableUpdateCompanionBuilder,
      (
        LocalProfileRow,
        BaseReferences<_$AppDatabase, $LocalProfilesTable, LocalProfileRow>,
      ),
      LocalProfileRow,
      PrefetchHooks Function()
    >;
typedef $$PinnedPeersTableCreateCompanionBuilder =
    PinnedPeersCompanion Function({
      required Uint8List deviceId,
      required Uint8List publicKey,
      required String displayName,
      required int profileRevision,
      required int profileCreatedAtMicros,
      required int profileUpdatedAtMicros,
      required int pinnedAtMicros,
      required int lastVerifiedAtMicros,
      required String trustState,
      Value<int> rowid,
    });
typedef $$PinnedPeersTableUpdateCompanionBuilder =
    PinnedPeersCompanion Function({
      Value<Uint8List> deviceId,
      Value<Uint8List> publicKey,
      Value<String> displayName,
      Value<int> profileRevision,
      Value<int> profileCreatedAtMicros,
      Value<int> profileUpdatedAtMicros,
      Value<int> pinnedAtMicros,
      Value<int> lastVerifiedAtMicros,
      Value<String> trustState,
      Value<int> rowid,
    });

class $$PinnedPeersTableFilterComposer
    extends Composer<_$AppDatabase, $PinnedPeersTable> {
  $$PinnedPeersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profileRevision => $composableBuilder(
    column: $table.profileRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profileCreatedAtMicros => $composableBuilder(
    column: $table.profileCreatedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profileUpdatedAtMicros => $composableBuilder(
    column: $table.profileUpdatedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinnedAtMicros => $composableBuilder(
    column: $table.pinnedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastVerifiedAtMicros => $composableBuilder(
    column: $table.lastVerifiedAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trustState => $composableBuilder(
    column: $table.trustState,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PinnedPeersTableOrderingComposer
    extends Composer<_$AppDatabase, $PinnedPeersTable> {
  $$PinnedPeersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profileRevision => $composableBuilder(
    column: $table.profileRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profileCreatedAtMicros => $composableBuilder(
    column: $table.profileCreatedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profileUpdatedAtMicros => $composableBuilder(
    column: $table.profileUpdatedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinnedAtMicros => $composableBuilder(
    column: $table.pinnedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastVerifiedAtMicros => $composableBuilder(
    column: $table.lastVerifiedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trustState => $composableBuilder(
    column: $table.trustState,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PinnedPeersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PinnedPeersTable> {
  $$PinnedPeersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<Uint8List> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get profileRevision => $composableBuilder(
    column: $table.profileRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get profileCreatedAtMicros => $composableBuilder(
    column: $table.profileCreatedAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get profileUpdatedAtMicros => $composableBuilder(
    column: $table.profileUpdatedAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pinnedAtMicros => $composableBuilder(
    column: $table.pinnedAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastVerifiedAtMicros => $composableBuilder(
    column: $table.lastVerifiedAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trustState => $composableBuilder(
    column: $table.trustState,
    builder: (column) => column,
  );
}

class $$PinnedPeersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PinnedPeersTable,
          PinnedPeerRow,
          $$PinnedPeersTableFilterComposer,
          $$PinnedPeersTableOrderingComposer,
          $$PinnedPeersTableAnnotationComposer,
          $$PinnedPeersTableCreateCompanionBuilder,
          $$PinnedPeersTableUpdateCompanionBuilder,
          (
            PinnedPeerRow,
            BaseReferences<_$AppDatabase, $PinnedPeersTable, PinnedPeerRow>,
          ),
          PinnedPeerRow,
          PrefetchHooks Function()
        > {
  $$PinnedPeersTableTableManager(_$AppDatabase db, $PinnedPeersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinnedPeersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinnedPeersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinnedPeersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<Uint8List> deviceId = const Value.absent(),
                Value<Uint8List> publicKey = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> profileRevision = const Value.absent(),
                Value<int> profileCreatedAtMicros = const Value.absent(),
                Value<int> profileUpdatedAtMicros = const Value.absent(),
                Value<int> pinnedAtMicros = const Value.absent(),
                Value<int> lastVerifiedAtMicros = const Value.absent(),
                Value<String> trustState = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PinnedPeersCompanion(
                deviceId: deviceId,
                publicKey: publicKey,
                displayName: displayName,
                profileRevision: profileRevision,
                profileCreatedAtMicros: profileCreatedAtMicros,
                profileUpdatedAtMicros: profileUpdatedAtMicros,
                pinnedAtMicros: pinnedAtMicros,
                lastVerifiedAtMicros: lastVerifiedAtMicros,
                trustState: trustState,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required Uint8List deviceId,
                required Uint8List publicKey,
                required String displayName,
                required int profileRevision,
                required int profileCreatedAtMicros,
                required int profileUpdatedAtMicros,
                required int pinnedAtMicros,
                required int lastVerifiedAtMicros,
                required String trustState,
                Value<int> rowid = const Value.absent(),
              }) => PinnedPeersCompanion.insert(
                deviceId: deviceId,
                publicKey: publicKey,
                displayName: displayName,
                profileRevision: profileRevision,
                profileCreatedAtMicros: profileCreatedAtMicros,
                profileUpdatedAtMicros: profileUpdatedAtMicros,
                pinnedAtMicros: pinnedAtMicros,
                lastVerifiedAtMicros: lastVerifiedAtMicros,
                trustState: trustState,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PinnedPeersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PinnedPeersTable,
      PinnedPeerRow,
      $$PinnedPeersTableFilterComposer,
      $$PinnedPeersTableOrderingComposer,
      $$PinnedPeersTableAnnotationComposer,
      $$PinnedPeersTableCreateCompanionBuilder,
      $$PinnedPeersTableUpdateCompanionBuilder,
      (
        PinnedPeerRow,
        BaseReferences<_$AppDatabase, $PinnedPeersTable, PinnedPeerRow>,
      ),
      PinnedPeerRow,
      PrefetchHooks Function()
    >;
typedef $$ConversationsTableCreateCompanionBuilder =
    ConversationsCompanion Function({
      required Uint8List conversationId,
      required Uint8List firstParticipantId,
      required Uint8List secondParticipantId,
      required int createdAtMicros,
      Value<int> rowid,
    });
typedef $$ConversationsTableUpdateCompanionBuilder =
    ConversationsCompanion Function({
      Value<Uint8List> conversationId,
      Value<Uint8List> firstParticipantId,
      Value<Uint8List> secondParticipantId,
      Value<int> createdAtMicros,
      Value<int> rowid,
    });

class $$ConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get firstParticipantId => $composableBuilder(
    column: $table.firstParticipantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get secondParticipantId => $composableBuilder(
    column: $table.secondParticipantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get firstParticipantId => $composableBuilder(
    column: $table.firstParticipantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get secondParticipantId => $composableBuilder(
    column: $table.secondParticipantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get firstParticipantId => $composableBuilder(
    column: $table.firstParticipantId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get secondParticipantId => $composableBuilder(
    column: $table.secondParticipantId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtMicros => $composableBuilder(
    column: $table.createdAtMicros,
    builder: (column) => column,
  );
}

class $$ConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsTable,
          ConversationRow,
          $$ConversationsTableFilterComposer,
          $$ConversationsTableOrderingComposer,
          $$ConversationsTableAnnotationComposer,
          $$ConversationsTableCreateCompanionBuilder,
          $$ConversationsTableUpdateCompanionBuilder,
          (
            ConversationRow,
            BaseReferences<_$AppDatabase, $ConversationsTable, ConversationRow>,
          ),
          ConversationRow,
          PrefetchHooks Function()
        > {
  $$ConversationsTableTableManager(_$AppDatabase db, $ConversationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<Uint8List> conversationId = const Value.absent(),
                Value<Uint8List> firstParticipantId = const Value.absent(),
                Value<Uint8List> secondParticipantId = const Value.absent(),
                Value<int> createdAtMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion(
                conversationId: conversationId,
                firstParticipantId: firstParticipantId,
                secondParticipantId: secondParticipantId,
                createdAtMicros: createdAtMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required Uint8List conversationId,
                required Uint8List firstParticipantId,
                required Uint8List secondParticipantId,
                required int createdAtMicros,
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion.insert(
                conversationId: conversationId,
                firstParticipantId: firstParticipantId,
                secondParticipantId: secondParticipantId,
                createdAtMicros: createdAtMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsTable,
      ConversationRow,
      $$ConversationsTableFilterComposer,
      $$ConversationsTableOrderingComposer,
      $$ConversationsTableAnnotationComposer,
      $$ConversationsTableCreateCompanionBuilder,
      $$ConversationsTableUpdateCompanionBuilder,
      (
        ConversationRow,
        BaseReferences<_$AppDatabase, $ConversationsTable, ConversationRow>,
      ),
      ConversationRow,
      PrefetchHooks Function()
    >;
typedef $$StoredOperationsTableCreateCompanionBuilder =
    StoredOperationsCompanion Function({
      required Uint8List operationId,
      required int protocolVersion,
      required Uint8List conversationId,
      required Uint8List authorDeviceId,
      required Uint8List recipientDeviceId,
      required int authorSequence,
      Value<Uint8List?> previousOperationId,
      required int authoredAtMicros,
      required String messageText,
      required Uint8List signature,
      required Uint8List canonicalBytes,
      required int receivedAtMicros,
      Value<int> rowid,
    });
typedef $$StoredOperationsTableUpdateCompanionBuilder =
    StoredOperationsCompanion Function({
      Value<Uint8List> operationId,
      Value<int> protocolVersion,
      Value<Uint8List> conversationId,
      Value<Uint8List> authorDeviceId,
      Value<Uint8List> recipientDeviceId,
      Value<int> authorSequence,
      Value<Uint8List?> previousOperationId,
      Value<int> authoredAtMicros,
      Value<String> messageText,
      Value<Uint8List> signature,
      Value<Uint8List> canonicalBytes,
      Value<int> receivedAtMicros,
      Value<int> rowid,
    });

class $$StoredOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredOperationsTable> {
  $$StoredOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get authorSequence => $composableBuilder(
    column: $table.authorSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get previousOperationId => $composableBuilder(
    column: $table.previousOperationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get authoredAtMicros => $composableBuilder(
    column: $table.authoredAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get canonicalBytes => $composableBuilder(
    column: $table.canonicalBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receivedAtMicros => $composableBuilder(
    column: $table.receivedAtMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoredOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredOperationsTable> {
  $$StoredOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get authorSequence => $composableBuilder(
    column: $table.authorSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get previousOperationId => $composableBuilder(
    column: $table.previousOperationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get authoredAtMicros => $composableBuilder(
    column: $table.authoredAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get signature => $composableBuilder(
    column: $table.signature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get canonicalBytes => $composableBuilder(
    column: $table.canonicalBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receivedAtMicros => $composableBuilder(
    column: $table.receivedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredOperationsTable> {
  $$StoredOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get protocolVersion => $composableBuilder(
    column: $table.protocolVersion,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get authorSequence => $composableBuilder(
    column: $table.authorSequence,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get previousOperationId => $composableBuilder(
    column: $table.previousOperationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get authoredAtMicros => $composableBuilder(
    column: $table.authoredAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get signature =>
      $composableBuilder(column: $table.signature, builder: (column) => column);

  GeneratedColumn<Uint8List> get canonicalBytes => $composableBuilder(
    column: $table.canonicalBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get receivedAtMicros => $composableBuilder(
    column: $table.receivedAtMicros,
    builder: (column) => column,
  );
}

class $$StoredOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredOperationsTable,
          StoredOperationRow,
          $$StoredOperationsTableFilterComposer,
          $$StoredOperationsTableOrderingComposer,
          $$StoredOperationsTableAnnotationComposer,
          $$StoredOperationsTableCreateCompanionBuilder,
          $$StoredOperationsTableUpdateCompanionBuilder,
          (
            StoredOperationRow,
            BaseReferences<
              _$AppDatabase,
              $StoredOperationsTable,
              StoredOperationRow
            >,
          ),
          StoredOperationRow,
          PrefetchHooks Function()
        > {
  $$StoredOperationsTableTableManager(
    _$AppDatabase db,
    $StoredOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoredOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoredOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoredOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<Uint8List> operationId = const Value.absent(),
                Value<int> protocolVersion = const Value.absent(),
                Value<Uint8List> conversationId = const Value.absent(),
                Value<Uint8List> authorDeviceId = const Value.absent(),
                Value<Uint8List> recipientDeviceId = const Value.absent(),
                Value<int> authorSequence = const Value.absent(),
                Value<Uint8List?> previousOperationId = const Value.absent(),
                Value<int> authoredAtMicros = const Value.absent(),
                Value<String> messageText = const Value.absent(),
                Value<Uint8List> signature = const Value.absent(),
                Value<Uint8List> canonicalBytes = const Value.absent(),
                Value<int> receivedAtMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredOperationsCompanion(
                operationId: operationId,
                protocolVersion: protocolVersion,
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                recipientDeviceId: recipientDeviceId,
                authorSequence: authorSequence,
                previousOperationId: previousOperationId,
                authoredAtMicros: authoredAtMicros,
                messageText: messageText,
                signature: signature,
                canonicalBytes: canonicalBytes,
                receivedAtMicros: receivedAtMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required Uint8List operationId,
                required int protocolVersion,
                required Uint8List conversationId,
                required Uint8List authorDeviceId,
                required Uint8List recipientDeviceId,
                required int authorSequence,
                Value<Uint8List?> previousOperationId = const Value.absent(),
                required int authoredAtMicros,
                required String messageText,
                required Uint8List signature,
                required Uint8List canonicalBytes,
                required int receivedAtMicros,
                Value<int> rowid = const Value.absent(),
              }) => StoredOperationsCompanion.insert(
                operationId: operationId,
                protocolVersion: protocolVersion,
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                recipientDeviceId: recipientDeviceId,
                authorSequence: authorSequence,
                previousOperationId: previousOperationId,
                authoredAtMicros: authoredAtMicros,
                messageText: messageText,
                signature: signature,
                canonicalBytes: canonicalBytes,
                receivedAtMicros: receivedAtMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredOperationsTable,
      StoredOperationRow,
      $$StoredOperationsTableFilterComposer,
      $$StoredOperationsTableOrderingComposer,
      $$StoredOperationsTableAnnotationComposer,
      $$StoredOperationsTableCreateCompanionBuilder,
      $$StoredOperationsTableUpdateCompanionBuilder,
      (
        StoredOperationRow,
        BaseReferences<
          _$AppDatabase,
          $StoredOperationsTable,
          StoredOperationRow
        >,
      ),
      StoredOperationRow,
      PrefetchHooks Function()
    >;
typedef $$FeedHeadsTableCreateCompanionBuilder = FeedHeadsCompanion Function({
  required Uint8List conversationId,
  required Uint8List authorDeviceId,
  required int headSequence,
  required Uint8List headOperationId,
  Value<bool> isQuarantined,
  Value<int> rowid,
});
typedef $$FeedHeadsTableUpdateCompanionBuilder = FeedHeadsCompanion Function({
  Value<Uint8List> conversationId,
  Value<Uint8List> authorDeviceId,
  Value<int> headSequence,
  Value<Uint8List> headOperationId,
  Value<bool> isQuarantined,
  Value<int> rowid,
});

class $$FeedHeadsTableFilterComposer
    extends Composer<_$AppDatabase, $FeedHeadsTable> {
  $$FeedHeadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get headSequence => $composableBuilder(
    column: $table.headSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get headOperationId => $composableBuilder(
    column: $table.headOperationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isQuarantined => $composableBuilder(
    column: $table.isQuarantined,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeedHeadsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedHeadsTable> {
  $$FeedHeadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get headSequence => $composableBuilder(
    column: $table.headSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get headOperationId => $composableBuilder(
    column: $table.headOperationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isQuarantined => $composableBuilder(
    column: $table.isQuarantined,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedHeadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedHeadsTable> {
  $$FeedHeadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get headSequence => $composableBuilder(
    column: $table.headSequence,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get headOperationId => $composableBuilder(
    column: $table.headOperationId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isQuarantined => $composableBuilder(
    column: $table.isQuarantined,
    builder: (column) => column,
  );
}

class $$FeedHeadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedHeadsTable,
          FeedHeadRow,
          $$FeedHeadsTableFilterComposer,
          $$FeedHeadsTableOrderingComposer,
          $$FeedHeadsTableAnnotationComposer,
          $$FeedHeadsTableCreateCompanionBuilder,
          $$FeedHeadsTableUpdateCompanionBuilder,
          (
            FeedHeadRow,
            BaseReferences<_$AppDatabase, $FeedHeadsTable, FeedHeadRow>,
          ),
          FeedHeadRow,
          PrefetchHooks Function()
        > {
  $$FeedHeadsTableTableManager(_$AppDatabase db, $FeedHeadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedHeadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedHeadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedHeadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<Uint8List> conversationId = const Value.absent(),
                Value<Uint8List> authorDeviceId = const Value.absent(),
                Value<int> headSequence = const Value.absent(),
                Value<Uint8List> headOperationId = const Value.absent(),
                Value<bool> isQuarantined = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeedHeadsCompanion(
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                headSequence: headSequence,
                headOperationId: headOperationId,
                isQuarantined: isQuarantined,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required Uint8List conversationId,
                required Uint8List authorDeviceId,
                required int headSequence,
                required Uint8List headOperationId,
                Value<bool> isQuarantined = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeedHeadsCompanion.insert(
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                headSequence: headSequence,
                headOperationId: headOperationId,
                isQuarantined: isQuarantined,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedHeadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedHeadsTable,
      FeedHeadRow,
      $$FeedHeadsTableFilterComposer,
      $$FeedHeadsTableOrderingComposer,
      $$FeedHeadsTableAnnotationComposer,
      $$FeedHeadsTableCreateCompanionBuilder,
      $$FeedHeadsTableUpdateCompanionBuilder,
      (
        FeedHeadRow,
        BaseReferences<_$AppDatabase, $FeedHeadsTable, FeedHeadRow>,
      ),
      FeedHeadRow,
      PrefetchHooks Function()
    >;
typedef $$MessageProjectionsTableCreateCompanionBuilder =
    MessageProjectionsCompanion Function({
      required Uint8List operationId,
      required Uint8List conversationId,
      required Uint8List authorDeviceId,
      required Uint8List recipientDeviceId,
      required int authorSequence,
      required int authoredAtMicros,
      required String messageText,
      required int insertedAtMicros,
      Value<int> rowid,
    });
typedef $$MessageProjectionsTableUpdateCompanionBuilder =
    MessageProjectionsCompanion Function({
      Value<Uint8List> operationId,
      Value<Uint8List> conversationId,
      Value<Uint8List> authorDeviceId,
      Value<Uint8List> recipientDeviceId,
      Value<int> authorSequence,
      Value<int> authoredAtMicros,
      Value<String> messageText,
      Value<int> insertedAtMicros,
      Value<int> rowid,
    });

class $$MessageProjectionsTableFilterComposer
    extends Composer<_$AppDatabase, $MessageProjectionsTable> {
  $$MessageProjectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get authorSequence => $composableBuilder(
    column: $table.authorSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get authoredAtMicros => $composableBuilder(
    column: $table.authoredAtMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get insertedAtMicros => $composableBuilder(
    column: $table.insertedAtMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessageProjectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageProjectionsTable> {
  $$MessageProjectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get authorSequence => $composableBuilder(
    column: $table.authorSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get authoredAtMicros => $composableBuilder(
    column: $table.authoredAtMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get insertedAtMicros => $composableBuilder(
    column: $table.insertedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessageProjectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageProjectionsTable> {
  $$MessageProjectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get authorSequence => $composableBuilder(
    column: $table.authorSequence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get authoredAtMicros => $composableBuilder(
    column: $table.authoredAtMicros,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageText => $composableBuilder(
    column: $table.messageText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get insertedAtMicros => $composableBuilder(
    column: $table.insertedAtMicros,
    builder: (column) => column,
  );
}

class $$MessageProjectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessageProjectionsTable,
          MessageProjectionRow,
          $$MessageProjectionsTableFilterComposer,
          $$MessageProjectionsTableOrderingComposer,
          $$MessageProjectionsTableAnnotationComposer,
          $$MessageProjectionsTableCreateCompanionBuilder,
          $$MessageProjectionsTableUpdateCompanionBuilder,
          (
            MessageProjectionRow,
            BaseReferences<
              _$AppDatabase,
              $MessageProjectionsTable,
              MessageProjectionRow
            >,
          ),
          MessageProjectionRow,
          PrefetchHooks Function()
        > {
  $$MessageProjectionsTableTableManager(
    _$AppDatabase db,
    $MessageProjectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageProjectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageProjectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageProjectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<Uint8List> operationId = const Value.absent(),
                Value<Uint8List> conversationId = const Value.absent(),
                Value<Uint8List> authorDeviceId = const Value.absent(),
                Value<Uint8List> recipientDeviceId = const Value.absent(),
                Value<int> authorSequence = const Value.absent(),
                Value<int> authoredAtMicros = const Value.absent(),
                Value<String> messageText = const Value.absent(),
                Value<int> insertedAtMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageProjectionsCompanion(
                operationId: operationId,
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                recipientDeviceId: recipientDeviceId,
                authorSequence: authorSequence,
                authoredAtMicros: authoredAtMicros,
                messageText: messageText,
                insertedAtMicros: insertedAtMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required Uint8List operationId,
                required Uint8List conversationId,
                required Uint8List authorDeviceId,
                required Uint8List recipientDeviceId,
                required int authorSequence,
                required int authoredAtMicros,
                required String messageText,
                required int insertedAtMicros,
                Value<int> rowid = const Value.absent(),
              }) => MessageProjectionsCompanion.insert(
                operationId: operationId,
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                recipientDeviceId: recipientDeviceId,
                authorSequence: authorSequence,
                authoredAtMicros: authoredAtMicros,
                messageText: messageText,
                insertedAtMicros: insertedAtMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessageProjectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessageProjectionsTable,
      MessageProjectionRow,
      $$MessageProjectionsTableFilterComposer,
      $$MessageProjectionsTableOrderingComposer,
      $$MessageProjectionsTableAnnotationComposer,
      $$MessageProjectionsTableCreateCompanionBuilder,
      $$MessageProjectionsTableUpdateCompanionBuilder,
      (
        MessageProjectionRow,
        BaseReferences<
          _$AppDatabase,
          $MessageProjectionsTable,
          MessageProjectionRow
        >,
      ),
      MessageProjectionRow,
      PrefetchHooks Function()
    >;
typedef $$RetentionFloorsTableCreateCompanionBuilder =
    RetentionFloorsCompanion Function({
      required Uint8List conversationId,
      required Uint8List authorDeviceId,
      required int retainedThroughSequence,
      Value<int> rowid,
    });
typedef $$RetentionFloorsTableUpdateCompanionBuilder =
    RetentionFloorsCompanion Function({
      Value<Uint8List> conversationId,
      Value<Uint8List> authorDeviceId,
      Value<int> retainedThroughSequence,
      Value<int> rowid,
    });

class $$RetentionFloorsTableFilterComposer
    extends Composer<_$AppDatabase, $RetentionFloorsTable> {
  $$RetentionFloorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retainedThroughSequence => $composableBuilder(
    column: $table.retainedThroughSequence,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RetentionFloorsTableOrderingComposer
    extends Composer<_$AppDatabase, $RetentionFloorsTable> {
  $$RetentionFloorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retainedThroughSequence => $composableBuilder(
    column: $table.retainedThroughSequence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RetentionFloorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RetentionFloorsTable> {
  $$RetentionFloorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retainedThroughSequence => $composableBuilder(
    column: $table.retainedThroughSequence,
    builder: (column) => column,
  );
}

class $$RetentionFloorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RetentionFloorsTable,
          RetentionFloorRow,
          $$RetentionFloorsTableFilterComposer,
          $$RetentionFloorsTableOrderingComposer,
          $$RetentionFloorsTableAnnotationComposer,
          $$RetentionFloorsTableCreateCompanionBuilder,
          $$RetentionFloorsTableUpdateCompanionBuilder,
          (
            RetentionFloorRow,
            BaseReferences<
              _$AppDatabase,
              $RetentionFloorsTable,
              RetentionFloorRow
            >,
          ),
          RetentionFloorRow,
          PrefetchHooks Function()
        > {
  $$RetentionFloorsTableTableManager(
    _$AppDatabase db,
    $RetentionFloorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RetentionFloorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RetentionFloorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RetentionFloorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<Uint8List> conversationId = const Value.absent(),
                Value<Uint8List> authorDeviceId = const Value.absent(),
                Value<int> retainedThroughSequence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RetentionFloorsCompanion(
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                retainedThroughSequence: retainedThroughSequence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required Uint8List conversationId,
                required Uint8List authorDeviceId,
                required int retainedThroughSequence,
                Value<int> rowid = const Value.absent(),
              }) => RetentionFloorsCompanion.insert(
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                retainedThroughSequence: retainedThroughSequence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RetentionFloorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RetentionFloorsTable,
      RetentionFloorRow,
      $$RetentionFloorsTableFilterComposer,
      $$RetentionFloorsTableOrderingComposer,
      $$RetentionFloorsTableAnnotationComposer,
      $$RetentionFloorsTableCreateCompanionBuilder,
      $$RetentionFloorsTableUpdateCompanionBuilder,
      (
        RetentionFloorRow,
        BaseReferences<_$AppDatabase, $RetentionFloorsTable, RetentionFloorRow>,
      ),
      RetentionFloorRow,
      PrefetchHooks Function()
    >;
typedef $$DeliveryAcknowledgementsTableCreateCompanionBuilder =
    DeliveryAcknowledgementsCompanion Function({
      required Uint8List conversationId,
      required Uint8List authorDeviceId,
      required Uint8List recipientDeviceId,
      required int highestSequence,
      required int updatedAtMicros,
      Value<int> rowid,
    });
typedef $$DeliveryAcknowledgementsTableUpdateCompanionBuilder =
    DeliveryAcknowledgementsCompanion Function({
      Value<Uint8List> conversationId,
      Value<Uint8List> authorDeviceId,
      Value<Uint8List> recipientDeviceId,
      Value<int> highestSequence,
      Value<int> updatedAtMicros,
      Value<int> rowid,
    });

class $$DeliveryAcknowledgementsTableFilterComposer
    extends Composer<_$AppDatabase, $DeliveryAcknowledgementsTable> {
  $$DeliveryAcknowledgementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get highestSequence => $composableBuilder(
    column: $table.highestSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeliveryAcknowledgementsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeliveryAcknowledgementsTable> {
  $$DeliveryAcknowledgementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get highestSequence => $composableBuilder(
    column: $table.highestSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeliveryAcknowledgementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeliveryAcknowledgementsTable> {
  $$DeliveryAcknowledgementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<Uint8List> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get authorDeviceId => $composableBuilder(
    column: $table.authorDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get recipientDeviceId => $composableBuilder(
    column: $table.recipientDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get highestSequence => $composableBuilder(
    column: $table.highestSequence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMicros => $composableBuilder(
    column: $table.updatedAtMicros,
    builder: (column) => column,
  );
}

class $$DeliveryAcknowledgementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeliveryAcknowledgementsTable,
          DeliveryAcknowledgementRow,
          $$DeliveryAcknowledgementsTableFilterComposer,
          $$DeliveryAcknowledgementsTableOrderingComposer,
          $$DeliveryAcknowledgementsTableAnnotationComposer,
          $$DeliveryAcknowledgementsTableCreateCompanionBuilder,
          $$DeliveryAcknowledgementsTableUpdateCompanionBuilder,
          (
            DeliveryAcknowledgementRow,
            BaseReferences<
              _$AppDatabase,
              $DeliveryAcknowledgementsTable,
              DeliveryAcknowledgementRow
            >,
          ),
          DeliveryAcknowledgementRow,
          PrefetchHooks Function()
        > {
  $$DeliveryAcknowledgementsTableTableManager(
    _$AppDatabase db,
    $DeliveryAcknowledgementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeliveryAcknowledgementsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DeliveryAcknowledgementsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DeliveryAcknowledgementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<Uint8List> conversationId = const Value.absent(),
                Value<Uint8List> authorDeviceId = const Value.absent(),
                Value<Uint8List> recipientDeviceId = const Value.absent(),
                Value<int> highestSequence = const Value.absent(),
                Value<int> updatedAtMicros = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeliveryAcknowledgementsCompanion(
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                recipientDeviceId: recipientDeviceId,
                highestSequence: highestSequence,
                updatedAtMicros: updatedAtMicros,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required Uint8List conversationId,
                required Uint8List authorDeviceId,
                required Uint8List recipientDeviceId,
                required int highestSequence,
                required int updatedAtMicros,
                Value<int> rowid = const Value.absent(),
              }) => DeliveryAcknowledgementsCompanion.insert(
                conversationId: conversationId,
                authorDeviceId: authorDeviceId,
                recipientDeviceId: recipientDeviceId,
                highestSequence: highestSequence,
                updatedAtMicros: updatedAtMicros,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeliveryAcknowledgementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeliveryAcknowledgementsTable,
      DeliveryAcknowledgementRow,
      $$DeliveryAcknowledgementsTableFilterComposer,
      $$DeliveryAcknowledgementsTableOrderingComposer,
      $$DeliveryAcknowledgementsTableAnnotationComposer,
      $$DeliveryAcknowledgementsTableCreateCompanionBuilder,
      $$DeliveryAcknowledgementsTableUpdateCompanionBuilder,
      (
        DeliveryAcknowledgementRow,
        BaseReferences<
          _$AppDatabase,
          $DeliveryAcknowledgementsTable,
          DeliveryAcknowledgementRow
        >,
      ),
      DeliveryAcknowledgementRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalProfilesTableTableManager get localProfiles =>
      $$LocalProfilesTableTableManager(_db, _db.localProfiles);
  $$PinnedPeersTableTableManager get pinnedPeers =>
      $$PinnedPeersTableTableManager(_db, _db.pinnedPeers);
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db, _db.conversations);
  $$StoredOperationsTableTableManager get storedOperations =>
      $$StoredOperationsTableTableManager(_db, _db.storedOperations);
  $$FeedHeadsTableTableManager get feedHeads =>
      $$FeedHeadsTableTableManager(_db, _db.feedHeads);
  $$MessageProjectionsTableTableManager get messageProjections =>
      $$MessageProjectionsTableTableManager(_db, _db.messageProjections);
  $$RetentionFloorsTableTableManager get retentionFloors =>
      $$RetentionFloorsTableTableManager(_db, _db.retentionFloors);
  $$DeliveryAcknowledgementsTableTableManager get deliveryAcknowledgements =>
      $$DeliveryAcknowledgementsTableTableManager(
        _db,
        _db.deliveryAcknowledgements,
      );
}
