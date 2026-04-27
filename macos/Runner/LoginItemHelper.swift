import Foundation
import FlutterMacOS
#if canImport(ServiceManagement)
import ServiceManagement
#endif

/// Bridges the Login Item ("open at login") toggle into the Dart layer over
/// the `de.kiefer_networks.sshvault/login_item` MethodChannel.
///
/// Strategy:
///   * macOS 13+ uses `SMAppService.mainApp` — the modern, sandbox-safe
///     replacement for the deprecated `SMLoginItemSetEnabled` and the
///     legacy `LSSharedFileList` APIs. The system handles the bookkeeping
///     and the user sees the entry under "System Settings > General >
///     Login Items".
///   * macOS 12 and older fall back to writing a per-user launchd agent at
///     `~/Library/LaunchAgents/de.kiefer_networks.SSHVault.plist`. This is
///     loaded automatically by `launchd` at next login (we do not call
///     `launchctl load` here — it would only affect the current session,
///     and the next login picks the agent up regardless).
///
/// All three methods (`isEnabled`, `enable`, `disable`) report errors via
/// `FlutterError` so the Dart side can surface a single consistent failure
/// path.
enum LoginItemHelper {
  /// Reverse-DNS identifier shared with the Linux/Windows backends and the
  /// `Info.plist`'s `CFBundleIdentifier`. Used as the `.plist` filename and
  /// the launchd `Label`.
  static let bundleIdentifier = "de.kiefer_networks.SSHVault"

  /// Channel name. Must match the Dart side in
  /// `lib/core/services/autostart_service.dart`.
  static let channelName = "de.kiefer_networks.sshvault/login_item"

  /// Wires the channel onto the engine's binary messenger. Called from
  /// `AppDelegate.applicationDidFinishLaunching` after the engine is up.
  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: messenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "isEnabled":
        result(isEnabled())
      case "enable":
        do {
          try enable()
          result(true)
        } catch {
          result(
            FlutterError(
              code: "ENABLE_FAILED",
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      case "disable":
        do {
          try disable()
          result(true)
        } catch {
          result(
            FlutterError(
              code: "DISABLE_FAILED",
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  // MARK: - Public state

  /// Returns `true` when the Login Item is currently active. On macOS 13+
  /// this consults `SMAppService.mainApp.status`; on older systems we
  /// check whether the launchd plist exists on disk.
  static func isEnabled() -> Bool {
    #if canImport(ServiceManagement)
    if #available(macOS 13.0, *) {
      return SMAppService.mainApp.status == .enabled
    }
    #endif
    return FileManager.default.fileExists(atPath: legacyPlistPath())
  }

  /// Enables the Login Item. macOS 13+ delegates to `SMAppService`; older
  /// versions write a launchd agent plist. Throws on I/O or registration
  /// failure so the Dart layer can surface the error.
  static func enable() throws {
    #if canImport(ServiceManagement)
    if #available(macOS 13.0, *) {
      try SMAppService.mainApp.register()
      return
    }
    #endif
    try writeLegacyPlist()
  }

  /// Disables the Login Item. macOS 13+ unregisters via `SMAppService`;
  /// older versions delete the launchd plist. Missing-file deletion is a
  /// no-op (already in the desired state).
  static func disable() throws {
    #if canImport(ServiceManagement)
    if #available(macOS 13.0, *) {
      try SMAppService.mainApp.unregister()
      return
    }
    #endif
    try removeLegacyPlist()
  }

  // MARK: - Legacy launchd fallback (macOS 12 and older)

  /// Absolute path to the per-user launchd agent we own.
  private static func legacyPlistPath() -> String {
    let home =
      FileManager.default.homeDirectoryForCurrentUser.path
    return "\(home)/Library/LaunchAgents/\(bundleIdentifier).plist"
  }

  /// Writes a minimal `LaunchAgent` plist. `RunAtLoad=true` triggers the
  /// agent at the next user login. `KeepAlive` is intentionally omitted —
  /// SSHVault is a UI app, not a daemon, and the user must be free to
  /// quit it without launchd respawning the process.
  private static func writeLegacyPlist() throws {
    let exePath = Bundle.main.executablePath ?? Bundle.main.bundlePath
    let plist: [String: Any] = [
      "Label": bundleIdentifier,
      "ProgramArguments": [exePath, "--minimized"],
      "RunAtLoad": true,
      "ProcessType": "Interactive",
    ]
    let data = try PropertyListSerialization.data(
      fromPropertyList: plist,
      format: .xml,
      options: 0
    )
    let path = legacyPlistPath()
    let dir = (path as NSString).deletingLastPathComponent
    try FileManager.default.createDirectory(
      atPath: dir,
      withIntermediateDirectories: true,
      attributes: nil
    )
    try data.write(to: URL(fileURLWithPath: path), options: .atomic)
  }

  /// Removes the launchd plist if present. Treats "already absent" as
  /// success because the desired post-condition (no autostart) holds.
  private static func removeLegacyPlist() throws {
    let path = legacyPlistPath()
    if FileManager.default.fileExists(atPath: path) {
      try FileManager.default.removeItem(atPath: path)
    }
  }
}
