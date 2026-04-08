import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/core/widgets/settings/section_card.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
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
          padding: Spacing.paddingAllXxl,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.cloud_sync_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Spacing.verticalLg,
                  Text(
                    l10n.authWhyLogin,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Spacing.verticalXxl,

                  Builder(
                    builder: (context) {
                      final serverUrl =
                          ref.watch(settingsProvider).value?.serverUrl ?? '';
                      if (serverUrl.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Spacing.lg),
                        child: Chip(
                          avatar: const Icon(Icons.dns_outlined, size: 18),
                          label: Text(
                            Uri.parse(serverUrl).host,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      );
                    },
                  ),

                  SectionCard(
                    padding: Spacing.paddingAllXl,
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
                        Spacing.verticalLg,

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: l10n.authPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: Tooltip(
                              message: obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              child: IconButton(
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
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return l10n.validatorPasswordRequired;
                            }
                            return null;
                          },
                        ),
                        Spacing.verticalSm,

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: AdaptiveButton.text(
                            onPressed: () => context.push('/forgot-password'),
                            child: Text(l10n.authForgotPassword),
                          ),
                        ),
                        Spacing.verticalLg,

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
                  Spacing.verticalLg,

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
                  Spacing.verticalSm,
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
