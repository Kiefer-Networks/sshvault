import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';
import 'package:shellvault/features/connection/domain/entities/server_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/server_repository.dart';
import 'package:shellvault/features/connection/domain/usecases/server_usecases.dart';

class MockServerRepository extends Mock implements ServerRepository {}

void main() {
  late MockServerRepository mockRepo;
  late ServerUseCases sut;

  final now = DateTime.now();

  final validServer = ServerEntity(
    id: '1',
    name: 'Production',
    hostname: 'prod.example.com',
    port: 22,
    username: 'deploy',
    authMethod: AuthMethod.key,
    color: 0xFF42A5F5,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepo = MockServerRepository();
    sut = ServerUseCases(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(validServer);
  });

  group('ServerUseCases', () {
    test('getServers delegates to repository', () async {
      when(() => mockRepo.getServers())
          .thenAnswer((_) async => Success([validServer]));

      final result = await sut.getServers();

      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
      verify(() => mockRepo.getServers()).called(1);
    });

    test('createServer validates empty name', () async {
      final invalid = validServer.copyWith(name: '');

      final result = await sut.createServer(invalid, null);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(() => mockRepo.createServer(any(), any()));
    });

    test('createServer validates empty hostname', () async {
      final invalid = validServer.copyWith(hostname: '');

      final result = await sut.createServer(invalid, null);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('createServer validates invalid port', () async {
      final invalid = validServer.copyWith(port: 0);

      final result = await sut.createServer(invalid, null);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('createServer validates empty username', () async {
      final invalid = validServer.copyWith(username: '');

      final result = await sut.createServer(invalid, null);

      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('createServer succeeds with valid data', () async {
      when(() => mockRepo.createServer(any(), any()))
          .thenAnswer((_) async => Success(validServer));

      final result = await sut.createServer(validServer, null);

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.createServer(any(), any())).called(1);
    });

    test('updateServer validates input', () async {
      final invalid = validServer.copyWith(name: '');

      final result = await sut.updateServer(invalid, null);

      expect(result.isFailure, isTrue);
      verifyNever(() => mockRepo.updateServer(any(), any()));
    });

    test('deleteServer delegates to repository', () async {
      when(() => mockRepo.deleteServer('1'))
          .thenAnswer((_) async => const Success(null));

      final result = await sut.deleteServer('1');

      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.deleteServer('1')).called(1);
    });
  });
}
