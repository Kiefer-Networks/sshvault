import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/connection/domain/entities/tag_entity.dart';

abstract class TagRepository {
  Future<Result<List<TagEntity>>> getTags();
  Future<Result<TagEntity>> getTag(String id);
  Future<Result<TagEntity>> createTag(TagEntity tag);
  Future<Result<TagEntity>> updateTag(TagEntity tag);
  Future<Result<void>> deleteTag(String id);
  Future<Result<List<TagEntity>>> getTagsForServer(String serverId);
  Future<Result<void>> setServerTags(String serverId, List<String> tagIds);
}
