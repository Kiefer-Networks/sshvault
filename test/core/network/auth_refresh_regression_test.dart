import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/network/auth_interceptor.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';

class _Storage extends Mock implements SecureStorageService {}

class _Adapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions) respond;
  _Adapter(this.respond);
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? stream,
    Future<void>? cancelFuture,
  ) => respond(options);
  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, int status) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  late _Storage storage;
  late Dio client;
  late Dio refresh;
  var expired = 0;
  var access = 'old-access';
  setUp(() {
    storage = _Storage();
    access = 'old-access';
    expired = 0;
    when(
      () => storage.getAccessToken(),
    ).thenAnswer((_) async => Success(access));
    when(
      () => storage.getRefreshToken(),
    ).thenAnswer((_) async => const Success('refresh'));
    when(
      () => storage.getDeviceId(),
    ).thenAnswer((_) async => const Success(null));
    when(() => storage.saveAccessToken(any())).thenAnswer((call) async {
      access = call.positionalArguments[0] as String;
      return const Success(null);
    });
    when(
      () => storage.saveRefreshToken(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => storage.clearAuthTokens(),
    ).thenAnswer((_) async => const Success(null));
    client = Dio(BaseOptions(baseUrl: 'https://example.test'));
    refresh = Dio(BaseOptions(baseUrl: 'https://example.test'));
    client.interceptors.add(
      AuthInterceptor(
        storage,
        refresh,
        onAuthExpired: ({bool sessionRevoked = false}) async {
          expired++;
        },
      ),
    );
    client.httpClientAdapter = _Adapter(
      (_) async => _json({'error': 'expired'}, 401),
    );
  });

  test('transient refresh failure preserves session', () async {
    refresh.httpClientAdapter = _Adapter(
      (_) async => _json({'error': 'unavailable'}, 503),
    );
    await expectLater(client.get('/v1/vault'), throwsA(isA<DioException>()));
    expect(expired, 0);
    verifyNever(() => storage.clearAuthTokens());
  });

  test('retry server error is not treated as revoked authentication', () async {
    refresh.httpClientAdapter = _Adapter(
      (request) async => request.path.endsWith('/refresh')
          ? _json({
              'access_token': 'new-access',
              'refresh_token': 'new-refresh',
            }, 200)
          : _json({'error': 'unavailable'}, 503),
    );
    await expectLater(client.get('/v1/vault'), throwsA(isA<DioException>()));
    expect(expired, 0);
    expect(access, 'new-access');
  });

  test(
    'malformed refresh completes all waiting requests with errors',
    () async {
      final gate = Completer<void>();
      refresh.httpClientAdapter = _Adapter((_) async {
        await gate.future;
        return _json({'access_token': 42}, 200);
      });
      final first = expectLater(
        client.get('/v1/vault').timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
      final second = expectLater(
        client.get('/v1/user').timeout(const Duration(seconds: 2)),
        throwsA(isA<DioException>()),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));
      gate.complete();
      await Future.wait([first, second]);
      // A successful HTTP refresh may have consumed the old single-use token.
      // Do not replay it after receiving an unusable replacement payload.
      expect(expired, 1);
    },
  );

  test('concurrent expired requests rotate refresh token only once', () async {
    var rotations = 0;
    refresh.httpClientAdapter = _Adapter((request) async {
      if (request.path.endsWith('/refresh')) {
        rotations++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return _json({
          'access_token': 'new-access',
          'refresh_token': 'new-refresh',
        }, 200);
      }
      return _json({'ok': true}, 200);
    });
    final responses = await Future.wait([
      client.get('/v1/vault'),
      client.get('/v1/user'),
    ]);
    expect(responses.every((r) => r.statusCode == 200), isTrue);
    expect(rotations, 1);
  });

  test(
    'explicit refresh rejection clears credentials once for all waiters',
    () async {
      refresh.httpClientAdapter = _Adapter((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return _json({'error': 'revoked'}, 401);
      });
      await Future.wait([
        expectLater(client.get('/v1/vault'), throwsA(isA<DioException>())),
        expectLater(client.get('/v1/user'), throwsA(isA<DioException>())),
      ]);
      expect(expired, 1);
      verify(() => storage.clearAuthTokens()).called(1);
    },
  );
}
