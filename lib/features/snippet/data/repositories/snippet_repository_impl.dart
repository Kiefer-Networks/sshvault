import 'package:uuid/uuid.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/connection/data/models/tag_mapper.dart';
import 'package:sshvault/features/snippet/data/datasources/snippet_dao.dart';
import 'package:sshvault/features/snippet/data/models/snippet_mapper.dart';
import 'package:sshvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:sshvault/features/snippet/domain/repositories/snippet_repository.dart';

class SnippetRepositoryImpl implements SnippetRepository {
  final SnippetDao _snippetDao;
  final Uuid _uuid;

  SnippetRepositoryImpl(this._snippetDao, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  Future<SnippetEntity> _enrichWithRelations(SnippetEntity snippet) async {
    final tags = await _snippetDao.getTagsForSnippet(snippet.id);
    final variables = await _snippetDao.getVariablesForSnippet(snippet.id);
    return snippet.copyWith(
      tags: tags.map((t) => TagMapper.fromDrift(t)).toList(),
      variables: variables
          .map((v) => SnippetMapper.variableFromDrift(v))
          .toList(),
    );
  }

  @override
  Future<Result<List<SnippetEntity>>> getSnippets() async {
    try {
      final rows = await _snippetDao.getAllSnippets();
      final snippets = <SnippetEntity>[];
      for (final row in rows) {
        snippets.add(await _enrichWithRelations(SnippetMapper.fromDrift(row)));
      }
      return Success(snippets);
    } catch (e) {
      return Err(DatabaseFailure('Failed to load snippets', cause: e));
    }
  }

  @override
  Future<Result<SnippetEntity>> getSnippet(String id) async {
    try {
      final row = await _snippetDao.getSnippetById(id);
      if (row == null) {
        return Err(NotFoundFailure('Snippet not found: $id'));
      }
      final snippet = await _enrichWithRelations(SnippetMapper.fromDrift(row));
      return Success(snippet);
    } catch (e) {
      return Err(DatabaseFailure('Failed to load snippet', cause: e));
    }
  }

  @override
  Future<Result<List<SnippetEntity>>> getSnippetsByGroupId(
    String groupId,
  ) async {
    try {
      final rows = await _snippetDao.getSnippetsByGroupId(groupId);
      final snippets = <SnippetEntity>[];
      for (final row in rows) {
        snippets.add(await _enrichWithRelations(SnippetMapper.fromDrift(row)));
      }
      return Success(snippets);
    } catch (e) {
      return Err(DatabaseFailure('Failed to load snippets', cause: e));
    }
  }

  @override
  Future<Result<List<SnippetEntity>>> getFilteredSnippets({
    String? searchQuery,
    String? groupId,
    List<String>? tagIds,
    String? language,
  }) async {
    try {
      final rows = await _snippetDao.getFilteredSnippets(
        searchQuery: searchQuery,
        groupId: groupId,
        tagIds: tagIds,
        language: language,
      );

      var snippets = <SnippetEntity>[];
      for (final row in rows) {
        snippets.add(await _enrichWithRelations(SnippetMapper.fromDrift(row)));
      }

      return Success(snippets);
    } catch (e) {
      return Err(DatabaseFailure('Failed to filter snippets', cause: e));
    }
  }

  @override
  Future<Result<SnippetEntity>> createSnippet(SnippetEntity snippet) async {
    try {
      final now = DateTime.now();
      final newSnippet = snippet.copyWith(
        id: _uuid.v4(),
        createdAt: now,
        updatedAt: now,
      );
      await _snippetDao.insertSnippet(SnippetMapper.toCompanion(newSnippet));

      // Set tags
      final tagIds = snippet.tags.map((t) => t.id).toList();
      if (tagIds.isNotEmpty) {
        await _snippetDao.setSnippetTags(newSnippet.id, tagIds);
      }

      // Set variables
      if (snippet.variables.isNotEmpty) {
        final varCompanions = snippet.variables
            .map(
              (v) => SnippetMapper.variableToCompanion(
                v.copyWith(id: _uuid.v4()),
                newSnippet.id,
              ),
            )
            .toList();
        await _snippetDao.setSnippetVariables(newSnippet.id, varCompanions);
      }

      return getSnippet(newSnippet.id);
    } catch (e) {
      return Err(DatabaseFailure('Failed to create snippet', cause: e));
    }
  }

  @override
  Future<Result<SnippetEntity>> updateSnippet(SnippetEntity snippet) async {
    try {
      final updated = snippet.copyWith(updatedAt: DateTime.now());
      await _snippetDao.updateSnippet(SnippetMapper.toCompanion(updated));

      // Update tags
      final tagIds = snippet.tags.map((t) => t.id).toList();
      await _snippetDao.setSnippetTags(snippet.id, tagIds);

      // Update variables
      final varCompanions = snippet.variables.map((v) {
        final varId = v.id.isEmpty ? _uuid.v4() : v.id;
        return SnippetMapper.variableToCompanion(
          v.copyWith(id: varId),
          snippet.id,
        );
      }).toList();
      await _snippetDao.setSnippetVariables(snippet.id, varCompanions);

      return getSnippet(snippet.id);
    } catch (e) {
      return Err(DatabaseFailure('Failed to update snippet', cause: e));
    }
  }

  @override
  Future<Result<void>> deleteSnippet(String id) async {
    try {
      await _snippetDao.deleteSnippetById(id);
      return const Success(null);
    } catch (e) {
      return Err(DatabaseFailure('Failed to delete snippet', cause: e));
    }
  }
}
