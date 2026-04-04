import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:sshvault/features/sync/presentation/widgets/first_sync_dialog.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

enum SyncPasswordMode { create, enter }

class _SyncPasswordFormState {
  final bool obscure;
  final bool saving;
  final String? errorMessage;

  const _SyncPasswordFormState({
    this.obscure = true,
    this.saving = false,
    this.errorMessage,
  });

  _SyncPasswordFormState copyWith({
    bool? obscure,
    bool? saving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return _SyncPasswordFormState(
      obscure: obscure ?? this.obscure,
      saving: saving ?? this.saving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class _SyncPasswordFormNotifier extends Notifier<_SyncPasswordFormState> {
  @override
  _SyncPasswordFormState build() => const _SyncPasswordFormState();

  void toggleObscure() {
    state = state.copyWith(obscure: !state.obscure);
  }

  void setSaving(bool value) {
    state = state.copyWith(saving: value);
  }

  void setError(String? value) {
    if (value == null) {
      state = state.copyWith(clearError: true);
    } else {
      state = state.copyWith(errorMessage: value);
    }
  }

  void startSaving() {
    state = state.copyWith(saving: true, clearError: true);
  }
}

final _syncPasswordFormProvider =
    NotifierProvider.autoDispose<
      _SyncPasswordFormNotifier,
      _SyncPasswordFormState
    >(_SyncPasswordFormNotifier.new);

class SyncPasswordScreen extends ConsumerStatefulWidget {
  final SyncPasswordMode mode;

  const SyncPasswordScreen({super.key, this.mode = SyncPasswordMode.create});

  @override
  ConsumerState<SyncPasswordScreen> createState() => _SyncPasswordScreenState();
}

class _SyncPasswordScreenState extends ConsumerState<SyncPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

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
    final formState = ref.watch(_syncPasswordFormProvider);

    return AdaptiveScaffold(
      title: _isCreateMode
          ? l10n.syncPasswordTitleCreate
          : l10n.syncPasswordTitleEnter,
      body: Center(
        child: SingleChildScrollView(
          padding: Spacing.paddingAllXxl,
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
                  Spacing.verticalLg,
                  Text(
                    _isCreateMode
                        ? l10n.syncPasswordDescription
                        : l10n.syncPasswordHintEnter,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (_isCreateMode) ...[
                    Spacing.verticalSm,
                    Card(
                      color: theme.colorScheme.errorContainer,
                      child: Padding(
                        padding: Spacing.paddingAllMd,
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                            Spacing.horizontalMd,
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
                  Spacing.verticalXxl,

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: formState.obscure,
                    decoration: InputDecoration(
                      labelText: l10n.syncPasswordLabel,
                      prefixIcon: const Icon(Icons.key_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          formState.obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => ref
                            .read(_syncPasswordFormProvider.notifier)
                            .toggleObscure(),
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
                    Spacing.verticalLg,
                    TextFormField(
                      controller: _confirmController,
                      obscureText: formState.obscure,
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
                  if (formState.errorMessage != null) ...[
                    Spacing.verticalMd,
                    Text(
                      formState.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  Spacing.verticalXxl,
                  AdaptiveButton.filled(
                    onPressed: formState.saving ? null : _save,
                    child: formState.saving
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
    final l10n = AppLocalizations.of(context)!;
    ref.read(_syncPasswordFormProvider.notifier).startSaving();

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
          ref
              .read(_syncPasswordFormProvider.notifier)
              .setError(l10n.syncPasswordWrong);
          ref.read(_syncPasswordFormProvider.notifier).setSaving(false);
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
      if (mounted) {
        ref.read(_syncPasswordFormProvider.notifier).setSaving(false);
      }
    }
  }

  Future<void> _handleFirstSync(String password) async {
    final servers = ref.read(serverListProvider).value ?? [];
    final hasLocalData = servers.isNotEmpty;

    // Check if remote vault has data
    final syncRepo = ref.read(syncRepositoryProvider);
    final vaultResult = await syncRepo.getVault();
    final hasRemoteData =
        vaultResult.isSuccess &&
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
