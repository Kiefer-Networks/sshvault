import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/security/security_providers.dart';
import 'package:sshvault/core/services/desktop_appearance_service.dart';
import 'package:sshvault/core/services/file_drop_service.dart';
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
import 'package:sshvault/core/storage/database_provider.dart';

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
      _pruneOldTombstones();
      _initDesktopAppearance();
    });
  }

  /// Garbage-collect tombstones (`deletedAt < now - 90d`) so the database
  /// doesn't grow indefinitely on a long-running install. Sync runs hourly
  /// or so in practice, so a 90 day window gives offline peers ample time
  /// to receive the deletion before it disappears.
  Future<void> _pruneOldTombstones() async {
    final db = ref.read(databaseProvider);
    final cutoff = DateTime.now().subtract(const Duration(days: 90));
    try {
      await db.serverDao.pruneTombstones(cutoff);
      await db.groupDao.pruneTombstones(cutoff);
      await db.tagDao.pruneTombstones(cutoff);
      await db.sshKeyDao.pruneTombstones(cutoff);
      await db.snippetDao.pruneTombstones(cutoff);
    } catch (e) {
      // Ignore prune errors — they just mean tombstones survive longer than
      // intended, which is correct from a sync perspective.
    }
  }

  /// Eagerly create the desktop appearance service so it connects to the XDG
  /// portal early. The provider is a `Provider` (not auto-dispose), so the
  /// signal subscription survives widget rebuilds. On non-Linux platforms
  /// the service is a cheap no-op.
  void _initDesktopAppearance() {
    ref.read(desktopAppearanceServiceProvider);
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

  /// Watch for attestation results and show warning on failure or key change.
  bool _attestationDialogShown = false;

  void _watchAttestationResult() {
    ref.listenManual(attestationCheckProvider, (prev, next) {
      // Only react to completed results, not AsyncLoading (which preserves
      // the previous value and would re-trigger the dialog during logout).
      if (next is! AsyncData<AttestationStatus>) return;
      final status = next.value;

      if (status == AttestationStatus.passed) {
        _attestationDialogShown = false;
        return;
      }

      if (!mounted || _attestationDialogShown) return;
      _attestationDialogShown = true;

      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null) {
        _attestationDialogShown = false;
        return;
      }

      final l10n = AppLocalizations.of(ctx)!;
      final isKeyChanged = status == AttestationStatus.keyChanged;

      SecurityWarningDialog.show(
        ctx,
        title: isKeyChanged
            ? l10n.attestationKeyChangedTitle
            : l10n.attestationFailedTitle,
        message: isKeyChanged
            ? l10n.attestationKeyChangedMessage
            : l10n.attestationFailedMessage,
        severity: isKeyChanged
            ? SecuritySeverity.critical
            : SecuritySeverity.warning,
        onDisconnect: () {
          Navigator.of(ctx, rootNavigator: true).pop();
          ref.read(authProvider.notifier).logout();
          AppRouter.router.go('/login');
        },
        onContinue: isKeyChanged
            ? null
            : () {
                Navigator.of(ctx, rootNavigator: true).pop();
                LoggingService.instance.warning(
                  'Security',
                  'User chose to continue despite attestation failure',
                );
              },
      );
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
      if (ref.read(authProvider).value != AuthStatus.authenticated) return;

      if (pw != null && pw.isNotEmpty) {
        ref.read(syncProvider.notifier).sync();
      }
      // If no sync password is set, do nothing here — the login/register
      // screens handle the redirect to the sync-password setup page with
      // the correct mode (enter for login, create for registration).
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
    final settings = settingsAsync.value;
    final userMode = settings?.themeMode ?? AppThemeMode.system;

    // When the user picks "system" we prefer the desktop portal's value over
    // `MediaQuery.platformBrightness` because GTK does not always propagate
    // GNOME 42+'s `prefers-color-scheme` to Flutter's view.
    final desktopBrightness = ref.watch(desktopColorSchemeProvider);
    final themeMode = switch (userMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system =>
        desktopBrightness == Brightness.dark
            ? ThemeMode.dark
            : desktopBrightness == Brightness.light
            ? ThemeMode.light
            : ThemeMode.system,
    };

    // Use the desktop accent as the Material 3 seed when the toggle is on
    // and the portal exposed one. Otherwise fall back to the brand color.
    final desktopAccent = ref.watch(desktopAccentColorProvider);
    final followAccent = settings?.followDesktopAccent ?? true;
    final seed = followAccent ? desktopAccent : null;

    final localeSetting = settings?.locale ?? '';
    final locale = localeSetting.isEmpty ? null : Locale(localeSetting);

    return MaterialApp.router(
      title: 'SSHVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLight(seedColor: seed),
      darkTheme: AppTheme.buildDark(seedColor: seed),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final baseTheme = Theme.of(context);
        final scaledTheme = baseTheme.copyWith(
          textTheme: responsiveTextTheme(baseTheme.textTheme, screenWidth),
        );
        return Theme(
          data: scaledTheme,
          child: _wrapWithDropOverlay(_wrapWithLock(settingsAsync, child)),
        );
      },
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

  /// Linux drag-and-drop overlay. Driven by [dragInProgressProvider], which
  /// the C++ side flips via `dragEnter` / `dragLeave` MethodChannel calls.
  /// On non-Linux platforms the provider is never flipped, so this Stack is
  /// effectively a one-child passthrough.
  Widget _wrapWithDropOverlay(Widget child) {
    return Consumer(
      builder: (context, ref, _) {
        final active = ref.watch(dragInProgressProvider);
        return Stack(children: [child, if (active) const _DropOverlay()]);
      },
    );
  }
}

/// Translucent overlay shown while a drag is hovering over the window. Sits
/// on the topmost Stack so it covers every screen including dialogs. Pointer
/// events are ignored so they reach the underlying widgets — GTK handles the
/// actual drop, Flutter just paints the affordance.
class _DropOverlay extends StatelessWidget {
  const _DropOverlay();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.18),
            border: Border.all(color: theme.colorScheme.primary, width: 3),
          ),
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_download_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Drop file here to import',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
