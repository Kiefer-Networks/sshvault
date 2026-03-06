// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SshKeysTable extends SshKeys with TableInfo<$SshKeysTable, SshKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SshKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyTypeMeta = const VerificationMeta(
    'keyType',
  );
  @override
  late final GeneratedColumn<String> keyType = GeneratedColumn<String>(
    'key_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _publicKeyMeta = const VerificationMeta(
    'publicKey',
  );
  @override
  late final GeneratedColumn<String> publicKey = GeneratedColumn<String>(
    'public_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedWithMeta = const VerificationMeta(
    'sharedWith',
  );
  @override
  late final GeneratedColumn<String> sharedWith = GeneratedColumn<String>(
    'shared_with',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    keyType,
    fingerprint,
    publicKey,
    comment,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ssh_keys';
  @override
  VerificationContext validateIntegrity(
    Insertable<SshKey> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('key_type')) {
      context.handle(
        _keyTypeMeta,
        keyType.isAcceptableOrUnknown(data['key_type']!, _keyTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_keyTypeMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    }
    if (data.containsKey('public_key')) {
      context.handle(
        _publicKeyMeta,
        publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('shared_with')) {
      context.handle(
        _sharedWithMeta,
        sharedWith.isAcceptableOrUnknown(data['shared_with']!, _sharedWithMeta),
      );
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SshKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SshKey(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      keyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_type'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      publicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}public_key'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      sharedWith: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_with'],
      ),
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SshKeysTable createAlias(String alias) {
    return $SshKeysTable(attachedDatabase, alias);
  }
}

class SshKey extends DataClass implements Insertable<SshKey> {
  final String id;
  final String name;
  final String keyType;
  final String fingerprint;
  final String publicKey;
  final String comment;
  final String? ownerId;
  final String? sharedWith;
  final String? permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SshKey({
    required this.id,
    required this.name,
    required this.keyType,
    required this.fingerprint,
    required this.publicKey,
    required this.comment,
    this.ownerId,
    this.sharedWith,
    this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['key_type'] = Variable<String>(keyType);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['public_key'] = Variable<String>(publicKey);
    map['comment'] = Variable<String>(comment);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    if (!nullToAbsent || sharedWith != null) {
      map['shared_with'] = Variable<String>(sharedWith);
    }
    if (!nullToAbsent || permissions != null) {
      map['permissions'] = Variable<String>(permissions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SshKeysCompanion toCompanion(bool nullToAbsent) {
    return SshKeysCompanion(
      id: Value(id),
      name: Value(name),
      keyType: Value(keyType),
      fingerprint: Value(fingerprint),
      publicKey: Value(publicKey),
      comment: Value(comment),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      sharedWith: sharedWith == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedWith),
      permissions: permissions == null && nullToAbsent
          ? const Value.absent()
          : Value(permissions),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SshKey.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SshKey(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      keyType: serializer.fromJson<String>(json['keyType']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      publicKey: serializer.fromJson<String>(json['publicKey']),
      comment: serializer.fromJson<String>(json['comment']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      sharedWith: serializer.fromJson<String?>(json['sharedWith']),
      permissions: serializer.fromJson<String?>(json['permissions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'keyType': serializer.toJson<String>(keyType),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'publicKey': serializer.toJson<String>(publicKey),
      'comment': serializer.toJson<String>(comment),
      'ownerId': serializer.toJson<String?>(ownerId),
      'sharedWith': serializer.toJson<String?>(sharedWith),
      'permissions': serializer.toJson<String?>(permissions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SshKey copyWith({
    String? id,
    String? name,
    String? keyType,
    String? fingerprint,
    String? publicKey,
    String? comment,
    Value<String?> ownerId = const Value.absent(),
    Value<String?> sharedWith = const Value.absent(),
    Value<String?> permissions = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SshKey(
    id: id ?? this.id,
    name: name ?? this.name,
    keyType: keyType ?? this.keyType,
    fingerprint: fingerprint ?? this.fingerprint,
    publicKey: publicKey ?? this.publicKey,
    comment: comment ?? this.comment,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    sharedWith: sharedWith.present ? sharedWith.value : this.sharedWith,
    permissions: permissions.present ? permissions.value : this.permissions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SshKey copyWithCompanion(SshKeysCompanion data) {
    return SshKey(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      keyType: data.keyType.present ? data.keyType.value : this.keyType,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      comment: data.comment.present ? data.comment.value : this.comment,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      sharedWith: data.sharedWith.present
          ? data.sharedWith.value
          : this.sharedWith,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SshKey(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('publicKey: $publicKey, ')
          ..write('comment: $comment, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    keyType,
    fingerprint,
    publicKey,
    comment,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SshKey &&
          other.id == this.id &&
          other.name == this.name &&
          other.keyType == this.keyType &&
          other.fingerprint == this.fingerprint &&
          other.publicKey == this.publicKey &&
          other.comment == this.comment &&
          other.ownerId == this.ownerId &&
          other.sharedWith == this.sharedWith &&
          other.permissions == this.permissions &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SshKeysCompanion extends UpdateCompanion<SshKey> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> keyType;
  final Value<String> fingerprint;
  final Value<String> publicKey;
  final Value<String> comment;
  final Value<String?> ownerId;
  final Value<String?> sharedWith;
  final Value<String?> permissions;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SshKeysCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.keyType = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.comment = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SshKeysCompanion.insert({
    required String id,
    required String name,
    required String keyType,
    this.fingerprint = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.comment = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       keyType = Value(keyType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SshKey> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? keyType,
    Expression<String>? fingerprint,
    Expression<String>? publicKey,
    Expression<String>? comment,
    Expression<String>? ownerId,
    Expression<String>? sharedWith,
    Expression<String>? permissions,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (keyType != null) 'key_type': keyType,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (publicKey != null) 'public_key': publicKey,
      if (comment != null) 'comment': comment,
      if (ownerId != null) 'owner_id': ownerId,
      if (sharedWith != null) 'shared_with': sharedWith,
      if (permissions != null) 'permissions': permissions,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SshKeysCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? keyType,
    Value<String>? fingerprint,
    Value<String>? publicKey,
    Value<String>? comment,
    Value<String?>? ownerId,
    Value<String?>? sharedWith,
    Value<String?>? permissions,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SshKeysCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      keyType: keyType ?? this.keyType,
      fingerprint: fingerprint ?? this.fingerprint,
      publicKey: publicKey ?? this.publicKey,
      comment: comment ?? this.comment,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (keyType.present) {
      map['key_type'] = Variable<String>(keyType.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<String>(publicKey.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sharedWith.present) {
      map['shared_with'] = Variable<String>(sharedWith.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SshKeysCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('publicKey: $publicKey, ')
          ..write('comment: $comment, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF6C63FF),
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('server'),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedWithMeta = const VerificationMeta(
    'sharedWith',
  );
  @override
  late final GeneratedColumn<String> sharedWith = GeneratedColumn<String>(
    'shared_with',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    color,
    iconName,
    parentId,
    sortOrder,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<Group> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('shared_with')) {
      context.handle(
        _sharedWithMeta,
        sharedWith.isAcceptableOrUnknown(data['shared_with']!, _sharedWithMeta),
      );
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      sharedWith: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_with'],
      ),
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final String id;
  final String name;
  final int color;
  final String iconName;
  final String? parentId;
  final int sortOrder;
  final String? ownerId;
  final String? sharedWith;
  final String? permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Group({
    required this.id,
    required this.name,
    required this.color,
    required this.iconName,
    this.parentId,
    required this.sortOrder,
    this.ownerId,
    this.sharedWith,
    this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['icon_name'] = Variable<String>(iconName);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    if (!nullToAbsent || sharedWith != null) {
      map['shared_with'] = Variable<String>(sharedWith);
    }
    if (!nullToAbsent || permissions != null) {
      map['permissions'] = Variable<String>(permissions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      iconName: Value(iconName),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      sortOrder: Value(sortOrder),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      sharedWith: sharedWith == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedWith),
      permissions: permissions == null && nullToAbsent
          ? const Value.absent()
          : Value(permissions),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Group.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      iconName: serializer.fromJson<String>(json['iconName']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      sharedWith: serializer.fromJson<String?>(json['sharedWith']),
      permissions: serializer.fromJson<String?>(json['permissions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'iconName': serializer.toJson<String>(iconName),
      'parentId': serializer.toJson<String?>(parentId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'ownerId': serializer.toJson<String?>(ownerId),
      'sharedWith': serializer.toJson<String?>(sharedWith),
      'permissions': serializer.toJson<String?>(permissions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Group copyWith({
    String? id,
    String? name,
    int? color,
    String? iconName,
    Value<String?> parentId = const Value.absent(),
    int? sortOrder,
    Value<String?> ownerId = const Value.absent(),
    Value<String?> sharedWith = const Value.absent(),
    Value<String?> permissions = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Group(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    iconName: iconName ?? this.iconName,
    parentId: parentId.present ? parentId.value : this.parentId,
    sortOrder: sortOrder ?? this.sortOrder,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    sharedWith: sharedWith.present ? sharedWith.value : this.sharedWith,
    permissions: permissions.present ? permissions.value : this.permissions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      sharedWith: data.sharedWith.present
          ? data.sharedWith.value
          : this.sharedWith,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconName: $iconName, ')
          ..write('parentId: $parentId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    color,
    iconName,
    parentId,
    sortOrder,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.iconName == this.iconName &&
          other.parentId == this.parentId &&
          other.sortOrder == this.sortOrder &&
          other.ownerId == this.ownerId &&
          other.sharedWith == this.sharedWith &&
          other.permissions == this.permissions &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<String> iconName;
  final Value<String?> parentId;
  final Value<int> sortOrder;
  final Value<String?> ownerId;
  final Value<String?> sharedWith;
  final Value<String?> permissions;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.iconName = const Value.absent(),
    this.parentId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    this.iconName = const Value.absent(),
    this.parentId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Group> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? iconName,
    Expression<String>? parentId,
    Expression<int>? sortOrder,
    Expression<String>? ownerId,
    Expression<String>? sharedWith,
    Expression<String>? permissions,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (iconName != null) 'icon_name': iconName,
      if (parentId != null) 'parent_id': parentId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (ownerId != null) 'owner_id': ownerId,
      if (sharedWith != null) 'shared_with': sharedWith,
      if (permissions != null) 'permissions': permissions,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? color,
    Value<String>? iconName,
    Value<String?>? parentId,
    Value<int>? sortOrder,
    Value<String?>? ownerId,
    Value<String?>? sharedWith,
    Value<String?>? permissions,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      parentId: parentId ?? this.parentId,
      sortOrder: sortOrder ?? this.sortOrder,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sharedWith.present) {
      map['shared_with'] = Variable<String>(sharedWith.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('iconName: $iconName, ')
          ..write('parentId: $parentId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServersTable extends Servers with TableInfo<$ServersTable, Server> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostnameMeta = const VerificationMeta(
    'hostname',
  );
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
    'hostname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(22),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authMethodMeta = const VerificationMeta(
    'authMethod',
  );
  @override
  late final GeneratedColumn<String> authMethod = GeneratedColumn<String>(
    'auth_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('password'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF6C63FF),
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('server'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _sshKeyIdMeta = const VerificationMeta(
    'sshKeyId',
  );
  @override
  late final GeneratedColumn<String> sshKeyId = GeneratedColumn<String>(
    'ssh_key_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ssh_keys (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distroIdMeta = const VerificationMeta(
    'distroId',
  );
  @override
  late final GeneratedColumn<String> distroId = GeneratedColumn<String>(
    'distro_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distroNameMeta = const VerificationMeta(
    'distroName',
  );
  @override
  late final GeneratedColumn<String> distroName = GeneratedColumn<String>(
    'distro_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jumpHostIdMeta = const VerificationMeta(
    'jumpHostId',
  );
  @override
  late final GeneratedColumn<String> jumpHostId = GeneratedColumn<String>(
    'jump_host_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proxyTypeMeta = const VerificationMeta(
    'proxyType',
  );
  @override
  late final GeneratedColumn<String> proxyType = GeneratedColumn<String>(
    'proxy_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _proxyHostMeta = const VerificationMeta(
    'proxyHost',
  );
  @override
  late final GeneratedColumn<String> proxyHost = GeneratedColumn<String>(
    'proxy_host',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _proxyPortMeta = const VerificationMeta(
    'proxyPort',
  );
  @override
  late final GeneratedColumn<int> proxyPort = GeneratedColumn<int>(
    'proxy_port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1080),
  );
  static const VerificationMeta _proxyUsernameMeta = const VerificationMeta(
    'proxyUsername',
  );
  @override
  late final GeneratedColumn<String> proxyUsername = GeneratedColumn<String>(
    'proxy_username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _useGlobalProxyMeta = const VerificationMeta(
    'useGlobalProxy',
  );
  @override
  late final GeneratedColumn<bool> useGlobalProxy = GeneratedColumn<bool>(
    'use_global_proxy',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_global_proxy" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _requiresVpnMeta = const VerificationMeta(
    'requiresVpn',
  );
  @override
  late final GeneratedColumn<bool> requiresVpn = GeneratedColumn<bool>(
    'requires_vpn',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_vpn" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _postConnectCommandsMeta =
      const VerificationMeta('postConnectCommands');
  @override
  late final GeneratedColumn<String> postConnectCommands =
      GeneratedColumn<String>(
        'post_connect_commands',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastConnectedAtMeta = const VerificationMeta(
    'lastConnectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastConnectedAt =
      GeneratedColumn<DateTime>(
        'last_connected_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedWithMeta = const VerificationMeta(
    'sharedWith',
  );
  @override
  late final GeneratedColumn<String> sharedWith = GeneratedColumn<String>(
    'shared_with',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    hostname,
    port,
    username,
    authMethod,
    notes,
    color,
    iconName,
    isActive,
    groupId,
    sshKeyId,
    sortOrder,
    distroId,
    distroName,
    jumpHostId,
    proxyType,
    proxyHost,
    proxyPort,
    proxyUsername,
    useGlobalProxy,
    requiresVpn,
    postConnectCommands,
    isFavorite,
    lastConnectedAt,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Server> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hostname')) {
      context.handle(
        _hostnameMeta,
        hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta),
      );
    } else if (isInserting) {
      context.missing(_hostnameMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('auth_method')) {
      context.handle(
        _authMethodMeta,
        authMethod.isAcceptableOrUnknown(data['auth_method']!, _authMethodMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('ssh_key_id')) {
      context.handle(
        _sshKeyIdMeta,
        sshKeyId.isAcceptableOrUnknown(data['ssh_key_id']!, _sshKeyIdMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('distro_id')) {
      context.handle(
        _distroIdMeta,
        distroId.isAcceptableOrUnknown(data['distro_id']!, _distroIdMeta),
      );
    }
    if (data.containsKey('distro_name')) {
      context.handle(
        _distroNameMeta,
        distroName.isAcceptableOrUnknown(data['distro_name']!, _distroNameMeta),
      );
    }
    if (data.containsKey('jump_host_id')) {
      context.handle(
        _jumpHostIdMeta,
        jumpHostId.isAcceptableOrUnknown(
          data['jump_host_id']!,
          _jumpHostIdMeta,
        ),
      );
    }
    if (data.containsKey('proxy_type')) {
      context.handle(
        _proxyTypeMeta,
        proxyType.isAcceptableOrUnknown(data['proxy_type']!, _proxyTypeMeta),
      );
    }
    if (data.containsKey('proxy_host')) {
      context.handle(
        _proxyHostMeta,
        proxyHost.isAcceptableOrUnknown(data['proxy_host']!, _proxyHostMeta),
      );
    }
    if (data.containsKey('proxy_port')) {
      context.handle(
        _proxyPortMeta,
        proxyPort.isAcceptableOrUnknown(data['proxy_port']!, _proxyPortMeta),
      );
    }
    if (data.containsKey('proxy_username')) {
      context.handle(
        _proxyUsernameMeta,
        proxyUsername.isAcceptableOrUnknown(
          data['proxy_username']!,
          _proxyUsernameMeta,
        ),
      );
    }
    if (data.containsKey('use_global_proxy')) {
      context.handle(
        _useGlobalProxyMeta,
        useGlobalProxy.isAcceptableOrUnknown(
          data['use_global_proxy']!,
          _useGlobalProxyMeta,
        ),
      );
    }
    if (data.containsKey('requires_vpn')) {
      context.handle(
        _requiresVpnMeta,
        requiresVpn.isAcceptableOrUnknown(
          data['requires_vpn']!,
          _requiresVpnMeta,
        ),
      );
    }
    if (data.containsKey('post_connect_commands')) {
      context.handle(
        _postConnectCommandsMeta,
        postConnectCommands.isAcceptableOrUnknown(
          data['post_connect_commands']!,
          _postConnectCommandsMeta,
        ),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('last_connected_at')) {
      context.handle(
        _lastConnectedAtMeta,
        lastConnectedAt.isAcceptableOrUnknown(
          data['last_connected_at']!,
          _lastConnectedAtMeta,
        ),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('shared_with')) {
      context.handle(
        _sharedWithMeta,
        sharedWith.isAcceptableOrUnknown(data['shared_with']!, _sharedWithMeta),
      );
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Server map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Server(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hostname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hostname'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      authMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_method'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      sshKeyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ssh_key_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      distroId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distro_id'],
      ),
      distroName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distro_name'],
      ),
      jumpHostId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jump_host_id'],
      ),
      proxyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proxy_type'],
      )!,
      proxyHost: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proxy_host'],
      )!,
      proxyPort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proxy_port'],
      )!,
      proxyUsername: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proxy_username'],
      ),
      useGlobalProxy: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_global_proxy'],
      )!,
      requiresVpn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_vpn'],
      )!,
      postConnectCommands: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}post_connect_commands'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      lastConnectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_connected_at'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      sharedWith: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_with'],
      ),
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(attachedDatabase, alias);
  }
}

class Server extends DataClass implements Insertable<Server> {
  final String id;
  final String name;
  final String hostname;
  final int port;
  final String username;
  final String authMethod;
  final String notes;
  final int color;
  final String iconName;
  final bool isActive;
  final String? groupId;
  final String? sshKeyId;
  final int sortOrder;
  final String? distroId;
  final String? distroName;
  final String? jumpHostId;
  final String proxyType;
  final String proxyHost;
  final int proxyPort;
  final String? proxyUsername;
  final bool useGlobalProxy;
  final bool requiresVpn;
  final String postConnectCommands;
  final bool isFavorite;
  final DateTime? lastConnectedAt;
  final String? ownerId;
  final String? sharedWith;
  final String? permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Server({
    required this.id,
    required this.name,
    required this.hostname,
    required this.port,
    required this.username,
    required this.authMethod,
    required this.notes,
    required this.color,
    required this.iconName,
    required this.isActive,
    this.groupId,
    this.sshKeyId,
    required this.sortOrder,
    this.distroId,
    this.distroName,
    this.jumpHostId,
    required this.proxyType,
    required this.proxyHost,
    required this.proxyPort,
    this.proxyUsername,
    required this.useGlobalProxy,
    required this.requiresVpn,
    required this.postConnectCommands,
    required this.isFavorite,
    this.lastConnectedAt,
    this.ownerId,
    this.sharedWith,
    this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['hostname'] = Variable<String>(hostname);
    map['port'] = Variable<int>(port);
    map['username'] = Variable<String>(username);
    map['auth_method'] = Variable<String>(authMethod);
    map['notes'] = Variable<String>(notes);
    map['color'] = Variable<int>(color);
    map['icon_name'] = Variable<String>(iconName);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    if (!nullToAbsent || sshKeyId != null) {
      map['ssh_key_id'] = Variable<String>(sshKeyId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || distroId != null) {
      map['distro_id'] = Variable<String>(distroId);
    }
    if (!nullToAbsent || distroName != null) {
      map['distro_name'] = Variable<String>(distroName);
    }
    if (!nullToAbsent || jumpHostId != null) {
      map['jump_host_id'] = Variable<String>(jumpHostId);
    }
    map['proxy_type'] = Variable<String>(proxyType);
    map['proxy_host'] = Variable<String>(proxyHost);
    map['proxy_port'] = Variable<int>(proxyPort);
    if (!nullToAbsent || proxyUsername != null) {
      map['proxy_username'] = Variable<String>(proxyUsername);
    }
    map['use_global_proxy'] = Variable<bool>(useGlobalProxy);
    map['requires_vpn'] = Variable<bool>(requiresVpn);
    map['post_connect_commands'] = Variable<String>(postConnectCommands);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || lastConnectedAt != null) {
      map['last_connected_at'] = Variable<DateTime>(lastConnectedAt);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    if (!nullToAbsent || sharedWith != null) {
      map['shared_with'] = Variable<String>(sharedWith);
    }
    if (!nullToAbsent || permissions != null) {
      map['permissions'] = Variable<String>(permissions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(
      id: Value(id),
      name: Value(name),
      hostname: Value(hostname),
      port: Value(port),
      username: Value(username),
      authMethod: Value(authMethod),
      notes: Value(notes),
      color: Value(color),
      iconName: Value(iconName),
      isActive: Value(isActive),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      sshKeyId: sshKeyId == null && nullToAbsent
          ? const Value.absent()
          : Value(sshKeyId),
      sortOrder: Value(sortOrder),
      distroId: distroId == null && nullToAbsent
          ? const Value.absent()
          : Value(distroId),
      distroName: distroName == null && nullToAbsent
          ? const Value.absent()
          : Value(distroName),
      jumpHostId: jumpHostId == null && nullToAbsent
          ? const Value.absent()
          : Value(jumpHostId),
      proxyType: Value(proxyType),
      proxyHost: Value(proxyHost),
      proxyPort: Value(proxyPort),
      proxyUsername: proxyUsername == null && nullToAbsent
          ? const Value.absent()
          : Value(proxyUsername),
      useGlobalProxy: Value(useGlobalProxy),
      requiresVpn: Value(requiresVpn),
      postConnectCommands: Value(postConnectCommands),
      isFavorite: Value(isFavorite),
      lastConnectedAt: lastConnectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConnectedAt),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      sharedWith: sharedWith == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedWith),
      permissions: permissions == null && nullToAbsent
          ? const Value.absent()
          : Value(permissions),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Server.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Server(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hostname: serializer.fromJson<String>(json['hostname']),
      port: serializer.fromJson<int>(json['port']),
      username: serializer.fromJson<String>(json['username']),
      authMethod: serializer.fromJson<String>(json['authMethod']),
      notes: serializer.fromJson<String>(json['notes']),
      color: serializer.fromJson<int>(json['color']),
      iconName: serializer.fromJson<String>(json['iconName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      sshKeyId: serializer.fromJson<String?>(json['sshKeyId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      distroId: serializer.fromJson<String?>(json['distroId']),
      distroName: serializer.fromJson<String?>(json['distroName']),
      jumpHostId: serializer.fromJson<String?>(json['jumpHostId']),
      proxyType: serializer.fromJson<String>(json['proxyType']),
      proxyHost: serializer.fromJson<String>(json['proxyHost']),
      proxyPort: serializer.fromJson<int>(json['proxyPort']),
      proxyUsername: serializer.fromJson<String?>(json['proxyUsername']),
      useGlobalProxy: serializer.fromJson<bool>(json['useGlobalProxy']),
      requiresVpn: serializer.fromJson<bool>(json['requiresVpn']),
      postConnectCommands: serializer.fromJson<String>(
        json['postConnectCommands'],
      ),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      lastConnectedAt: serializer.fromJson<DateTime?>(json['lastConnectedAt']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      sharedWith: serializer.fromJson<String?>(json['sharedWith']),
      permissions: serializer.fromJson<String?>(json['permissions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'hostname': serializer.toJson<String>(hostname),
      'port': serializer.toJson<int>(port),
      'username': serializer.toJson<String>(username),
      'authMethod': serializer.toJson<String>(authMethod),
      'notes': serializer.toJson<String>(notes),
      'color': serializer.toJson<int>(color),
      'iconName': serializer.toJson<String>(iconName),
      'isActive': serializer.toJson<bool>(isActive),
      'groupId': serializer.toJson<String?>(groupId),
      'sshKeyId': serializer.toJson<String?>(sshKeyId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'distroId': serializer.toJson<String?>(distroId),
      'distroName': serializer.toJson<String?>(distroName),
      'jumpHostId': serializer.toJson<String?>(jumpHostId),
      'proxyType': serializer.toJson<String>(proxyType),
      'proxyHost': serializer.toJson<String>(proxyHost),
      'proxyPort': serializer.toJson<int>(proxyPort),
      'proxyUsername': serializer.toJson<String?>(proxyUsername),
      'useGlobalProxy': serializer.toJson<bool>(useGlobalProxy),
      'requiresVpn': serializer.toJson<bool>(requiresVpn),
      'postConnectCommands': serializer.toJson<String>(postConnectCommands),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'lastConnectedAt': serializer.toJson<DateTime?>(lastConnectedAt),
      'ownerId': serializer.toJson<String?>(ownerId),
      'sharedWith': serializer.toJson<String?>(sharedWith),
      'permissions': serializer.toJson<String?>(permissions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Server copyWith({
    String? id,
    String? name,
    String? hostname,
    int? port,
    String? username,
    String? authMethod,
    String? notes,
    int? color,
    String? iconName,
    bool? isActive,
    Value<String?> groupId = const Value.absent(),
    Value<String?> sshKeyId = const Value.absent(),
    int? sortOrder,
    Value<String?> distroId = const Value.absent(),
    Value<String?> distroName = const Value.absent(),
    Value<String?> jumpHostId = const Value.absent(),
    String? proxyType,
    String? proxyHost,
    int? proxyPort,
    Value<String?> proxyUsername = const Value.absent(),
    bool? useGlobalProxy,
    bool? requiresVpn,
    String? postConnectCommands,
    bool? isFavorite,
    Value<DateTime?> lastConnectedAt = const Value.absent(),
    Value<String?> ownerId = const Value.absent(),
    Value<String?> sharedWith = const Value.absent(),
    Value<String?> permissions = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Server(
    id: id ?? this.id,
    name: name ?? this.name,
    hostname: hostname ?? this.hostname,
    port: port ?? this.port,
    username: username ?? this.username,
    authMethod: authMethod ?? this.authMethod,
    notes: notes ?? this.notes,
    color: color ?? this.color,
    iconName: iconName ?? this.iconName,
    isActive: isActive ?? this.isActive,
    groupId: groupId.present ? groupId.value : this.groupId,
    sshKeyId: sshKeyId.present ? sshKeyId.value : this.sshKeyId,
    sortOrder: sortOrder ?? this.sortOrder,
    distroId: distroId.present ? distroId.value : this.distroId,
    distroName: distroName.present ? distroName.value : this.distroName,
    jumpHostId: jumpHostId.present ? jumpHostId.value : this.jumpHostId,
    proxyType: proxyType ?? this.proxyType,
    proxyHost: proxyHost ?? this.proxyHost,
    proxyPort: proxyPort ?? this.proxyPort,
    proxyUsername: proxyUsername.present
        ? proxyUsername.value
        : this.proxyUsername,
    useGlobalProxy: useGlobalProxy ?? this.useGlobalProxy,
    requiresVpn: requiresVpn ?? this.requiresVpn,
    postConnectCommands: postConnectCommands ?? this.postConnectCommands,
    isFavorite: isFavorite ?? this.isFavorite,
    lastConnectedAt: lastConnectedAt.present
        ? lastConnectedAt.value
        : this.lastConnectedAt,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    sharedWith: sharedWith.present ? sharedWith.value : this.sharedWith,
    permissions: permissions.present ? permissions.value : this.permissions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Server copyWithCompanion(ServersCompanion data) {
    return Server(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      port: data.port.present ? data.port.value : this.port,
      username: data.username.present ? data.username.value : this.username,
      authMethod: data.authMethod.present
          ? data.authMethod.value
          : this.authMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      color: data.color.present ? data.color.value : this.color,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      sshKeyId: data.sshKeyId.present ? data.sshKeyId.value : this.sshKeyId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      distroId: data.distroId.present ? data.distroId.value : this.distroId,
      distroName: data.distroName.present
          ? data.distroName.value
          : this.distroName,
      jumpHostId: data.jumpHostId.present
          ? data.jumpHostId.value
          : this.jumpHostId,
      proxyType: data.proxyType.present ? data.proxyType.value : this.proxyType,
      proxyHost: data.proxyHost.present ? data.proxyHost.value : this.proxyHost,
      proxyPort: data.proxyPort.present ? data.proxyPort.value : this.proxyPort,
      proxyUsername: data.proxyUsername.present
          ? data.proxyUsername.value
          : this.proxyUsername,
      useGlobalProxy: data.useGlobalProxy.present
          ? data.useGlobalProxy.value
          : this.useGlobalProxy,
      requiresVpn: data.requiresVpn.present
          ? data.requiresVpn.value
          : this.requiresVpn,
      postConnectCommands: data.postConnectCommands.present
          ? data.postConnectCommands.value
          : this.postConnectCommands,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      lastConnectedAt: data.lastConnectedAt.present
          ? data.lastConnectedAt.value
          : this.lastConnectedAt,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      sharedWith: data.sharedWith.present
          ? data.sharedWith.value
          : this.sharedWith,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Server(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('authMethod: $authMethod, ')
          ..write('notes: $notes, ')
          ..write('color: $color, ')
          ..write('iconName: $iconName, ')
          ..write('isActive: $isActive, ')
          ..write('groupId: $groupId, ')
          ..write('sshKeyId: $sshKeyId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('distroId: $distroId, ')
          ..write('distroName: $distroName, ')
          ..write('jumpHostId: $jumpHostId, ')
          ..write('proxyType: $proxyType, ')
          ..write('proxyHost: $proxyHost, ')
          ..write('proxyPort: $proxyPort, ')
          ..write('proxyUsername: $proxyUsername, ')
          ..write('useGlobalProxy: $useGlobalProxy, ')
          ..write('requiresVpn: $requiresVpn, ')
          ..write('postConnectCommands: $postConnectCommands, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastConnectedAt: $lastConnectedAt, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    hostname,
    port,
    username,
    authMethod,
    notes,
    color,
    iconName,
    isActive,
    groupId,
    sshKeyId,
    sortOrder,
    distroId,
    distroName,
    jumpHostId,
    proxyType,
    proxyHost,
    proxyPort,
    proxyUsername,
    useGlobalProxy,
    requiresVpn,
    postConnectCommands,
    isFavorite,
    lastConnectedAt,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Server &&
          other.id == this.id &&
          other.name == this.name &&
          other.hostname == this.hostname &&
          other.port == this.port &&
          other.username == this.username &&
          other.authMethod == this.authMethod &&
          other.notes == this.notes &&
          other.color == this.color &&
          other.iconName == this.iconName &&
          other.isActive == this.isActive &&
          other.groupId == this.groupId &&
          other.sshKeyId == this.sshKeyId &&
          other.sortOrder == this.sortOrder &&
          other.distroId == this.distroId &&
          other.distroName == this.distroName &&
          other.jumpHostId == this.jumpHostId &&
          other.proxyType == this.proxyType &&
          other.proxyHost == this.proxyHost &&
          other.proxyPort == this.proxyPort &&
          other.proxyUsername == this.proxyUsername &&
          other.useGlobalProxy == this.useGlobalProxy &&
          other.requiresVpn == this.requiresVpn &&
          other.postConnectCommands == this.postConnectCommands &&
          other.isFavorite == this.isFavorite &&
          other.lastConnectedAt == this.lastConnectedAt &&
          other.ownerId == this.ownerId &&
          other.sharedWith == this.sharedWith &&
          other.permissions == this.permissions &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> hostname;
  final Value<int> port;
  final Value<String> username;
  final Value<String> authMethod;
  final Value<String> notes;
  final Value<int> color;
  final Value<String> iconName;
  final Value<bool> isActive;
  final Value<String?> groupId;
  final Value<String?> sshKeyId;
  final Value<int> sortOrder;
  final Value<String?> distroId;
  final Value<String?> distroName;
  final Value<String?> jumpHostId;
  final Value<String> proxyType;
  final Value<String> proxyHost;
  final Value<int> proxyPort;
  final Value<String?> proxyUsername;
  final Value<bool> useGlobalProxy;
  final Value<bool> requiresVpn;
  final Value<String> postConnectCommands;
  final Value<bool> isFavorite;
  final Value<DateTime?> lastConnectedAt;
  final Value<String?> ownerId;
  final Value<String?> sharedWith;
  final Value<String?> permissions;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ServersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hostname = const Value.absent(),
    this.port = const Value.absent(),
    this.username = const Value.absent(),
    this.authMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.color = const Value.absent(),
    this.iconName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sshKeyId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.distroId = const Value.absent(),
    this.distroName = const Value.absent(),
    this.jumpHostId = const Value.absent(),
    this.proxyType = const Value.absent(),
    this.proxyHost = const Value.absent(),
    this.proxyPort = const Value.absent(),
    this.proxyUsername = const Value.absent(),
    this.useGlobalProxy = const Value.absent(),
    this.requiresVpn = const Value.absent(),
    this.postConnectCommands = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastConnectedAt = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServersCompanion.insert({
    required String id,
    required String name,
    required String hostname,
    this.port = const Value.absent(),
    required String username,
    this.authMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.color = const Value.absent(),
    this.iconName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sshKeyId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.distroId = const Value.absent(),
    this.distroName = const Value.absent(),
    this.jumpHostId = const Value.absent(),
    this.proxyType = const Value.absent(),
    this.proxyHost = const Value.absent(),
    this.proxyPort = const Value.absent(),
    this.proxyUsername = const Value.absent(),
    this.useGlobalProxy = const Value.absent(),
    this.requiresVpn = const Value.absent(),
    this.postConnectCommands = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.lastConnectedAt = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       hostname = Value(hostname),
       username = Value(username),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Server> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? hostname,
    Expression<int>? port,
    Expression<String>? username,
    Expression<String>? authMethod,
    Expression<String>? notes,
    Expression<int>? color,
    Expression<String>? iconName,
    Expression<bool>? isActive,
    Expression<String>? groupId,
    Expression<String>? sshKeyId,
    Expression<int>? sortOrder,
    Expression<String>? distroId,
    Expression<String>? distroName,
    Expression<String>? jumpHostId,
    Expression<String>? proxyType,
    Expression<String>? proxyHost,
    Expression<int>? proxyPort,
    Expression<String>? proxyUsername,
    Expression<bool>? useGlobalProxy,
    Expression<bool>? requiresVpn,
    Expression<String>? postConnectCommands,
    Expression<bool>? isFavorite,
    Expression<DateTime>? lastConnectedAt,
    Expression<String>? ownerId,
    Expression<String>? sharedWith,
    Expression<String>? permissions,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hostname != null) 'hostname': hostname,
      if (port != null) 'port': port,
      if (username != null) 'username': username,
      if (authMethod != null) 'auth_method': authMethod,
      if (notes != null) 'notes': notes,
      if (color != null) 'color': color,
      if (iconName != null) 'icon_name': iconName,
      if (isActive != null) 'is_active': isActive,
      if (groupId != null) 'group_id': groupId,
      if (sshKeyId != null) 'ssh_key_id': sshKeyId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (distroId != null) 'distro_id': distroId,
      if (distroName != null) 'distro_name': distroName,
      if (jumpHostId != null) 'jump_host_id': jumpHostId,
      if (proxyType != null) 'proxy_type': proxyType,
      if (proxyHost != null) 'proxy_host': proxyHost,
      if (proxyPort != null) 'proxy_port': proxyPort,
      if (proxyUsername != null) 'proxy_username': proxyUsername,
      if (useGlobalProxy != null) 'use_global_proxy': useGlobalProxy,
      if (requiresVpn != null) 'requires_vpn': requiresVpn,
      if (postConnectCommands != null)
        'post_connect_commands': postConnectCommands,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (lastConnectedAt != null) 'last_connected_at': lastConnectedAt,
      if (ownerId != null) 'owner_id': ownerId,
      if (sharedWith != null) 'shared_with': sharedWith,
      if (permissions != null) 'permissions': permissions,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? hostname,
    Value<int>? port,
    Value<String>? username,
    Value<String>? authMethod,
    Value<String>? notes,
    Value<int>? color,
    Value<String>? iconName,
    Value<bool>? isActive,
    Value<String?>? groupId,
    Value<String?>? sshKeyId,
    Value<int>? sortOrder,
    Value<String?>? distroId,
    Value<String?>? distroName,
    Value<String?>? jumpHostId,
    Value<String>? proxyType,
    Value<String>? proxyHost,
    Value<int>? proxyPort,
    Value<String?>? proxyUsername,
    Value<bool>? useGlobalProxy,
    Value<bool>? requiresVpn,
    Value<String>? postConnectCommands,
    Value<bool>? isFavorite,
    Value<DateTime?>? lastConnectedAt,
    Value<String?>? ownerId,
    Value<String?>? sharedWith,
    Value<String?>? permissions,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ServersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      username: username ?? this.username,
      authMethod: authMethod ?? this.authMethod,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      isActive: isActive ?? this.isActive,
      groupId: groupId ?? this.groupId,
      sshKeyId: sshKeyId ?? this.sshKeyId,
      sortOrder: sortOrder ?? this.sortOrder,
      distroId: distroId ?? this.distroId,
      distroName: distroName ?? this.distroName,
      jumpHostId: jumpHostId ?? this.jumpHostId,
      proxyType: proxyType ?? this.proxyType,
      proxyHost: proxyHost ?? this.proxyHost,
      proxyPort: proxyPort ?? this.proxyPort,
      proxyUsername: proxyUsername ?? this.proxyUsername,
      useGlobalProxy: useGlobalProxy ?? this.useGlobalProxy,
      requiresVpn: requiresVpn ?? this.requiresVpn,
      postConnectCommands: postConnectCommands ?? this.postConnectCommands,
      isFavorite: isFavorite ?? this.isFavorite,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (authMethod.present) {
      map['auth_method'] = Variable<String>(authMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (sshKeyId.present) {
      map['ssh_key_id'] = Variable<String>(sshKeyId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (distroId.present) {
      map['distro_id'] = Variable<String>(distroId.value);
    }
    if (distroName.present) {
      map['distro_name'] = Variable<String>(distroName.value);
    }
    if (jumpHostId.present) {
      map['jump_host_id'] = Variable<String>(jumpHostId.value);
    }
    if (proxyType.present) {
      map['proxy_type'] = Variable<String>(proxyType.value);
    }
    if (proxyHost.present) {
      map['proxy_host'] = Variable<String>(proxyHost.value);
    }
    if (proxyPort.present) {
      map['proxy_port'] = Variable<int>(proxyPort.value);
    }
    if (proxyUsername.present) {
      map['proxy_username'] = Variable<String>(proxyUsername.value);
    }
    if (useGlobalProxy.present) {
      map['use_global_proxy'] = Variable<bool>(useGlobalProxy.value);
    }
    if (requiresVpn.present) {
      map['requires_vpn'] = Variable<bool>(requiresVpn.value);
    }
    if (postConnectCommands.present) {
      map['post_connect_commands'] = Variable<String>(
        postConnectCommands.value,
      );
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (lastConnectedAt.present) {
      map['last_connected_at'] = Variable<DateTime>(lastConnectedAt.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sharedWith.present) {
      map['shared_with'] = Variable<String>(sharedWith.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('username: $username, ')
          ..write('authMethod: $authMethod, ')
          ..write('notes: $notes, ')
          ..write('color: $color, ')
          ..write('iconName: $iconName, ')
          ..write('isActive: $isActive, ')
          ..write('groupId: $groupId, ')
          ..write('sshKeyId: $sshKeyId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('distroId: $distroId, ')
          ..write('distroName: $distroName, ')
          ..write('jumpHostId: $jumpHostId, ')
          ..write('proxyType: $proxyType, ')
          ..write('proxyHost: $proxyHost, ')
          ..write('proxyPort: $proxyPort, ')
          ..write('proxyUsername: $proxyUsername, ')
          ..write('useGlobalProxy: $useGlobalProxy, ')
          ..write('requiresVpn: $requiresVpn, ')
          ..write('postConnectCommands: $postConnectCommands, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('lastConnectedAt: $lastConnectedAt, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF6C63FF),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedWithMeta = const VerificationMeta(
    'sharedWith',
  );
  @override
  late final GeneratedColumn<String> sharedWith = GeneratedColumn<String>(
    'shared_with',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    color,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('shared_with')) {
      context.handle(
        _sharedWithMeta,
        sharedWith.isAcceptableOrUnknown(data['shared_with']!, _sharedWithMeta),
      );
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      sharedWith: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_with'],
      ),
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final int color;
  final String? ownerId;
  final String? sharedWith;
  final String? permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Tag({
    required this.id,
    required this.name,
    required this.color,
    this.ownerId,
    this.sharedWith,
    this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    if (!nullToAbsent || sharedWith != null) {
      map['shared_with'] = Variable<String>(sharedWith);
    }
    if (!nullToAbsent || permissions != null) {
      map['permissions'] = Variable<String>(permissions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      sharedWith: sharedWith == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedWith),
      permissions: permissions == null && nullToAbsent
          ? const Value.absent()
          : Value(permissions),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      sharedWith: serializer.fromJson<String?>(json['sharedWith']),
      permissions: serializer.fromJson<String?>(json['permissions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'ownerId': serializer.toJson<String?>(ownerId),
      'sharedWith': serializer.toJson<String?>(sharedWith),
      'permissions': serializer.toJson<String?>(permissions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    int? color,
    Value<String?> ownerId = const Value.absent(),
    Value<String?> sharedWith = const Value.absent(),
    Value<String?> permissions = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    sharedWith: sharedWith.present ? sharedWith.value : this.sharedWith,
    permissions: permissions.present ? permissions.value : this.permissions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      sharedWith: data.sharedWith.present
          ? data.sharedWith.value
          : this.sharedWith,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    color,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.ownerId == this.ownerId &&
          other.sharedWith == this.sharedWith &&
          other.permissions == this.permissions &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<String?> ownerId;
  final Value<String?> sharedWith;
  final Value<String?> permissions;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? ownerId,
    Expression<String>? sharedWith,
    Expression<String>? permissions,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (ownerId != null) 'owner_id': ownerId,
      if (sharedWith != null) 'shared_with': sharedWith,
      if (permissions != null) 'permissions': permissions,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? color,
    Value<String?>? ownerId,
    Value<String?>? sharedWith,
    Value<String?>? permissions,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sharedWith.present) {
      map['shared_with'] = Variable<String>(sharedWith.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServerTagsTable extends ServerTags
    with TableInfo<$ServerTagsTable, ServerTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES servers (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [serverId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServerTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, tagId};
  @override
  ServerTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerTag(
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $ServerTagsTable createAlias(String alias) {
    return $ServerTagsTable(attachedDatabase, alias);
  }
}

class ServerTag extends DataClass implements Insertable<ServerTag> {
  final String serverId;
  final String tagId;
  const ServerTag({required this.serverId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['server_id'] = Variable<String>(serverId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  ServerTagsCompanion toCompanion(bool nullToAbsent) {
    return ServerTagsCompanion(serverId: Value(serverId), tagId: Value(tagId));
  }

  factory ServerTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerTag(
      serverId: serializer.fromJson<String>(json['serverId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serverId': serializer.toJson<String>(serverId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  ServerTag copyWith({String? serverId, String? tagId}) => ServerTag(
    serverId: serverId ?? this.serverId,
    tagId: tagId ?? this.tagId,
  );
  ServerTag copyWithCompanion(ServerTagsCompanion data) {
    return ServerTag(
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerTag(')
          ..write('serverId: $serverId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(serverId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerTag &&
          other.serverId == this.serverId &&
          other.tagId == this.tagId);
}

class ServerTagsCompanion extends UpdateCompanion<ServerTag> {
  final Value<String> serverId;
  final Value<String> tagId;
  final Value<int> rowid;
  const ServerTagsCompanion({
    this.serverId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServerTagsCompanion.insert({
    required String serverId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       tagId = Value(tagId);
  static Insertable<ServerTag> custom({
    Expression<String>? serverId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serverId != null) 'server_id': serverId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServerTagsCompanion copyWith({
    Value<String>? serverId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return ServerTagsCompanion(
      serverId: serverId ?? this.serverId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerTagsCompanion(')
          ..write('serverId: $serverId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetsTable extends Snippets with TableInfo<$SnippetsTable, Snippet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bash'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedWithMeta = const VerificationMeta(
    'sharedWith',
  );
  @override
  late final GeneratedColumn<String> sharedWith = GeneratedColumn<String>(
    'shared_with',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _permissionsMeta = const VerificationMeta(
    'permissions',
  );
  @override
  late final GeneratedColumn<String> permissions = GeneratedColumn<String>(
    'permissions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    content,
    language,
    description,
    groupId,
    sortOrder,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Snippet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('shared_with')) {
      context.handle(
        _sharedWithMeta,
        sharedWith.isAcceptableOrUnknown(data['shared_with']!, _sharedWithMeta),
      );
    }
    if (data.containsKey('permissions')) {
      context.handle(
        _permissionsMeta,
        permissions.isAcceptableOrUnknown(
          data['permissions']!,
          _permissionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snippet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snippet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      sharedWith: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shared_with'],
      ),
      permissions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permissions'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SnippetsTable createAlias(String alias) {
    return $SnippetsTable(attachedDatabase, alias);
  }
}

class Snippet extends DataClass implements Insertable<Snippet> {
  final String id;
  final String name;
  final String content;
  final String language;
  final String description;
  final String? groupId;
  final int sortOrder;
  final String? ownerId;
  final String? sharedWith;
  final String? permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Snippet({
    required this.id,
    required this.name,
    required this.content,
    required this.language,
    required this.description,
    this.groupId,
    required this.sortOrder,
    this.ownerId,
    this.sharedWith,
    this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['content'] = Variable<String>(content);
    map['language'] = Variable<String>(language);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    if (!nullToAbsent || sharedWith != null) {
      map['shared_with'] = Variable<String>(sharedWith);
    }
    if (!nullToAbsent || permissions != null) {
      map['permissions'] = Variable<String>(permissions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SnippetsCompanion toCompanion(bool nullToAbsent) {
    return SnippetsCompanion(
      id: Value(id),
      name: Value(name),
      content: Value(content),
      language: Value(language),
      description: Value(description),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      sortOrder: Value(sortOrder),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      sharedWith: sharedWith == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedWith),
      permissions: permissions == null && nullToAbsent
          ? const Value.absent()
          : Value(permissions),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Snippet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snippet(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      content: serializer.fromJson<String>(json['content']),
      language: serializer.fromJson<String>(json['language']),
      description: serializer.fromJson<String>(json['description']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      sharedWith: serializer.fromJson<String?>(json['sharedWith']),
      permissions: serializer.fromJson<String?>(json['permissions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'content': serializer.toJson<String>(content),
      'language': serializer.toJson<String>(language),
      'description': serializer.toJson<String>(description),
      'groupId': serializer.toJson<String?>(groupId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'ownerId': serializer.toJson<String?>(ownerId),
      'sharedWith': serializer.toJson<String?>(sharedWith),
      'permissions': serializer.toJson<String?>(permissions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Snippet copyWith({
    String? id,
    String? name,
    String? content,
    String? language,
    String? description,
    Value<String?> groupId = const Value.absent(),
    int? sortOrder,
    Value<String?> ownerId = const Value.absent(),
    Value<String?> sharedWith = const Value.absent(),
    Value<String?> permissions = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Snippet(
    id: id ?? this.id,
    name: name ?? this.name,
    content: content ?? this.content,
    language: language ?? this.language,
    description: description ?? this.description,
    groupId: groupId.present ? groupId.value : this.groupId,
    sortOrder: sortOrder ?? this.sortOrder,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    sharedWith: sharedWith.present ? sharedWith.value : this.sharedWith,
    permissions: permissions.present ? permissions.value : this.permissions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Snippet copyWithCompanion(SnippetsCompanion data) {
    return Snippet(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      content: data.content.present ? data.content.value : this.content,
      language: data.language.present ? data.language.value : this.language,
      description: data.description.present
          ? data.description.value
          : this.description,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      sharedWith: data.sharedWith.present
          ? data.sharedWith.value
          : this.sharedWith,
      permissions: data.permissions.present
          ? data.permissions.value
          : this.permissions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snippet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('content: $content, ')
          ..write('language: $language, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    content,
    language,
    description,
    groupId,
    sortOrder,
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snippet &&
          other.id == this.id &&
          other.name == this.name &&
          other.content == this.content &&
          other.language == this.language &&
          other.description == this.description &&
          other.groupId == this.groupId &&
          other.sortOrder == this.sortOrder &&
          other.ownerId == this.ownerId &&
          other.sharedWith == this.sharedWith &&
          other.permissions == this.permissions &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SnippetsCompanion extends UpdateCompanion<Snippet> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> content;
  final Value<String> language;
  final Value<String> description;
  final Value<String?> groupId;
  final Value<int> sortOrder;
  final Value<String?> ownerId;
  final Value<String?> sharedWith;
  final Value<String?> permissions;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SnippetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.content = const Value.absent(),
    this.language = const Value.absent(),
    this.description = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnippetsCompanion.insert({
    required String id,
    required String name,
    required String content,
    this.language = const Value.absent(),
    this.description = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.sharedWith = const Value.absent(),
    this.permissions = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Snippet> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? content,
    Expression<String>? language,
    Expression<String>? description,
    Expression<String>? groupId,
    Expression<int>? sortOrder,
    Expression<String>? ownerId,
    Expression<String>? sharedWith,
    Expression<String>? permissions,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (content != null) 'content': content,
      if (language != null) 'language': language,
      if (description != null) 'description': description,
      if (groupId != null) 'group_id': groupId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (ownerId != null) 'owner_id': ownerId,
      if (sharedWith != null) 'shared_with': sharedWith,
      if (permissions != null) 'permissions': permissions,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnippetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? content,
    Value<String>? language,
    Value<String>? description,
    Value<String?>? groupId,
    Value<int>? sortOrder,
    Value<String?>? ownerId,
    Value<String?>? sharedWith,
    Value<String?>? permissions,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SnippetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      content: content ?? this.content,
      language: language ?? this.language,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
      sortOrder: sortOrder ?? this.sortOrder,
      ownerId: ownerId ?? this.ownerId,
      sharedWith: sharedWith ?? this.sharedWith,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (sharedWith.present) {
      map['shared_with'] = Variable<String>(sharedWith.value);
    }
    if (permissions.present) {
      map['permissions'] = Variable<String>(permissions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('content: $content, ')
          ..write('language: $language, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('ownerId: $ownerId, ')
          ..write('sharedWith: $sharedWith, ')
          ..write('permissions: $permissions, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetTagsTable extends SnippetTags
    with TableInfo<$SnippetTagsTable, SnippetTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _snippetIdMeta = const VerificationMeta(
    'snippetId',
  );
  @override
  late final GeneratedColumn<String> snippetId = GeneratedColumn<String>(
    'snippet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES snippets (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [snippetId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippet_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnippetTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('snippet_id')) {
      context.handle(
        _snippetIdMeta,
        snippetId.isAcceptableOrUnknown(data['snippet_id']!, _snippetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_snippetIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {snippetId, tagId};
  @override
  SnippetTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnippetTag(
      snippetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snippet_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $SnippetTagsTable createAlias(String alias) {
    return $SnippetTagsTable(attachedDatabase, alias);
  }
}

class SnippetTag extends DataClass implements Insertable<SnippetTag> {
  final String snippetId;
  final String tagId;
  const SnippetTag({required this.snippetId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['snippet_id'] = Variable<String>(snippetId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  SnippetTagsCompanion toCompanion(bool nullToAbsent) {
    return SnippetTagsCompanion(
      snippetId: Value(snippetId),
      tagId: Value(tagId),
    );
  }

  factory SnippetTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnippetTag(
      snippetId: serializer.fromJson<String>(json['snippetId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'snippetId': serializer.toJson<String>(snippetId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  SnippetTag copyWith({String? snippetId, String? tagId}) => SnippetTag(
    snippetId: snippetId ?? this.snippetId,
    tagId: tagId ?? this.tagId,
  );
  SnippetTag copyWithCompanion(SnippetTagsCompanion data) {
    return SnippetTag(
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnippetTag(')
          ..write('snippetId: $snippetId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(snippetId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnippetTag &&
          other.snippetId == this.snippetId &&
          other.tagId == this.tagId);
}

class SnippetTagsCompanion extends UpdateCompanion<SnippetTag> {
  final Value<String> snippetId;
  final Value<String> tagId;
  final Value<int> rowid;
  const SnippetTagsCompanion({
    this.snippetId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnippetTagsCompanion.insert({
    required String snippetId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : snippetId = Value(snippetId),
       tagId = Value(tagId);
  static Insertable<SnippetTag> custom({
    Expression<String>? snippetId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (snippetId != null) 'snippet_id': snippetId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnippetTagsCompanion copyWith({
    Value<String>? snippetId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return SnippetTagsCompanion(
      snippetId: snippetId ?? this.snippetId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetTagsCompanion(')
          ..write('snippetId: $snippetId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnippetVariablesTable extends SnippetVariables
    with TableInfo<$SnippetVariablesTable, SnippetVariable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnippetVariablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snippetIdMeta = const VerificationMeta(
    'snippetId',
  );
  @override
  late final GeneratedColumn<String> snippetId = GeneratedColumn<String>(
    'snippet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES snippets (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultValueMeta = const VerificationMeta(
    'defaultValue',
  );
  @override
  late final GeneratedColumn<String> defaultValue = GeneratedColumn<String>(
    'default_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    snippetId,
    name,
    defaultValue,
    description,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snippet_variables';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnippetVariable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('snippet_id')) {
      context.handle(
        _snippetIdMeta,
        snippetId.isAcceptableOrUnknown(data['snippet_id']!, _snippetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_snippetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('default_value')) {
      context.handle(
        _defaultValueMeta,
        defaultValue.isAcceptableOrUnknown(
          data['default_value']!,
          _defaultValueMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnippetVariable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnippetVariable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      snippetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snippet_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      defaultValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_value'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SnippetVariablesTable createAlias(String alias) {
    return $SnippetVariablesTable(attachedDatabase, alias);
  }
}

class SnippetVariable extends DataClass implements Insertable<SnippetVariable> {
  final String id;
  final String snippetId;
  final String name;
  final String defaultValue;
  final String description;
  final int sortOrder;
  const SnippetVariable({
    required this.id,
    required this.snippetId,
    required this.name,
    required this.defaultValue,
    required this.description,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['snippet_id'] = Variable<String>(snippetId);
    map['name'] = Variable<String>(name);
    map['default_value'] = Variable<String>(defaultValue);
    map['description'] = Variable<String>(description);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SnippetVariablesCompanion toCompanion(bool nullToAbsent) {
    return SnippetVariablesCompanion(
      id: Value(id),
      snippetId: Value(snippetId),
      name: Value(name),
      defaultValue: Value(defaultValue),
      description: Value(description),
      sortOrder: Value(sortOrder),
    );
  }

  factory SnippetVariable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnippetVariable(
      id: serializer.fromJson<String>(json['id']),
      snippetId: serializer.fromJson<String>(json['snippetId']),
      name: serializer.fromJson<String>(json['name']),
      defaultValue: serializer.fromJson<String>(json['defaultValue']),
      description: serializer.fromJson<String>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'snippetId': serializer.toJson<String>(snippetId),
      'name': serializer.toJson<String>(name),
      'defaultValue': serializer.toJson<String>(defaultValue),
      'description': serializer.toJson<String>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SnippetVariable copyWith({
    String? id,
    String? snippetId,
    String? name,
    String? defaultValue,
    String? description,
    int? sortOrder,
  }) => SnippetVariable(
    id: id ?? this.id,
    snippetId: snippetId ?? this.snippetId,
    name: name ?? this.name,
    defaultValue: defaultValue ?? this.defaultValue,
    description: description ?? this.description,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  SnippetVariable copyWithCompanion(SnippetVariablesCompanion data) {
    return SnippetVariable(
      id: data.id.present ? data.id.value : this.id,
      snippetId: data.snippetId.present ? data.snippetId.value : this.snippetId,
      name: data.name.present ? data.name.value : this.name,
      defaultValue: data.defaultValue.present
          ? data.defaultValue.value
          : this.defaultValue,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnippetVariable(')
          ..write('id: $id, ')
          ..write('snippetId: $snippetId, ')
          ..write('name: $name, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, snippetId, name, defaultValue, description, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnippetVariable &&
          other.id == this.id &&
          other.snippetId == this.snippetId &&
          other.name == this.name &&
          other.defaultValue == this.defaultValue &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder);
}

class SnippetVariablesCompanion extends UpdateCompanion<SnippetVariable> {
  final Value<String> id;
  final Value<String> snippetId;
  final Value<String> name;
  final Value<String> defaultValue;
  final Value<String> description;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const SnippetVariablesCompanion({
    this.id = const Value.absent(),
    this.snippetId = const Value.absent(),
    this.name = const Value.absent(),
    this.defaultValue = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SnippetVariablesCompanion.insert({
    required String id,
    required String snippetId,
    required String name,
    this.defaultValue = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       snippetId = Value(snippetId),
       name = Value(name);
  static Insertable<SnippetVariable> custom({
    Expression<String>? id,
    Expression<String>? snippetId,
    Expression<String>? name,
    Expression<String>? defaultValue,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (snippetId != null) 'snippet_id': snippetId,
      if (name != null) 'name': name,
      if (defaultValue != null) 'default_value': defaultValue,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SnippetVariablesCompanion copyWith({
    Value<String>? id,
    Value<String>? snippetId,
    Value<String>? name,
    Value<String>? defaultValue,
    Value<String>? description,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return SnippetVariablesCompanion(
      id: id ?? this.id,
      snippetId: snippetId ?? this.snippetId,
      name: name ?? this.name,
      defaultValue: defaultValue ?? this.defaultValue,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (snippetId.present) {
      map['snippet_id'] = Variable<String>(snippetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (defaultValue.present) {
      map['default_value'] = Variable<String>(defaultValue.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnippetVariablesCompanion(')
          ..write('id: $id, ')
          ..write('snippetId: $snippetId, ')
          ..write('name: $name, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KnownHostsTable extends KnownHosts
    with TableInfo<$KnownHostsTable, KnownHost> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnownHostsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hostnameMeta = const VerificationMeta(
    'hostname',
  );
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
    'hostname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(22),
  );
  static const VerificationMeta _keyTypeMeta = const VerificationMeta(
    'keyType',
  );
  @override
  late final GeneratedColumn<String> keyType = GeneratedColumn<String>(
    'key_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trustedMeta = const VerificationMeta(
    'trusted',
  );
  @override
  late final GeneratedColumn<bool> trusted = GeneratedColumn<bool>(
    'trusted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("trusted" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _firstSeenAtMeta = const VerificationMeta(
    'firstSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
    'first_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hostname,
    port,
    keyType,
    fingerprint,
    trusted,
    firstSeenAt,
    lastSeenAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'known_hosts';
  @override
  VerificationContext validateIntegrity(
    Insertable<KnownHost> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hostname')) {
      context.handle(
        _hostnameMeta,
        hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta),
      );
    } else if (isInserting) {
      context.missing(_hostnameMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('key_type')) {
      context.handle(
        _keyTypeMeta,
        keyType.isAcceptableOrUnknown(data['key_type']!, _keyTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_keyTypeMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('trusted')) {
      context.handle(
        _trustedMeta,
        trusted.isAcceptableOrUnknown(data['trusted']!, _trustedMeta),
      );
    }
    if (data.containsKey('first_seen_at')) {
      context.handle(
        _firstSeenAtMeta,
        firstSeenAt.isAcceptableOrUnknown(
          data['first_seen_at']!,
          _firstSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstSeenAtMeta);
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSeenAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnownHost map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnownHost(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      hostname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hostname'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      )!,
      keyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_type'],
      )!,
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      )!,
      trusted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}trusted'],
      )!,
      firstSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen_at'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      )!,
    );
  }

  @override
  $KnownHostsTable createAlias(String alias) {
    return $KnownHostsTable(attachedDatabase, alias);
  }
}

class KnownHost extends DataClass implements Insertable<KnownHost> {
  final String id;
  final String hostname;
  final int port;
  final String keyType;
  final String fingerprint;
  final bool trusted;
  final DateTime firstSeenAt;
  final DateTime lastSeenAt;
  const KnownHost({
    required this.id,
    required this.hostname,
    required this.port,
    required this.keyType,
    required this.fingerprint,
    required this.trusted,
    required this.firstSeenAt,
    required this.lastSeenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hostname'] = Variable<String>(hostname);
    map['port'] = Variable<int>(port);
    map['key_type'] = Variable<String>(keyType);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['trusted'] = Variable<bool>(trusted);
    map['first_seen_at'] = Variable<DateTime>(firstSeenAt);
    map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    return map;
  }

  KnownHostsCompanion toCompanion(bool nullToAbsent) {
    return KnownHostsCompanion(
      id: Value(id),
      hostname: Value(hostname),
      port: Value(port),
      keyType: Value(keyType),
      fingerprint: Value(fingerprint),
      trusted: Value(trusted),
      firstSeenAt: Value(firstSeenAt),
      lastSeenAt: Value(lastSeenAt),
    );
  }

  factory KnownHost.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnownHost(
      id: serializer.fromJson<String>(json['id']),
      hostname: serializer.fromJson<String>(json['hostname']),
      port: serializer.fromJson<int>(json['port']),
      keyType: serializer.fromJson<String>(json['keyType']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      trusted: serializer.fromJson<bool>(json['trusted']),
      firstSeenAt: serializer.fromJson<DateTime>(json['firstSeenAt']),
      lastSeenAt: serializer.fromJson<DateTime>(json['lastSeenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hostname': serializer.toJson<String>(hostname),
      'port': serializer.toJson<int>(port),
      'keyType': serializer.toJson<String>(keyType),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'trusted': serializer.toJson<bool>(trusted),
      'firstSeenAt': serializer.toJson<DateTime>(firstSeenAt),
      'lastSeenAt': serializer.toJson<DateTime>(lastSeenAt),
    };
  }

  KnownHost copyWith({
    String? id,
    String? hostname,
    int? port,
    String? keyType,
    String? fingerprint,
    bool? trusted,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
  }) => KnownHost(
    id: id ?? this.id,
    hostname: hostname ?? this.hostname,
    port: port ?? this.port,
    keyType: keyType ?? this.keyType,
    fingerprint: fingerprint ?? this.fingerprint,
    trusted: trusted ?? this.trusted,
    firstSeenAt: firstSeenAt ?? this.firstSeenAt,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
  );
  KnownHost copyWithCompanion(KnownHostsCompanion data) {
    return KnownHost(
      id: data.id.present ? data.id.value : this.id,
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      port: data.port.present ? data.port.value : this.port,
      keyType: data.keyType.present ? data.keyType.value : this.keyType,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      trusted: data.trusted.present ? data.trusted.value : this.trusted,
      firstSeenAt: data.firstSeenAt.present
          ? data.firstSeenAt.value
          : this.firstSeenAt,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnownHost(')
          ..write('id: $id, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('trusted: $trusted, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('lastSeenAt: $lastSeenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hostname,
    port,
    keyType,
    fingerprint,
    trusted,
    firstSeenAt,
    lastSeenAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnownHost &&
          other.id == this.id &&
          other.hostname == this.hostname &&
          other.port == this.port &&
          other.keyType == this.keyType &&
          other.fingerprint == this.fingerprint &&
          other.trusted == this.trusted &&
          other.firstSeenAt == this.firstSeenAt &&
          other.lastSeenAt == this.lastSeenAt);
}

class KnownHostsCompanion extends UpdateCompanion<KnownHost> {
  final Value<String> id;
  final Value<String> hostname;
  final Value<int> port;
  final Value<String> keyType;
  final Value<String> fingerprint;
  final Value<bool> trusted;
  final Value<DateTime> firstSeenAt;
  final Value<DateTime> lastSeenAt;
  final Value<int> rowid;
  const KnownHostsCompanion({
    this.id = const Value.absent(),
    this.hostname = const Value.absent(),
    this.port = const Value.absent(),
    this.keyType = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.trusted = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KnownHostsCompanion.insert({
    required String id,
    required String hostname,
    this.port = const Value.absent(),
    required String keyType,
    required String fingerprint,
    this.trusted = const Value.absent(),
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       hostname = Value(hostname),
       keyType = Value(keyType),
       fingerprint = Value(fingerprint),
       firstSeenAt = Value(firstSeenAt),
       lastSeenAt = Value(lastSeenAt);
  static Insertable<KnownHost> custom({
    Expression<String>? id,
    Expression<String>? hostname,
    Expression<int>? port,
    Expression<String>? keyType,
    Expression<String>? fingerprint,
    Expression<bool>? trusted,
    Expression<DateTime>? firstSeenAt,
    Expression<DateTime>? lastSeenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hostname != null) 'hostname': hostname,
      if (port != null) 'port': port,
      if (keyType != null) 'key_type': keyType,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (trusted != null) 'trusted': trusted,
      if (firstSeenAt != null) 'first_seen_at': firstSeenAt,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KnownHostsCompanion copyWith({
    Value<String>? id,
    Value<String>? hostname,
    Value<int>? port,
    Value<String>? keyType,
    Value<String>? fingerprint,
    Value<bool>? trusted,
    Value<DateTime>? firstSeenAt,
    Value<DateTime>? lastSeenAt,
    Value<int>? rowid,
  }) {
    return KnownHostsCompanion(
      id: id ?? this.id,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      keyType: keyType ?? this.keyType,
      fingerprint: fingerprint ?? this.fingerprint,
      trusted: trusted ?? this.trusted,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (keyType.present) {
      map['key_type'] = Variable<String>(keyType.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (trusted.present) {
      map['trusted'] = Variable<bool>(trusted.value);
    }
    if (firstSeenAt.present) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnownHostsCompanion(')
          ..write('id: $id, ')
          ..write('hostname: $hostname, ')
          ..write('port: $port, ')
          ..write('keyType: $keyType, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('trusted: $trusted, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SftpBookmarksTable extends SftpBookmarks
    with TableInfo<$SftpBookmarksTable, SftpBookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SftpBookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES servers (id)',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    path,
    label,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sftp_bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SftpBookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SftpBookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SftpBookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SftpBookmarksTable createAlias(String alias) {
    return $SftpBookmarksTable(attachedDatabase, alias);
  }
}

class SftpBookmark extends DataClass implements Insertable<SftpBookmark> {
  final String id;
  final String serverId;
  final String path;
  final String label;
  final int sortOrder;
  final DateTime createdAt;
  const SftpBookmark({
    required this.id,
    required this.serverId,
    required this.path,
    required this.label,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['server_id'] = Variable<String>(serverId);
    map['path'] = Variable<String>(path);
    map['label'] = Variable<String>(label);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SftpBookmarksCompanion toCompanion(bool nullToAbsent) {
    return SftpBookmarksCompanion(
      id: Value(id),
      serverId: Value(serverId),
      path: Value(path),
      label: Value(label),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory SftpBookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SftpBookmark(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      path: serializer.fromJson<String>(json['path']),
      label: serializer.fromJson<String>(json['label']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String>(serverId),
      'path': serializer.toJson<String>(path),
      'label': serializer.toJson<String>(label),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SftpBookmark copyWith({
    String? id,
    String? serverId,
    String? path,
    String? label,
    int? sortOrder,
    DateTime? createdAt,
  }) => SftpBookmark(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    path: path ?? this.path,
    label: label ?? this.label,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  SftpBookmark copyWithCompanion(SftpBookmarksCompanion data) {
    return SftpBookmark(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      path: data.path.present ? data.path.value : this.path,
      label: data.label.present ? data.label.value : this.label,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SftpBookmark(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('path: $path, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverId, path, label, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SftpBookmark &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.path == this.path &&
          other.label == this.label &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class SftpBookmarksCompanion extends UpdateCompanion<SftpBookmark> {
  final Value<String> id;
  final Value<String> serverId;
  final Value<String> path;
  final Value<String> label;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SftpBookmarksCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.path = const Value.absent(),
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SftpBookmarksCompanion.insert({
    required String id,
    required String serverId,
    required String path,
    required String label,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       serverId = Value(serverId),
       path = Value(path),
       label = Value(label),
       createdAt = Value(createdAt);
  static Insertable<SftpBookmark> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? path,
    Expression<String>? label,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (path != null) 'path': path,
      if (label != null) 'label': label,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SftpBookmarksCompanion copyWith({
    Value<String>? id,
    Value<String>? serverId,
    Value<String>? path,
    Value<String>? label,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SftpBookmarksCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      path: path ?? this.path,
      label: label ?? this.label,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SftpBookmarksCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('path: $path, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SshKeysTable sshKeys = $SshKeysTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $ServersTable servers = $ServersTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $ServerTagsTable serverTags = $ServerTagsTable(this);
  late final $SnippetsTable snippets = $SnippetsTable(this);
  late final $SnippetTagsTable snippetTags = $SnippetTagsTable(this);
  late final $SnippetVariablesTable snippetVariables = $SnippetVariablesTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $KnownHostsTable knownHosts = $KnownHostsTable(this);
  late final $SftpBookmarksTable sftpBookmarks = $SftpBookmarksTable(this);
  late final ServerDao serverDao = ServerDao(this as AppDatabase);
  late final SshKeyDao sshKeyDao = SshKeyDao(this as AppDatabase);
  late final GroupDao groupDao = GroupDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  late final AppSettingsDao appSettingsDao = AppSettingsDao(
    this as AppDatabase,
  );
  late final SnippetDao snippetDao = SnippetDao(this as AppDatabase);
  late final KnownHostDao knownHostDao = KnownHostDao(this as AppDatabase);
  late final SftpBookmarkDao sftpBookmarkDao = SftpBookmarkDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sshKeys,
    groups,
    servers,
    tags,
    serverTags,
    snippets,
    snippetTags,
    snippetVariables,
    appSettings,
    knownHosts,
    sftpBookmarks,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SshKeysTableCreateCompanionBuilder =
    SshKeysCompanion Function({
      required String id,
      required String name,
      required String keyType,
      Value<String> fingerprint,
      Value<String> publicKey,
      Value<String> comment,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SshKeysTableUpdateCompanionBuilder =
    SshKeysCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> keyType,
      Value<String> fingerprint,
      Value<String> publicKey,
      Value<String> comment,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SshKeysTableReferences
    extends BaseReferences<_$AppDatabase, $SshKeysTable, SshKey> {
  $$SshKeysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServersTable, List<Server>> _serversRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.servers,
    aliasName: $_aliasNameGenerator(db.sshKeys.id, db.servers.sshKeyId),
  );

  $$ServersTableProcessedTableManager get serversRefs {
    final manager = $$ServersTableTableManager(
      $_db,
      $_db.servers,
    ).filter((f) => f.sshKeyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serversRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SshKeysTableFilterComposer
    extends Composer<_$AppDatabase, $SshKeysTable> {
  $$SshKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> serversRefs(
    Expression<bool> Function($$ServersTableFilterComposer f) f,
  ) {
    final $$ServersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.sshKeyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableFilterComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SshKeysTableOrderingComposer
    extends Composer<_$AppDatabase, $SshKeysTable> {
  $$SshKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SshKeysTableAnnotationComposer
    extends Composer<_$AppDatabase, $SshKeysTable> {
  $$SshKeysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get keyType =>
      $composableBuilder(column: $table.keyType, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> serversRefs<T extends Object>(
    Expression<T> Function($$ServersTableAnnotationComposer a) f,
  ) {
    final $$ServersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.sshKeyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableAnnotationComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SshKeysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SshKeysTable,
          SshKey,
          $$SshKeysTableFilterComposer,
          $$SshKeysTableOrderingComposer,
          $$SshKeysTableAnnotationComposer,
          $$SshKeysTableCreateCompanionBuilder,
          $$SshKeysTableUpdateCompanionBuilder,
          (SshKey, $$SshKeysTableReferences),
          SshKey,
          PrefetchHooks Function({bool serversRefs})
        > {
  $$SshKeysTableTableManager(_$AppDatabase db, $SshKeysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SshKeysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SshKeysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SshKeysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> keyType = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<String> publicKey = const Value.absent(),
                Value<String> comment = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SshKeysCompanion(
                id: id,
                name: name,
                keyType: keyType,
                fingerprint: fingerprint,
                publicKey: publicKey,
                comment: comment,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String keyType,
                Value<String> fingerprint = const Value.absent(),
                Value<String> publicKey = const Value.absent(),
                Value<String> comment = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SshKeysCompanion.insert(
                id: id,
                name: name,
                keyType: keyType,
                fingerprint: fingerprint,
                publicKey: publicKey,
                comment: comment,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SshKeysTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({serversRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (serversRefs) db.servers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serversRefs)
                    await $_getPrefetchedData<SshKey, $SshKeysTable, Server>(
                      currentTable: table,
                      referencedTable: $$SshKeysTableReferences
                          ._serversRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SshKeysTableReferences(db, table, p0).serversRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sshKeyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SshKeysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SshKeysTable,
      SshKey,
      $$SshKeysTableFilterComposer,
      $$SshKeysTableOrderingComposer,
      $$SshKeysTableAnnotationComposer,
      $$SshKeysTableCreateCompanionBuilder,
      $$SshKeysTableUpdateCompanionBuilder,
      (SshKey, $$SshKeysTableReferences),
      SshKey,
      PrefetchHooks Function({bool serversRefs})
    >;
typedef $$GroupsTableCreateCompanionBuilder =
    GroupsCompanion Function({
      required String id,
      required String name,
      Value<int> color,
      Value<String> iconName,
      Value<String?> parentId,
      Value<int> sortOrder,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GroupsTableUpdateCompanionBuilder =
    GroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> color,
      Value<String> iconName,
      Value<String?> parentId,
      Value<int> sortOrder,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _parentIdTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.groups.parentId, db.groups.id),
  );

  $$GroupsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ServersTable, List<Server>> _serversRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.servers,
    aliasName: $_aliasNameGenerator(db.groups.id, db.servers.groupId),
  );

  $$ServersTableProcessedTableManager get serversRefs {
    final manager = $$ServersTableTableManager(
      $_db,
      $_db.servers,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serversRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SnippetsTable, List<Snippet>> _snippetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.snippets,
    aliasName: $_aliasNameGenerator(db.groups.id, db.snippets.groupId),
  );

  $$SnippetsTableProcessedTableManager get snippetsRefs {
    final manager = $$SnippetsTableTableManager(
      $_db,
      $_db.snippets,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_snippetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get parentId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> serversRefs(
    Expression<bool> Function($$ServersTableFilterComposer f) f,
  ) {
    final $$ServersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableFilterComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> snippetsRefs(
    Expression<bool> Function($$SnippetsTableFilterComposer f) f,
  ) {
    final $$SnippetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableFilterComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get parentId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get parentId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> serversRefs<T extends Object>(
    Expression<T> Function($$ServersTableAnnotationComposer a) f,
  ) {
    final $$ServersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableAnnotationComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> snippetsRefs<T extends Object>(
    Expression<T> Function($$SnippetsTableAnnotationComposer a) f,
  ) {
    final $$SnippetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableAnnotationComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          Group,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (Group, $$GroupsTableReferences),
          Group,
          PrefetchHooks Function({
            bool parentId,
            bool serversRefs,
            bool snippetsRefs,
          })
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                name: name,
                color: color,
                iconName: iconName,
                parentId: parentId,
                sortOrder: sortOrder,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> color = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                name: name,
                color: color,
                iconName: iconName,
                parentId: parentId,
                sortOrder: sortOrder,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GroupsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({parentId = false, serversRefs = false, snippetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serversRefs) db.servers,
                    if (snippetsRefs) db.snippets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable: $$GroupsTableReferences
                                        ._parentIdTable(db),
                                    referencedColumn: $$GroupsTableReferences
                                        ._parentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serversRefs)
                        await $_getPrefetchedData<Group, $GroupsTable, Server>(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._serversRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).serversRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (snippetsRefs)
                        await $_getPrefetchedData<Group, $GroupsTable, Snippet>(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._snippetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).snippetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      Group,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (Group, $$GroupsTableReferences),
      Group,
      PrefetchHooks Function({
        bool parentId,
        bool serversRefs,
        bool snippetsRefs,
      })
    >;
typedef $$ServersTableCreateCompanionBuilder =
    ServersCompanion Function({
      required String id,
      required String name,
      required String hostname,
      Value<int> port,
      required String username,
      Value<String> authMethod,
      Value<String> notes,
      Value<int> color,
      Value<String> iconName,
      Value<bool> isActive,
      Value<String?> groupId,
      Value<String?> sshKeyId,
      Value<int> sortOrder,
      Value<String?> distroId,
      Value<String?> distroName,
      Value<String?> jumpHostId,
      Value<String> proxyType,
      Value<String> proxyHost,
      Value<int> proxyPort,
      Value<String?> proxyUsername,
      Value<bool> useGlobalProxy,
      Value<bool> requiresVpn,
      Value<String> postConnectCommands,
      Value<bool> isFavorite,
      Value<DateTime?> lastConnectedAt,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ServersTableUpdateCompanionBuilder =
    ServersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> hostname,
      Value<int> port,
      Value<String> username,
      Value<String> authMethod,
      Value<String> notes,
      Value<int> color,
      Value<String> iconName,
      Value<bool> isActive,
      Value<String?> groupId,
      Value<String?> sshKeyId,
      Value<int> sortOrder,
      Value<String?> distroId,
      Value<String?> distroName,
      Value<String?> jumpHostId,
      Value<String> proxyType,
      Value<String> proxyHost,
      Value<int> proxyPort,
      Value<String?> proxyUsername,
      Value<bool> useGlobalProxy,
      Value<bool> requiresVpn,
      Value<String> postConnectCommands,
      Value<bool> isFavorite,
      Value<DateTime?> lastConnectedAt,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ServersTableReferences
    extends BaseReferences<_$AppDatabase, $ServersTable, Server> {
  $$ServersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.servers.groupId, db.groups.id),
  );

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SshKeysTable _sshKeyIdTable(_$AppDatabase db) => db.sshKeys
      .createAlias($_aliasNameGenerator(db.servers.sshKeyId, db.sshKeys.id));

  $$SshKeysTableProcessedTableManager? get sshKeyId {
    final $_column = $_itemColumn<String>('ssh_key_id');
    if ($_column == null) return null;
    final manager = $$SshKeysTableTableManager(
      $_db,
      $_db.sshKeys,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sshKeyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ServerTagsTable, List<ServerTag>>
  _serverTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serverTags,
    aliasName: $_aliasNameGenerator(db.servers.id, db.serverTags.serverId),
  );

  $$ServerTagsTableProcessedTableManager get serverTagsRefs {
    final manager = $$ServerTagsTableTableManager(
      $_db,
      $_db.serverTags,
    ).filter((f) => f.serverId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serverTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SftpBookmarksTable, List<SftpBookmark>>
  _sftpBookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sftpBookmarks,
    aliasName: $_aliasNameGenerator(db.servers.id, db.sftpBookmarks.serverId),
  );

  $$SftpBookmarksTableProcessedTableManager get sftpBookmarksRefs {
    final manager = $$SftpBookmarksTableTableManager(
      $_db,
      $_db.sftpBookmarks,
    ).filter((f) => f.serverId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sftpBookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServersTableFilterComposer
    extends Composer<_$AppDatabase, $ServersTable> {
  $$ServersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distroId => $composableBuilder(
    column: $table.distroId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distroName => $composableBuilder(
    column: $table.distroName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jumpHostId => $composableBuilder(
    column: $table.jumpHostId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proxyType => $composableBuilder(
    column: $table.proxyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proxyHost => $composableBuilder(
    column: $table.proxyHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proxyPort => $composableBuilder(
    column: $table.proxyPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proxyUsername => $composableBuilder(
    column: $table.proxyUsername,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useGlobalProxy => $composableBuilder(
    column: $table.useGlobalProxy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresVpn => $composableBuilder(
    column: $table.requiresVpn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postConnectCommands => $composableBuilder(
    column: $table.postConnectCommands,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SshKeysTableFilterComposer get sshKeyId {
    final $$SshKeysTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sshKeyId,
      referencedTable: $db.sshKeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SshKeysTableFilterComposer(
            $db: $db,
            $table: $db.sshKeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> serverTagsRefs(
    Expression<bool> Function($$ServerTagsTableFilterComposer f) f,
  ) {
    final $$ServerTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serverTags,
      getReferencedColumn: (t) => t.serverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerTagsTableFilterComposer(
            $db: $db,
            $table: $db.serverTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sftpBookmarksRefs(
    Expression<bool> Function($$SftpBookmarksTableFilterComposer f) f,
  ) {
    final $$SftpBookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sftpBookmarks,
      getReferencedColumn: (t) => t.serverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SftpBookmarksTableFilterComposer(
            $db: $db,
            $table: $db.sftpBookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServersTableOrderingComposer
    extends Composer<_$AppDatabase, $ServersTable> {
  $$ServersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distroId => $composableBuilder(
    column: $table.distroId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distroName => $composableBuilder(
    column: $table.distroName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jumpHostId => $composableBuilder(
    column: $table.jumpHostId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proxyType => $composableBuilder(
    column: $table.proxyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proxyHost => $composableBuilder(
    column: $table.proxyHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proxyPort => $composableBuilder(
    column: $table.proxyPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proxyUsername => $composableBuilder(
    column: $table.proxyUsername,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useGlobalProxy => $composableBuilder(
    column: $table.useGlobalProxy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresVpn => $composableBuilder(
    column: $table.requiresVpn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postConnectCommands => $composableBuilder(
    column: $table.postConnectCommands,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SshKeysTableOrderingComposer get sshKeyId {
    final $$SshKeysTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sshKeyId,
      referencedTable: $db.sshKeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SshKeysTableOrderingComposer(
            $db: $db,
            $table: $db.sshKeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServersTable> {
  $$ServersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get authMethod => $composableBuilder(
    column: $table.authMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get distroId =>
      $composableBuilder(column: $table.distroId, builder: (column) => column);

  GeneratedColumn<String> get distroName => $composableBuilder(
    column: $table.distroName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jumpHostId => $composableBuilder(
    column: $table.jumpHostId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proxyType =>
      $composableBuilder(column: $table.proxyType, builder: (column) => column);

  GeneratedColumn<String> get proxyHost =>
      $composableBuilder(column: $table.proxyHost, builder: (column) => column);

  GeneratedColumn<int> get proxyPort =>
      $composableBuilder(column: $table.proxyPort, builder: (column) => column);

  GeneratedColumn<String> get proxyUsername => $composableBuilder(
    column: $table.proxyUsername,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get useGlobalProxy => $composableBuilder(
    column: $table.useGlobalProxy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresVpn => $composableBuilder(
    column: $table.requiresVpn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postConnectCommands => $composableBuilder(
    column: $table.postConnectCommands,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastConnectedAt => $composableBuilder(
    column: $table.lastConnectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SshKeysTableAnnotationComposer get sshKeyId {
    final $$SshKeysTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sshKeyId,
      referencedTable: $db.sshKeys,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SshKeysTableAnnotationComposer(
            $db: $db,
            $table: $db.sshKeys,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> serverTagsRefs<T extends Object>(
    Expression<T> Function($$ServerTagsTableAnnotationComposer a) f,
  ) {
    final $$ServerTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serverTags,
      getReferencedColumn: (t) => t.serverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.serverTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sftpBookmarksRefs<T extends Object>(
    Expression<T> Function($$SftpBookmarksTableAnnotationComposer a) f,
  ) {
    final $$SftpBookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sftpBookmarks,
      getReferencedColumn: (t) => t.serverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SftpBookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.sftpBookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServersTable,
          Server,
          $$ServersTableFilterComposer,
          $$ServersTableOrderingComposer,
          $$ServersTableAnnotationComposer,
          $$ServersTableCreateCompanionBuilder,
          $$ServersTableUpdateCompanionBuilder,
          (Server, $$ServersTableReferences),
          Server,
          PrefetchHooks Function({
            bool groupId,
            bool sshKeyId,
            bool serverTagsRefs,
            bool sftpBookmarksRefs,
          })
        > {
  $$ServersTableTableManager(_$AppDatabase db, $ServersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> hostname = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> authMethod = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String?> sshKeyId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> distroId = const Value.absent(),
                Value<String?> distroName = const Value.absent(),
                Value<String?> jumpHostId = const Value.absent(),
                Value<String> proxyType = const Value.absent(),
                Value<String> proxyHost = const Value.absent(),
                Value<int> proxyPort = const Value.absent(),
                Value<String?> proxyUsername = const Value.absent(),
                Value<bool> useGlobalProxy = const Value.absent(),
                Value<bool> requiresVpn = const Value.absent(),
                Value<String> postConnectCommands = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastConnectedAt = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServersCompanion(
                id: id,
                name: name,
                hostname: hostname,
                port: port,
                username: username,
                authMethod: authMethod,
                notes: notes,
                color: color,
                iconName: iconName,
                isActive: isActive,
                groupId: groupId,
                sshKeyId: sshKeyId,
                sortOrder: sortOrder,
                distroId: distroId,
                distroName: distroName,
                jumpHostId: jumpHostId,
                proxyType: proxyType,
                proxyHost: proxyHost,
                proxyPort: proxyPort,
                proxyUsername: proxyUsername,
                useGlobalProxy: useGlobalProxy,
                requiresVpn: requiresVpn,
                postConnectCommands: postConnectCommands,
                isFavorite: isFavorite,
                lastConnectedAt: lastConnectedAt,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String hostname,
                Value<int> port = const Value.absent(),
                required String username,
                Value<String> authMethod = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String?> sshKeyId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> distroId = const Value.absent(),
                Value<String?> distroName = const Value.absent(),
                Value<String?> jumpHostId = const Value.absent(),
                Value<String> proxyType = const Value.absent(),
                Value<String> proxyHost = const Value.absent(),
                Value<int> proxyPort = const Value.absent(),
                Value<String?> proxyUsername = const Value.absent(),
                Value<bool> useGlobalProxy = const Value.absent(),
                Value<bool> requiresVpn = const Value.absent(),
                Value<String> postConnectCommands = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> lastConnectedAt = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ServersCompanion.insert(
                id: id,
                name: name,
                hostname: hostname,
                port: port,
                username: username,
                authMethod: authMethod,
                notes: notes,
                color: color,
                iconName: iconName,
                isActive: isActive,
                groupId: groupId,
                sshKeyId: sshKeyId,
                sortOrder: sortOrder,
                distroId: distroId,
                distroName: distroName,
                jumpHostId: jumpHostId,
                proxyType: proxyType,
                proxyHost: proxyHost,
                proxyPort: proxyPort,
                proxyUsername: proxyUsername,
                useGlobalProxy: useGlobalProxy,
                requiresVpn: requiresVpn,
                postConnectCommands: postConnectCommands,
                isFavorite: isFavorite,
                lastConnectedAt: lastConnectedAt,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                sshKeyId = false,
                serverTagsRefs = false,
                sftpBookmarksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serverTagsRefs) db.serverTags,
                    if (sftpBookmarksRefs) db.sftpBookmarks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$ServersTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$ServersTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (sshKeyId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sshKeyId,
                                    referencedTable: $$ServersTableReferences
                                        ._sshKeyIdTable(db),
                                    referencedColumn: $$ServersTableReferences
                                        ._sshKeyIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serverTagsRefs)
                        await $_getPrefetchedData<
                          Server,
                          $ServersTable,
                          ServerTag
                        >(
                          currentTable: table,
                          referencedTable: $$ServersTableReferences
                              ._serverTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServersTableReferences(
                                db,
                                table,
                                p0,
                              ).serverTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serverId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sftpBookmarksRefs)
                        await $_getPrefetchedData<
                          Server,
                          $ServersTable,
                          SftpBookmark
                        >(
                          currentTable: table,
                          referencedTable: $$ServersTableReferences
                              ._sftpBookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServersTableReferences(
                                db,
                                table,
                                p0,
                              ).sftpBookmarksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serverId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServersTable,
      Server,
      $$ServersTableFilterComposer,
      $$ServersTableOrderingComposer,
      $$ServersTableAnnotationComposer,
      $$ServersTableCreateCompanionBuilder,
      $$ServersTableUpdateCompanionBuilder,
      (Server, $$ServersTableReferences),
      Server,
      PrefetchHooks Function({
        bool groupId,
        bool sshKeyId,
        bool serverTagsRefs,
        bool sftpBookmarksRefs,
      })
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String name,
      Value<int> color,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> color,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ServerTagsTable, List<ServerTag>>
  _serverTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serverTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.serverTags.tagId),
  );

  $$ServerTagsTableProcessedTableManager get serverTagsRefs {
    final manager = $$ServerTagsTableTableManager(
      $_db,
      $_db.serverTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_serverTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SnippetTagsTable, List<SnippetTag>>
  _snippetTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.snippetTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.snippetTags.tagId),
  );

  $$SnippetTagsTableProcessedTableManager get snippetTagsRefs {
    final manager = $$SnippetTagsTableTableManager(
      $_db,
      $_db.snippetTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_snippetTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> serverTagsRefs(
    Expression<bool> Function($$ServerTagsTableFilterComposer f) f,
  ) {
    final $$ServerTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serverTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerTagsTableFilterComposer(
            $db: $db,
            $table: $db.serverTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> snippetTagsRefs(
    Expression<bool> Function($$SnippetTagsTableFilterComposer f) f,
  ) {
    final $$SnippetTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippetTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetTagsTableFilterComposer(
            $db: $db,
            $table: $db.snippetTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> serverTagsRefs<T extends Object>(
    Expression<T> Function($$ServerTagsTableAnnotationComposer a) f,
  ) {
    final $$ServerTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serverTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.serverTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> snippetTagsRefs<T extends Object>(
    Expression<T> Function($$SnippetTagsTableAnnotationComposer a) f,
  ) {
    final $$SnippetTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippetTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.snippetTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool serverTagsRefs, bool snippetTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                color: color,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> color = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                color: color,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({serverTagsRefs = false, snippetTagsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (serverTagsRefs) db.serverTags,
                    if (snippetTagsRefs) db.snippetTags,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (serverTagsRefs)
                        await $_getPrefetchedData<Tag, $TagsTable, ServerTag>(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._serverTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).serverTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tagId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (snippetTagsRefs)
                        await $_getPrefetchedData<Tag, $TagsTable, SnippetTag>(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._snippetTagsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).snippetTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tagId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool serverTagsRefs, bool snippetTagsRefs})
    >;
typedef $$ServerTagsTableCreateCompanionBuilder =
    ServerTagsCompanion Function({
      required String serverId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$ServerTagsTableUpdateCompanionBuilder =
    ServerTagsCompanion Function({
      Value<String> serverId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$ServerTagsTableReferences
    extends BaseReferences<_$AppDatabase, $ServerTagsTable, ServerTag> {
  $$ServerTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServersTable _serverIdTable(_$AppDatabase db) => db.servers
      .createAlias($_aliasNameGenerator(db.serverTags.serverId, db.servers.id));

  $$ServersTableProcessedTableManager get serverId {
    final $_column = $_itemColumn<String>('server_id')!;

    final manager = $$ServersTableTableManager(
      $_db,
      $_db.servers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags.createAlias(
    $_aliasNameGenerator(db.serverTags.tagId, db.tags.id),
  );

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ServerTagsTableFilterComposer
    extends Composer<_$AppDatabase, $ServerTagsTable> {
  $$ServerTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ServersTableFilterComposer get serverId {
    final $$ServersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableFilterComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServerTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServerTagsTable> {
  $$ServerTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ServersTableOrderingComposer get serverId {
    final $$ServersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableOrderingComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServerTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServerTagsTable> {
  $$ServerTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ServersTableAnnotationComposer get serverId {
    final $$ServersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableAnnotationComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServerTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServerTagsTable,
          ServerTag,
          $$ServerTagsTableFilterComposer,
          $$ServerTagsTableOrderingComposer,
          $$ServerTagsTableAnnotationComposer,
          $$ServerTagsTableCreateCompanionBuilder,
          $$ServerTagsTableUpdateCompanionBuilder,
          (ServerTag, $$ServerTagsTableReferences),
          ServerTag,
          PrefetchHooks Function({bool serverId, bool tagId})
        > {
  $$ServerTagsTableTableManager(_$AppDatabase db, $ServerTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serverId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServerTagsCompanion(
                serverId: serverId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serverId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => ServerTagsCompanion.insert(
                serverId: serverId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServerTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({serverId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (serverId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.serverId,
                                referencedTable: $$ServerTagsTableReferences
                                    ._serverIdTable(db),
                                referencedColumn: $$ServerTagsTableReferences
                                    ._serverIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$ServerTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$ServerTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ServerTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServerTagsTable,
      ServerTag,
      $$ServerTagsTableFilterComposer,
      $$ServerTagsTableOrderingComposer,
      $$ServerTagsTableAnnotationComposer,
      $$ServerTagsTableCreateCompanionBuilder,
      $$ServerTagsTableUpdateCompanionBuilder,
      (ServerTag, $$ServerTagsTableReferences),
      ServerTag,
      PrefetchHooks Function({bool serverId, bool tagId})
    >;
typedef $$SnippetsTableCreateCompanionBuilder =
    SnippetsCompanion Function({
      required String id,
      required String name,
      required String content,
      Value<String> language,
      Value<String> description,
      Value<String?> groupId,
      Value<int> sortOrder,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SnippetsTableUpdateCompanionBuilder =
    SnippetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> content,
      Value<String> language,
      Value<String> description,
      Value<String?> groupId,
      Value<int> sortOrder,
      Value<String?> ownerId,
      Value<String?> sharedWith,
      Value<String?> permissions,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SnippetsTableReferences
    extends BaseReferences<_$AppDatabase, $SnippetsTable, Snippet> {
  $$SnippetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.snippets.groupId, db.groups.id),
  );

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SnippetTagsTable, List<SnippetTag>>
  _snippetTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.snippetTags,
    aliasName: $_aliasNameGenerator(db.snippets.id, db.snippetTags.snippetId),
  );

  $$SnippetTagsTableProcessedTableManager get snippetTagsRefs {
    final manager = $$SnippetTagsTableTableManager(
      $_db,
      $_db.snippetTags,
    ).filter((f) => f.snippetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_snippetTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SnippetVariablesTable, List<SnippetVariable>>
  _snippetVariablesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.snippetVariables,
    aliasName: $_aliasNameGenerator(
      db.snippets.id,
      db.snippetVariables.snippetId,
    ),
  );

  $$SnippetVariablesTableProcessedTableManager get snippetVariablesRefs {
    final manager = $$SnippetVariablesTableTableManager(
      $_db,
      $_db.snippetVariables,
    ).filter((f) => f.snippetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _snippetVariablesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SnippetsTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> snippetTagsRefs(
    Expression<bool> Function($$SnippetTagsTableFilterComposer f) f,
  ) {
    final $$SnippetTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippetTags,
      getReferencedColumn: (t) => t.snippetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetTagsTableFilterComposer(
            $db: $db,
            $table: $db.snippetTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> snippetVariablesRefs(
    Expression<bool> Function($$SnippetVariablesTableFilterComposer f) f,
  ) {
    final $$SnippetVariablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippetVariables,
      getReferencedColumn: (t) => t.snippetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetVariablesTableFilterComposer(
            $db: $db,
            $table: $db.snippetVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SnippetsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnippetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetsTable> {
  $$SnippetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get sharedWith => $composableBuilder(
    column: $table.sharedWith,
    builder: (column) => column,
  );

  GeneratedColumn<String> get permissions => $composableBuilder(
    column: $table.permissions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> snippetTagsRefs<T extends Object>(
    Expression<T> Function($$SnippetTagsTableAnnotationComposer a) f,
  ) {
    final $$SnippetTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippetTags,
      getReferencedColumn: (t) => t.snippetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.snippetTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> snippetVariablesRefs<T extends Object>(
    Expression<T> Function($$SnippetVariablesTableAnnotationComposer a) f,
  ) {
    final $$SnippetVariablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snippetVariables,
      getReferencedColumn: (t) => t.snippetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetVariablesTableAnnotationComposer(
            $db: $db,
            $table: $db.snippetVariables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SnippetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnippetsTable,
          Snippet,
          $$SnippetsTableFilterComposer,
          $$SnippetsTableOrderingComposer,
          $$SnippetsTableAnnotationComposer,
          $$SnippetsTableCreateCompanionBuilder,
          $$SnippetsTableUpdateCompanionBuilder,
          (Snippet, $$SnippetsTableReferences),
          Snippet,
          PrefetchHooks Function({
            bool groupId,
            bool snippetTagsRefs,
            bool snippetVariablesRefs,
          })
        > {
  $$SnippetsTableTableManager(_$AppDatabase db, $SnippetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion(
                id: id,
                name: name,
                content: content,
                language: language,
                description: description,
                groupId: groupId,
                sortOrder: sortOrder,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String content,
                Value<String> language = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> sharedWith = const Value.absent(),
                Value<String?> permissions = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SnippetsCompanion.insert(
                id: id,
                name: name,
                content: content,
                language: language,
                description: description,
                groupId: groupId,
                sortOrder: sortOrder,
                ownerId: ownerId,
                sharedWith: sharedWith,
                permissions: permissions,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SnippetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                snippetTagsRefs = false,
                snippetVariablesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (snippetTagsRefs) db.snippetTags,
                    if (snippetVariablesRefs) db.snippetVariables,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.groupId,
                                    referencedTable: $$SnippetsTableReferences
                                        ._groupIdTable(db),
                                    referencedColumn: $$SnippetsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (snippetTagsRefs)
                        await $_getPrefetchedData<
                          Snippet,
                          $SnippetsTable,
                          SnippetTag
                        >(
                          currentTable: table,
                          referencedTable: $$SnippetsTableReferences
                              ._snippetTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SnippetsTableReferences(
                                db,
                                table,
                                p0,
                              ).snippetTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.snippetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (snippetVariablesRefs)
                        await $_getPrefetchedData<
                          Snippet,
                          $SnippetsTable,
                          SnippetVariable
                        >(
                          currentTable: table,
                          referencedTable: $$SnippetsTableReferences
                              ._snippetVariablesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SnippetsTableReferences(
                                db,
                                table,
                                p0,
                              ).snippetVariablesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.snippetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SnippetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnippetsTable,
      Snippet,
      $$SnippetsTableFilterComposer,
      $$SnippetsTableOrderingComposer,
      $$SnippetsTableAnnotationComposer,
      $$SnippetsTableCreateCompanionBuilder,
      $$SnippetsTableUpdateCompanionBuilder,
      (Snippet, $$SnippetsTableReferences),
      Snippet,
      PrefetchHooks Function({
        bool groupId,
        bool snippetTagsRefs,
        bool snippetVariablesRefs,
      })
    >;
typedef $$SnippetTagsTableCreateCompanionBuilder =
    SnippetTagsCompanion Function({
      required String snippetId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$SnippetTagsTableUpdateCompanionBuilder =
    SnippetTagsCompanion Function({
      Value<String> snippetId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$SnippetTagsTableReferences
    extends BaseReferences<_$AppDatabase, $SnippetTagsTable, SnippetTag> {
  $$SnippetTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SnippetsTable _snippetIdTable(_$AppDatabase db) =>
      db.snippets.createAlias(
        $_aliasNameGenerator(db.snippetTags.snippetId, db.snippets.id),
      );

  $$SnippetsTableProcessedTableManager get snippetId {
    final $_column = $_itemColumn<String>('snippet_id')!;

    final manager = $$SnippetsTableTableManager(
      $_db,
      $_db.snippets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_snippetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags.createAlias(
    $_aliasNameGenerator(db.snippetTags.tagId, db.tags.id),
  );

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SnippetTagsTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetTagsTable> {
  $$SnippetTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SnippetsTableFilterComposer get snippetId {
    final $$SnippetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snippetId,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableFilterComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnippetTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetTagsTable> {
  $$SnippetTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SnippetsTableOrderingComposer get snippetId {
    final $$SnippetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snippetId,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableOrderingComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnippetTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetTagsTable> {
  $$SnippetTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SnippetsTableAnnotationComposer get snippetId {
    final $$SnippetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snippetId,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableAnnotationComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnippetTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnippetTagsTable,
          SnippetTag,
          $$SnippetTagsTableFilterComposer,
          $$SnippetTagsTableOrderingComposer,
          $$SnippetTagsTableAnnotationComposer,
          $$SnippetTagsTableCreateCompanionBuilder,
          $$SnippetTagsTableUpdateCompanionBuilder,
          (SnippetTag, $$SnippetTagsTableReferences),
          SnippetTag,
          PrefetchHooks Function({bool snippetId, bool tagId})
        > {
  $$SnippetTagsTableTableManager(_$AppDatabase db, $SnippetTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> snippetId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetTagsCompanion(
                snippetId: snippetId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String snippetId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => SnippetTagsCompanion.insert(
                snippetId: snippetId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SnippetTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({snippetId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (snippetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.snippetId,
                                referencedTable: $$SnippetTagsTableReferences
                                    ._snippetIdTable(db),
                                referencedColumn: $$SnippetTagsTableReferences
                                    ._snippetIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$SnippetTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$SnippetTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SnippetTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnippetTagsTable,
      SnippetTag,
      $$SnippetTagsTableFilterComposer,
      $$SnippetTagsTableOrderingComposer,
      $$SnippetTagsTableAnnotationComposer,
      $$SnippetTagsTableCreateCompanionBuilder,
      $$SnippetTagsTableUpdateCompanionBuilder,
      (SnippetTag, $$SnippetTagsTableReferences),
      SnippetTag,
      PrefetchHooks Function({bool snippetId, bool tagId})
    >;
typedef $$SnippetVariablesTableCreateCompanionBuilder =
    SnippetVariablesCompanion Function({
      required String id,
      required String snippetId,
      required String name,
      Value<String> defaultValue,
      Value<String> description,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$SnippetVariablesTableUpdateCompanionBuilder =
    SnippetVariablesCompanion Function({
      Value<String> id,
      Value<String> snippetId,
      Value<String> name,
      Value<String> defaultValue,
      Value<String> description,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$SnippetVariablesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SnippetVariablesTable, SnippetVariable> {
  $$SnippetVariablesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SnippetsTable _snippetIdTable(_$AppDatabase db) =>
      db.snippets.createAlias(
        $_aliasNameGenerator(db.snippetVariables.snippetId, db.snippets.id),
      );

  $$SnippetsTableProcessedTableManager get snippetId {
    final $_column = $_itemColumn<String>('snippet_id')!;

    final manager = $$SnippetsTableTableManager(
      $_db,
      $_db.snippets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_snippetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SnippetVariablesTableFilterComposer
    extends Composer<_$AppDatabase, $SnippetVariablesTable> {
  $$SnippetVariablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultValue => $composableBuilder(
    column: $table.defaultValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$SnippetsTableFilterComposer get snippetId {
    final $$SnippetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snippetId,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableFilterComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnippetVariablesTableOrderingComposer
    extends Composer<_$AppDatabase, $SnippetVariablesTable> {
  $$SnippetVariablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultValue => $composableBuilder(
    column: $table.defaultValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$SnippetsTableOrderingComposer get snippetId {
    final $$SnippetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snippetId,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableOrderingComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnippetVariablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnippetVariablesTable> {
  $$SnippetVariablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get defaultValue => $composableBuilder(
    column: $table.defaultValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$SnippetsTableAnnotationComposer get snippetId {
    final $$SnippetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.snippetId,
      referencedTable: $db.snippets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnippetsTableAnnotationComposer(
            $db: $db,
            $table: $db.snippets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnippetVariablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnippetVariablesTable,
          SnippetVariable,
          $$SnippetVariablesTableFilterComposer,
          $$SnippetVariablesTableOrderingComposer,
          $$SnippetVariablesTableAnnotationComposer,
          $$SnippetVariablesTableCreateCompanionBuilder,
          $$SnippetVariablesTableUpdateCompanionBuilder,
          (SnippetVariable, $$SnippetVariablesTableReferences),
          SnippetVariable,
          PrefetchHooks Function({bool snippetId})
        > {
  $$SnippetVariablesTableTableManager(
    _$AppDatabase db,
    $SnippetVariablesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnippetVariablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnippetVariablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnippetVariablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> snippetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> defaultValue = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetVariablesCompanion(
                id: id,
                snippetId: snippetId,
                name: name,
                defaultValue: defaultValue,
                description: description,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String snippetId,
                required String name,
                Value<String> defaultValue = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SnippetVariablesCompanion.insert(
                id: id,
                snippetId: snippetId,
                name: name,
                defaultValue: defaultValue,
                description: description,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SnippetVariablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({snippetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (snippetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.snippetId,
                                referencedTable:
                                    $$SnippetVariablesTableReferences
                                        ._snippetIdTable(db),
                                referencedColumn:
                                    $$SnippetVariablesTableReferences
                                        ._snippetIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SnippetVariablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnippetVariablesTable,
      SnippetVariable,
      $$SnippetVariablesTableFilterComposer,
      $$SnippetVariablesTableOrderingComposer,
      $$SnippetVariablesTableAnnotationComposer,
      $$SnippetVariablesTableCreateCompanionBuilder,
      $$SnippetVariablesTableUpdateCompanionBuilder,
      (SnippetVariable, $$SnippetVariablesTableReferences),
      SnippetVariable,
      PrefetchHooks Function({bool snippetId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$KnownHostsTableCreateCompanionBuilder =
    KnownHostsCompanion Function({
      required String id,
      required String hostname,
      Value<int> port,
      required String keyType,
      required String fingerprint,
      Value<bool> trusted,
      required DateTime firstSeenAt,
      required DateTime lastSeenAt,
      Value<int> rowid,
    });
typedef $$KnownHostsTableUpdateCompanionBuilder =
    KnownHostsCompanion Function({
      Value<String> id,
      Value<String> hostname,
      Value<int> port,
      Value<String> keyType,
      Value<String> fingerprint,
      Value<bool> trusted,
      Value<DateTime> firstSeenAt,
      Value<DateTime> lastSeenAt,
      Value<int> rowid,
    });

class $$KnownHostsTableFilterComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get trusted => $composableBuilder(
    column: $table.trusted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KnownHostsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyType => $composableBuilder(
    column: $table.keyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get trusted => $composableBuilder(
    column: $table.trusted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KnownHostsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnownHostsTable> {
  $$KnownHostsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get keyType =>
      $composableBuilder(column: $table.keyType, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get trusted =>
      $composableBuilder(column: $table.trusted, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );
}

class $$KnownHostsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KnownHostsTable,
          KnownHost,
          $$KnownHostsTableFilterComposer,
          $$KnownHostsTableOrderingComposer,
          $$KnownHostsTableAnnotationComposer,
          $$KnownHostsTableCreateCompanionBuilder,
          $$KnownHostsTableUpdateCompanionBuilder,
          (
            KnownHost,
            BaseReferences<_$AppDatabase, $KnownHostsTable, KnownHost>,
          ),
          KnownHost,
          PrefetchHooks Function()
        > {
  $$KnownHostsTableTableManager(_$AppDatabase db, $KnownHostsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnownHostsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnownHostsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnownHostsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> hostname = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<String> keyType = const Value.absent(),
                Value<String> fingerprint = const Value.absent(),
                Value<bool> trusted = const Value.absent(),
                Value<DateTime> firstSeenAt = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KnownHostsCompanion(
                id: id,
                hostname: hostname,
                port: port,
                keyType: keyType,
                fingerprint: fingerprint,
                trusted: trusted,
                firstSeenAt: firstSeenAt,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String hostname,
                Value<int> port = const Value.absent(),
                required String keyType,
                required String fingerprint,
                Value<bool> trusted = const Value.absent(),
                required DateTime firstSeenAt,
                required DateTime lastSeenAt,
                Value<int> rowid = const Value.absent(),
              }) => KnownHostsCompanion.insert(
                id: id,
                hostname: hostname,
                port: port,
                keyType: keyType,
                fingerprint: fingerprint,
                trusted: trusted,
                firstSeenAt: firstSeenAt,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KnownHostsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KnownHostsTable,
      KnownHost,
      $$KnownHostsTableFilterComposer,
      $$KnownHostsTableOrderingComposer,
      $$KnownHostsTableAnnotationComposer,
      $$KnownHostsTableCreateCompanionBuilder,
      $$KnownHostsTableUpdateCompanionBuilder,
      (KnownHost, BaseReferences<_$AppDatabase, $KnownHostsTable, KnownHost>),
      KnownHost,
      PrefetchHooks Function()
    >;
typedef $$SftpBookmarksTableCreateCompanionBuilder =
    SftpBookmarksCompanion Function({
      required String id,
      required String serverId,
      required String path,
      required String label,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SftpBookmarksTableUpdateCompanionBuilder =
    SftpBookmarksCompanion Function({
      Value<String> id,
      Value<String> serverId,
      Value<String> path,
      Value<String> label,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$SftpBookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $SftpBookmarksTable, SftpBookmark> {
  $$SftpBookmarksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ServersTable _serverIdTable(_$AppDatabase db) =>
      db.servers.createAlias(
        $_aliasNameGenerator(db.sftpBookmarks.serverId, db.servers.id),
      );

  $$ServersTableProcessedTableManager get serverId {
    final $_column = $_itemColumn<String>('server_id')!;

    final manager = $$ServersTableTableManager(
      $_db,
      $_db.servers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SftpBookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $SftpBookmarksTable> {
  $$SftpBookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServersTableFilterComposer get serverId {
    final $$ServersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableFilterComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SftpBookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $SftpBookmarksTable> {
  $$SftpBookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServersTableOrderingComposer get serverId {
    final $$ServersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableOrderingComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SftpBookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SftpBookmarksTable> {
  $$SftpBookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ServersTableAnnotationComposer get serverId {
    final $$ServersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableAnnotationComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SftpBookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SftpBookmarksTable,
          SftpBookmark,
          $$SftpBookmarksTableFilterComposer,
          $$SftpBookmarksTableOrderingComposer,
          $$SftpBookmarksTableAnnotationComposer,
          $$SftpBookmarksTableCreateCompanionBuilder,
          $$SftpBookmarksTableUpdateCompanionBuilder,
          (SftpBookmark, $$SftpBookmarksTableReferences),
          SftpBookmark,
          PrefetchHooks Function({bool serverId})
        > {
  $$SftpBookmarksTableTableManager(_$AppDatabase db, $SftpBookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SftpBookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SftpBookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SftpBookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SftpBookmarksCompanion(
                id: id,
                serverId: serverId,
                path: path,
                label: label,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String serverId,
                required String path,
                required String label,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SftpBookmarksCompanion.insert(
                id: id,
                serverId: serverId,
                path: path,
                label: label,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SftpBookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({serverId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (serverId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.serverId,
                                referencedTable: $$SftpBookmarksTableReferences
                                    ._serverIdTable(db),
                                referencedColumn: $$SftpBookmarksTableReferences
                                    ._serverIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SftpBookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SftpBookmarksTable,
      SftpBookmark,
      $$SftpBookmarksTableFilterComposer,
      $$SftpBookmarksTableOrderingComposer,
      $$SftpBookmarksTableAnnotationComposer,
      $$SftpBookmarksTableCreateCompanionBuilder,
      $$SftpBookmarksTableUpdateCompanionBuilder,
      (SftpBookmark, $$SftpBookmarksTableReferences),
      SftpBookmark,
      PrefetchHooks Function({bool serverId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SshKeysTableTableManager get sshKeys =>
      $$SshKeysTableTableManager(_db, _db.sshKeys);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db, _db.servers);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$ServerTagsTableTableManager get serverTags =>
      $$ServerTagsTableTableManager(_db, _db.serverTags);
  $$SnippetsTableTableManager get snippets =>
      $$SnippetsTableTableManager(_db, _db.snippets);
  $$SnippetTagsTableTableManager get snippetTags =>
      $$SnippetTagsTableTableManager(_db, _db.snippetTags);
  $$SnippetVariablesTableTableManager get snippetVariables =>
      $$SnippetVariablesTableTableManager(_db, _db.snippetVariables);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$KnownHostsTableTableManager get knownHosts =>
      $$KnownHostsTableTableManager(_db, _db.knownHosts);
  $$SftpBookmarksTableTableManager get sftpBookmarks =>
      $$SftpBookmarksTableTableManager(_db, _db.sftpBookmarks);
}
