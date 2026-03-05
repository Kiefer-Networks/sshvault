import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/features/host_key/data/repositories/known_host_repository_impl.dart';
import 'package:shellvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:shellvault/features/host_key/domain/repositories/known_host_repository.dart';

final knownHostRepositoryProvider = Provider<KnownHostRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return KnownHostRepositoryImpl(db.knownHostDao);
});

final knownHostListProvider = FutureProvider<List<KnownHostEntity>>((ref) async {
  final repo = ref.watch(knownHostRepositoryProvider);
  final result = await repo.getAll();
  return result.fold(
    onSuccess: (hosts) => hosts,
    onFailure: (_) => [],
  );
});
