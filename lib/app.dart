import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/security/security_providers.dart';
import 'package:sshvault/core/services/screen_protection_service.dart';
import 'package:sshvault/core/theme/app_theme.dart';
import 'package:sshvault/core/widgets/lock_screen.dart';
import 'package:sshvault/core/widgets/security_warning_dialog.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';

class SSHVaultApp extends ConsumerStatefulWidget {
  const SSHVaultApp({super.key});

  @override
  ConsumerState<SSHVaultApp> createState() => _SSHVaultAppState();
}

class _SSHVaultAppState extends ConsumerState<SSHVaultApp> {
  bool _autoSyncTriggered = false;
  final _screenProtection = ScreenProtectionService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyScreenProtection();
      _listenForAutoSync();
      _watchHeartbeatExpiry();
      _watchAttestationResult();
      _initHeartbeat();
    });
  }

  void _applyScreenProtection() {
    ref.listenManual(settingsProvider, (_, next) {
      final prevent = next.value?.preventScreenshots ?? false;
      _screenProtection.setEnabled(prevent);
    }, fireImmediately: true);
  }

  void _listenForAutoSync() {
    ref.listenManual(authProvider, (prev, next) {
      if (next.value == AuthStatus.authenticated && !_autoSyncTriggered) {
        _autoSyncTriggered = true;
        _triggerAutoSync();
      }
    }, fireImmediately: true);
  }

  /// Initialize heartbeat service when authenticated.
  /// The provider handles start/stop lifecycle via auth state.
  void _initHeartbeat() {
    ref.listenManual(authProvider, (prev, next) {
      if (next.value == AuthStatus.authenticated) {
        // Reading the heartbeat provider starts the service
        ref.read(heartbeatProvider);
      }
    }, fireImmediately: true);
  }

  /// Watch for heartbeat expiry and show critical security warning.
  void _watchHeartbeatExpiry() {
    ref.listenManual(heartbeatExpiredProvider, (prev, next) {
      if (next && mounted) {
        final ctx = rootNavigatorKey.currentContext;
        if (ctx != null) {
          final l10n = AppLocalizations.of(ctx)!;
          SecurityWarningDialog.show(
            ctx,
            title: l10n.connectionLost,
            message: l10n.heartbeatLostMessage,
            severity: SecuritySeverity.critical,
            onDisconnect: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              ref.read(heartbeatExpiredProvider.notifier).state = false;
            },
          );
        }
      }
    }, fireImmediately: false);
  }

  /// Watch for attestation results and show warning on failure.
  void _watchAttestationResult() {
    ref.listenManual(authProvider, (prev, next) {
      if (next.value == AuthStatus.authenticated) {
        // Trigger attestation check as a background task
        _performAttestationCheck();
      }
    }, fireImmediately: true);
  }

  void _performAttestationCheck() {
    // Listen for the attestation result
    ref.listenManual(attestationCheckProvider, (prev, next) {
      final result = next.value;
      if (result == false && mounted) {
        final ctx = rootNavigatorKey.currentContext;
        if (ctx != null) {
          final l10n = AppLocalizations.of(ctx)!;
          SecurityWarningDialog.show(
            ctx,
            title: l10n.attestationFailedTitle,
            message: l10n.attestationFailedMessage,
            severity: SecuritySeverity.warning,
            onDisconnect: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              ref.read(authProvider.notifier).logout();
            },
            onContinue: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              LoggingService.instance.warning(
                'Security',
                'User chose to continue despite attestation failure',
              );
            },
          );
        }
      }
    }, fireImmediately: false);
  }

  void _triggerAutoSync() {
    final settings = ref.read(settingsProvider).value;
    if (!(settings?.autoSync ?? true)) return;

    final auth = ref.read(authProvider).value;
    if (auth != AuthStatus.authenticated) return;

    Future<void>(() async {
      final storage = ref.read(secureStorageProvider);
      final pwResult = await storage.getSyncPassword();
      final pw = pwResult.isSuccess ? pwResult.value : null;
      if (!mounted) return;

      if (pw == null || pw.isEmpty) {
        AppRouter.router.go('/sync-password?mode=create');
      } else {
        ref.read(syncProvider.notifier).sync();
      }
    }).catchError((Object e) {
      LoggingService.instance.warning(
        'SSHVaultApp',
        'Sync password check failed: $e',
      );
    });
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
    final themeMode = switch (settingsAsync.value?.themeMode ?? AppThemeMode.system) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
    final localeSetting = settingsAsync.value?.locale ?? '';
    final locale = localeSetting.isEmpty ? null : Locale(localeSetting);

    return MaterialApp.router(
      title: 'SSHVault',
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
