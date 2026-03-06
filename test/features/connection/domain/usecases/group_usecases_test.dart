import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/connection/domain/entities/group_entity.dart';
import 'package:sshvault/features/connection/domain/repositories/group_repository.dart';
import 'package:sshvault/features/connection/domain/usecases/group_usecases.dart';

class MockGroupRepository extends Mock implements GroupRepository {}

void main() {
  late MockGroupRepository mockRepo;
  late GroupUseCases sut;

  final now = DateTime.now();

  final validGroup = GroupEntity(
    id: '1',
    name: 'Production',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepo = MockGroupRepository();
    sut = GroupUseCases(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(validGroup);
  });

  group('GroupUseCases', () {
    test('getGroups delegates to repository', () async {
      when(
        () => mockRepo.getGroups(),
      ).thenAnswer((_) async => Success([validGroup]));

      final result = await sut.getGroups();

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
      verify(() => mockRepo.getGroups()).called(1);
    });

    test('createGroup rejects empty name', () async {
      final invalid = validGroup.copyWith(name: '');

      final result = await sut.createGroup(invalid);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(() => mockRepo.createGroup(any()));
    });

    test('createGroup rejects whitespace-only name', () async {
      final invalid = validGroup.copyWith(name: '   ');

      final result = await sut.createGroup(invalid);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('createGroup succeeds with valid name', () async {
      when(
        () => mockRepo.createGroup(any()),
      ).thenAnswer((_) async => Success(validGroup));

      final result = await sut.createGroup(validGroup);

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.createGroup(any())).called(1);
    });

    test('updateGroup validates name', () async {
      final invalid = validGroup.copyWith(name: '');

      final result = await sut.updateGroup(invalid);

      expect(result.isFailure, isTrue);
      verifyNever(() => mockRepo.updateGroup(any()));
    });

    test('deleteGroup delegates to repository', () async {
      when(
        () => mockRepo.deleteGroup('1'),
      ).thenAnswer((_) async => const Success(null));

      final result = await sut.deleteGroup('1');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.deleteGroup('1')).called(1);
    });

    test('getGroupTree delegates to repository', () async {
      when(
        () => mockRepo.getGroupTree(),
      ).thenAnswer((_) async => Success([validGroup]));

      final result = await sut.getGroupTree();

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.getGroupTree()).called(1);
    });
  });
}
