import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/routing/app_router.dart';
import 'package:shellvault/core/theme/app_theme.dart';
import 'package:shellvault/core/widgets/lock_screen.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerAutoSync();
    });
  }

  void _triggerAutoSync() {
    if (_autoSyncTriggered) return;
    _autoSyncTriggered = true;

    final authStatus = ref.read(authProvider).valueOrNull;
    final settings = ref.read(settingsProvider).valueOrNull;

    if (authStatus == AuthStatus.authenticated &&
        (settings?.autoSync ?? true)) {
      ref.read(syncProvider.notifier).sync();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final themeMode =
        settingsAsync.valueOrNull?.themeMode ?? ThemeMode.system;
    final localeSetting = settingsAsync.valueOrNull?.locale ?? '';

    return MaterialApp.router(
      title: 'SSH Vault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: localeSetting.isEmpty ? null : Locale(localeSetting),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        final settings = settingsAsync.valueOrNull;
        final content = child ?? const SizedBox.shrink();
        if (settings != null && settings.hasAnyLock) {
          return LockScreen(child: content);
        }
        return content;
      },
    );
  }
}
