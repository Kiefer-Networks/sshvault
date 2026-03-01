import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/crypto/crypto_provider.dart';
import 'package:shellvault/core/crypto/field_crypto_provider.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/core/storage/secure_storage_provider.dart';
import 'package:shellvault/features/connection/data/repositories/export_import_repository_impl.dart';
import 'package:shellvault/features/connection/data/repositories/group_repository_impl.dart';
import 'package:shellvault/features/connection/data/repositories/server_repository_impl.dart';
import 'package:shellvault/features/connection/data/repositories/ssh_key_repository_impl.dart';
import 'package:shellvault/features/connection/data/repositories/tag_repository_impl.dart';
import 'package:shellvault/features/connection/domain/repositories/export_import_repository.dart';
import 'package:shellvault/features/connection/domain/repositories/group_repository.dart';
import 'package:shellvault/features/connection/domain/repositories/server_repository.dart';
import 'package:shellvault/features/connection/domain/repositories/ssh_key_repository.dart';
import 'package:shellvault/features/connection/domain/repositories/tag_repository.dart';
import 'package:shellvault/features/connection/domain/usecases/export_import_usecases.dart';
import 'package:shellvault/features/connection/domain/usecases/group_usecases.dart';
import 'package:shellvault/features/connection/domain/usecases/server_usecases.dart';
import 'package:shellvault/features/connection/domain/usecases/ssh_key_usecases.dart';
import 'package:shellvault/features/connection/domain/usecases/tag_usecases.dart';
import 'package:shellvault/features/snippet/data/repositories/snippet_repository_impl.dart';
import 'package:shellvault/features/snippet/domain/repositories/snippet_repository.dart';
import 'package:shellvault/features/snippet/domain/usecases/snippet_usecases.dart';

final serverRepositoryProvider = Provider<ServerRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final crypto = ref.watch(fieldCryptoServiceProvider);
  return ServerRepositoryImpl(db.serverDao, secureStorage, crypto: crypto);
});

final sshKeyRepositoryProvider = Provider<SshKeyRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final crypto = ref.watch(fieldCryptoServiceProvider);
  return SshKeyRepositoryImpl(db.sshKeyDao, secureStorage, crypto: crypto);
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final crypto = ref.watch(fieldCryptoServiceProvider);
  return GroupRepositoryImpl(db.groupDao, crypto: crypto);
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final crypto = ref.watch(fieldCryptoServiceProvider);
  return TagRepositoryImpl(db.tagDao, db.serverDao, crypto: crypto);
});

final exportImportRepositoryProvider =
    Provider<ExportImportRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final encryptionService = ref.watch(encryptionServiceProvider);
  final crypto = ref.watch(fieldCryptoServiceProvider);
  return ExportImportRepositoryImpl(
    db.serverDao,
    db.groupDao,
    db.tagDao,
    db.sshKeyDao,
    secureStorage,
    encryptionService,
    crypto: crypto,
  );
});

// Use Cases
final serverUseCasesProvider = Provider<ServerUseCases>((ref) {
  return ServerUseCases(ref.watch(serverRepositoryProvider));
});

final sshKeyUseCasesProvider = Provider<SshKeyUseCases>((ref) {
  return SshKeyUseCases(ref.watch(sshKeyRepositoryProvider));
});

final groupUseCasesProvider = Provider<GroupUseCases>((ref) {
  return GroupUseCases(ref.watch(groupRepositoryProvider));
});

final tagUseCasesProvider = Provider<TagUseCases>((ref) {
  return TagUseCases(ref.watch(tagRepositoryProvider));
});

final exportImportUseCasesProvider = Provider<ExportImportUseCases>((ref) {
  return ExportImportUseCases(ref.watch(exportImportRepositoryProvider));
});

// Snippets
final snippetRepositoryProvider = Provider<SnippetRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final crypto = ref.watch(fieldCryptoServiceProvider);
  return SnippetRepositoryImpl(db.snippetDao, crypto: crypto);
});

final snippetUseCasesProvider = Provider<SnippetUseCases>((ref) {
  return SnippetUseCases(ref.watch(snippetRepositoryProvider));
});
