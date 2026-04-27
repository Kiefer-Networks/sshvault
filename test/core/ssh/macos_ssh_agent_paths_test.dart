// Verifies the macOS ssh-agent socket detection logic against a
// synthesized HOME directory, so the tests run on any host platform.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/ssh/macos_ssh_agent_paths.dart';

void main() {
  group('macos_ssh_agent_paths', () {
    late Directory tempHome;

    setUp(() {
      tempHome = Directory.systemTemp.createTempSync('sshvault_macos_agents_');
    });

    tearDown(() {
      if (tempHome.existsSync()) {
        tempHome.deleteSync(recursive: true);
      }
    });

    String mkSocket(String relative) {
      final f = File('${tempHome.path}/$relative');
      f.parent.createSync(recursive: true);
      f.writeAsStringSync('');
      return f.path;
    }

    test('returns empty list on non-macOS hosts', () async {
      final agents = await listAvailableAgents(
        environment: {'HOME': tempHome.path},
        platformIsMacOS: false,
      );
      expect(agents, isEmpty);

      final socket = await detectActiveAgentSocket(
        environment: {'HOME': tempHome.path},
        platformIsMacOS: false,
      );
      expect(socket, isNull);
    });

    test('returns empty list when no candidate paths exist', () async {
      final agents = await listAvailableAgents(
        environment: {'HOME': tempHome.path},
        platformIsMacOS: true,
      );
      expect(agents, isEmpty);
      expect(
        await detectActiveAgentSocket(
          environment: {'HOME': tempHome.path},
          platformIsMacOS: true,
        ),
        isNull,
      );
    });

    test('detects the 1Password convenience socket under \$HOME', () async {
      final path = mkSocket('.1password/agent.sock');
      final agents = await listAvailableAgents(
        environment: {'HOME': tempHome.path},
        platformIsMacOS: true,
      );
      expect(agents, hasLength(1));
      expect(agents.single.socketPath, path);
      expect(agents.single.displayName, '1Password');
      expect(
        await detectActiveAgentSocket(
          environment: {'HOME': tempHome.path},
          platformIsMacOS: true,
        ),
        path,
      );
    });

    test('detects the 1Password group-container socket', () async {
      final path = mkSocket(
        'Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock',
      );
      final agents = await listAvailableAgents(
        environment: {'HOME': tempHome.path},
        platformIsMacOS: true,
      );
      expect(agents.map((a) => a.socketPath).toList(), [path]);
      expect(agents.single.displayName, '1Password (group container)');
    });

    test('detects the Secretive socket', () async {
      final path = mkSocket(
        'Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh',
      );
      final agents = await listAvailableAgents(
        environment: {'HOME': tempHome.path},
        platformIsMacOS: true,
      );
      expect(agents.map((a) => a.socketPath).toList(), [path]);
      expect(agents.single.displayName, 'Secretive');
    });

    test(
      'respects priority order: SSH_AUTH_SOCK > 1Password > group > Secretive',
      () async {
        final authSock = mkSocket('custom/agent.sock');
        final onepw = mkSocket('.1password/agent.sock');
        final group = mkSocket(
          'Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock',
        );
        final secretive = mkSocket(
          'Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh',
        );

        final agents = await listAvailableAgents(
          environment: {'HOME': tempHome.path, 'SSH_AUTH_SOCK': authSock},
          platformIsMacOS: true,
        );

        expect(agents.map((a) => a.socketPath).toList(), [
          authSock,
          onepw,
          group,
          secretive,
        ]);

        expect(
          await detectActiveAgentSocket(
            environment: {'HOME': tempHome.path, 'SSH_AUTH_SOCK': authSock},
            platformIsMacOS: true,
          ),
          authSock,
        );
      },
    );

    test('skips SSH_AUTH_SOCK when the file does not exist', () async {
      final onepw = mkSocket('.1password/agent.sock');
      final agents = await listAvailableAgents(
        environment: {
          'HOME': tempHome.path,
          'SSH_AUTH_SOCK': '${tempHome.path}/does/not/exist.sock',
        },
        platformIsMacOS: true,
      );
      expect(agents.map((a) => a.socketPath).toList(), [onepw]);
    });

    test('deduplicates when SSH_AUTH_SOCK points at a known path', () async {
      final onepw = mkSocket('.1password/agent.sock');
      final agents = await listAvailableAgents(
        environment: {'HOME': tempHome.path, 'SSH_AUTH_SOCK': onepw},
        platformIsMacOS: true,
      );
      expect(agents, hasLength(1));
      expect(agents.single.socketPath, onepw);
      // First-wins: SSH_AUTH_SOCK label wins over the 1Password label.
      expect(agents.single.displayName, r'$SSH_AUTH_SOCK');
    });

    test('falls back gracefully when HOME is unset', () async {
      final agents = await listAvailableAgents(
        environment: const {},
        platformIsMacOS: true,
      );
      expect(agents, isEmpty);
    });
  });
}
