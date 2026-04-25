import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sshvault/core/network/api_client.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
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
        padding: Spacing.paddingAllLg,
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: Spacing.paddingAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      Spacing.horizontalSm,
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
                  Spacing.verticalMd,
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
          Spacing.verticalXxl,

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
          Spacing.verticalLg,

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
                      Spacing.horizontalSm,
                      Text(l10n.serverConfigTest),
                    ],
                  ),
          ),

          if (testState.result != null)
            Semantics(
              liveRegion: true,
              label: testState.result,
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.md),
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
                    Spacing.horizontalSm,
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
            ),
          Spacing.verticalXxl,

          AdaptiveButton.filled(
            onPressed: canContinue ? _saveAndContinue : null,
            child: Text(l10n.serverSetupContinue),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndContinue() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    await ref.read(settingsProvider.notifier).setServerUrl(url);
    await ref.read(settingsProvider.future);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _testConnection() async {
    var url = _urlController.text.trim();
    if (url.isEmpty) return;

    // Auto-prepend https:// if no scheme is present
    if (!url.startsWith('https://') && !url.startsWith('http://')) {
      url = 'https://$url';
      _urlController.text = url;
      _urlController.selection = TextSelection.collapsed(offset: url.length);
    } else if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', 'https://');
      _urlController.text = url;
      _urlController.selection = TextSelection.collapsed(offset: url.length);
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
