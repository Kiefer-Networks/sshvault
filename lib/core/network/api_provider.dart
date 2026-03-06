import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/core/network/auth_interceptor.dart';
import 'package:shellvault/core/network/doh_interceptor.dart';
import 'package:shellvault/core/network/pow_interceptor.dart';
import 'package:shellvault/core/security/security_providers.dart';
import 'package:shellvault/core/services/logging_service.dart';
import 'package:shellvault/core/storage/database_provider.dart';
import 'package:shellvault/core/storage/secure_storage_provider.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:shellvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/snippet/presentation/providers/snippet_providers.dart';

export 'package:shellvault/core/storage/secure_storage_provider.dart';

final serverUrlProvider = StateProvider<String>((ref) {
  return AppConstants.defaultServerUrl;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(serverUrlProvider);
  final storage = ref.watch(secureStorageProvider);

  // Certificate pinning — creates a custom HttpClient with pin validation
  final pinningService = ref.watch(certificatePinningProvider);

  // DNS-over-HTTPS resolver — intercepts requests to resolve via DoH
  final dohResolver = ref.watch(dohResolverProvider);
  final dohInterceptor = DohInterceptor(dohResolver);

  final client = ApiClient(
    baseUrl,
    createHttpClient: pinningService?.createHttpClient,
    interceptors: [
      // DoH resolution runs first, before auth headers are attached
      dohInterceptor,
      AuthInterceptor(
        storage,
        ApiClient(baseUrl).dio,
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
    ],
  );

  // Add PoW interceptor after client creation so it can reference the
  // parent Dio's httpClientAdapter (preserves certificate pinning).
  client.dio.interceptors.add(PowInterceptor(parentDio: client.dio));

  return client;
});
