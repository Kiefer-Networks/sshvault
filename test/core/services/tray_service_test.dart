import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

import 'package:sshvault/core/services/tray_service.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';

ServerEntity _server(String id, String name) {
  final now = DateTime.utc(2026, 1, 1);
  return ServerEntity(
    id: id,
    name: name,
    hostname: '$name.example.com',
    port: 22,
    username: 'root',
    authMethod: AuthMethod.password,
    color: 0xFF00FF00,
    isFavorite: true,
    createdAt: now,
    updatedAt: now,
  );
}

SshSessionEntity _session(String id, String title) {
  return SshSessionEntity(
    id: id,
    serverId: 'srv-$id',
    title: title,
    terminal: Terminal(maxLines: 10),
  );
}

void main() {
  group('TrayService.computeMenu', () {
    test('returns the canonical labels with empty inputs', () {
      final menu = TrayService.computeMenu(
        favorites: const [],
        sessions: const [],
      );

      // Top-level: Show window, separator, Connect to favorite, Active
      // sessions, separator, Settings, Quit.
      final labels = menu.map((e) => e.isSeparator ? '---' : e.label).toList();
      expect(labels, [
        'Show window',
        '---',
        'Connect to favorite',
        'Active sessions',
        '---',
        'Settings',
        'Quit',
      ]);
    });

    test('shows "Hide to tray" when the window is visible', () {
      final menu = TrayService.computeMenu(
        favorites: const [],
        sessions: const [],
        windowVisible: true,
      );
      expect(menu.first.key, 'hide_to_tray');
      expect(menu.first.label, 'Hide to tray');
    });

    test('empty favorites submenu has a single placeholder child', () {
      final menu = TrayService.computeMenu(
        favorites: const [],
        sessions: const [],
      );
      final favorites = menu.firstWhere((e) => e.key == 'favorites');
      expect(favorites.children.length, 1);
      expect(favorites.children.first.key, 'favorites_empty');
    });

    test('favorites submenu lists each favorite by name', () {
      final menu = TrayService.computeMenu(
        favorites: [_server('s1', 'prod'), _server('s2', 'staging')],
        sessions: const [],
      );

      final favorites = menu.firstWhere((e) => e.key == 'favorites');
      expect(favorites.children.length, 2);
      expect(favorites.children[0].key, 'favorite:s1');
      expect(favorites.children[0].label, 'prod');
      expect(favorites.children[1].key, 'favorite:s2');
      expect(favorites.children[1].label, 'staging');
    });

    test('falls back to hostname when the favorite has no name', () {
      final unnamed = _server('s3', '').copyWith(name: '');
      final menu = TrayService.computeMenu(
        favorites: [unnamed],
        sessions: const [],
      );

      final favorites = menu.firstWhere((e) => e.key == 'favorites');
      expect(favorites.children.first.label, '.example.com');
    });

    test('sessions submenu indexes each session positionally', () {
      final menu = TrayService.computeMenu(
        favorites: const [],
        sessions: [_session('a', 'tab-0'), _session('b', 'tab-1')],
      );

      final sessions = menu.firstWhere((e) => e.key == 'sessions');
      expect(sessions.children.length, 2);
      expect(sessions.children[0].key, 'session:0');
      expect(sessions.children[0].label, 'tab-0');
      expect(sessions.children[1].key, 'session:1');
      expect(sessions.children[1].label, 'tab-1');
    });

    test('separators and submenus are correctly tagged', () {
      final menu = TrayService.computeMenu(
        favorites: [_server('s1', 'a')],
        sessions: [_session('a', 'tab')],
      );

      final separators = menu.where((e) => e.isSeparator).toList();
      expect(separators.length, 2);

      final favorites = menu.firstWhere((e) => e.key == 'favorites');
      final sessions = menu.firstWhere((e) => e.key == 'sessions');
      expect(favorites.children, isNotEmpty);
      expect(sessions.children, isNotEmpty);
      expect(favorites.isSeparator, isFalse);
      expect(sessions.isSeparator, isFalse);
    });
  });
}
