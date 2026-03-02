import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:shellvault/features/sync/presentation/widgets/first_sync_dialog.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

enum SyncPasswordMode { create, enter }

class SyncPasswordScreen extends ConsumerStatefulWidget {
  final SyncPasswordMode mode;

  const SyncPasswordScreen({
    super.key,
    this.mode = SyncPasswordMode.create,
  });

  @override
  ConsumerState<SyncPasswordScreen> createState() => _SyncPasswordScreenState();
}

class _SyncPasswordScreenState extends ConsumerState<SyncPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _saving = false;
  String? _errorMessage;

  bool get _isCreateMode => widget.mode == SyncPasswordMode.create;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isCreateMode
              ? l10n.syncPasswordTitleCreate
              : l10n.syncPasswordTitleEnter,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.enhanced_encryption_outlined,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isCreateMode
                        ? l10n.syncPasswordDescription
                        : l10n.syncPasswordHintEnter,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (_isCreateMode) ...[
                    const SizedBox(height: 8),
                    Card(
                      color: theme.colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.syncPasswordWarning,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: l10n.syncPasswordLabel,
                      prefixIcon: const Icon(Icons.key_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 8) {
                        return l10n.validatorPasswordLength;
                      }
                      return null;
                    },
                  ),

                  // Confirm field only in create mode
                  if (_isCreateMode) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: l10n.authConfirmPasswordLabel,
                        prefixIcon: const Icon(Icons.key_outlined),
                      ),
                      validator: (v) {
                        if (v != _passwordController.text) {
                          return l10n.authPasswordMismatch;
                        }
                        return null;
                      },
                    ),
                  ],

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.save),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    try {
      final password = _passwordController.text;

      if (_isCreateMode) {
        // Create mode: save password and push initial vault
        final storage = ref.read(secureStorageProvider);
        await storage.saveSyncPassword(password);

        // Push initial vault if there's local data
        ref.read(syncProvider.notifier).pushOnly();

        if (mounted) context.go('/');
      } else {
        // Enter mode: validate password against server vault
        final useCases = ref.read(syncUseCasesProvider);
        final validResult = await useCases.validatePassword(password);

        if (validResult.isFailure || !validResult.value) {
          setState(() {
            _errorMessage = AppLocalizations.of(context)!.syncPasswordWrong;
            _saving = false;
          });
          return;
        }

        // Password is valid — save it
        final storage = ref.read(secureStorageProvider);
        await storage.saveSyncPassword(password);

        if (!mounted) return;

        // Check if we need merge dialog
        await _handleFirstSync(password);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _handleFirstSync(String password) async {
    final servers = ref.read(serverListProvider).valueOrNull ?? [];
    final hasLocalData = servers.isNotEmpty;

    // Check if remote vault has data
    final syncRepo = ref.read(syncRepositoryProvider);
    final vaultResult = await syncRepo.getVault();
    final hasRemoteData = vaultResult.isSuccess &&
        vaultResult.value.blob != null &&
        vaultResult.value.blob!.isNotEmpty;

    if (!mounted) return;

    if (hasLocalData && hasRemoteData) {
      // Both have data — show merge dialog
      final strategy = await showFirstSyncDialog(context);
      if (!mounted) return;
      if (strategy == null) return; // User cancelled

      await _executeFirstSyncStrategy(strategy, password);
    } else if (hasRemoteData) {
      // Only remote — pull
      await ref.read(syncProvider.notifier).pullOnly();
    } else if (hasLocalData) {
      // Only local — push
      await ref.read(syncProvider.notifier).pushOnly();
    }

    if (mounted) context.go('/');
  }

  Future<void> _executeFirstSyncStrategy(
    FirstSyncStrategy strategy,
    String password,
  ) async {
    final syncNotifier = ref.read(syncProvider.notifier);

    switch (strategy) {
      case FirstSyncStrategy.merge:
        await syncNotifier.sync();
      case FirstSyncStrategy.overwriteLocal:
        await syncNotifier.pullOnly();
      case FirstSyncStrategy.keepLocal:
        await syncNotifier.pushOnly();
      case FirstSyncStrategy.deleteLocalAndPull:
        await syncNotifier.pullOnly();
    }
  }
}
