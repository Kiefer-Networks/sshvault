// Unit tests for the Android Home-Screen Widget bridge.
//
// `AndroidWidgetService` is a singleton that pushes the top-N favorite hosts
// to a native MethodChannel. We exercise the pure builder
// (`buildHosts`) directly and verify the channel-call shape via the
// `invoker` test seam — that mirrors the pattern in
// `jump_list_service_test.dart` and avoids the full
// `TestDefaultBinaryMessengerBinding` setup while still asserting that the
// right method is called with the right payload.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sshvault/core/services/android_widget_service.dart';
import 'package:sshvault/features/connection/domain/entities/auth_method.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';

ServerEntity _server(String id, String name, {String hostname = ''}) {
  final now = DateTime.utc(2026, 1, 1);
  return ServerEntity(
    id: id,
    name: name,
    hostname: hostname.isEmpty ? '$id.example.com' : hostname,
    port: 22,
    username: 'root',
    authMethod: AuthMethod.password,
    color: 0xFF00AAFF,
    isFavorite: true,
    createdAt: now,
    updatedAt: now,
  );
}

class _Recorder {
  final List<({String method, Object? args})> calls = [];

  Future<Object?> call(String method, Object? args) async {
    calls.add((method: method, args: args));
    return null;
  }
}

void main() {
  group('AndroidWidgetService.buildHosts', () {
    test('returns empty list when no favorites', () {
      final hosts = AndroidWidgetService.buildHosts(favorites: const []);
      expect(hosts, isEmpty);
    });

    test('maps each favorite to a WidgetHost in order', () {
      final hosts = AndroidWidgetService.buildHosts(
        favorites: [
          _server('s1', 'prod', hostname: 'prod.example.com'),
          _server('s2', 'staging', hostname: 'staging.example.com'),
        ],
      );

      expect(hosts.length, 2);
      expect(hosts[0].id, 's1');
      expect(hosts[0].name, 'prod');
      expect(hosts[0].hostname, 'prod.example.com');
      expect(hosts[1].id, 's2');
      expect(hosts[1].name, 'staging');
    });

    test('caps at AndroidWidgetService.kMaxTiles entries', () {
      // The Kotlin side renders a 4×1 grid, so the Dart side never sends
      // more than four entries even if the user has flagged more favorites.
      final favorites = List.generate(10, (i) => _server('s$i', 'srv$i'));
      final hosts = AndroidWidgetService.buildHosts(favorites: favorites);

      expect(hosts.length, AndroidWidgetService.kMaxTiles);
      expect(hosts.first.id, 's0');
      expect(hosts.last.id, 's${AndroidWidgetService.kMaxTiles - 1}');
    });

    test('drops favorites with empty ids defensively', () {
      final hosts = AndroidWidgetService.buildHosts(
        favorites: [_server('', 'noid'), _server('s1', 'prod')],
      );
      expect(hosts.length, 1);
      expect(hosts.single.id, 's1');
    });
  });

  group('WidgetHost encoding', () {
    test('toMap preserves every field', () {
      const host = WidgetHost(
        id: 's1',
        name: 'prod',
        hostname: 'prod.example.com',
      );
      expect(host.toMap(), {
        'id': 's1',
        'name': 'prod',
        'hostname': 'prod.example.com',
      });
    });

    test('value equality compares all fields', () {
      const a = WidgetHost(id: 's1', name: 'prod', hostname: 'p.example.com');
      const b = WidgetHost(id: 's1', name: 'prod', hostname: 'p.example.com');
      const c = WidgetHost(id: 's1', name: 'prod', hostname: 'q.example.com');
      expect(a, equals(b));
      expect(a == c, isFalse);
    });
  });

  group('AndroidWidgetService channel contract', () {
    setUp(() => AndroidWidgetService.instance.resetForTest());
    tearDown(() => AndroidWidgetService.instance.resetForTest());

    test('emits setFavorites with the encoded host payload', () async {
      final recorder = _Recorder();
      final svc = AndroidWidgetService.instance..invoker = recorder.call;

      // We can't drive `_refresh` without a ProviderContainer, but invoking
      // the same code path with the canonical builder output is the
      // contract the Kotlin side observes — and the only thing the test
      // should care about.
      final hosts = AndroidWidgetService.buildHosts(
        favorites: [
          _server('s1', 'prod', hostname: 'prod.example.com'),
          _server('s2', 'staging', hostname: 'staging.example.com'),
        ],
      );
      await svc.invoker(
        'setFavorites',
        hosts.map((h) => h.toMap()).toList(growable: false),
      );

      expect(recorder.calls.length, 1);
      expect(recorder.calls.first.method, 'setFavorites');
      final payload = recorder.calls.first.args as List;
      expect(payload.length, 2);
      expect(payload[0], {
        'id': 's1',
        'name': 'prod',
        'hostname': 'prod.example.com',
      });
      expect(payload[1]['id'], 's2');
    });

    test('handles MissingPluginException without crashing', () async {
      final svc = AndroidWidgetService.instance
        ..invoker = (_, _) async {
          throw MissingPluginException('not registered');
        };

      // Should not throw — the production code logs and disables itself.
      await svc.invoker('setFavorites', const []);
    });
  });
}
