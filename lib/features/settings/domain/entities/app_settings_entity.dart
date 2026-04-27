import 'package:sshvault/core/constants/app_constants.dart';
import 'package:sshvault/features/connection/domain/entities/proxy_config.dart';

enum AppThemeMode { system, light, dark }

class AppSettingsEntity {
  final AppThemeMode themeMode;
  final int defaultSshPort;
  final String defaultUsername;
  final int autoLockMinutes;
  final bool biometricUnlock;
  final bool encryptExportByDefault;
  final String pinHash;
  final String pinSalt;
  final bool dismissedSecurityHint;
  final String locale;
  final int failedPinAttempts;
  final DateTime? lockoutUntil;
  final String serverUrl;
  final bool selfHosted;
  final bool autoSync;
  final int autoSyncIntervalMinutes;

  /// Android-only: when `true`, schedule a WorkManager periodic worker
  /// that runs the sync pipeline even with the app closed. Default-off
  /// (opt-in) so we don't burn battery on devices the user hasn't
  /// configured for sync. The `AndroidBackgroundSyncService` enforces
  /// the platform gate; on iOS / desktop the flag round-trips harmlessly.
  final bool backgroundSyncEnabled;
  final int localVaultVersion;
  final bool preventScreenshots;
  final String dnsServers;
  // SSH defaults
  final String defaultAuthMethod;
  final int connectionTimeoutSecs;
  final int keepaliveIntervalSecs;
  final bool sshCompression;
  final String defaultTerminalType;
  // Security
  final int clipboardAutoClearSecs;
  final int sessionTimeoutMins;
  final String duressPinHash;
  final String duressPinSalt;
  final int keyRotationReminderDays;
  // Global Proxy
  final String globalProxyType;
  final String globalProxyHost;
  final int globalProxyPort;
  final String globalProxyUsername;
  // Desktop integration
  /// Show a system tray icon on Linux / Windows. Ignored on macOS / mobile.
  final bool showSystemTray;

  /// Enroll SSHVault with the desktop session's auto-start system so it
  /// launches at login (minimized to tray). Linux only — implemented via
  /// an XDG `.desktop` file under `~/.config/autostart/`.
  final bool autoStartEnabled;

  /// When `true`, clicking the [×] window-close button hides the window
  /// instead of quitting (Linux / Windows only). Off by default so we don't
  /// surprise users on first launch.
  final bool closeToTray;

  /// When the binary is started with `--minimized`, automatically reopen the
  /// hosts that were active in the previous session. Sessions are restored
  /// in the background — the window stays hidden until the user pops it
  /// from the tray.
  final bool resumeOnLogin;
  // Master-key keyring migration (Linux libsecret). Flips to true after the
  // legacy on-disk master key has been moved into the system keyring (or
  // confirmed absent) so the migration only runs once per install.
  final bool keyringMigrationCompleted;

  /// Windows-only: flips to `true` after the runtime registrar has written
  /// the ssh:// / sftp:// URL handlers + .pub/.pem/.ppk file associations
  /// to HKCU (or detected that the Inno installer already did). Used to
  /// suppress the first-run "Register SSHVault as default ssh:// handler?"
  /// dialog. Ignored on non-Windows platforms.
  final bool windowsProtocolRegistered;

  /// Follow the GNOME / KDE desktop accent color (Linux only). When `true`
  /// and the XDG appearance portal exposes an accent color, the app theme
  /// uses that color as its seed; otherwise it falls back to the built-in
  /// brand color. Has no effect on non-Linux platforms.
  final bool followDesktopAccent;

  /// Follow the Android 12+ Material You / wallpaper-derived accent color.
  /// When `true` and the platform exposes a [CorePalette] via the
  /// `dynamic_color` plugin, the app theme uses the palette's primary
  /// color as its Material 3 seed; otherwise it falls back to the
  /// built-in brand color. Has no effect on non-Android platforms.
  final bool followDynamicColor;

  // ---------- ssh-agent integration (Linux / macOS) ----------

  /// When `true`, opening an SSH session forwards the user's
  /// `$SSH_AUTH_SOCK` so the remote shell sees the same loaded keys.
  /// Per-host overrides may toggle this on/off (when implemented).
  final bool sshAgentForwardByDefault;

  /// Default lifetime (seconds) used when the user adds an SSHVault key to
  /// the running agent. `0` = no expiry (kept until explicit removal).
  final int sshAgentDefaultLifetimeSecs;

  // ---------- Power management (Linux only) ----------

