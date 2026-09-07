import 'dart:async';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/features/sftp/presentation/services/sftp_connection_manager.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:xterm/xterm.dart';

class _Ssh extends Mock implements SSHClient {}

class _Sftp extends Mock implements SftpClient {}

class _Sessions extends SessionManagerNotifier {
  final SshSessionEntity session;
  _Sessions(this.session);
  @override
  List<SshSessionEntity> build() => [session];
}

void main() {
  ProviderContainer containerFor(SSHClient ssh) {
    final session = SshSessionEntity(
      id: 'session',
      serverId: 'host',
      title: 'host',
      terminal: Terminal(),
      client: ssh,
      status: SshConnectionStatus.connected,
    );
    final container = ProviderContainer(
      overrides: [
        sessionManagerProvider.overrideWith(() => _Sessions(session)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  _Sftp readyChannel() {
    final channel = _Sftp();
    when(() => channel.handshake).thenAnswer((_) async => SftpHandsake(3, {}));
    when(() => channel.close()).thenAnswer((_) async {});
    return channel;
  }

  test('concurrent uncached callers share one channel open', () async {
    final ssh = _Ssh();
    when(() => ssh.isClosed).thenReturn(false);
    final open = Completer<SftpClient>();
    var opens = 0;
    when(() => ssh.sftp()).thenAnswer((_) {
      opens++;
      return open.future;
    });
    final container = containerFor(ssh);
    final manager = SftpConnectionManager();
    final first = manager.getClient('host', container);
    final second = manager.getClient('host', container);
    final channel = readyChannel();
    open.complete(channel);
    final results = await Future.wait([first, second]);
    expect(opens, 1);
    expect(
      results.every(
        (result) => result.isSuccess && identical(result.value, channel),
      ),
      true,
    );
    expect((await manager.getClient('host', container)).value, same(channel));
    manager.closeAll();
  });

  test('shared failure is evicted so a later request can retry', () async {
    final ssh = _Ssh();
    when(() => ssh.isClosed).thenReturn(false);
    final open = Completer<SftpClient>();
    final channel = readyChannel();
    var opens = 0;
    when(() => ssh.sftp()).thenAnswer((_) {
      opens++;
      return opens == 1 ? open.future : Future.value(channel);
    });
    final container = containerFor(ssh);
    final manager = SftpConnectionManager();
    final first = manager.getClient('host', container);
    final second = manager.getClient('host', container);
    open.completeError(StateError('Channel rejected'));
    final results = await Future.wait([first, second]);
    expect(results.every((result) => result.isFailure), true);
    expect(opens, 1);
    expect((await manager.getClient('host', container)).value, same(channel));
    expect(opens, 2);
    manager.closeAll();
  });

  for (final closeAll in [false, true]) {
    test(
      '${closeAll ? 'closeAll' : 'closeClient'} detaches pending attempt without disrupting its replacement',
      () async {
        final ssh = _Ssh();
        when(() => ssh.isClosed).thenReturn(false);
        final oldOpen = Completer<SftpClient>();
        final newOpen = Completer<SftpClient>();
        var opens = 0;
        when(
          () => ssh.sftp(),
        ).thenAnswer((_) => ++opens == 1 ? oldOpen.future : newOpen.future);
        final container = containerFor(ssh);
        final manager = SftpConnectionManager();
        final oldRequest = manager.getClient('host', container);
        if (closeAll) {
          manager.closeAll();
        } else {
          manager.closeClient('host');
        }
        final newRequest = manager.getClient('host', container);
        final stale = readyChannel();
        oldOpen.complete(stale);
        expect((await oldRequest).isFailure, true);
        verify(() => stale.close()).called(1);
        final joining = manager.getClient('host', container);
        final fresh = readyChannel();
        newOpen.complete(fresh);
        expect((await newRequest).value, same(fresh));
        expect((await joining).value, same(fresh));
        expect(opens, 2);
        expect((await manager.getClient('host', container)).value, same(fresh));
        verifyNever(() => ssh.close());
        manager.closeAll();
      },
    );
  }

  test(
    'closing borrowed SFTP channel leaves terminal transport alive',
    () async {
      final ssh = _Ssh();
      final sftp = _Sftp();
      when(() => ssh.isClosed).thenReturn(false);
      when(() => ssh.close()).thenAnswer((_) async {});
      when(() => sftp.close()).thenAnswer((_) async {});
      when(() => ssh.sftp()).thenAnswer((_) async => sftp);
      when(() => sftp.handshake).thenAnswer((_) async => SftpHandsake(3, {}));
      final session = SshSessionEntity(
        id: 'session',
        serverId: 'host',
        title: 'host',
        terminal: Terminal(),
        client: ssh,
        status: SshConnectionStatus.connected,
      );
      final container = ProviderContainer(
        overrides: [
          sessionManagerProvider.overrideWith(() => _Sessions(session)),
        ],
      );
      addTearDown(container.dispose);
      final manager = SftpConnectionManager();
      expect((await manager.getClient('host', container)).isSuccess, true);
      manager.closeClient('host');
      verifyNever(() => ssh.close());
      verify(() => sftp.close()).called(1);
    },
  );
}
