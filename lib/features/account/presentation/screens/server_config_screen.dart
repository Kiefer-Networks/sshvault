import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/core/network/api_client.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class _ConnectionTestState {
  final bool testing;
  final String? result;
  final bool? success;

  const _ConnectionTestState({this.testing = false, this.result, this.success});
}

final _connectionTestProvider = StateProvider.autoDispose<_ConnectionTestState>(
  (ref) => const _ConnectionTestState(),
);

class ServerConfigScreen extends ConsumerStatefulWidget {
  const ServerConfigScreen({super.key});

  @override
  ConsumerState<ServerConfigScreen> createState() => _ServerConfigScreenState();
}

class _ServerConfigScreenState extends ConsumerState<ServerConfigScreen> {
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).value;
    _urlController.text = settings?.serverUrl ?? AppConstants.defaultServerUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.value;
    final isSelfHosted = settings?.selfHosted ?? false;
    final testState = ref.watch(_connectionTestProvider);
    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.value == AuthStatus.authenticated;

    return AdaptiveScaffold(
      title: l10n.serverConfigTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Self-hosted toggle
          AdaptiveSwitchTile(
            secondary: const Icon(Icons.dns_outlined),
            title: l10n.serverConfigSelfHosted,
            subtitle: l10n.serverConfigSelfHostedDescription,
            value: isSelfHosted,
            onChanged: isLoggedIn
                ? null
                : (v) {
                    ref.read(settingsProvider.notifier).setSelfHosted(v);
                    if (!v) {
                      _urlController.text = AppConstants.defaultServerUrl;
                      _saveUrl(AppConstants.defaultServerUrl);
                    }
                  },
          ),
          if (isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
              child: Text(
                l10n.serverUrlLockedWhileLoggedIn,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Server URL
          TextField(
            controller: _urlController,
            enabled: isSelfHosted && !isLoggedIn,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: l10n.serverConfigUrlLabel,
              hintText: 'https://your-server.example.com',
              prefixIcon: const Icon(Icons.link),
              suffixIcon: IconButton(
                icon: testState.testing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                tooltip: l10n.serverConfigTest,
                onPressed: testState.testing ? null : _testConnection,
              ),
            ),
            onSubmitted: (_) => _saveUrl(_urlController.text.trim()),
          ),
          if (testState.result != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                testState.result!,
                style: TextStyle(
                  color: testState.success == true
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (isSelfHosted)
            Align(
              alignment: Alignment.centerRight,
              child: AdaptiveButton.filled(
                onPressed: () => _saveUrl(_urlController.text.trim()),
                child: Text(l10n.save),
              ),
            ),
        ],
      ),
    );
  }

  void _saveUrl(String url) {
    if (url.isEmpty) return;
    ref.read(settingsProvider.notifier).setServerUrl(url);
    ref.read(serverUrlProvider.notifier).state = url;
  }

  Future<void> _testConnection() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;

    ref.read(_connectionTestProvider.notifier).state =
        const _ConnectionTestState(testing: true);

    try {
      final client = ApiClient(url);
      final result = await client.get('/health');
      result.fold(
        onSuccess: (_) {
          if (mounted) {
            ref
                .read(_connectionTestProvider.notifier)
                .state = _ConnectionTestState(
              result: l10n.connectionTestSuccess,
              success: true,
            );
          }
        },
        onFailure: (f) {
          if (mounted) {
            ref
                .read(_connectionTestProvider.notifier)
                .state = _ConnectionTestState(
              result: l10n.connectionTestFailed(f.message),
              success: false,
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ref.read(_connectionTestProvider.notifier).state = _ConnectionTestState(
          result: l10n.connectionTestFailed(e.toString()),
          success: false,
        );
      }
    }
  }
}
