import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';

abstract class GroupRepository {
  Future<Result<List<GroupEntity>>> getGroups();
  Future<Result<GroupEntity>> getGroup(String id);
  Future<Result<GroupEntity>> createGroup(GroupEntity group);
  Future<Result<GroupEntity>> updateGroup(GroupEntity group);
  Future<Result<void>> deleteGroup(String id);
  Future<Result<List<GroupEntity>>> getGroupTree();
}
