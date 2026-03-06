import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/utils/auto_sync_mixin.dart';
import 'package:sshvault/features/connection/domain/entities/group_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/repository_providers.dart';

final folderListProvider =
    AsyncNotifierProvider<FolderListNotifier, List<GroupEntity>>(
      FolderListNotifier.new,
    );

class FolderListNotifier extends AsyncNotifier<List<GroupEntity>>
    with AutoSyncMixin {
  @override
  Future<List<GroupEntity>> build() async {
    final useCases = ref.watch(folderUseCasesProvider);
    final result = await useCases.getGroups();
    return result.fold(
      onSuccess: (groups) => groups,
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> createFolder(GroupEntity folder) async {
    final useCases = ref.read(folderUseCasesProvider);
    final result = await useCases.createGroup(folder);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        ref.invalidate(folderTreeProvider);
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> updateFolder(GroupEntity folder) async {
    final useCases = ref.read(folderUseCasesProvider);
    final result = await useCases.updateGroup(folder);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        ref.invalidate(folderTreeProvider);
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }

  Future<void> deleteFolder(String id) async {
    final useCases = ref.read(folderUseCasesProvider);
    final result = await useCases.deleteGroup(id);
    result.fold(
      onSuccess: (_) {
        ref.invalidateSelf();
        ref.invalidate(folderTreeProvider);
        triggerAutoSync();
      },
      onFailure: (failure) => throw failure,
    );
  }
}

final folderTreeProvider = FutureProvider<List<GroupEntity>>((ref) async {
  final useCases = ref.watch(folderUseCasesProvider);
  final result = await useCases.getGroupTree();
  return result.fold(
    onSuccess: (tree) => tree,
    onFailure: (failure) => throw failure,
  );
});
