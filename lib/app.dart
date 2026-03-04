import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/routing/app_router.dart';
import 'package:shellvault/core/services/screen_protection_service.dart';
import 'package:shellvault/core/theme/app_theme.dart';
import 'package:shellvault/core/widgets/lock_screen.dart';
import 'package:shellvault/core/network/api_provider.dart';
import 'package:shellvault/features/account/presentation/providers/account_providers.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:shellvault/features/sync/presentation/providers/sync_providers.dart';

class ShellVaultApp extends ConsumerStatefulWidget {
  const ShellVaultApp({super.key});

  @override
  ConsumerState<ShellVaultApp> createState() => _ShellVaultAppState();
}

class _ShellVaultAppState extends ConsumerState<ShellVaultApp> {
  bool _autoSyncTriggered = false;
  final _screenProtection = ScreenProtectionService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerAutoSync();
      _applyScreenProtection();
    });
  }

  void _applyScreenProtection() {
    ref.listenManual(settingsProvider, (_, next) {
      final prevent = next.value?.preventScreenshots ?? false;
      _screenProtection.setEnabled(prevent);
    }, fireImmediately: true);
  }

  void _triggerAutoSync() {
    if (_autoSyncTriggered) return;
    _autoSyncTriggered = true;

    final authStatus = ref.read(authProvider).value;
    final settings = ref.read(settingsProvider).value;

    if (authStatus != AuthStatus.authenticated) return;
    if (!(settings?.autoSync ?? true)) return;

    ref
        .read(billingStatusProvider.future)
        .then((billing) async {
          if (!billing.active || !mounted) return;

          // Check if sync password is set — if not, redirect to create it
          final storage = ref.read(secureStorageProvider);
          final pwResult = await storage.getSyncPassword();
          final pw = pwResult.isSuccess ? pwResult.value : null;
          if (!mounted) return;

          if (pw == null || pw.isEmpty) {
            AppRouter.router.go('/sync-password?mode=create');
          } else {
            ref.read(syncProvider.notifier).sync();
          }
        })
        .catchError((_) {});
  }

  static const _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final themeMode = settingsAsync.value?.themeMode ?? ThemeMode.system;
    final localeSetting = settingsAsync.value?.locale ?? '';
    final locale = localeSetting.isEmpty ? null : Locale(localeSetting);

    return MaterialApp.router(
      title: 'ShellVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router,
      builder: (context, child) => _wrapWithLock(settingsAsync, child),
    );
  }

  Widget _wrapWithLock(AsyncValue settingsAsync, Widget? child) {
    final settings = settingsAsync.value;
    final content = child ?? const SizedBox.shrink();
    if (settings != null && settings.hasAnyLock) {
      return LockScreen(child: content);
    }
    return content;
  }
}
