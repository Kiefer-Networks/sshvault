import 'package:drift/drift.dart';

class SshKeys extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
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
  TextColumn get name => text()();
  TextColumn get hostname => text()();
  IntColumn get port => integer().withDefault(const Constant(22))();
  TextColumn get username => text()();
  TextColumn get authMethod => text().withDefault(const Constant('password'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  IntColumn get color => integer().withDefault(const Constant(0xFF6C63FF))();
  TextColumn get iconName => text().withDefault(const Constant('server'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get groupId => text().nullable().references(Groups, #id)();
  TextColumn get sshKeyId => text().nullable().references(SshKeys, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get distroId => text().nullable()();
  TextColumn get distroName => text().nullable()();
  TextColumn get jumpHostId => text().nullable()();
  // Proxy
  TextColumn get proxyType => text().withDefault(const Constant('none'))();
  TextColumn get proxyHost => text().withDefault(const Constant(''))();
  IntColumn get proxyPort => integer().withDefault(const Constant(1080))();
  TextColumn get proxyUsername => text().nullable()();
  BoolColumn get useGlobalProxy =>
      boolean().withDefault(const Constant(true))();
  // VPN
  BoolColumn get requiresVpn => boolean().withDefault(const Constant(false))();
  // Post-Connect
  TextColumn get postConnectCommands =>
      text().withDefault(const Constant(''))();
  // Dashboard
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastConnectedAt => dateTime().nullable()();
  // Sync
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
  TextColumn get name => text()();
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
  TextColumn get name => text()();
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

class Snippets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get content => text()();
  TextColumn get language => text().withDefault(const Constant('bash'))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get groupId => text().nullable().references(Groups, #id)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get ownerId => text().nullable()();
  TextColumn get sharedWith => text().nullable()();
  TextColumn get permissions => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SnippetTags extends Table {
  TextColumn get snippetId => text().references(Snippets, #id)();
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {snippetId, tagId};
}

class SnippetVariables extends Table {
  TextColumn get id => text()();
  TextColumn get snippetId => text().references(Snippets, #id)();
  TextColumn get name => text()();
  TextColumn get defaultValue => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class KnownHosts extends Table {
  TextColumn get id => text()();
  TextColumn get hostname => text()();
  IntColumn get port => integer().withDefault(const Constant(22))();
  TextColumn get keyType => text()();
  TextColumn get fingerprint => text()();
  BoolColumn get trusted => boolean().withDefault(const Constant(true))();
  DateTimeColumn get firstSeenAt => dateTime()();
  DateTimeColumn get lastSeenAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
