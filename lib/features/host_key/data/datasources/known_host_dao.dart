import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/data/models/drift_tables.dart';

part 'known_host_dao.g.dart';

@DriftAccessor(tables: [KnownHosts])
class KnownHostDao extends DatabaseAccessor<AppDatabase>
    with _$KnownHostDaoMixin {
  KnownHostDao(super.db);

  Future<KnownHost?> findByHostAndPort(String hostname, int port) async {
    return (select(knownHosts)
          ..where((t) => t.hostname.equals(hostname) & t.port.equals(port)))
        .getSingleOrNull();
  }

  Future<List<KnownHost>> getAll() => select(knownHosts).get();

  Future<int> insertKnownHost(KnownHostsCompanion host) =>
      into(knownHosts).insert(host);

  Future<bool> updateKnownHost(KnownHostsCompanion host) =>
      update(knownHosts).replace(host);

  Future<int> deleteById(String id) =>
      (delete(knownHosts)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAll() => delete(knownHosts).go();
}
