import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/network/api_client.dart';

void main() {
  late ApiClient sut;

  setUp(() {
    sut = ApiClient('https://api.test.com');
  });

  group('ApiClient — initialization', () {
    test('exposes Dio instance', () {
      expect(sut.dio, isNotNull);
      expect(sut.dio.options.baseUrl, 'https://api.test.com');
    });

    test('sets default timeouts', () {
      expect(sut.dio.options.connectTimeout, const Duration(seconds: 15));
      expect(sut.dio.options.receiveTimeout, const Duration(seconds: 15));
    });

    test('sets content-type header', () {
      expect(sut.dio.options.headers['Content-Type'], 'application/json');
    });

    test('accepts custom interceptors', () {
      final interceptor = InterceptorsWrapper();
      final client = ApiClient(
        'https://api.test.com',
        interceptors: [interceptor],
      );
      expect(client.dio.interceptors, contains(interceptor));
    });
  });

  group('ApiClient — error mapping via GET', () {
    late ApiClient client;
    late _TestAdapter adapter;

    setUp(() {
      client = ApiClient('https://api.test.com');
      adapter = _TestAdapter();
      client.dio.httpClientAdapter = adapter;
    });

    test('returns Success with parsed response data', () async {
      adapter.responseData = {'id': '1', 'name': 'test'};
      adapter.statusCode = 200;

      final result = await client.get('/v1/test');
      expect(result.isSuccess, isTrue);
      expect(result.value['id'], '1');
    });

    test('returns Success with empty map when response is null', () async {
      adapter.responseData = null;
      adapter.statusCode = 200;

      final result = await client.get('/v1/test');
      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });

    test('returns NetworkFailure on connection timeout', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await client.get('/v1/test');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<NetworkFailure>());
      expect(result.failure.message, 'Connection timed out');
    });

    test('returns NetworkFailure on receive timeout', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.receiveTimeout,
      );

      final result = await client.get('/v1/test');
      expect(result.failure.message, 'Server took too long to respond');
    });

    test('returns NetworkFailure on connection error', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.connectionError,
      );

      final result = await client.get('/v1/test');
      expect(result.failure.message, 'Could not connect to server');
    });

    test('extracts error from response body on HTTP error', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/v1/test'),
          statusCode: 422,
          data: {'error': 'validation failed'},
        ),
        type: DioExceptionType.badResponse,
      );

      final result = await client.get('/v1/test');
      final failure = result.failure as NetworkFailure;
      expect(failure.statusCode, 422);
      expect(failure.message, 'validation failed');
    });

    test('returns NetworkFailure on generic DioException', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.unknown,
        message: 'Network error',
      );

      final result = await client.get('/v1/test');
      expect(result.isFailure, isTrue);
      expect(result.failure, isA<NetworkFailure>());
    });
  });

  group('ApiClient — POST', () {
    late ApiClient client;
    late _TestAdapter adapter;

    setUp(() {
      client = ApiClient('https://api.test.com');
      adapter = _TestAdapter();
      client.dio.httpClientAdapter = adapter;
    });

    test('returns Success with response data', () async {
      adapter.responseData = {'id': '1', 'created': true};
      adapter.statusCode = 201;

      final result = await client.post('/v1/test', data: {'name': 'new'});
      expect(result.isSuccess, isTrue);
      expect(result.value['created'], true);
    });

    test('returns NetworkFailure on error', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.connectionError,
      );

      final result = await client.post('/v1/test', data: {});
      expect(result.isFailure, isTrue);
    });
  });

  group('ApiClient — PUT', () {
    late ApiClient client;
    late _TestAdapter adapter;

    setUp(() {
      client = ApiClient('https://api.test.com');
      adapter = _TestAdapter();
      client.dio.httpClientAdapter = adapter;
    });

    test('returns Success with response data', () async {
      adapter.responseData = {'updated': true};
      adapter.statusCode = 200;

      final result = await client.put('/v1/test', data: {'name': 'updated'});
      expect(result.isSuccess, isTrue);
      expect(result.value['updated'], true);
    });

    test('returns NetworkFailure on error', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        type: DioExceptionType.receiveTimeout,
      );

      final result = await client.put('/v1/test', data: {});
      expect(result.isFailure, isTrue);
    });
  });

  group('ApiClient — DELETE', () {
    late ApiClient client;
    late _TestAdapter adapter;

    setUp(() {
      client = ApiClient('https://api.test.com');
      adapter = _TestAdapter();
      client.dio.httpClientAdapter = adapter;
    });

    test('returns Success on delete', () async {
      adapter.responseData = <String, dynamic>{};
      adapter.statusCode = 200;

      final result = await client.delete('/v1/test');
      expect(result.isSuccess, isTrue);
    });

    test('returns NetworkFailure with status code on HTTP error', () async {
      adapter.error = DioException(
        requestOptions: RequestOptions(path: '/v1/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/v1/test'),
          statusCode: 403,
          data: {'error': 'forbidden'},
        ),
        type: DioExceptionType.badResponse,
      );

      final result = await client.delete('/v1/test');
      expect(result.isFailure, isTrue);
      final failure = result.failure as NetworkFailure;
      expect(failure.statusCode, 403);
      expect(failure.message, 'forbidden');
    });
  });
}

/// Test HTTP adapter that returns JSON-encoded responses or throws errors.
class _TestAdapter implements HttpClientAdapter {
  Map<String, dynamic>? responseData;
  int statusCode = 200;
  Object? error;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (error != null) {
      throw error!;
    }

    final body = responseData != null ? jsonEncode(responseData) : 'null';
    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        'content-type': ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
