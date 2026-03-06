import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_credentials.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';

const _globalProxyPasswordKey = 'global_proxy_password';

final globalProxyConfigProvider = Provider<ProxyConfig?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  if (settings == null) return null;
  return settings.globalProxyConfig;
});

final globalProxyCredentialsProvider = FutureProvider<ProxyCredentials>((
  ref,
) async {
  const storage = FlutterSecureStorage();
  final password = await storage.read(key: _globalProxyPasswordKey);
  return ProxyCredentials(password: password);
});

Future<void> saveGlobalProxyPassword(String? password) async {
  const storage = FlutterSecureStorage();
  if (password == null || password.isEmpty) {
    await storage.delete(key: _globalProxyPasswordKey);
  } else {
    await storage.write(key: _globalProxyPasswordKey, value: password);
  }
}
