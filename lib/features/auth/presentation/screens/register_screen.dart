import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

final _obscurePasswordProvider = StateProvider.autoDispose<bool>((_) => true);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final obscurePassword = ref.watch(_obscurePasswordProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.value == AuthStatus.authenticated && mounted) {
        context.go('/sync-password?mode=create');
      }
      if (next.hasError && mounted) {
        AdaptiveNotification.show(context, message: errorMessage(next.error!));
      }
    });

    return AdaptiveScaffold(
      title: l10n.authRegister,
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
                    Icons.cloud_sync_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Spacing.verticalXxl,
                  SectionCard(
                    padding: Spacing.paddingAllXl,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: l10n.authEmailLabel,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.authEmailRequired;
                            }
                            if (!v.contains('@')) return l10n.authEmailInvalid;
                            return null;
                          },
                        ),
                        Spacing.verticalLg,
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          autofillHints: const [AutofillHints.newPassword],
                          decoration: InputDecoration(
                            labelText: l10n.authPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () =>
                                  ref
                                          .read(
                                            _obscurePasswordProvider.notifier,
                                          )
                                          .state =
                                      !obscurePassword,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.length < 8) {
                              return l10n.validatorPasswordLength;
                            }
                            return null;
                          },
                        ),
                        Spacing.verticalLg,
                        TextFormField(
                          controller: _confirmController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            labelText: l10n.authConfirmPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outlined),
                          ),
                          validator: (v) {
                            if (v != _passwordController.text) {
                              return l10n.authPasswordMismatch;
                            }
                            return null;
                          },
                        ),
                        Spacing.verticalXxl,
                        AdaptiveButton.filled(
                          onPressed: isLoading ? null : _register,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.authRegister),
                        ),
                      ],
                    ),
                  ),
                  Spacing.verticalLg,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.authHasAccount),
                      AdaptiveButton.text(
                        onPressed: () => context.pop(),
                        child: Text(l10n.authLogin),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .register(_emailController.text.trim(), _passwordController.text);
  }
}
