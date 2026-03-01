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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 32,
    ),
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
    ownerId,
    sharedWith,
    permissions,
    createdAt,
    updatedAt,
  );
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SshKeysTable sshKeys = $SshKeysTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $ServersTable servers = $ServersTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $ServerTagsTable serverTags = $ServerTagsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final ServerDao serverDao = ServerDao(this as AppDatabase);
  late final SshKeyDao sshKeyDao = SshKeyDao(this as AppDatabase);
  late final GroupDao groupDao = GroupDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  late final AppSettingsDao appSettingsDao = AppSettingsDao(
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
    appSettings,
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
          PrefetchHooks Function({bool parentId, bool serversRefs})
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
          prefetchHooksCallback: ({parentId = false, serversRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (serversRefs) db.servers],
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
                          $$GroupsTableReferences(db, table, p0).serversRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
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
      PrefetchHooks Function({bool parentId, bool serversRefs})
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
              ({groupId = false, sshKeyId = false, serverTagsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (serverTagsRefs) db.serverTags],
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
      PrefetchHooks Function({bool groupId, bool sshKeyId, bool serverTagsRefs})
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
          PrefetchHooks Function({bool serverTagsRefs})
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
          prefetchHooksCallback: ({serverTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (serverTagsRefs) db.serverTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serverTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, ServerTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._serverTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).serverTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
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
      PrefetchHooks Function({bool serverTagsRefs})
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
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
