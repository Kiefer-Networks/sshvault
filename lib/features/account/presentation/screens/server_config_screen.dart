import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/constants/app_constants.dart';
import 'package:shellvault/core/network/api_client.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerConfigScreen extends ConsumerStatefulWidget {
  const ServerConfigScreen({super.key});

  @override
  ConsumerState<ServerConfigScreen> createState() =>
      _ServerConfigScreenState();
}

class _ServerConfigScreenState extends ConsumerState<ServerConfigScreen> {
  final _urlController = TextEditingController();
  bool _testing = false;
  String? _testResult;
  bool? _testSuccess;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider).valueOrNull;
    _urlController.text =
        settings?.serverUrl ?? AppConstants.defaultServerUrl;
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
    final settings = settingsAsync.valueOrNull;
    final isSelfHosted = settings?.selfHosted ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.serverConfigTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Self-hosted toggle
          SwitchListTile(
            secondary: const Icon(Icons.dns_outlined),
            title: Text(l10n.serverConfigSelfHosted),
            subtitle: Text(l10n.serverConfigSelfHostedDescription),
            value: isSelfHosted,
            onChanged: (v) {
              ref.read(settingsProvider.notifier).setSelfHosted(v);
              if (!v) {
                _urlController.text = AppConstants.defaultServerUrl;
                _saveUrl(AppConstants.defaultServerUrl);
              }
            },
          ),
          const SizedBox(height: 16),

          // Server URL
          TextField(
            controller: _urlController,
            enabled: isSelfHosted,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: l10n.serverConfigUrlLabel,
              hintText: 'https://your-server.example.com',
              prefixIcon: const Icon(Icons.link),
              suffixIcon: IconButton(
                icon: _testing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                tooltip: l10n.serverConfigTest,
                onPressed: _testing ? null : _testConnection,
              ),
            ),
            onSubmitted: (_) => _saveUrl(_urlController.text.trim()),
          ),
          if (_testResult != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _testResult!,
                style: TextStyle(
                  color: _testSuccess == true
                      ? Colors.green
                      : theme.colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (isSelfHosted)
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () =>
                    _saveUrl(_urlController.text.trim()),
                child: Text(l10n.save),
              ),
            ),
          const SizedBox(height: 24),

          // Donation card for self-hosted
          if (isSelfHosted)
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite_outlined,
                            color: theme.colorScheme.onPrimaryContainer),
                        const SizedBox(width: 8),
                        Text(
                          l10n.donationTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.donationDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('https://shellvault.app/donate');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(l10n.donationButton),
                    ),
                  ],
                ),
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

    setState(() {
      _testing = true;
      _testResult = null;
      _testSuccess = null;
    });

    try {
      final client = ApiClient(url);
      final result = await client.get('/health');
      result.fold(
        onSuccess: (_) {
          if (mounted) {
            setState(() {
              _testResult = 'Connection successful';
              _testSuccess = true;
            });
          }
        },
        onFailure: (f) {
          if (mounted) {
            setState(() {
              _testResult = 'Connection failed: ${f.message}';
              _testSuccess = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _testResult = 'Connection failed: $e';
          _testSuccess = false;
        });
      }
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }
}
