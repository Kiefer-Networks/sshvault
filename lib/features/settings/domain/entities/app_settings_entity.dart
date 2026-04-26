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
  // Master-key keyring migration (Linux libsecret). Flips to true after the
  // legacy on-disk master key has been moved into the system keyring (or
  // confirmed absent) so the migration only runs once per install.
  final bool keyringMigrationCompleted;

  /// Follow the GNOME / KDE desktop accent color (Linux only). When `true`
  /// and the XDG appearance portal exposes an accent color, the app theme
  /// uses that color as its seed; otherwise it falls back to the built-in
  /// brand color. Has no effect on non-Linux platforms.
  final bool followDesktopAccent;

  // ---------- ssh-agent integration (Linux / macOS) ----------

  /// When `true`, opening an SSH session forwards the user's
  /// `$SSH_AUTH_SOCK` so the remote shell sees the same loaded keys.
  /// Per-host overrides may toggle this on/off (when implemented).
  final bool sshAgentForwardByDefault;

  /// Default lifetime (seconds) used when the user adds an SSHVault key to
  /// the running agent. `0` = no expiry (kept until explicit removal).
  final int sshAgentDefaultLifetimeSecs;

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
    this.keyringMigrationCompleted = false,
    this.followDesktopAccent = true,
    this.sshAgentForwardByDefault = false,
    this.sshAgentDefaultLifetimeSecs = 3600,
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
    bool? keyringMigrationCompleted,
    bool? followDesktopAccent,
    bool? sshAgentForwardByDefault,
    int? sshAgentDefaultLifetimeSecs,
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
      keyringMigrationCompleted:
          keyringMigrationCompleted ?? this.keyringMigrationCompleted,
      followDesktopAccent: followDesktopAccent ?? this.followDesktopAccent,
      sshAgentForwardByDefault:
          sshAgentForwardByDefault ?? this.sshAgentForwardByDefault,
      sshAgentDefaultLifetimeSecs:
          sshAgentDefaultLifetimeSecs ?? this.sshAgentDefaultLifetimeSecs,
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
