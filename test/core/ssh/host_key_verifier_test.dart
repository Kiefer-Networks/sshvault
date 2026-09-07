import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/features/host_key/domain/entities/known_host_entity.dart';
import 'package:sshvault/features/host_key/domain/repositories/known_host_repository.dart';
import 'package:sshvault/features/host_key/domain/services/host_key_verifier.dart';

class _Repository extends Mock implements KnownHostRepository {}

void main() {
  final digest = Uint8List(32);
  final matching = KnownHostEntity(
    id: 'known',
    hostname: 'host',
    port: 22,
    keyType: 'ssh-ed25519',
    fingerprint: List.filled(32, '00').join(':'),
    firstSeenAt: DateTime(2020),
    lastSeenAt: DateTime(2020),
  );
  final changed = matching.copyWith(
    fingerprint: List.filled(32, '11').join(':'),
  );
  setUpAll(() => registerFallbackValue(matching));

  for (final automatic in [true, false]) {
    test(
      '${automatic ? 'SFTP' : 'terminal'} rejects lookup failure without asking consent or writing',
      () async {
        final repo = _Repository();
        when(
          () => repo.findByHostAndPort('host', 22),
        ).thenAnswer((_) async => const Err(DatabaseFailure('read failed')));
        when(
          () => repo.save(any()),
        ).thenAnswer((_) async => const Success(null));
        var confirmations = 0;
        final verifier = HostKeyVerifier(
          repository: repo,
          hostname: 'host',
          port: 22,
          trustNewHosts: automatic,
          confirm: (_, _, _) async {
            confirmations++;
            return true;
          },
        );
        expect(await verifier.verify('ssh-ed25519', digest), false);
        expect(confirmations, 0);
        verifyNever(() => repo.save(any()));
      },
    );

    for (final previous in <KnownHostEntity?>[null, matching]) {
      test(
        '${automatic ? 'SFTP' : 'terminal'} rejects ${previous == null ? 'new pin' : 'lastSeen'} write failure',
        () async {
          final repo = _Repository();
          when(
            () => repo.findByHostAndPort('host', 22),
          ).thenAnswer((_) async => Success(previous));
          when(
            () => repo.save(any()),
          ).thenAnswer((_) async => const Err(DatabaseFailure('write failed')));
          var storedNotifications = 0;
          final verifier = HostKeyVerifier(
            repository: repo,
            hostname: 'host',
            port: 22,
            trustNewHosts: automatic,
            confirm: (_, _, _) async => true,
            onStored: () => storedNotifications++,
          );
          expect(await verifier.verify('ssh-ed25519', digest), false);
          expect(storedNotifications, 0);
        },
      );
    }
  }

  test(
    'terminal consent cannot override failure to persist changed key',
    () async {
      final repo = _Repository();
      when(
        () => repo.findByHostAndPort('host', 22),
      ).thenAnswer((_) async => Success(changed));
      when(
        () => repo.save(any()),
      ).thenAnswer((_) async => const Err(DatabaseFailure('write failed')));
      final verifier = HostKeyVerifier(
        repository: repo,
        hostname: 'host',
        port: 22,
        confirm: (_, _, previous) async {
          expect(previous, changed);
          return true;
        },
      );
      expect(await verifier.verify('ssh-ed25519', digest), false);
    },
  );

  test('SFTP rejects a changed host key without overwriting it', () async {
    final repo = _Repository();
    when(
      () => repo.findByHostAndPort('host', 22),
    ).thenAnswer((_) async => Success(changed));
    final verifier = HostKeyVerifier(
      repository: repo,
      hostname: 'host',
      port: 22,
      trustNewHosts: true,
    );
    expect(await verifier.verify('ssh-ed25519', digest), false);
    verifyNever(() => repo.save(any()));
  });

  for (final previous in <KnownHostEntity?>[null, matching, changed]) {
    test(
      'successful persistence accepts ${previous == null
          ? 'new'
          : previous == matching
          ? 'matching'
          : 'confirmed changed'} key',
      () async {
        final repo = _Repository();
        when(
          () => repo.findByHostAndPort('host', 22),
        ).thenAnswer((_) async => Success(previous));
        when(
          () => repo.save(any()),
        ).thenAnswer((_) async => const Success(null));
        final verifier = HostKeyVerifier(
          repository: repo,
          hostname: 'host',
          port: 22,
          confirm: (_, _, _) async => true,
        );
        expect(await verifier.verify('ssh-ed25519', digest), true);
        final stored =
            verify(() => repo.save(captureAny())).captured.single
                as KnownHostEntity;
        expect(stored.fingerprint, matching.fingerprint);
        expect(stored.hostname, 'host');
        if (previous != null) expect(stored.firstSeenAt, previous.firstSeenAt);
      },
    );
  }

  for (final readThrows in [true, false]) {
    test(
      'repository ${readThrows ? 'read' : 'write'} exceptions reject the key',
      () async {
        final repo = _Repository();
        if (readThrows) {
          when(
            () => repo.findByHostAndPort('host', 22),
          ).thenThrow(StateError('unavailable'));
        } else {
          when(
            () => repo.findByHostAndPort('host', 22),
          ).thenAnswer((_) async => Success(matching));
          when(() => repo.save(any())).thenThrow(StateError('unavailable'));
        }
        final verifier = HostKeyVerifier(
          repository: repo,
          hostname: 'host',
          port: 22,
          trustNewHosts: true,
        );
        expect(await verifier.verify('ssh-ed25519', digest), false);
      },
    );
  }
}
