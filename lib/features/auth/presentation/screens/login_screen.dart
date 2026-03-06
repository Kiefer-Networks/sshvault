import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/utils/platform_utils.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/features/account/presentation/providers/account_providers.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

final _obscurePasswordProvider = StateProvider.autoDispose<bool>((_) => true);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        // Check if sync password is set, if not redirect to set it
        _checkSyncPasswordAndNavigate();
      }
      if (next.hasError && mounted) {
        AdaptiveNotification.show(context, message: errorMessage(next.error!));
      }
    });

    return AdaptiveScaffold(
      title: l10n.authLogin,
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
                    Icons.cloud_sync_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.authWhyLogin,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.authPricingInfo(
                              isNativeIapPlatform ? '€12.99' : '€9.99',
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.authPricingHint,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SectionCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Email field
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
                            if (!v.contains('@')) {
                              return l10n.authEmailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          autofillHints: const [AutofillHints.password],
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
                            if (v == null || v.isEmpty) {
                              return l10n.validatorPasswordRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: AdaptiveButton.text(
                            onPressed: () => context.push('/forgot-password'),
                            child: Text(l10n.authForgotPassword),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login button
                        AdaptiveButton.filled(
                          onPressed: isLoading ? null : _login,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.authLogin),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.authNoAccount),
                      AdaptiveButton.text(
                        onPressed: () => context.push('/register'),
                        child: Text(l10n.authRegister),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Self-hosted link
                  AdaptiveButton.text(
                    onPressed: () => context.push('/server-config'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.dns_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(l10n.authSelfHosted),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);
  }

  Future<void> _checkSyncPasswordAndNavigate() async {
    // Check billing status first — no subscription means no vault to decrypt
    final billing = await ref.read(billingStatusProvider.future);
    if (!mounted) return;
    if (!billing.active) {
      context.go('/');
      return;
    }

    final storage = ref.read(secureStorageProvider);
    final syncPwResult = await storage.getSyncPassword();
    final syncPw = syncPwResult.isSuccess ? syncPwResult.value : null;
    if (!mounted) return;
    if (syncPw == null || syncPw.isEmpty) {
      context.go('/sync-password?mode=enter');
    } else {
      context.go('/');
    }
  }
}
