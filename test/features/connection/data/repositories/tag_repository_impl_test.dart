import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/storage/database.dart';
import 'package:shellvault/features/connection/data/datasources/server_dao.dart';
import 'package:shellvault/features/connection/data/datasources/tag_dao.dart';
import 'package:shellvault/features/connection/data/repositories/tag_repository_impl.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';

class MockTagDao extends Mock implements TagDao {}

class MockServerDao extends Mock implements ServerDao {}

class MockUuid extends Mock implements Uuid {}

void main() {
  late MockTagDao mockTagDao;
  late MockServerDao mockServerDao;
  late MockUuid mockUuid;
  late TagRepositoryImpl sut;

  final now = DateTime(2026, 1, 1);

  final driftTag = Tag(
    id: 't1',
    name: 'Production',
    color: 0xFF42A5F5,
    createdAt: now,
    updatedAt: now,
  );

  final driftTag2 = Tag(
    id: 't2',
    name: 'Critical',
    color: 0xFFEF5350,
    createdAt: now,
    updatedAt: now,
  );

  final validEntity = TagEntity(
    id: 't1',
    name: 'Production',
    color: 0xFF42A5F5,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockTagDao = MockTagDao();
    mockServerDao = MockServerDao();
    mockUuid = MockUuid();
    sut = TagRepositoryImpl(mockTagDao, mockServerDao, uuid: mockUuid);
  });

  setUpAll(() {
    registerFallbackValue(const TagsCompanion());
  });

  group('getTags', () {
    test('returns list of TagEntity on success', () async {
      when(
        () => mockTagDao.getAllTags(),
      ).thenAnswer((_) async => [driftTag, driftTag2]);

      final result = await sut.getTags();

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(2));
      expect(result.value[0].name, 'Production');
      expect(result.value[1].name, 'Critical');
      verify(() => mockTagDao.getAllTags()).called(1);
    });

    test('returns empty list when no tags exist', () async {
      when(() => mockTagDao.getAllTags()).thenAnswer((_) async => []);

      final result = await sut.getTags();

      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });

    test('returns DatabaseFailure on exception', () async {
      when(() => mockTagDao.getAllTags()).thenThrow(Exception('db error'));

      final result = await sut.getTags();

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to load tags');
    });
  });

  group('getTag', () {
    test('returns TagEntity when found', () async {
      when(() => mockTagDao.getTagById('t1')).thenAnswer((_) async => driftTag);

      final result = await sut.getTag('t1');

      expect(result.isSuccess, isTrue);
      expect(result.value.id, 't1');
      expect(result.value.name, 'Production');
      expect(result.value.color, 0xFF42A5F5);
    });

    test('returns NotFoundFailure when tag does not exist', () async {
      when(
        () => mockTagDao.getTagById('missing'),
      ).thenAnswer((_) async => null);

      final result = await sut.getTag('missing');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<NotFoundFailure>());
      expect(result.failure.message, 'Tag not found: missing');
    });

    test('returns DatabaseFailure on exception', () async {
      when(() => mockTagDao.getTagById('t1')).thenThrow(Exception('db error'));

      final result = await sut.getTag('t1');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to load tag');
    });
  });

  group('createTag', () {
    test('creates tag with generated UUID and timestamps', () async {
      when(() => mockUuid.v4()).thenReturn('generated-uuid');
      when(() => mockTagDao.insertTag(any())).thenAnswer((_) async => 1);

      final result = await sut.createTag(validEntity);

      expect(result.isSuccess, isTrue);
      expect(result.value.id, 'generated-uuid');
      expect(result.value.name, 'Production');
      verify(() => mockUuid.v4()).called(1);
      verify(() => mockTagDao.insertTag(any())).called(1);
    });

    test('returns DatabaseFailure when insert fails', () async {
      when(() => mockUuid.v4()).thenReturn('generated-uuid');
      when(
        () => mockTagDao.insertTag(any()),
      ).thenThrow(Exception('insert error'));

      final result = await sut.createTag(validEntity);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to create tag');
    });
  });

  group('updateTag', () {
    test('updates tag and returns updated entity', () async {
      when(() => mockTagDao.updateTag(any())).thenAnswer((_) async => true);

      final result = await sut.updateTag(validEntity);

      expect(result.isSuccess, isTrue);
      expect(result.value.name, 'Production');
      verify(() => mockTagDao.updateTag(any())).called(1);
    });

    test('returns DatabaseFailure when update fails', () async {
      when(
        () => mockTagDao.updateTag(any()),
      ).thenThrow(Exception('update error'));

      final result = await sut.updateTag(validEntity);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to update tag');
    });
  });

  group('deleteTag', () {
    test('deletes tag by ID', () async {
      when(() => mockTagDao.deleteTagById('t1')).thenAnswer((_) async => 1);

      final result = await sut.deleteTag('t1');

      expect(result.isSuccess, isTrue);
      verify(() => mockTagDao.deleteTagById('t1')).called(1);
    });

    test('returns DatabaseFailure when delete fails', () async {
      when(
        () => mockTagDao.deleteTagById('t1'),
      ).thenThrow(Exception('delete error'));

      final result = await sut.deleteTag('t1');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to delete tag');
    });
  });

  group('getTagsForServer', () {
    test('returns tags for a server', () async {
      when(
        () => mockServerDao.getTagsForServer('server-1'),
      ).thenAnswer((_) async => [driftTag, driftTag2]);

      final result = await sut.getTagsForServer('server-1');

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(2));
      expect(result.value[0].name, 'Production');
      expect(result.value[1].name, 'Critical');
      verify(() => mockServerDao.getTagsForServer('server-1')).called(1);
    });

    test('returns empty list when server has no tags', () async {
      when(
        () => mockServerDao.getTagsForServer('server-1'),
      ).thenAnswer((_) async => []);

      final result = await sut.getTagsForServer('server-1');

      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });

    test('returns DatabaseFailure on exception', () async {
      when(
        () => mockServerDao.getTagsForServer('server-1'),
      ).thenThrow(Exception('db error'));

      final result = await sut.getTagsForServer('server-1');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to load server tags');
    });
  });

  group('setServerTags', () {
    test('sets tags for a server', () async {
      when(
        () => mockServerDao.setServerTags('server-1', ['t1', 't2']),
      ).thenAnswer((_) async {});

      final result = await sut.setServerTags('server-1', ['t1', 't2']);

      expect(result.isSuccess, isTrue);
      verify(
        () => mockServerDao.setServerTags('server-1', ['t1', 't2']),
      ).called(1);
    });

    test('sets empty tag list', () async {
      when(
        () => mockServerDao.setServerTags('server-1', []),
      ).thenAnswer((_) async {});

      final result = await sut.setServerTags('server-1', []);

      expect(result.isSuccess, isTrue);
      verify(() => mockServerDao.setServerTags('server-1', [])).called(1);
    });

    test('returns DatabaseFailure on exception', () async {
      when(
        () => mockServerDao.setServerTags('server-1', ['t1']),
      ).thenThrow(Exception('db error'));

      final result = await sut.setServerTags('server-1', ['t1']);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to set server tags');
    });
  });
}
