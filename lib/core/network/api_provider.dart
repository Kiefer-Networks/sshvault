import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/core/network/auth_interceptor.dart';
import 'package:shellvault/core/storage/secure_storage_provider.dart';

export 'package:shellvault/core/storage/secure_storage_provider.dart';

final serverUrlProvider = StateProvider<String>((ref) {
  return AppConstants.defaultServerUrl;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(serverUrlProvider);
  final storage = ref.watch(secureStorageProvider);

  final client = ApiClient(
    baseUrl,
    interceptors: [
      AuthInterceptor(
        storage,
        ApiClient(baseUrl).dio,
        onAuthExpired: () {
          // Will be handled by AuthNotifier watching token state
        },
      ),
    ],
  );

  return client;
});
