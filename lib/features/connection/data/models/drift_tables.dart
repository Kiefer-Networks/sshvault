import 'package:drift/drift.dart';

class SshKeys extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get keyType => text()(); // ed25519, rsa, ecdsa256, etc.
  TextColumn get fingerprint => text().withDefault(const Constant(''))();
  TextColumn get publicKey => text().withDefault(const Constant(''))();
  TextColumn get comment => text().withDefault(const Constant(''))();
  TextColumn get ownerId => text().nullable()();
  TextColumn get sharedWith => text().nullable()();
  TextColumn get permissions => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Servers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get hostname => text().withLength(min: 1, max: 255)();
  IntColumn get port => integer().withDefault(const Constant(22))();
  TextColumn get username => text().withLength(min: 1, max: 32)();
  TextColumn get authMethod => text().withDefault(const Constant('password'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get color => integer().withDefault(const Constant(0xFF6C63FF))();
  TextColumn get iconName => text().withDefault(const Constant('server'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get groupId => text().nullable().references(Groups, #id)();
  TextColumn get sshKeyId => text().nullable().references(SshKeys, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get ownerId => text().nullable()();
  TextColumn get sharedWith => text().nullable()();
  TextColumn get permissions => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Groups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get color => integer().withDefault(const Constant(0xFF6C63FF))();
  TextColumn get iconName => text().withDefault(const Constant('server'))();
  TextColumn get parentId => text().nullable().references(Groups, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get ownerId => text().nullable()();
  TextColumn get sharedWith => text().nullable()();
  TextColumn get permissions => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get color => integer().withDefault(const Constant(0xFF6C63FF))();
  TextColumn get ownerId => text().nullable()();
  TextColumn get sharedWith => text().nullable()();
  TextColumn get permissions => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class ServerTags extends Table {
  TextColumn get serverId => text().references(Servers, #id)();
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {serverId, tagId};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
