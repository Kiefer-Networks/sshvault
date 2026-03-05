import 'package:drift/drift.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/host_key/domain/entities/known_host_entity.dart';

abstract final class KnownHostMapper {
  static KnownHostEntity fromDrift(KnownHost row) {
    return KnownHostEntity(
      id: row.id,
      hostname: row.hostname,
      port: row.port,
      keyType: row.keyType,
      fingerprint: row.fingerprint,
      trusted: row.trusted,
      firstSeenAt: row.firstSeenAt,
      lastSeenAt: row.lastSeenAt,
    );
  }

  static KnownHostsCompanion toCompanion(KnownHostEntity entity) {
    return KnownHostsCompanion(
      id: Value(entity.id),
      hostname: Value(entity.hostname),
      port: Value(entity.port),
      keyType: Value(entity.keyType),
      fingerprint: Value(entity.fingerprint),
      trusted: Value(entity.trusted),
      firstSeenAt: Value(entity.firstSeenAt),
      lastSeenAt: Value(entity.lastSeenAt),
    );
  }
}
