import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/network/api_client.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final url = ref.read(settingsProvider).value?.serverUrl;
    if (url != null && url.isNotEmpty) {
      _urlController.text = url;
    }
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
    final testState = ref.watch(_connectionTestProvider);
    final canContinue = testState.success == true;

    return AdaptiveScaffold(
      title: l10n.serverSetupTitle,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.serverSetupInfoCard,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => launchUrl(
                      Uri.parse(
                        'https://github.com/Kiefer-Networks/sshvault-api',
                      ),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text(l10n.serverSetupRepoLink),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          TextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: l10n.serverConfigUrlLabel,
              hintText: l10n.hintExampleServerUrl,
              prefixIcon: const Icon(Icons.link),
            ),
            onChanged: (_) {
              ref.read(_connectionTestProvider.notifier).state =
                  const _ConnectionTestState();
            },
          ),
          const SizedBox(height: 16),

          OutlinedButton(
            onPressed: testState.testing ? null : _testConnection,
            child: testState.testing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18),
                      const SizedBox(width: 8),
                      Text(l10n.serverConfigTest),
                    ],
                  ),
          ),

          if (testState.result != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Icon(
                    testState.success == true
                        ? Icons.check_circle
                        : Icons.error_outline,
                    size: 20,
                    color: testState.success == true
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      testState.result!,
                      style: TextStyle(
                        color: testState.success == true
                            ? theme.colorScheme.tertiary
                            : theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          AdaptiveButton.filled(
            onPressed: canContinue ? _saveAndContinue : null,
            child: Text(l10n.serverSetupContinue),
          ),
        ],
      ),
    );
  }

  void _saveAndContinue() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    ref.read(settingsProvider.notifier).setServerUrl(url);
    Navigator.of(context).pop();
  }

  Future<void> _testConnection() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    if (!url.startsWith('https://')) {
      final l10n = AppLocalizations.of(context)!;
      ref.read(_connectionTestProvider.notifier).state = _ConnectionTestState(
        result: l10n.connectionTestFailed('HTTPS required'),
        success: false,
      );
      return;
    }

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
