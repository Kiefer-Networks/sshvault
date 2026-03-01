import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/core/utils/validators.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:shellvault/features/snippet/domain/repositories/snippet_repository.dart';

class SnippetUseCases {
  final SnippetRepository _repository;

  SnippetUseCases(this._repository);

  Future<Result<List<SnippetEntity>>> getSnippets() {
    return _repository.getSnippets();
  }

  Future<Result<SnippetEntity>> getSnippet(String id) {
    return _repository.getSnippet(id);
  }

  Future<Result<List<SnippetEntity>>> getSnippetsByGroupId(String groupId) {
    return _repository.getSnippetsByGroupId(groupId);
  }

  Future<Result<List<SnippetEntity>>> getFilteredSnippets({
    String? searchQuery,
    String? groupId,
    List<String>? tagIds,
    String? language,
  }) {
    return _repository.getFilteredSnippets(
      searchQuery: searchQuery,
      groupId: groupId,
      tagIds: tagIds,
      language: language,
    );
  }

  Future<Result<SnippetEntity>> createSnippet(SnippetEntity snippet) {
    final nameValidation =
        Validators.validateRequired(snippet.name, 'Snippet name');
    if (nameValidation != null) {
      return Future.value(Err(ValidationFailure(nameValidation)));
    }
    final contentValidation =
        Validators.validateRequired(snippet.content, 'Snippet content');
    if (contentValidation != null) {
      return Future.value(Err(ValidationFailure(contentValidation)));
    }
    return _repository.createSnippet(snippet);
  }

  Future<Result<SnippetEntity>> updateSnippet(SnippetEntity snippet) {
    final nameValidation =
        Validators.validateRequired(snippet.name, 'Snippet name');
    if (nameValidation != null) {
      return Future.value(Err(ValidationFailure(nameValidation)));
    }
    final contentValidation =
        Validators.validateRequired(snippet.content, 'Snippet content');
    if (contentValidation != null) {
      return Future.value(Err(ValidationFailure(contentValidation)));
    }
    return _repository.updateSnippet(snippet);
  }

  Future<Result<void>> deleteSnippet(String id) {
    return _repository.deleteSnippet(id);
  }
}