  /// When `true` (default), the app holds an
  /// `org.freedesktop.login1.Manager.Inhibit("sleep:idle", ..., "block")`
  /// lock for as long as at least one SSH session is open, preventing the
  /// system from auto-suspending mid-session. Ignored on non-Linux
  /// platforms (the underlying service is a no-op there).
  final bool preventSuspendDuringSshSessions;

  // ---------- Desktop window geometry persistence (Linux/Windows/macOS) ----------

  /// Last-known logical width of the main window. Restored at boot before
  /// the window is shown to avoid a "flash" at the default size. Default
  /// (1280) is applied by the WindowStateService when no value is saved.
  /// Ignored on web / mobile.
  final double windowWidth;

  /// Last-known logical height of the main window. Default 800.
  final double windowHeight;

  /// Last-known X coordinate (logical px) of the top-left corner. A
  /// negative value means "no saved position — let the OS center the
  /// window". The clamping logic in WindowStateService rejects obviously
  /// off-screen values too.
  final double windowX;

  /// Last-known Y coordinate (logical px) of the top-left corner.
  final double windowY;

  /// Whether the window was maximized at last close. Re-applied after
  /// `setSize` / `setPosition` during boot.
  final bool windowMaximized;

  // ---------- HiDPI / pixel-ratio override (Linux desktops) ----------

  /// User-forced device pixel ratio. `0.0` means "auto" — fall back to the
  /// platform-provided value from `MediaQuery`. Otherwise the value is used
  /// verbatim everywhere `effectiveDevicePixelRatio` is consulted. Useful
  /// for users on misconfigured Wayland fractional-scaling setups where GTK
  /// reports a stale or wrong scale to the embedded FlView.
  final double forcedPixelRatio;

  // ---------- Windows-only: native toast notifications ----------

  /// When `true` (default), session toasts on Windows render with action
  /// buttons ("Disconnect", "Show") instead of body-only. Power users who
  /// find the buttons cluttered in the Action Center can flip this off in
  /// Settings → Notifications. Ignored on non-Windows platforms.
  final bool windowsToastActionsEnabled;

  // ---------- macOS-only: native UNUserNotificationCenter toasts ----------

  /// When `true` (default), session toasts on macOS render with action
  /// buttons ("Disconnect", "Show") in Notification Center via the native
  /// `UNUserNotificationCenter` API. Mirrors [windowsToastActionsEnabled];
  /// ignored on non-macOS platforms.
  final bool macosToastActionsEnabled;

  // ---------- Windows 11 chrome (Mica / rounded corners) ----------

  /// Use Windows 11 Mica backdrop (Acrylic on Win10). Default `true`.
  /// Ignored on non-Windows platforms — the chrome service is gated by
  /// `Platform.isWindows` so the flag round-trips harmlessly.
  final bool windowsMicaBackdrop;

  /// Apply rounded window corners on Windows 11. Default `true`. Win10
  /// silently ignores the DWM call (E_INVALIDARG), so leaving this on
  /// costs nothing there.
  final bool windowsRoundCorners;

  // ---------- Android-only: Picture-in-Picture ----------

  /// When `true` (default), pressing Home with at least one active SSH
  /// session floats SSHVault into an Android Picture-in-Picture window so
  /// the terminal stays visible while the user works in another app.
  /// Ignored on non-Android platforms — the flag still round-trips through
  /// the entity but [AndroidPipService] short-circuits on iOS / desktop.
  final bool pictureInPictureEnabled;

