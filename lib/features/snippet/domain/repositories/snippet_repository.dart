import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';

abstract class SnippetRepository {
  Future<Result<List<SnippetEntity>>> getSnippets();
  Future<Result<SnippetEntity>> getSnippet(String id);
  Future<Result<List<SnippetEntity>>> getSnippetsByGroupId(String groupId);
  Future<Result<List<SnippetEntity>>> getFilteredSnippets({
    String? searchQuery,
    String? groupId,
    List<String>? tagIds,
    String? language,
  });
  Future<Result<SnippetEntity>> createSnippet(SnippetEntity snippet);
  Future<Result<SnippetEntity>> updateSnippet(SnippetEntity snippet);
  Future<Result<void>> deleteSnippet(String id);
}
