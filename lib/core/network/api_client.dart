import 'package:dio/dio.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/error/result.dart';

class ApiClient {
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
  }

  Dio get dio => _dio;

  Future<Result<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return Success(response.data ?? {});
    } on DioException catch (e) {
      return Err(_mapDioError(e));
    } catch (e) {
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  Future<Result<Map<String, dynamic>>> post(String path, {Object? data}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      return Success(response.data ?? {});
    } on DioException catch (e) {
      return Err(_mapDioError(e));
    } catch (e) {
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  Future<Result<Map<String, dynamic>>> put(String path, {Object? data}) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(path, data: data);
      return Success(response.data ?? {});
    } on DioException catch (e) {
      return Err(_mapDioError(e));
    } catch (e) {
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  Future<Result<Map<String, dynamic>>> delete(
    String path, {
    Object? data,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        data: data,
      );
      return Success(response.data ?? {});
    } on DioException catch (e) {
      return Err(_mapDioError(e));
    } catch (e) {
      return Err(NetworkFailure('Unexpected error', cause: e));
    }
  }

  NetworkFailure _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String message;
    if (data is Map<String, dynamic> && data.containsKey('error')) {
      message = data['error'] as String;
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
