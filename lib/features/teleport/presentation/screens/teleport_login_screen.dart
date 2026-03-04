import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/teleport/presentation/providers/teleport_providers.dart';

class TeleportLoginScreen extends ConsumerStatefulWidget {
  final String clusterId;

  const TeleportLoginScreen({super.key, required this.clusterId});

  @override
  ConsumerState<TeleportLoginScreen> createState() =>
      _TeleportLoginScreenState();
}

class _TeleportLoginScreenState extends ConsumerState<TeleportLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final repo = ref.read(teleportRepositoryProvider);
    final result = await repo.login(
      clusterId: widget.clusterId,
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      otpToken: _otpController.text.trim().isNotEmpty
          ? _otpController.text.trim()
          : null,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      onSuccess: (_) => context.pop(true),
      onFailure: (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.teleportLoginTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: l10n.teleportLoginUsername,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.teleportLoginPassword,
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: l10n.teleportLoginTotpCode,
                prefixIcon: const Icon(Icons.security),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.teleportLoginButton),
            ),
          ],
        ),
      ),
    );
  }
}
