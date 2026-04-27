import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/security/security_providers.dart';
import 'package:sshvault/core/services/desktop_appearance_service.dart';
import 'package:sshvault/core/services/file_drop_service.dart';
import 'package:sshvault/core/services/global_shortcut_service.dart';
import 'package:sshvault/core/services/headless_boot_service.dart';
import 'package:sshvault/core/services/power_inhibitor_service.dart';
import 'package:sshvault/core/services/screen_protection_service.dart';
import 'package:sshvault/core/services/windows_chrome_service.dart';
import 'package:sshvault/core/theme/app_theme.dart';
import 'package:sshvault/core/theme/dynamic_color_provider.dart';
import 'package:sshvault/core/widgets/lock_screen.dart';
import 'package:sshvault/core/widgets/security_warning_dialog.dart';
import 'package:sshvault/core/widgets/system_ui_overlay.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/connection/presentation/widgets/quick_connect_sheet.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:sshvault/features/terminal/domain/entities/ssh_session_entity.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

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
      _initSshSessionPowerInhibitor();
      _listenForQuickConnectShortcut();
      _wireHeadlessBoot();
      _wireWindowsChrome();
    });
  }

  /// Windows only: re-apply Mica / dark title bar / rounded corners whenever
  /// the user changes the theme or toggles the Appearance switches. The
  /// `applyChrome` call is idempotent and cheap (a couple of FFI writes), so
  /// firing it on every settings emission is safe.
  void _wireWindowsChrome() {
    if (!Platform.isWindows) return;
    ref.listenManual(settingsProvider, (_, next) {
      final s = next.value;
      if (s == null) return;
      final brightness = MediaQuery.maybeOf(context)?.platformBrightness;
      final isDark = switch (s.themeMode) {
        AppThemeMode.light => false,
        AppThemeMode.dark => true,
        AppThemeMode.system => brightness == Brightness.dark,
      };
      WindowsChromeService.instance.applyChrome(
        WindowsChromeOptions(
          backdrop: s.windowsMicaBackdrop
              ? WindowsBackdrop.mica
              : WindowsBackdrop.none,
          roundedCorners: s.windowsRoundCorners,
          darkTheme: isDark,
        ),
      );
    }, fireImmediately: true);
  }

  /// Connects HeadlessBootService to the live providers:
  ///   - Mirrors `closeToTray` / `resumeOnLogin` from settings.
  ///   - Persists active host ids whenever the session list changes so the
  ///     next minimized boot can replay them.
  ///   - On a minimized boot with `resumeOnLogin == true`, replays the
  ///     persisted host ids in the background once auth succeeds.
  void _wireHeadlessBoot() {
    final boot = HeadlessBootService.instance;

    // Push settings flags into the service whenever they change. The very
    // first emission applies the persisted user choices.
    ref.listenManual(settingsProvider, (_, next) {
      final s = next.value;
      if (s == null) return;
      boot.applySettings(
        closeToTraySetting: s.closeToTray,
        resumeOnLoginSetting: s.resumeOnLogin,
      );
    }, fireImmediately: true);

    // Wire persistence callbacks. We capture `ref.read` lazily so the
    // callbacks always see the freshest provider state.
    boot.wirePersistence(
      loadLastActiveHosts: () =>
          ref.read(settingsProvider.notifier).getLastActiveHosts(),
      openSession: (id) =>
          ref.read(sessionManagerProvider.notifier).openSession(id),
    );

    // Track active hosts so we can replay them on the next boot. Only the
    // server ids of fully-connected sessions are persisted to avoid
    // resurrecting half-finished connection attempts.
    ref.listenManual<List<SshSessionEntity>>(sessionManagerProvider, (
      prev,
      next,
    ) {
      final connected = next
          .where((s) => s.status == SshConnectionStatus.connected)
          .map((s) => s.serverId)
          .toSet()
          .toList();
      ref.read(settingsProvider.notifier).setLastActiveHosts(connected);
    }, fireImmediately: false);

    // After auth, replay saved sessions on minimized boot. We piggyback on
    // the existing auth listener so we don't duplicate the lock-screen
    // gating logic.
    ref.listenManual(authProvider, (prev, next) async {
      if (next.value != AuthStatus.authenticated) return;
      if (!boot.isHeadlessBoot) return;
      try {
        await boot.resumeSavedSessions();
      } catch (e) {
        LoggingService.instance.warning(
          'HeadlessBoot',
          'Resume saved sessions failed: $e',
        );
      }
    }, fireImmediately: false);
  }

  /// Eagerly subscribes the power inhibitor watcher so it acquires /
  /// releases the login1 sleep lock based on session count. The provider
  /// pins itself with `keepAlive`, so reading it once is enough — the
  /// internal listeners survive widget rebuilds. On non-Linux platforms
  /// the watcher returns immediately.
  void _initSshSessionPowerInhibitor() {
    ref.read(sshSessionPowerInhibitorProvider);
  }

  /// Linux only: surface the Quick Connect overlay every time the global
  /// shortcut fires. The provider is a [StreamProvider] of monotonically
  /// increasing tick counts, so we react on each new value rather than on
  /// equality (which would suppress repeated activations).
  void _listenForQuickConnectShortcut() {
    if (!Platform.isLinux) return;
    ref.listenManual<AsyncValue<int>>(quickConnectShortcutProvider, (
      prev,
      next,
    ) async {
      final tick = next.value;
      if (tick == null) return;
      if (prev?.value == tick) return;
      // Raise the window first — the user pressed the hotkey from anywhere.
      try {
        await windowManager.show();
        await windowManager.focus();
        HeadlessBootService.instance.markWindowSurfaced();
      } catch (_) {
        // window_manager may not be ready in tests / headless boots — the
        // sheet still renders into whatever's already on screen.
      }
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null && mounted) {
        // ignore: use_build_context_synchronously
        await QuickConnectSheet.show(ctx);
      }
    }, fireImmediately: false);
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
        // Suppress while booted into the tray — surfacing a modal dialog
        // over a hidden window strands the user with no visible
        // affordance. The flag flips off as soon as the user pops the
        // window from the tray; the next listener tick will re-fire.
        if (HeadlessBootService.instance.isHeadlessBoot) return;
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
      // Defer the dialog while booted into the tray — there's no window
      // to anchor it to. The notifier keeps emitting, so the next time
      // the user surfaces the window we re-evaluate and show it.
      if (HeadlessBootService.instance.isHeadlessBoot) return;
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
    Color? seed = followAccent ? desktopAccent : null;

    // Material You override on Android 12+. The dynamic color provider
    // is an `AsyncValue<CorePalette?>`; we only consume a successful
    // payload (`AsyncData` with non-null palette) to avoid flicker
    // during the very first frame while the platform channel resolves.
    // The user-facing toggle gates this — flipping it off falls back to
    // the brand seed without restarting the app.
    final followDynamic = settings?.followDynamicColor ?? true;
    if (Platform.isAndroid && followDynamic) {
      final dynamicPalette = ref.watch(dynamicColorProvider);
      final corePalette = dynamicPalette.value;
      if (corePalette != null) {
        // CorePalette.primary is a TonalPalette; tone 40 is the canonical
        // "key color" used by Material 3 as the primary anchor and is the
        // value the framework's own `ColorScheme.fromSeed` derivation
        // expects.
        seed = Color(corePalette.primary.get(40));
      }
    }

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
        // Drive Android system bar styling from the *resolved* theme
        // brightness (after themeMode + platform brightness collapse).
        // EdgeToEdgeSystemUi is a no-op on non-mobile platforms.
        final brightness = scaledTheme.brightness;
        // Imperatively re-apply too: AnnotatedRegion only kicks in once a
        // route is built, but we want the very first frame post-runApp to
        // already have transparent bars + correct icon contrast.
        EdgeToEdgeSystemUi.apply(brightness);
        return Theme(
          data: scaledTheme,
          child: EdgeToEdgeSystemUi(
            brightness: brightness,
            child: _wrapWithDropOverlay(_wrapWithLock(settingsAsync, child)),
          ),
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
