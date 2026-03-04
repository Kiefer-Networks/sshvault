import 'package:drift/drift.dart';

/// Local cache of Teleport clusters registered by the user.
///
/// The cluster configuration (proxy address, auth method) is stored locally so
/// the app can reconnect without requiring a server round-trip. The actual
/// Teleport sessions and certificates live on the Go backend.
class TeleportClusters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get proxyAddr => text()();
  TextColumn get authMethod =>
      text().withDefault(const Constant('local'))(); // local, sso_oidc, sso_saml, identity_file
  TextColumn get username => text().withDefault(const Constant(''))();
  TextColumn get metadata => text().withDefault(const Constant('{}'))();
  DateTimeColumn get certExpiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
