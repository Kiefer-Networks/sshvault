import 'package:dio/dio.dart';
import 'package:shellvault/core/security/proof_of_work_service.dart';
import 'package:shellvault/core/services/logging_service.dart';

/// Dio interceptor that handles 428 (Precondition Required) responses
/// by automatically solving a PoW challenge and retrying the request.
class PowInterceptor extends Interceptor {
  static final _log = LoggingService.instance;
  static const _tag = 'PoW';

  final ProofOfWorkService _powService;

  PowInterceptor({ProofOfWorkService? powService})
    : _powService = powService ?? ProofOfWorkService();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 428) {
      return handler.next(err);
    }

    _log.info(
      _tag,
      '428 on ${err.requestOptions.path} — solving PoW challenge',
    );

    try {
      // Fetch challenge from server using a plain Dio to avoid recursion
      final challengeDio = Dio(
        BaseOptions(
          baseUrl: err.requestOptions.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final challengeResponse = await challengeDio.get<Map<String, dynamic>>(
        '/v1/auth/challenge',
      );

      if (challengeResponse.data == null) {
        _log.error(_tag, 'Empty challenge response');
        return handler.next(err);
      }

      final challenge = ProofOfWorkChallenge.fromJson(challengeResponse.data!);

      if (challenge.isExpired) {
        _log.error(_tag, 'Challenge already expired');
        return handler.next(err);
      }

      // Solve the challenge
      final solveResult = await _powService.solve(challenge);
      if (!solveResult.isSuccess) {
        _log.error(_tag, 'Failed to solve PoW challenge');
        return handler.next(err);
      }

      final solution = solveResult.value;

      // Retry original request with PoW headers
      final opts = err.requestOptions;
      opts.headers['X-PoW-Challenge'] = challenge.prefix;
      opts.headers['X-PoW-Nonce'] = solution.nonce;

      _log.info(
        _tag,
        'Retrying ${opts.method} ${opts.path} with PoW solution '
        '(${solution.iterations} iterations, ${solution.durationMs}ms)',
      );

      final retryDio = Dio(
        BaseOptions(
          baseUrl: opts.baseUrl,
          connectTimeout: opts.connectTimeout,
          receiveTimeout: opts.receiveTimeout,
        ),
      );

      final retryResponse = await retryDio.request<dynamic>(
        opts.path,
        data: opts.data,
        queryParameters: opts.queryParameters,
        options: Options(method: opts.method, headers: opts.headers),
      );

      return handler.resolve(
        Response(
          requestOptions: opts,
          data: retryResponse.data,
          statusCode: retryResponse.statusCode,
          headers: retryResponse.headers,
        ),
      );
    } on DioException catch (e) {
      _log.error(
        _tag,
        'PoW retry failed: ${e.response?.statusCode ?? 'N/A'} ${e.message}',
      );
      return handler.next(e);
    } catch (e) {
      _log.error(_tag, 'PoW handling error: $e');
      return handler.next(err);
    }
  }
}
