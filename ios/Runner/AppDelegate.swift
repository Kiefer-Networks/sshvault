import CoreSpotlight
import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var secureFields: [UIWindowScene: UITextField] = [:]

  /// Primary channel for iOS-native features. Mirrors the macOS side:
  /// Dart code listens on this channel and routes `openUrl(<urlString>)`
  /// calls into `SshUrlHandler.handle(...)`.
  private var iosChannel: FlutterMethodChannel?

  /// Lazily-initialised generator for iOS notification haptics
  /// (`success` / `warning` / `error`). Apple recommends keeping the
  /// generator alive between calls and `prepare()`-ing it ahead of the
  /// haptic so the Taptic Engine is warm by the time
  /// `notificationOccurred` fires — that's why this is a stored property
  /// rather than a fresh instance per channel call. Touched on the main
  /// thread only, to match `UIFeedbackGenerator`'s threading contract.
  private lazy var notificationFeedbackGenerator: UINotificationFeedbackGenerator = {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    return generator
  }()

  /// URLs that arrived before the Flutter engine + channel were ready.
  /// Drained as soon as `didInitializeImplicitFlutterEngine` wires the
  /// channel.
  private var pendingUrls: [String] = []

  /// Spotlight host ids that arrived before the Flutter engine + channel
  /// were ready (cold launch from a Spotlight tap). Drained alongside
  /// `pendingUrls` once the channel is up.
  private var pendingSpotlightHostIds: [String] = []

  /// Siri / App Intent shortcut activations that arrived before the
  /// Flutter engine + channel were ready (cold launch from a Siri command
  /// or Shortcuts run). Drained alongside `pendingUrls` once the channel
  /// is up.
  private var pendingSiriShortcuts: [(String, [String: Any])] = []

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // BGTaskScheduler requires registration during launch — anything
    // later (e.g. once the Flutter engine is up) is rejected by iOS.
    BackgroundSyncHelper.register()

    // If iOS launched us via an `ssh://` / `sftp://` URL, capture it now.
    // It will be drained once the Flutter engine wires up the channel.
    if let launchOptions = launchOptions,
       let url = launchOptions[.url] as? URL {
      pendingUrls.append(url.absoluteString)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Called by iOS when an `ssh://` / `sftp://` URL is opened while the
  /// app is already running, or after a cold launch when the URL was
  /// captured at `didFinishLaunchingWithOptions` time. We forward the
  /// URL string verbatim — Dart owns the parsing.
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    forwardOrBuffer(url: url)
    return true
  }

  /// Universal Links ("https://sshvault.app/connect/...") arrive here.
  /// We pipe them down the same channel as ssh:// / sftp:// URLs so the
  /// Dart router only has one entry point.
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      forwardOrBuffer(url: url)
      return true
    }
    // Core Spotlight activation — the user picked an SSHVault host from
    // the iOS Spotlight surface. `userInfo[CSSearchableItemActivityIdentifier]`
    // carries the host id we originally indexed via `SpotlightIndexer`; we
    // forward it as `spotlightOpen(hostId)` over the existing iOS channel
    // so the Dart side can route to the connection.
    if userActivity.activityType == CSSearchableItemActionType,
       let hostId = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
       !hostId.isEmpty {
      forwardOrBufferSpotlight(hostId: hostId)
      return true
    }
    // Siri / App Intent activation (ConnectToHostIntent, QuickConnectIntent,
    // ReopenLastIntent, …). The intent's `perform()` already opens the app
    // via deep link, so this channel call is purely additive context for the
    // Dart `IosAppService` which can route it as `siriShortcut(intentName,
    // params)` for richer handling than the URL alone provides.
    let intentName = userActivity.activityType
    var params: [String: Any] = [:]
    if let info = userActivity.userInfo {
      for (key, value) in info {
        if let stringKey = key as? String {
          params[stringKey] = value
        }
      }
    }
    if let title = userActivity.title {
      params["title"] = title
    }
    forwardOrBufferSiriShortcut(intentName: intentName, params: params)
    return true
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ScreenProtectionPlugin")
    let channel = FlutterMethodChannel(
      name: "de.kiefer-networks.sshvault/screen_protection",
      binaryMessenger: registrar!.messenger())
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      switch call.method {
      case "setFlagSecure":
        let args = call.arguments as? [String: Any]
        let enable = args?["enable"] as? Bool ?? false
        DispatchQueue.main.async {
          if enable {
            self.enableScreenProtection()
          } else {
            self.disableScreenProtection()
          }
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // iOS-wide channel. Dart-side listener:
    //   `lib/core/services/ios_app_service.dart`
    let iosRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "SSHVaultIOS")
    let messenger = iosRegistrar?.messenger() ?? registrar!.messenger()
    iosChannel = FlutterMethodChannel(
      name: "de.kiefer_networks.sshvault/ios",
      binaryMessenger: messenger)

    // ActivityKit Live Activity bridge. Gated at runtime by the iOS
    // 16.1 availability check — older devices skip registration so the
    // Dart-side service receives `MissingPluginException` and treats
    // the platform as unsupported. See `LiveActivityBridge.swift`.
    if #available(iOS 16.1, *) {
      LiveActivityBridge.register(with: messenger)
    }

    // Background-sync channel. Dart calls `schedule` / `cancel` to flip
    // the BGTask request; the BGTask handler calls `runBackgroundSync`
    // back into Dart when iOS dispatches the work slot.
    let bgRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "SSHVaultBackgroundSync")
    let bgMessenger = bgRegistrar?.messenger() ?? messenger
    let bgChannel = FlutterMethodChannel(
      name: BackgroundSyncHelper.channelName,
      binaryMessenger: bgMessenger)
    bgChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "schedule":
        let args = call.arguments as? [String: Any]
        let interval = (args?["intervalSeconds"] as? Double) ?? (60 * 60)
        BackgroundSyncHelper.schedule(interval: interval)
        result(nil)
      case "cancel":
        BackgroundSyncHelper.cancel()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    BackgroundSyncHelper.channel = bgChannel

    // Notification-haptic channel. Mirrors
    // `HapticFeedbackHelper.iosNotificationChannel` on the Dart side and
    // exposes `UINotificationFeedbackGenerator` (iOS 10+), which Flutter's
    // built-in `HapticFeedback` API does *not* surface — `HapticFeedback
    // .vibrate()` resolves to `AudioServicesPlaySystemSound` on iOS, not
    // a notification haptic. The Dart helper falls back to a stock
    // impact / `HapticFeedbackConstants` when this channel returns
    // `false` (unknown payload) or is missing entirely (e.g. on test
    // benches without the iOS runtime).
    let hapticRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "SSHVaultHaptic")
    let hapticMessenger = hapticRegistrar?.messenger() ?? messenger
    let hapticChannel = FlutterMethodChannel(
      name: "de.kiefer-networks.sshvault/haptic_notification",
      binaryMessenger: hapticMessenger)
    hapticChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else {
        result(false)
        return
      }
      switch call.method {
      case "notify":
        let args = call.arguments as? [String: Any]
        let type = (args?["type"] as? String) ?? ""
        let feedback: UINotificationFeedbackGenerator.FeedbackType?
        switch type {
        case "success": feedback = .success
        case "warning": feedback = .warning
        case "error": feedback = .error
        default: feedback = nil
        }
        guard let feedback = feedback else {
          // Unknown payload — let the Dart side degrade to its stock
          // fallback rather than firing a wrong-shaped haptic.
          result(false)
          return
        }
        // UIFeedbackGenerator is documented to be touched only from the
        // main thread. Channel handlers already run on the platform
        // (main) thread on iOS, but we hop explicitly to be defensive
        // against future Flutter engine changes.
        DispatchQueue.main.async {
          self.notificationFeedbackGenerator.notificationOccurred(feedback)
          // Re-prime so the Taptic Engine is warm for the next haptic;
          // `prepare()` keeps the generator ready for ~a few seconds and
          // then idles back down to save power.
          self.notificationFeedbackGenerator.prepare()
        }
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // Core Spotlight indexing — wires
    // `de.kiefer_networks.sshvault/spotlight` so Dart can push the host
    // list into Spotlight. Activations land in
    // `application(_:continue:restorationHandler:)` above and are forwarded
    // back over `iosChannel` as `spotlightOpen(hostId)`.
    SpotlightIndexer.register(messenger: messenger)

    // Widget bridge — paired with `lib/core/services/ios_widget_service.dart`.
    // The Flutter side calls `setFavorites(json)` whenever the favorite
    // or recent server lists change. We persist the JSON into the App
    // Group shared `UserDefaults` (the widget extension reads from
    // there) and reload all active widget timelines so the OS rebuilds
    // them. The App Group identifier matches both `Runner.entitlements`
    // and `SshvaultWidget.entitlements`.
    let widgetRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "SSHVaultWidget")
    let widgetMessenger = widgetRegistrar?.messenger() ?? messenger
    let widgetChannel = FlutterMethodChannel(
      name: "de.kiefer_networks.sshvault/ios_widget",
      binaryMessenger: widgetMessenger)
    widgetChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "setFavorites":
        // The Dart side already JSON-encodes the payload so we can
        // write it verbatim — the widget decodes it via `JSONDecoder`.
        guard let payload = call.arguments as? String else {
          result(FlutterError(code: "bad_args", message: "expected JSON string", details: nil))
          return
        }
        if let defaults = UserDefaults(suiteName: "group.de.kiefer_networks.sshvault") {
          defaults.set(payload, forKey: "qc_widget_payload")
        }
        if #available(iOS 14.0, *) {
          WidgetCenter.shared.reloadAllTimelines()
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // Drain anything that arrived before the engine was ready.
    drainPendingUrls()
    drainPendingSpotlightHostIds()
    drainPendingSiriShortcuts()
  }

  /// Forwards [url] over the iOS channel, or buffers it if the channel
  /// isn't up yet. Mirrors the macOS side's `forwardOrBuffer`.
  private func forwardOrBuffer(url: URL) {
    let urlString = url.absoluteString
    if let channel = iosChannel {
      channel.invokeMethod("openUrl", arguments: urlString)
    } else {
      pendingUrls.append(urlString)
    }
  }

  private func drainPendingUrls() {
    guard let channel = iosChannel, !pendingUrls.isEmpty else { return }
    let buffered = pendingUrls
    pendingUrls.removeAll()
    for urlString in buffered {
      channel.invokeMethod("openUrl", arguments: urlString)
    }
  }

  /// Forwards a Spotlight-derived host id over the iOS channel, or buffers
  /// it if the channel isn't up yet (cold launch from a Spotlight tap).
  private func forwardOrBufferSpotlight(hostId: String) {
    if let channel = iosChannel {
      channel.invokeMethod("spotlightOpen", arguments: hostId)
    } else {
      pendingSpotlightHostIds.append(hostId)
    }
  }

  private func drainPendingSpotlightHostIds() {
    guard let channel = iosChannel, !pendingSpotlightHostIds.isEmpty else { return }
    let buffered = pendingSpotlightHostIds
    pendingSpotlightHostIds.removeAll()
    for hostId in buffered {
      channel.invokeMethod("spotlightOpen", arguments: hostId)
    }
  }

  /// Forwards a Siri / App Intent activation over the iOS channel, or
  /// buffers it if the channel isn't up yet (cold launch from a Siri or
  /// Shortcuts invocation).
  private func forwardOrBufferSiriShortcut(
    intentName: String,
    params: [String: Any]
  ) {
    if let channel = iosChannel {
      channel.invokeMethod("siriShortcut", arguments: [
        "intentName": intentName,
        "params": params,
      ])
    } else {
      pendingSiriShortcuts.append((intentName, params))
    }
  }

  private func drainPendingSiriShortcuts() {
    guard let channel = iosChannel, !pendingSiriShortcuts.isEmpty else { return }
    let buffered = pendingSiriShortcuts
    pendingSiriShortcuts.removeAll()
    for (intentName, params) in buffered {
      channel.invokeMethod("siriShortcut", arguments: [
        "intentName": intentName,
        "params": params,
      ])
    }
  }

  private func enableScreenProtection() {
    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene,
            secureFields[windowScene] == nil,
            let window = windowScene.windows.first else { continue }
      let field = UITextField()
      field.isSecureTextEntry = true
      field.translatesAutoresizingMaskIntoConstraints = false
      field.isUserInteractionEnabled = false
      window.addSubview(field)
      field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
      field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
      secureFields[windowScene] = field
    }
  }

  private func disableScreenProtection() {
    for (scene, field) in secureFields {
      field.removeFromSuperview()
      secureFields.removeValue(forKey: scene)
    }
  }
}
