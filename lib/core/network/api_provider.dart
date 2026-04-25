import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/network/api_client.dart';
import 'package:sshvault/core/network/auth_interceptor.dart';
import 'package:sshvault/core/network/pow_interceptor.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';

export 'package:sshvault/core/storage/secure_storage_provider.dart';

/// The active server URL, derived from persisted settings.
///
/// Returns an empty string when no server is configured.
/// Sync features must check for an empty URL before making API calls.
final serverUrlProvider = Provider<String>((ref) {
  final url = ref.watch(settingsProvider).value?.serverUrl;
  return (url != null && url.isNotEmpty) ? url : '';
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(serverUrlProvider);
  final storage = ref.watch(secureStorageProvider);

  final client = ApiClient(baseUrl);

  // Create a refresh Dio that shares the main client's httpClientAdapter.
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  refreshDio.httpClientAdapter = client.dio.httpClientAdapter;

  client.dio.interceptors.add(
    AuthInterceptor(
      storage,
      refreshDio,
      onAuthExpired: ({bool sessionRevoked = false}) async {
        // Never auto-wipe local data on a remote 401. Local servers, keys,
        // folders, tags and snippets are the user's data; losing them
        // because the API rejected a refresh token (server hiccup, long
        // offline, rotated session, etc.) is destructive and surprising.
        //
        // Tokens were already cleared by AuthInterceptor._handleAuthExpired,
        // so the user is logged out and will be prompted to re-authenticate.
        // The sync password and DEK are kept so re-login does not require
        // re-entering the encryption passphrase.
        if (sessionRevoked) {
          LoggingService.instance.warning(
            'ApiProvider',
            'Session revoked remotely — local data preserved, re-login required',
          );
        }
        ref.invalidate(authProvider);
      },
    ),
  );

  client.dio.interceptors.add(PowInterceptor(parentDio: client.dio));

  return client;
});
