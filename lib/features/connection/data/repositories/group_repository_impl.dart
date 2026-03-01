import 'package:uuid/uuid.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/data/datasources/group_dao.dart';
import 'package:shellvault/features/connection/data/models/group_mapper.dart';
import 'package:shellvault/features/connection/domain/entities/group_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/group_repository.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupDao _groupDao;
  final Uuid _uuid;

  GroupRepositoryImpl(this._groupDao, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  @override
  Future<Result<List<GroupEntity>>> getGroups() async {
    try {
      final rows = await _groupDao.getAllGroups();
      final entities = <GroupEntity>[];
      for (final row in rows) {
        final count = await _groupDao.getServerCountForGroup(row.id);
        entities.add(GroupMapper.fromDrift(row, serverCount: count));
      }
      return Success(entities);
    } catch (e) {
      return Err(DatabaseFailure('Failed to load groups', cause: e));
    }
  }

  @override
  Future<Result<GroupEntity>> getGroup(String id) async {
    try {
      final row = await _groupDao.getGroupById(id);
      if (row == null) {
        return Err(NotFoundFailure('Group not found: $id'));
      }
      final count = await _groupDao.getServerCountForGroup(id);
      return Success(GroupMapper.fromDrift(row, serverCount: count));
    } catch (e) {
      return Err(DatabaseFailure('Failed to load group', cause: e));
    }
  }

  @override
  Future<Result<GroupEntity>> createGroup(GroupEntity group) async {
    try {
      final now = DateTime.now();
      final newGroup = group.copyWith(
        id: _uuid.v4(),
        createdAt: now,
        updatedAt: now,
      );
      await _groupDao.insertGroup(GroupMapper.toCompanion(newGroup));
      return Success(newGroup);
    } catch (e) {
      return Err(DatabaseFailure('Failed to create group', cause: e));
    }
  }

  @override
  Future<Result<GroupEntity>> updateGroup(GroupEntity group) async {
    try {
      final updated = group.copyWith(updatedAt: DateTime.now());
      await _groupDao.updateGroup(GroupMapper.toCompanion(updated));
      return Success(updated);
    } catch (e) {
      return Err(DatabaseFailure('Failed to update group', cause: e));
    }
  }

  @override
  Future<Result<void>> deleteGroup(String id) async {
    try {
      await _groupDao.deleteGroupById(id);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete group', cause: e));
    }
  }

  @override
  Future<Result<List<GroupEntity>>> getGroupTree() async {
    try {
      final allRows = await _groupDao.getAllGroups();
      final allEntities = <GroupEntity>[];
      for (final row in allRows) {
        final count = await _groupDao.getServerCountForGroup(row.id);
        allEntities.add(GroupMapper.fromDrift(row, serverCount: count));
      }

      final rootGroups =
          allEntities.where((g) => g.parentId == null).toList();
      final tree = rootGroups
          .map((root) => _buildTree(root, allEntities))
          .toList();

      return Success(tree);
    } catch (e) {
      return Err(DatabaseFailure('Failed to load group tree', cause: e));
    }
  }

  GroupEntity _buildTree(GroupEntity parent, List<GroupEntity> all) {
    final children = all
        .where((g) => g.parentId == parent.id)
        .map((child) => _buildTree(child, all))
        .toList();
    return parent.copyWith(children: children);
  }
}
