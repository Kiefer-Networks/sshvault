import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/snippet/domain/entities/snippet_entity.dart';
import 'package:sshvault/features/snippet/domain/repositories/snippet_repository.dart';
import 'package:sshvault/features/snippet/domain/usecases/snippet_usecases.dart';

class MockSnippetRepository extends Mock implements SnippetRepository {}

void main() {
  late MockSnippetRepository mockRepo;
  late SnippetUseCases sut;

  final now = DateTime.now();

  final validSnippet = SnippetEntity(
    id: '1',
    name: 'Deploy Script',
    content: 'ssh deploy@prod "cd /app && git pull"',
    language: 'bash',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepo = MockSnippetRepository();
    sut = SnippetUseCases(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(validSnippet);
  });

  group('SnippetUseCases', () {
    test('getSnippets delegates to repository', () async {
      when(
        () => mockRepo.getSnippets(),
      ).thenAnswer((_) async => Success([validSnippet]));

      final result = await sut.getSnippets();

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
      verify(() => mockRepo.getSnippets()).called(1);
    });

    test('createSnippet rejects empty name', () async {
      final invalid = validSnippet.copyWith(name: '');

      final result = await sut.createSnippet(invalid);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(() => mockRepo.createSnippet(any()));
    });

    test('createSnippet rejects empty content', () async {
      final invalid = validSnippet.copyWith(content: '');

      final result = await sut.createSnippet(invalid);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('createSnippet succeeds with valid data', () async {
      when(
        () => mockRepo.createSnippet(any()),
      ).thenAnswer((_) async => Success(validSnippet));

      final result = await sut.createSnippet(validSnippet);

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.createSnippet(any())).called(1);
    });

    test('updateSnippet rejects empty name', () async {
      final invalid = validSnippet.copyWith(name: '');

      final result = await sut.updateSnippet(invalid);

      expect(result.isFailure, isTrue);
      verifyNever(() => mockRepo.updateSnippet(any()));
    });

    test('updateSnippet rejects empty content', () async {
      final invalid = validSnippet.copyWith(content: '   ');

      final result = await sut.updateSnippet(invalid);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('deleteSnippet delegates to repository', () async {
      when(
        () => mockRepo.deleteSnippet('1'),
      ).thenAnswer((_) async => const Success(null));

      final result = await sut.deleteSnippet('1');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.deleteSnippet('1')).called(1);
    });

    test('getSnippetsByGroupId delegates to repository', () async {
      when(
        () => mockRepo.getSnippetsByGroupId('g1'),
      ).thenAnswer((_) async => Success([validSnippet]));

      final result = await sut.getSnippetsByGroupId('g1');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.getSnippetsByGroupId('g1')).called(1);
    });
  });
}
