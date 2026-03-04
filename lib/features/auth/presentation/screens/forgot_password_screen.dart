import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/error/failures.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class _ForgotPasswordState {
  final bool sent;
  final bool loading;

  const _ForgotPasswordState({this.sent = false, this.loading = false});

  _ForgotPasswordState copyWith({bool? sent, bool? loading}) {
    return _ForgotPasswordState(
      sent: sent ?? this.sent,
      loading: loading ?? this.loading,
    );
  }
}

class _ForgotPasswordNotifier extends Notifier<_ForgotPasswordState> {
  @override
  _ForgotPasswordState build() => const _ForgotPasswordState();

  void setLoading(bool value) {
    state = state.copyWith(loading: value);
  }

  void setSent(bool value) {
    state = state.copyWith(sent: value);
  }
}

final _forgotPasswordProvider =
    NotifierProvider.autoDispose<_ForgotPasswordNotifier, _ForgotPasswordState>(
      _ForgotPasswordNotifier.new,
    );

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fpState = ref.watch(_forgotPasswordProvider);

    return AdaptiveScaffold(
      title: l10n.authForgotPassword,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: fpState.sent
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mark_email_read_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.authResetEmailSent,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      AdaptiveButton.filled(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.authBackToLogin),
                      ),
                    ],
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.authResetDescription,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: l10n.authEmailLabel,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.authEmailRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AdaptiveButton.filled(
                          onPressed: fpState.loading ? null : _sendReset,
                          child: fpState.loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.authSendResetLink),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(_forgotPasswordProvider.notifier).setLoading(true);
    try {
      await ref
          .read(authProvider.notifier)
          .forgotPassword(_emailController.text.trim());
      if (mounted) ref.read(_forgotPasswordProvider.notifier).setSent(true);
    } catch (e) {
      if (mounted) {
        AdaptiveNotification.show(context, message: errorMessage(e));
      }
    } finally {
      if (mounted) {
        ref.read(_forgotPasswordProvider.notifier).setLoading(false);
      }
    }
  }
}
