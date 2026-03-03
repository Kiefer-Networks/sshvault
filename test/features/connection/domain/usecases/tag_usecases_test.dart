import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/entities/tag_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/tag_repository.dart';
import 'package:shellvault/features/connection/domain/usecases/tag_usecases.dart';

class MockTagRepository extends Mock implements TagRepository {}

void main() {
  late MockTagRepository mockRepo;
  late TagUseCases sut;

  final now = DateTime.now();
  final validTag = TagEntity(
    id: '1',
    name: 'Production',
    color: 0xFF42A5F5,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepo = MockTagRepository();
    sut = TagUseCases(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(validTag);
  });

  group('getTags', () {
    test('delegates to repository', () async {
      when(() => mockRepo.getTags())
          .thenAnswer((_) async => Success([validTag]));

      final result = await sut.getTags();
      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
      verify(() => mockRepo.getTags()).called(1);
    });
  });

  group('getTag', () {
    test('delegates to repository', () async {
      when(() => mockRepo.getTag('1'))
          .thenAnswer((_) async => Success(validTag));

      final result = await sut.getTag('1');
      expect(result.isSuccess, isTrue);
      expect(result.value.name, 'Production');
    });
  });

  group('createTag', () {
    test('creates tag when name is valid', () async {
      when(() => mockRepo.createTag(any()))
          .thenAnswer((_) async => Success(validTag));

      final result = await sut.createTag(validTag);
      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.createTag(any())).called(1);
    });

    test('returns ValidationFailure when name is empty', () async {
      final invalidTag = validTag.copyWith(name: '');
      final result = await sut.createTag(invalidTag);
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(() => mockRepo.createTag(any()));
    });

    test('returns ValidationFailure when name is whitespace', () async {
      final invalidTag = validTag.copyWith(name: '   ');
      final result = await sut.createTag(invalidTag);
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });
  });

  group('updateTag', () {
    test('updates tag when name is valid', () async {
      when(() => mockRepo.updateTag(any()))
          .thenAnswer((_) async => Success(validTag));

      final result = await sut.updateTag(validTag);
      expect(result.isSuccess, isTrue);
    });

    test('returns ValidationFailure when name is empty', () async {
      final invalidTag = validTag.copyWith(name: '');
      final result = await sut.updateTag(invalidTag);
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(() => mockRepo.updateTag(any()));
    });
  });

  group('deleteTag', () {
    test('delegates to repository', () async {
      when(() => mockRepo.deleteTag('1'))
          .thenAnswer((_) async => const Success(null));

      final result = await sut.deleteTag('1');
      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.deleteTag('1')).called(1);
    });
  });

  group('getTagsForServer', () {
    test('delegates to repository', () async {
      when(() => mockRepo.getTagsForServer('server-1'))
          .thenAnswer((_) async => Success([validTag]));

      final result = await sut.getTagsForServer('server-1');
      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
    });
  });

  group('setServerTags', () {
    test('delegates to repository', () async {
      when(() => mockRepo.setServerTags('server-1', ['tag-1', 'tag-2']))
          .thenAnswer((_) async => const Success(null));

      final result = await sut.setServerTags('server-1', ['tag-1', 'tag-2']);
      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.setServerTags('server-1', ['tag-1', 'tag-2']))
          .called(1);
    });
  });
}