  const AppSettingsEntity({
    this.themeMode = AppThemeMode.system,
    this.defaultSshPort = 22,
    this.defaultUsername = 'root',
    this.autoLockMinutes = 5,
    this.biometricUnlock = false,
    this.encryptExportByDefault = true,
    this.pinHash = '',
    this.pinSalt = '',
    this.dismissedSecurityHint = false,
    this.locale = '',
    this.failedPinAttempts = 0,
    this.lockoutUntil,
    this.serverUrl = '',
    this.selfHosted = false,
    this.autoSync = true,
    this.autoSyncIntervalMinutes = 5,
    this.backgroundSyncEnabled = false,
    this.localVaultVersion = 0,
    this.preventScreenshots = false,
    this.dnsServers = '',
    this.defaultAuthMethod = 'password',
    this.connectionTimeoutSecs = 30,
    this.keepaliveIntervalSecs = 15,
    this.sshCompression = false,
    this.defaultTerminalType = 'xterm-256color',
    this.clipboardAutoClearSecs = 0,
    this.sessionTimeoutMins = 0,
    this.duressPinHash = '',
    this.duressPinSalt = '',
    this.keyRotationReminderDays = 0,
    this.globalProxyType = 'none',
    this.globalProxyHost = '',
    this.globalProxyPort = 1080,
    this.globalProxyUsername = '',
    this.showSystemTray = true,
    this.autoStartEnabled = false,
    this.closeToTray = false,
    this.resumeOnLogin = false,
    this.keyringMigrationCompleted = false,
    this.windowsProtocolRegistered = false,
    this.followDesktopAccent = true,
    this.followDynamicColor = true,
    this.sshAgentForwardByDefault = false,
    this.sshAgentDefaultLifetimeSecs = 3600,
    this.preventSuspendDuringSshSessions = true,
    this.windowWidth = 1280,
    this.windowHeight = 800,
    this.windowX = -1,
    this.windowY = -1,
    this.windowMaximized = false,
    this.forcedPixelRatio = 0,
    this.windowsToastActionsEnabled = true,
    this.macosToastActionsEnabled = true,
    this.windowsMicaBackdrop = true,
    this.windowsRoundCorners = true,
    this.pictureInPictureEnabled = true,
  });

  bool get hasPin => pinHash.isNotEmpty;
  bool get hasDuressPin => duressPinHash.isNotEmpty;
  bool get hasAnyLock => biometricUnlock || hasPin;

