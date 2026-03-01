import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/utils/validators.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/tag_repository.dart';

class TagUseCases {
  final TagRepository _repository;

  TagUseCases(this._repository);

  Future<Result<List<TagEntity>>> getTags() {
    return _repository.getTags();
  }

  Future<Result<TagEntity>> getTag(String id) {
    return _repository.getTag(id);
  }

  Future<Result<TagEntity>> createTag(TagEntity tag) {
    final validation = Validators.validateRequired(tag.name, 'Tag name');
    if (validation != null) {
      return Future.value(Err(ValidationFailure(validation)));
    }
    return _repository.createTag(tag);
  }

  Future<Result<TagEntity>> updateTag(TagEntity tag) {
    final validation = Validators.validateRequired(tag.name, 'Tag name');
    if (validation != null) {
      return Future.value(Err(ValidationFailure(validation)));
    }
    return _repository.updateTag(tag);
  }

  Future<Result<void>> deleteTag(String id) {
    return _repository.deleteTag(id);
  }

  Future<Result<List<TagEntity>>> getTagsForServer(String serverId) {
    return _repository.getTagsForServer(serverId);
  }

  Future<Result<void>> setServerTags(String serverId, List<String> tagIds) {
    return _repository.setServerTags(serverId, tagIds);
  }
}
