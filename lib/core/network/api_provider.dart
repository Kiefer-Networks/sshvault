import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/network/api_client.dart';
import 'package:sshvault/core/network/auth_interceptor.dart';
import 'package:sshvault/core/network/pow_interceptor.dart';
import 'package:sshvault/core/security/security_providers.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/snippet/presentation/providers/snippet_providers.dart';

export 'package:sshvault/core/storage/secure_storage_provider.dart';

/// The active server URL, derived from persisted settings.
///
/// Falls back to [AppConstants.defaultServerUrl] when no custom URL is stored.
/// Updates automatically when settings change — no manual override needed.
final serverUrlProvider = Provider<String>((ref) {
  final url = ref.watch(settingsProvider).value?.serverUrl;
  return (url != null && url.isNotEmpty) ? url : AppConstants.defaultServerUrl;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(serverUrlProvider);
  final storage = ref.watch(secureStorageProvider);

  // Certificate pinning at HttpClient level.
  // DoH is NOT used in connectionFactory — Dart's HttpClient on iOS
  // does not wrap connectionFactory sockets in TLS, causing plain HTTP
  // to be sent to HTTPS ports. DoH cross-check runs separately.
  final pinningService = ref.watch(certificatePinningProvider);

  final client = ApiClient(
    baseUrl,
    createHttpClient: pinningService != null
        ? () => pinningService.createHttpClient()
        : null,
  );

  // Create a refresh Dio that shares the main client's httpClientAdapter
  // so token refresh requests go through the same certificate pinning.
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
  refreshDio.httpClientAdapter = client.dio.httpClientAdapter;

  // Add AuthInterceptor after client creation so the refresh Dio can
  // reuse the pinned httpClientAdapter (same pattern as PowInterceptor).
  client.dio.interceptors.add(
    AuthInterceptor(
      storage,
      refreshDio,
      onAuthExpired: ({bool sessionRevoked = false}) async {
        if (sessionRevoked) {
          LoggingService.instance.warning(
            'ApiProvider',
            'Session revoked remotely — wiping all local data',
          );
          await storage.clearAllData();
          try {
            final db = ref.read(databaseProvider);
            await db.deleteAllData();
          } catch (e) {
            LoggingService.instance.error(
              'ApiProvider',
              'Failed to clear database: $e',
            );
          }
          ref.invalidate(serverListProvider);
          ref.invalidate(sshKeyListProvider);
          ref.invalidate(folderListProvider);
          ref.invalidate(tagListProvider);
          ref.invalidate(snippetListProvider);
          ref.invalidate(settingsProvider);
        }
        ref.invalidate(authProvider);
      },
    ),
  );

  // Add PoW interceptor after client creation so it can reference the
  // parent Dio's httpClientAdapter (preserves certificate pinning).
  client.dio.interceptors.add(PowInterceptor(parentDio: client.dio));

  return client;
});
