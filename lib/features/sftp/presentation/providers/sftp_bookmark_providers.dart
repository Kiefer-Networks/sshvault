import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/features/sftp/data/repositories/sftp_bookmark_repository_impl.dart';
import 'package:shellvault/features/sftp/domain/entities/sftp_bookmark_entity.dart';
import 'package:shellvault/features/sftp/domain/repositories/sftp_bookmark_repository.dart';

final sftpBookmarkRepositoryProvider = Provider<SftpBookmarkRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SftpBookmarkRepositoryImpl(db.sftpBookmarkDao);
});

final sftpBookmarksProvider =
    FutureProvider.family<List<SftpBookmarkEntity>, String>((
      ref,
      serverId,
    ) async {
      final repo = ref.watch(sftpBookmarkRepositoryProvider);
      final result = await repo.getByServerId(serverId);
      return result.fold(
        onSuccess: (bookmarks) => bookmarks,
        onFailure: (_) => [],
      );
    });
