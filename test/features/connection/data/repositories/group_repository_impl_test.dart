import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/storage/database.dart';
import 'package:sshvault/features/connection/data/datasources/group_dao.dart';
import 'package:sshvault/features/connection/data/repositories/group_repository_impl.dart';
import 'package:sshvault/features/connection/domain/entities/group_entity.dart';

class MockGroupDao extends Mock implements GroupDao {}

class MockUuid extends Mock implements Uuid {}

void main() {
  late MockGroupDao mockDao;
  late MockUuid mockUuid;
  late GroupRepositoryImpl sut;

  final now = DateTime(2026, 1, 1);

  final driftGroup = Group(
    id: 'g1',
    name: 'Production',
    color: 0xFF6C63FF,
    iconName: 'server',
    sortOrder: 0,
    createdAt: now,
    updatedAt: now,
  );

  final driftGroupChild = Group(
    id: 'g2',
    name: 'Web Servers',
    color: 0xFF42A5F5,
    iconName: 'web',
    parentId: 'g1',
    sortOrder: 1,
    createdAt: now,
    updatedAt: now,
  );

  final validEntity = GroupEntity(
    id: 'g1',
    name: 'Production',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockDao = MockGroupDao();
    mockUuid = MockUuid();
    sut = GroupRepositoryImpl(mockDao, uuid: mockUuid);
  });

  setUpAll(() {
    registerFallbackValue(const GroupsCompanion());
  });

  group('getGroups', () {
    test('returns list of GroupEntity on success', () async {
      when(() => mockDao.getAllGroups()).thenAnswer((_) async => [driftGroup]);
      when(
        () => mockDao.getServerCountForGroup('g1'),
      ).thenAnswer((_) async => 3);

      final result = await sut.getGroups();

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
      expect(result.value[0].name, 'Production');
      expect(result.value[0].serverCount, 3);
      verify(() => mockDao.getAllGroups()).called(1);
      verify(() => mockDao.getServerCountForGroup('g1')).called(1);
    });

    test('returns empty list when no groups exist', () async {
      when(() => mockDao.getAllGroups()).thenAnswer((_) async => []);

      final result = await sut.getGroups();

      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });

    test('returns DatabaseFailure on exception', () async {
      when(() => mockDao.getAllGroups()).thenThrow(Exception('db error'));

      final result = await sut.getGroups();

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to load groups');
    });
  });

  group('getGroup', () {
    test('returns GroupEntity when found', () async {
      when(
        () => mockDao.getGroupById('g1'),
      ).thenAnswer((_) async => driftGroup);
      when(
        () => mockDao.getServerCountForGroup('g1'),
      ).thenAnswer((_) async => 5);

      final result = await sut.getGroup('g1');

      expect(result.isSuccess, isTrue);
      expect(result.value.id, 'g1');
      expect(result.value.name, 'Production');
      expect(result.value.serverCount, 5);
    });

    test('returns NotFoundFailure when group does not exist', () async {
      when(() => mockDao.getGroupById('missing')).thenAnswer((_) async => null);

      final result = await sut.getGroup('missing');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<NotFoundFailure>());
      expect(result.failure.message, 'Group not found: missing');
    });

    test('returns DatabaseFailure on exception', () async {
      when(() => mockDao.getGroupById('g1')).thenThrow(Exception('db error'));

      final result = await sut.getGroup('g1');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to load group');
    });
  });

  group('createGroup', () {
    test('creates group with generated UUID and timestamps', () async {
      when(() => mockUuid.v4()).thenReturn('generated-uuid');
      when(() => mockDao.insertGroup(any())).thenAnswer((_) async => 1);

      final result = await sut.createGroup(validEntity);

      expect(result.isSuccess, isTrue);
      expect(result.value.id, 'generated-uuid');
      expect(result.value.name, 'Production');
      verify(() => mockUuid.v4()).called(1);
      verify(() => mockDao.insertGroup(any())).called(1);
    });

    test('returns DatabaseFailure when insert fails', () async {
      when(() => mockUuid.v4()).thenReturn('generated-uuid');
      when(
        () => mockDao.insertGroup(any()),
      ).thenThrow(Exception('insert error'));

      final result = await sut.createGroup(validEntity);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to create group');
    });
  });

  group('updateGroup', () {
    test('updates group and returns updated entity', () async {
      when(() => mockDao.updateGroup(any())).thenAnswer((_) async => true);

      final result = await sut.updateGroup(validEntity);

      expect(result.isSuccess, isTrue);
      expect(result.value.name, 'Production');
      verify(() => mockDao.updateGroup(any())).called(1);
    });

    test('returns DatabaseFailure when update fails', () async {
      when(
        () => mockDao.updateGroup(any()),
      ).thenThrow(Exception('update error'));

      final result = await sut.updateGroup(validEntity);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to update group');
    });
  });

  group('deleteGroup', () {
    test('deletes group by ID', () async {
      when(() => mockDao.deleteGroupById('g1')).thenAnswer((_) async => 1);

      final result = await sut.deleteGroup('g1');

      expect(result.isSuccess, isTrue);
      verify(() => mockDao.deleteGroupById('g1')).called(1);
    });

    test('returns DatabaseFailure when delete fails', () async {
      when(
        () => mockDao.deleteGroupById('g1'),
      ).thenThrow(Exception('delete error'));

      final result = await sut.deleteGroup('g1');

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to delete group');
    });
  });

  group('getGroupTree', () {
    test('returns tree structure with root and child groups', () async {
      when(
        () => mockDao.getAllGroups(),
      ).thenAnswer((_) async => [driftGroup, driftGroupChild]);
      when(
        () => mockDao.getServerCountForGroup('g1'),
      ).thenAnswer((_) async => 2);
      when(
        () => mockDao.getServerCountForGroup('g2'),
      ).thenAnswer((_) async => 1);

      final result = await sut.getGroupTree();

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
      expect(result.value[0].name, 'Production');
      expect(result.value[0].children, hasLength(1));
      expect(result.value[0].children[0].name, 'Web Servers');
    });

    test('returns empty list when no groups exist', () async {
      when(() => mockDao.getAllGroups()).thenAnswer((_) async => []);

      final result = await sut.getGroupTree();

      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });

    test('returns multiple root groups', () async {
      final secondRoot = Group(
        id: 'g3',
        name: 'Staging',
        color: 0xFF6C63FF,
        iconName: 'server',
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
      );

      when(
        () => mockDao.getAllGroups(),
      ).thenAnswer((_) async => [driftGroup, secondRoot]);
      when(
        () => mockDao.getServerCountForGroup('g1'),
      ).thenAnswer((_) async => 0);
      when(
        () => mockDao.getServerCountForGroup('g3'),
      ).thenAnswer((_) async => 0);

      final result = await sut.getGroupTree();

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(2));
      expect(result.value[0].name, 'Production');
      expect(result.value[1].name, 'Staging');
    });

    test('returns DatabaseFailure on exception', () async {
      when(() => mockDao.getAllGroups()).thenThrow(Exception('db error'));

      final result = await sut.getGroupTree();

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<DatabaseFailure>());
      expect(result.failure.message, 'Failed to load group tree');
    });
  });
}
