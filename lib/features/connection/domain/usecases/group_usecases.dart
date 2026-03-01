import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/utils/validators.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/group_repository.dart';

class GroupUseCases {
  final GroupRepository _repository;

  GroupUseCases(this._repository);

  Future<Result<List<GroupEntity>>> getGroups() {
    return _repository.getGroups();
  }

  Future<Result<GroupEntity>> getGroup(String id) {
    return _repository.getGroup(id);
  }

  Future<Result<GroupEntity>> createGroup(GroupEntity group) {
    final validation = Validators.validateRequired(group.name, 'Group name');
    if (validation != null) {
      return Future.value(Err(ValidationFailure(validation)));
    }
    return _repository.createGroup(group);
  }

  Future<Result<GroupEntity>> updateGroup(GroupEntity group) {
    final validation = Validators.validateRequired(group.name, 'Group name');
    if (validation != null) {
      return Future.value(Err(ValidationFailure(validation)));
    }
    return _repository.updateGroup(group);
  }

  Future<Result<void>> deleteGroup(String id) {
    return _repository.deleteGroup(id);
  }

  Future<Result<List<GroupEntity>>> getGroupTree() {
    return _repository.getGroupTree();
  }
}
