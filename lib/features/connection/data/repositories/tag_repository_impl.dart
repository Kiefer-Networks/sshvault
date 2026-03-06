import 'package:uuid/uuid.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/connection/data/datasources/server_dao.dart';
import 'package:sshvault/features/connection/data/datasources/tag_dao.dart';
import 'package:sshvault/features/connection/data/models/tag_mapper.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';
import 'package:sshvault/features/connection/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final TagDao _tagDao;
  final ServerDao _serverDao;
  final Uuid _uuid;

  TagRepositoryImpl(this._tagDao, this._serverDao, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  @override
  Future<Result<List<TagEntity>>> getTags() async {
    try {
      final rows = await _tagDao.getAllTags();
      return Success(rows.map((r) => TagMapper.fromDrift(r)).toList());
    } catch (e) {
      return Err(DatabaseFailure('Failed to load tags', cause: e));
    }
  }

  @override
  Future<Result<TagEntity>> getTag(String id) async {
    try {
      final row = await _tagDao.getTagById(id);
      if (row == null) {
        return Err(NotFoundFailure('Tag not found: $id'));
      }
      return Success(TagMapper.fromDrift(row));
    } catch (e) {
      return Err(DatabaseFailure('Failed to load tag', cause: e));
    }
  }

  @override
  Future<Result<TagEntity>> createTag(TagEntity tag) async {
    try {
      final now = DateTime.now();
      final newTag = tag.copyWith(
        id: _uuid.v4(),
        createdAt: now,
        updatedAt: now,
      );
      await _tagDao.insertTag(TagMapper.toCompanion(newTag));
      return Success(newTag);
    } catch (e) {
      return Err(DatabaseFailure('Failed to create tag', cause: e));
    }
  }

  @override
  Future<Result<TagEntity>> updateTag(TagEntity tag) async {
    try {
      final updated = tag.copyWith(updatedAt: DateTime.now());
      await _tagDao.updateTag(TagMapper.toCompanion(updated));
      return Success(updated);
    } catch (e) {
      return Err(DatabaseFailure('Failed to update tag', cause: e));
    }
  }

  @override
  Future<Result<void>> deleteTag(String id) async {
    try {
      await _tagDao.deleteTagById(id);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete tag', cause: e));
    }
  }

  @override
  Future<Result<List<TagEntity>>> getTagsForServer(String serverId) async {
    try {
      final rows = await _serverDao.getTagsForServer(serverId);
      return Success(rows.map((r) => TagMapper.fromDrift(r)).toList());
    } catch (e) {
      return Err(DatabaseFailure('Failed to load server tags', cause: e));
    }
  }

  @override
  Future<Result<void>> setServerTags(
    String serverId,
    List<String> tagIds,
  ) async {
    try {
      await _serverDao.setServerTags(serverId, tagIds);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to set server tags', cause: e));
    }
  }
}
