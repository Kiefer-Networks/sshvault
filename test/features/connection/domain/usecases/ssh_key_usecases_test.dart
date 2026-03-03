import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shellvault/core/crypto/ssh_key_type.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';
import 'package:shellvault/features/connection/domain/entities/ssh_key_entity.dart';
import 'package:shellvault/features/connection/domain/repositories/ssh_key_repository.dart';
import 'package:shellvault/features/connection/domain/usecases/ssh_key_usecases.dart';

class MockSshKeyRepository extends Mock implements SshKeyRepository {}

void main() {
  late MockSshKeyRepository mockRepo;
  late SshKeyUseCases sut;

  final now = DateTime.now();
  final validKey = SshKeyEntity(
    id: '1',
    name: 'My Key',
    keyType: SshKeyType.ed25519,
    fingerprint: 'SHA256:abc',
    publicKey: 'ssh-ed25519 AAAA...',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    mockRepo = MockSshKeyRepository();
    sut = SshKeyUseCases(mockRepo);
  });

  setUpAll(() {
    registerFallbackValue(validKey);
  });

  group('getAllSshKeys', () {
    test('delegates to repository', () async {
      when(
        () => mockRepo.getAllSshKeys(),
      ).thenAnswer((_) async => Success([validKey]));

      final result = await sut.getAllSshKeys();
      expect(result.isSuccess, isTrue);
      expect(result.value, hasLength(1));
      verify(() => mockRepo.getAllSshKeys()).called(1);
    });
  });

  group('getSshKey', () {
    test('delegates to repository', () async {
      when(
        () => mockRepo.getSshKey('1'),
      ).thenAnswer((_) async => Success(validKey));

      final result = await sut.getSshKey('1');
      expect(result.isSuccess, isTrue);
      expect(result.value.name, 'My Key');
    });
  });

  group('createSshKey', () {
    test('creates key when valid', () async {
      when(
        () => mockRepo.createSshKey(
          any(),
          privateKey: any(named: 'privateKey'),
          passphrase: any(named: 'passphrase'),
        ),
      ).thenAnswer((_) async => Success(validKey));

      final result = await sut.createSshKey(
        validKey,
        privateKey: '-----BEGIN OPENSSH PRIVATE KEY-----...',
      );
      expect(result.isSuccess, isTrue);
    });

    test('returns ValidationFailure when name is empty', () async {
      final invalidKey = validKey.copyWith(name: '');
      final result = await sut.createSshKey(invalidKey, privateKey: 'some-key');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(
        () => mockRepo.createSshKey(
          any(),
          privateKey: any(named: 'privateKey'),
          passphrase: any(named: 'passphrase'),
        ),
      );
    });

    test('returns ValidationFailure when name is whitespace', () async {
      final invalidKey = validKey.copyWith(name: '   ');
      final result = await sut.createSshKey(invalidKey, privateKey: 'some-key');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('returns ValidationFailure when private key is empty', () async {
      final result = await sut.createSshKey(validKey, privateKey: '');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('returns ValidationFailure when private key is whitespace', () async {
      final result = await sut.createSshKey(validKey, privateKey: '   ');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
    });

    test('passes passphrase to repository', () async {
      when(
        () => mockRepo.createSshKey(
          any(),
          privateKey: any(named: 'privateKey'),
          passphrase: any(named: 'passphrase'),
        ),
      ).thenAnswer((_) async => Success(validKey));

      await sut.createSshKey(
        validKey,
        privateKey: 'key-data',
        passphrase: 'my-phrase',
      );
      verify(
        () => mockRepo.createSshKey(
          any(),
          privateKey: 'key-data',
          passphrase: 'my-phrase',
        ),
      ).called(1);
    });
  });

  group('updateSshKey', () {
    test('updates key when valid', () async {
      when(
        () => mockRepo.updateSshKey(any()),
      ).thenAnswer((_) async => Success(validKey));

      final result = await sut.updateSshKey(validKey);
      expect(result.isSuccess, isTrue);
    });

    test('returns ValidationFailure when name is empty', () async {
      final invalidKey = validKey.copyWith(name: '');
      final result = await sut.updateSshKey(invalidKey);
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<ValidationFailure>());
      verifyNever(() => mockRepo.updateSshKey(any()));
    });
  });

  group('deleteSshKey', () {
    test('delegates to repository', () async {
      when(
        () => mockRepo.deleteSshKey('1'),
      ).thenAnswer((_) async => const Success(null));

      final result = await sut.deleteSshKey('1');
      expect(result.isSuccess, isTrue);
      verify(() => mockRepo.deleteSshKey('1')).called(1);
    });
  });

  group('countServersUsingSshKey', () {
    test('delegates to repository', () async {
      when(
        () => mockRepo.countServersUsingSshKey('1'),
      ).thenAnswer((_) async => const Success(3));

      final result = await sut.countServersUsingSshKey('1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 3);
    });
  });

  group('getSshKeyPrivateKey', () {
    test('delegates to repository', () async {
      when(
        () => mockRepo.getSshKeyPrivateKey('1'),
      ).thenAnswer((_) async => const Success('pem-data'));

      final result = await sut.getSshKeyPrivateKey('1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'pem-data');
    });
  });

  group('getSshKeyPassphrase', () {
    test('delegates to repository', () async {
      when(
        () => mockRepo.getSshKeyPassphrase('1'),
      ).thenAnswer((_) async => const Success('phrase'));

      final result = await sut.getSshKeyPassphrase('1');
      expect(result.isSuccess, isTrue);
      expect(result.value, 'phrase');
    });
  });
}
