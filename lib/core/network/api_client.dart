import 'package:dio/dio.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/services/logging_service.dart';

class ApiClient {
  static final _log = LoggingService.instance;
  static const _tag = 'Network';

  final Dio _dio;

  ApiClient(String baseUrl, {List<Interceptor>? interceptors})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
    _log.info(_tag, 'ApiClient initialized (baseUrl=$baseUrl)');
  }

  Dio get dio => _dio;

  Future<Result<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    _log.debug(_tag, 'GET $path');
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      _log.debug(_tag, 'GET $path → ${response.statusCode}');
      return Success(response.data ?? {});
    } on DioException catch (e) {
      final failure = _mapDioError(e);
      _log.error(
        _tag,
        'GET $path failed: ${failure.statusCode ?? 'N/A'} ${failure.message}',
      );
      return Err(failure);
    } catch (e) {
      _log.error(_tag, 'GET $path unexpected error: $e');
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  Future<Result<Map<String, dynamic>>> post(String path, {Object? data}) async {
    _log.debug(_tag, 'POST $path');
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      _log.debug(_tag, 'POST $path → ${response.statusCode}');
      return Success(response.data ?? {});
    } on DioException catch (e) {
      final failure = _mapDioError(e);
      _log.error(
        _tag,
        'POST $path failed: ${failure.statusCode ?? 'N/A'} ${failure.message}',
      );
      // Extended diagnostics for non-server responses
      if (e.response != null) {
        final headers = e.response!.headers.map;
        final hasVia = headers.containsKey('via');
        final server = headers['server']?.join(', ') ?? 'unknown';
        _log.error(
          _tag,
          'Response diagnostics — server: $server, '
          'via: ${hasVia ? headers["via"]!.join(", ") : "absent"}, '
          'data type: ${e.response!.data?.runtimeType}, '
          'redirects: ${e.response!.redirects.length}',
        );
      } else {
        _log.error(
          _tag,
          'No response object — DioExceptionType: ${e.type}, '
          'message: ${e.message}',
        );
      }
      return Err(failure);
    } catch (e) {
      _log.error(_tag, 'POST $path unexpected error: $e');
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  Future<Result<Map<String, dynamic>>> put(String path, {Object? data}) async {
    _log.debug(_tag, 'PUT $path');
    try {
      final response = await _dio.put<Map<String, dynamic>>(path, data: data);
      _log.debug(_tag, 'PUT $path → ${response.statusCode}');
      return Success(response.data ?? {});
    } on DioException catch (e) {
      final failure = _mapDioError(e);
      _log.error(
        _tag,
        'PUT $path failed: ${failure.statusCode ?? 'N/A'} ${failure.message}',
      );
      return Err(failure);
    } catch (e) {
      _log.error(_tag, 'PUT $path unexpected error: $e');
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  Future<Result<Map<String, dynamic>>> delete(
    String path, {
    Object? data,
  }) async {
    _log.debug(_tag, 'DELETE $path');
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        data: data,
      );
      _log.debug(_tag, 'DELETE $path → ${response.statusCode}');
      return Success(response.data ?? {});
    } on DioException catch (e) {
      final failure = _mapDioError(e);
      _log.error(
        _tag,
        'DELETE $path failed: ${failure.statusCode ?? 'N/A'} ${failure.message}',
      );
      return Err(failure);
    } catch (e) {
      _log.error(_tag, 'DELETE $path unexpected error: $e');
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  NetworkFailure _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message;
    if (data is Map<String, dynamic> && data.containsKey('error')) {
      message = data['error'] as String;
    } else if (data is String && data.isNotEmpty) {
      // Plain-text or HTML error from reverse proxy
      message = data.length > 200 ? data.substring(0, 200) : data;
    } else {
      message = switch (e.type) {
        DioExceptionType.connectionTimeout => 'Connection timed out',
        DioExceptionType.receiveTimeout => 'Server took too long to respond',
        DioExceptionType.connectionError => 'Could not connect to server',
        _ => e.message ?? 'Network error',
      };
    }

    return NetworkFailure(message, statusCode: statusCode, cause: e);
  }
}