  bool get isLockedOut {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil!);
  }

  Duration get remainingLockout {
    if (lockoutUntil == null) return Duration.zero;
    final remaining = lockoutUntil!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get shouldLockout => failedPinAttempts >= AppConstants.maxPinAttempts;

  AppSettingsEntity copyWith({
    AppThemeMode? themeMode,
    int? defaultSshPort,
    String? defaultUsername,
    int? autoLockMinutes,
    bool? biometricUnlock,
    bool? encryptExportByDefault,
    String? pinHash,
    String? pinSalt,
    bool? dismissedSecurityHint,
    String? locale,
    int? failedPinAttempts,
    DateTime? lockoutUntil,
    bool clearLockout = false,
    String? serverUrl,
    bool? selfHosted,
    bool? autoSync,
    int? autoSyncIntervalMinutes,
    bool? backgroundSyncEnabled,
    int? localVaultVersion,
    bool? preventScreenshots,
    String? dnsServers,
    String? defaultAuthMethod,
    int? connectionTimeoutSecs,
    int? keepaliveIntervalSecs,
    bool? sshCompression,
    String? defaultTerminalType,
    int? clipboardAutoClearSecs,
    int? sessionTimeoutMins,
    String? duressPinHash,
    String? duressPinSalt,
    int? keyRotationReminderDays,
    String? globalProxyType,
    String? globalProxyHost,
    int? globalProxyPort,
    String? globalProxyUsername,
    bool? showSystemTray,
    bool? autoStartEnabled,
    bool? closeToTray,
    bool? resumeOnLogin,
    bool? keyringMigrationCompleted,
    bool? windowsProtocolRegistered,
    bool? followDesktopAccent,
    bool? followDynamicColor,
    bool? sshAgentForwardByDefault,
    int? sshAgentDefaultLifetimeSecs,
    bool? preventSuspendDuringSshSessions,
    double? windowWidth,
    double? windowHeight,
    double? windowX,
    double? windowY,
    bool? windowMaximized,
    double? forcedPixelRatio,
    bool? windowsToastActionsEnabled,
    bool? macosToastActionsEnabled,
    bool? windowsMicaBackdrop,
    bool? windowsRoundCorners,
    bool? pictureInPictureEnabled,
  }) {
    return AppSettingsEntity(
      themeMode: themeMode ?? this.themeMode,
      defaultSshPort: defaultSshPort ?? this.defaultSshPort,
      defaultUsername: defaultUsername ?? this.defaultUsername,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
      biometricUnlock: biometricUnlock ?? this.biometricUnlock,
      encryptExportByDefault:
          encryptExportByDefault ?? this.encryptExportByDefault,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      dismissedSecurityHint:
          dismissedSecurityHint ?? this.dismissedSecurityHint,
      locale: locale ?? this.locale,
      failedPinAttempts: failedPinAttempts ?? this.failedPinAttempts,
      lockoutUntil: clearLockout ? null : (lockoutUntil ?? this.lockoutUntil),
      serverUrl: serverUrl ?? this.serverUrl,
      selfHosted: selfHosted ?? this.selfHosted,
      autoSync: autoSync ?? this.autoSync,
      autoSyncIntervalMinutes:
          autoSyncIntervalMinutes ?? this.autoSyncIntervalMinutes,
      backgroundSyncEnabled:
          backgroundSyncEnabled ?? this.backgroundSyncEnabled,
      localVaultVersion: localVaultVersion ?? this.localVaultVersion,
      preventScreenshots: preventScreenshots ?? this.preventScreenshots,
      dnsServers: dnsServers ?? this.dnsServers,
      defaultAuthMethod: defaultAuthMethod ?? this.defaultAuthMethod,
      connectionTimeoutSecs:
          connectionTimeoutSecs ?? this.connectionTimeoutSecs,
      keepaliveIntervalSecs:
          keepaliveIntervalSecs ?? this.keepaliveIntervalSecs,
      sshCompression: sshCompression ?? this.sshCompression,
      defaultTerminalType: defaultTerminalType ?? this.defaultTerminalType,
      clipboardAutoClearSecs:
          clipboardAutoClearSecs ?? this.clipboardAutoClearSecs,
      sessionTimeoutMins: sessionTimeoutMins ?? this.sessionTimeoutMins,
      duressPinHash: duressPinHash ?? this.duressPinHash,
      duressPinSalt: duressPinSalt ?? this.duressPinSalt,
      keyRotationReminderDays:
          keyRotationReminderDays ?? this.keyRotationReminderDays,
      globalProxyType: globalProxyType ?? this.globalProxyType,
      globalProxyHost: globalProxyHost ?? this.globalProxyHost,
      globalProxyPort: globalProxyPort ?? this.globalProxyPort,
      globalProxyUsername: globalProxyUsername ?? this.globalProxyUsername,
      showSystemTray: showSystemTray ?? this.showSystemTray,
      autoStartEnabled: autoStartEnabled ?? this.autoStartEnabled,
      closeToTray: closeToTray ?? this.closeToTray,
      resumeOnLogin: resumeOnLogin ?? this.resumeOnLogin,
      keyringMigrationCompleted:
          keyringMigrationCompleted ?? this.keyringMigrationCompleted,
      windowsProtocolRegistered:
          windowsProtocolRegistered ?? this.windowsProtocolRegistered,
      followDesktopAccent: followDesktopAccent ?? this.followDesktopAccent,
      followDynamicColor: followDynamicColor ?? this.followDynamicColor,
      sshAgentForwardByDefault:
          sshAgentForwardByDefault ?? this.sshAgentForwardByDefault,
      sshAgentDefaultLifetimeSecs:
          sshAgentDefaultLifetimeSecs ?? this.sshAgentDefaultLifetimeSecs,
      preventSuspendDuringSshSessions:
          preventSuspendDuringSshSessions ??
          this.preventSuspendDuringSshSessions,
      windowWidth: windowWidth ?? this.windowWidth,
      windowHeight: windowHeight ?? this.windowHeight,
      windowX: windowX ?? this.windowX,
      windowY: windowY ?? this.windowY,
      windowMaximized: windowMaximized ?? this.windowMaximized,
      forcedPixelRatio: forcedPixelRatio ?? this.forcedPixelRatio,
      windowsToastActionsEnabled:
          windowsToastActionsEnabled ?? this.windowsToastActionsEnabled,
      macosToastActionsEnabled:
          macosToastActionsEnabled ?? this.macosToastActionsEnabled,
      windowsMicaBackdrop: windowsMicaBackdrop ?? this.windowsMicaBackdrop,
      windowsRoundCorners: windowsRoundCorners ?? this.windowsRoundCorners,
      pictureInPictureEnabled:
          pictureInPictureEnabled ?? this.pictureInPictureEnabled,
    );
  }

  ProxyConfig get globalProxyConfig {
    final type = ProxyType.values.firstWhere(
      (e) => e.name == globalProxyType,
      orElse: () => ProxyType.none,
    );
    if (type == ProxyType.none) return const ProxyConfig();
    return ProxyConfig(
      type: type,
      host: globalProxyHost,
      port: globalProxyPort,
      username: globalProxyUsername.isEmpty ? null : globalProxyUsername,
    );
  }

  /// Returns the list of configured DNS-over-HTTPS server URLs.
  /// If empty, uses the built-in defaults (Cloudflare + Google).
  List<String> get dnsServerList {
    if (dnsServers.isEmpty) return const [];
    return dnsServers
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
