import 'package:uuid/uuid.dart';
import 'package:shellvault/core/crypto/field_crypto_service.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/data/models/tag_mapper.dart';
import 'package:shellvault/features/snippet/data/datasources/snippet_dao.dart';
import 'package:shellvault/features/snippet/data/models/snippet_mapper.dart';
import 'package:shellvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:shellvault/features/snippet/domain/repositories/snippet_repository.dart';

class SnippetRepositoryImpl implements SnippetRepository {
  final SnippetDao _snippetDao;
  final Uuid _uuid;
  final FieldCryptoService? _crypto;

  SnippetRepositoryImpl(this._snippetDao, {FieldCryptoService? crypto, Uuid? uuid})
      : _crypto = crypto,
        _uuid = uuid ?? const Uuid();

  Future<SnippetEntity> _enrichWithRelations(SnippetEntity snippet) async {
    final tags = await _snippetDao.getTagsForSnippet(snippet.id);
    final variables = await _snippetDao.getVariablesForSnippet(snippet.id);
    return snippet.copyWith(
      tags: tags.map((t) => TagMapper.fromDrift(t, crypto: _crypto)).toList(),
      variables: variables.map((v) => SnippetMapper.variableFromDrift(v, crypto: _crypto)).toList(),
    );
  }

  @override
  Future<Result<List<SnippetEntity>>> getSnippets() async {
    try {
      final rows = await _snippetDao.getAllSnippets();
      final snippets = <SnippetEntity>[];
      for (final row in rows) {
        snippets.add(await _enrichWithRelations(SnippetMapper.fromDrift(row, crypto: _crypto)));
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
      final snippet =
          await _enrichWithRelations(SnippetMapper.fromDrift(row, crypto: _crypto));
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
        snippets.add(await _enrichWithRelations(SnippetMapper.fromDrift(row, crypto: _crypto)));
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
      // When encryption is active, load all and filter in memory
      final bool hasSearch = searchQuery != null && searchQuery.isNotEmpty;
      final useInMemorySearch = _crypto != null && hasSearch;

      final rows = await _snippetDao.getFilteredSnippets(
        searchQuery: useInMemorySearch ? null : searchQuery,
        groupId: groupId,
        tagIds: tagIds,
        language: _crypto != null ? null : language,
      );

      var snippets = <SnippetEntity>[];
      for (final row in rows) {
        snippets.add(await _enrichWithRelations(SnippetMapper.fromDrift(row, crypto: _crypto)));
      }

      // In-memory search on decrypted data
      if (useInMemorySearch) {
        final query = searchQuery.toLowerCase();
        snippets = snippets.where((s) =>
          s.name.toLowerCase().contains(query) ||
          s.content.toLowerCase().contains(query) ||
          s.description.toLowerCase().contains(query)
        ).toList();
      }

      // In-memory language filter on decrypted data
      if (_crypto != null && language != null && language.isNotEmpty) {
        snippets = snippets.where((s) => s.language == language).toList();
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
      await _snippetDao.insertSnippet(SnippetMapper.toCompanion(newSnippet, crypto: _crypto));

      // Set tags
      final tagIds = snippet.tags.map((t) => t.id).toList();
      if (tagIds.isNotEmpty) {
        await _snippetDao.setSnippetTags(newSnippet.id, tagIds);
      }

      // Set variables
      if (snippet.variables.isNotEmpty) {
        final varCompanions = snippet.variables
            .map((v) => SnippetMapper.variableToCompanion(
                  v.copyWith(id: _uuid.v4()),
                  newSnippet.id,
                  crypto: _crypto,
                ))
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
      await _snippetDao.updateSnippet(SnippetMapper.toCompanion(updated, crypto: _crypto));

      // Update tags
      final tagIds = snippet.tags.map((t) => t.id).toList();
      await _snippetDao.setSnippetTags(snippet.id, tagIds);

      // Update variables
      final varCompanions = snippet.variables.map((v) {
        final varId = v.id.isEmpty ? _uuid.v4() : v.id;
        return SnippetMapper.variableToCompanion(
          v.copyWith(id: varId),
          snippet.id,
          crypto: _crypto,
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
