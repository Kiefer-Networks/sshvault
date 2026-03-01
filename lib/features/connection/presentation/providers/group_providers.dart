import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/presentation/providers/repository_providers.dart';

final groupListProvider =
    AsyncNotifierProvider<GroupListNotifier, List<GroupEntity>>(
  GroupListNotifier.new,
);

class GroupListNotifier extends AsyncNotifier<List<GroupEntity>> {
  @override
  Future<List<GroupEntity>> build() async {
    final useCases = ref.watch(groupUseCasesProvider);
    final result = await useCases.getGroups();
    return result.fold(
      onSuccess: (groups) => groups,
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> createGroup(GroupEntity group) async {
    final useCases = ref.read(groupUseCasesProvider);
    final result = await useCases.createGroup(group);
    result.fold(
      onSuccess: (_) => ref.invalidateSelf(),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> updateGroup(GroupEntity group) async {
    final useCases = ref.read(groupUseCasesProvider);
    final result = await useCases.updateGroup(group);
    result.fold(
      onSuccess: (_) => ref.invalidateSelf(),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }

  Future<void> deleteGroup(String id) async {
    final useCases = ref.read(groupUseCasesProvider);
    final result = await useCases.deleteGroup(id);
    result.fold(
      onSuccess: (_) => ref.invalidateSelf(),
      onFailure: (failure) => throw Exception(failure.message),
    );
  }
}

final groupTreeProvider =
    FutureProvider<List<GroupEntity>>((ref) async {
  final useCases = ref.watch(groupUseCasesProvider);
  final result = await useCases.getGroupTree();
  return result.fold(
    onSuccess: (tree) => tree,
    onFailure: (failure) => throw Exception(failure.message),
  );
});
