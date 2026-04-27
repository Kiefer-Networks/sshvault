import Flutter
import UIKit

/// User-activity type used to encode the host id when spawning a new
/// scene from Flutter. Must match `IosWindowService._activityType` on the
/// Dart side.
private let kSshVaultSessionActivityType = "de.kiefer_networks.sshvault.session"

/// User-info key carrying the host id inside the activity payload.
private let kSshVaultHostIdKey = "hostId"

/// Method-channel name shared with `lib/core/services/ios_window_service.dart`.
private let kIosWindowsChannel = "de.kiefer_networks.sshvault/ios_windows"

class SceneDelegate: FlutterSceneDelegate {
  /// Strong reference so the drop handler outlives the scene callback.
  /// Mirrors the `dropHandler` field on `MainFlutterWindow.swift`.
  private var dragDropHandler: DragDropHandler?

  /// Per-scene method channel for the multi-window bridge. Each scene owns
  /// its own FlutterEngine, so we install one channel per scene rather than
  /// using `AppDelegate`'s global registrar.
  private var iosWindowsChannel: FlutterMethodChannel?

  /// Per-scene UIKeyCommand registrar. Retained so the registered commands
  /// outlive `scene(_:willConnectTo:)`; the FlutterViewController only holds
  /// a weak reference to its target.
  private var keyboardShortcuts: KeyboardShortcuts?

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    guard let windowScene = scene as? UIWindowScene else { return }

    // Enable full-screen on iPad by default
    if #available(iOS 16.0, *) {
      windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
    }

    // Install the iPadOS drag-and-drop bridge once the FlutterViewController
    // is reachable. We probe the scene's first window's rootViewController —
    // FlutterSceneDelegate has set this up by the time `super.scene(...)`
    // returns. If the controller isn't ready yet (rare, but possible during
    // cold launch), retry on the next runloop tick.
    installDragAndDrop(on: windowScene)
    installIosWindowsChannel(on: windowScene)
    installKeyboardShortcuts(on: windowScene)

    // If this scene was spawned for a specific session (via
    // `requestSceneSessionActivation`), forward the host id to Flutter so
    // it can route to that session on first frame.
    if let activity = connectionOptions.userActivities.first
      ?? session.stateRestorationActivity,
       activity.activityType == kSshVaultSessionActivityType,
       let hostId = activity.userInfo?[kSshVaultHostIdKey] as? String {
      forwardInitialSession(hostId: hostId)
    }
  }

  override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if userActivity.activityType == kSshVaultSessionActivityType,
       let hostId = userActivity.userInfo?[kSshVaultHostIdKey] as? String {
      iosWindowsChannel?.invokeMethod("openSessionInThisWindow", arguments: ["hostId": hostId])
    }
    super.scene(scene, continue: userActivity)
  }

  override func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
    // Persist the host id so iPadOS can rehydrate the same session on
    // cold relaunch of this window (Stage Manager / Slide Over).
    return scene.userActivity ?? super.stateRestorationActivity(for: scene)
  }

  private func installDragAndDrop(on windowScene: UIWindowScene) {
    if let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
      dragDropHandler = DragDropHandler.install(on: controller)
      return
    }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
        self.dragDropHandler = DragDropHandler.install(on: controller)
      }
    }
  }

  private func installIosWindowsChannel(on windowScene: UIWindowScene) {
    let install: (FlutterViewController) -> Void = { [weak self] controller in
      guard let self = self else { return }
      let channel = FlutterMethodChannel(
        name: kIosWindowsChannel,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        self?.handle(call: call, result: result, scene: windowScene)
      }
      self.iosWindowsChannel = channel
    }

    if let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
      install(controller)
      return
    }
    DispatchQueue.main.async {
      if let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
        install(controller)
      }
    }
  }

  /// Registers the iPadOS UIKeyCommand fallbacks on the scene's
  /// FlutterViewController. The Dart `IosKeyboardShortcuts` widget catches
  /// nearly everything; this is the safety net for the rare cases where
  /// Flutter is not the first responder (e.g. UIKit-presented modals).
  private func installKeyboardShortcuts(on windowScene: UIWindowScene) {
    let install: (FlutterViewController) -> Void = { [weak self] controller in
      self?.keyboardShortcuts = KeyboardShortcuts(controller: controller)
    }
    if let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
      install(controller)
      return
    }
    DispatchQueue.main.async {
      if let controller = windowScene.windows.first?.rootViewController as? FlutterViewController {
        install(controller)
      }
    }
  }

  private func handle(
    call: FlutterMethodCall,
    result: @escaping FlutterResult,
    scene: UIWindowScene
  ) {
    switch call.method {
    case "openSessionWindow":
      guard let args = call.arguments as? [String: Any],
            let hostId = args["hostId"] as? String else {
        result(FlutterError(code: "bad-args",
                            message: "hostId required",
                            details: nil))
        return
      }
      requestNewSessionScene(hostId: hostId, fromScene: scene, result: result)
    case "isMultiWindowSupported":
      result(UIApplication.shared.supportsMultipleScenes)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func requestNewSessionScene(
    hostId: String,
    fromScene scene: UIWindowScene,
    result: @escaping FlutterResult
  ) {
    let activity = NSUserActivity(activityType: kSshVaultSessionActivityType)
    activity.userInfo = [kSshVaultHostIdKey: hostId]
    activity.title = "SSHVault Session"
    activity.targetContentIdentifier = "session://\(hostId)"

    UIApplication.shared.requestSceneSessionActivation(
      nil,
      userActivity: activity,
      options: nil,
      errorHandler: { error in
        // Surface the failure on Flutter's logger; we cannot call
        // `result(...)` here because the API returns asynchronously
        // long after `result(nil)` has already fired. Multi-window may
        // be unavailable (iPhone running iOS, Slide Over not granted,
        // etc.) — that is expected.
        NSLog("SSHVault: requestSceneSessionActivation failed: \(error)")
      }
    )
    result(nil)
  }

  private func forwardInitialSession(hostId: String) {
    // Wait one runloop tick — the Flutter engine is not ready to receive
    // method calls until after `scene(_:willConnectTo:options:)` returns.
    DispatchQueue.main.async { [weak self] in
      self?.iosWindowsChannel?.invokeMethod(
        "openSessionInThisWindow",
        arguments: ["hostId": hostId]
      )
    }
  }
}

