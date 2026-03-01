import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';

final sshKeyListProvider =
    AsyncNotifierProvider<SshKeyListNotifier, List<SshKeyEntity>>(
  SshKeyListNotifier.new,
);

class SshKeyListNotifier extends AsyncNotifier<List<SshKeyEntity>> {
  @override
  Future<List<SshKeyEntity>> build() async {
    final useCases = ref.watch(sshKeyUseCasesProvider);
    final result = await useCases.getAllSshKeys();
    return result.fold(
      onSuccess: (keys) => keys,
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> createSshKey(
    SshKeyEntity key, {
    required String privateKey,
    String? passphrase,
  }) async {
    final useCases = ref.read(sshKeyUseCasesProvider);
    final result = await useCases.createSshKey(
      key,
      privateKey: privateKey,
      passphrase: passphrase,
    );
    result.fold(
      onSuccess: (_) => ref.invalidateSelf(),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> updateSshKey(SshKeyEntity key) async {
    final useCases = ref.read(sshKeyUseCasesProvider);
    final result = await useCases.updateSshKey(key);
    result.fold(
      onSuccess: (_) => ref.invalidateSelf(),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> deleteSshKey(String id) async {
    final useCases = ref.read(sshKeyUseCasesProvider);
    final result = await useCases.deleteSshKey(id);
    result.fold(
      onSuccess: (_) => ref.invalidateSelf(),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final sshKeyDetailProvider =
    FutureProvider.family<SshKeyEntity, String>((ref, id) async {
  final useCases = ref.watch(sshKeyUseCasesProvider);
  final result = await useCases.getSshKey(id);
  return result.fold(
    onSuccess: (key) => key,
    onFailure: (failure) => throw Exception(failure.message),
  );
});
