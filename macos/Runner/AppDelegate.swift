import Cocoa
import CoreSpotlight
import FlutterMacOS

/// AppDelegate for the macOS host of SSHVault.
///
/// Bridges several platform-native features into the Dart layer over the
/// `de.kiefer_networks.sshvault/macos` MethodChannel:
///
///   * `ssh://` / `sftp://` URL scheme handling (Phase A items 1, 2).
///   * A native NSMenu with the standard SSHVault / File / Edit / View /
///     Window / Help submenus (item 11).
///   * Live `NSAppearance` follow-along, posted as `appearanceChanged(name)`
///     on the channel whenever the user toggles light/dark in System Settings
///     (item 13).
///   * A macOS Services menu provider — entry "Connect with SSHVault" forwards
///     a selected ssh://-URL or `user@host` text from the pasteboard into the
///     channel (item 15).
///
/// URLs delivered before the Flutter engine is up (e.g. `Open With…` from
/// Finder at cold launch) are buffered and replayed once the channel is ready.
/// Two channel names exist for back-compat:
///
///   * `de.kiefer_networks.sshvault/menu`  — legacy Settings hook.
///   * `de.kiefer_networks.sshvault/macos` — everything in this file.
@main
class AppDelegate: FlutterAppDelegate {

  // MARK: - Channels

  /// Legacy channel kept for the existing `openPreferences` IBAction.
  private var legacyMenuChannel: FlutterMethodChannel?

  /// Primary channel for all macOS-native features added in this pass.
  private var macosChannel: FlutterMethodChannel?

  /// IOPMAssertion bridge — keeps the Mac awake while SSH sessions are
  /// active. Owns its own MethodChannel; see `PowerInhibitor.swift`.
  private var powerInhibitor: PowerInhibitor?

  /// URLs that arrived before `macosChannel` was ready. Drained as soon as
  /// the engine finishes initializing.
  private var pendingUrls: [String] = []

  // MARK: - KVO for NSAppearance

  /// KVO context tag — distinguishes our observation from anything inherited
  /// from the Flutter side. Pointer-stable for the AppDelegate's lifetime.
  private var appearanceContext = 0

  // MARK: - Lifecycle

  override func applicationShouldTerminateAfterLastWindowClosed(
    _ sender: NSApplication
  ) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(
    _ app: NSApplication
  ) -> Bool {
    return true
  }

  override func applicationWillFinishLaunching(_ notification: Notification) {
    // Register for `kAEGetURL` early — Finder may send this before
    // `applicationDidFinishLaunching` if the user double-clicks an ssh:// link
    // while the app is still launching. We forward what we can; anything that
    // arrives before the channel exists is buffered into `pendingUrls`.
    NSAppleEventManager.shared().setEventHandler(
      self,
      andSelector: #selector(handleGetURLEvent(_:withReplyEvent:)),
      forEventClass: AEEventClass(kInternetEventClass),
      andEventID: AEEventID(kAEGetURL)
    )
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    guard
      let controller = mainFlutterWindow?.contentViewController
        as? FlutterViewController
    else {
      // Without a controller the channels never come up — but we still want
      // the menu bar to render (otherwise the user sees an empty menu bar).
      installMainMenu()
      return
    }

    legacyMenuChannel = FlutterMethodChannel(
      name: "de.kiefer_networks.sshvault/menu",
      binaryMessenger: controller.engine.binaryMessenger
    )

    macosChannel = FlutterMethodChannel(
      name: "de.kiefer_networks.sshvault/macos",
      binaryMessenger: controller.engine.binaryMessenger
    )

    // Native UNUserNotificationCenter bridge — replaces the deprecated
    // NSUserNotification path inside `local_notifier`. The Swift source
    // lives next to AppDelegate (not a Pub plugin) so it has to be
    // registered manually here. Channel: `…/macos_notif`.
    if #available(macOS 10.14, *) {
      if let registrar = controller.registrar(forPlugin: "UNUserNotificationsPlugin") {
        UNUserNotificationsPlugin.register(with: registrar)
      }
    }

    // Core Spotlight indexing — wires
    // `de.kiefer_networks.sshvault/spotlight` so Dart can push the host list
    // into Spotlight (Cmd-Space), and recover host ids when the user picks
    // a result via `application(_:continue:userActivity:)` below.
    SpotlightIndexer.register(messenger: controller.engine.binaryMessenger)

    // Register for the Services menu — does not require a method handler on
    // the Dart side; the Service action lands in `connectWithSSHVault`.
    NSApp.servicesProvider = self

    // Login Item ("open at login") bridge — channel `…/login_item`. Uses
    // `SMAppService` on macOS 13+, falls back to a launchd plist on older
    // releases.
    LoginItemHelper.register(messenger: controller.engine.binaryMessenger)

    // IOPMAssertion bridge — channel `…/power_inhibit`. Mirrors the Linux
    // logind / Windows SetThreadExecutionState backends in
    // `PowerInhibitorService` so SSH sessions can suppress idle sleep.
    powerInhibitor = PowerInhibitor(
      messenger: controller.engine.binaryMessenger
    )

    // Build the native menu bar.
    installMainMenu()

    // Live appearance follow.
    NSApp.addObserver(
      self,
      forKeyPath: "effectiveAppearance",
      options: [.initial, .new],
      context: &appearanceContext
    )

    // Drain URLs that arrived before the channel existed.
    drainPendingUrls()
  }

  // MARK: - URL scheme handling

  /// Modern (10.13+) overload — Cocoa hands us a list of URLs at once.
  override func application(_ application: NSApplication, open urls: [URL]) {
    for url in urls {
      forwardOrBuffer(url: url)
    }
  }

  /// Apple Event handler for the legacy `kAEGetURL` path. Wired in
  /// `applicationWillFinishLaunching` so Finder can deliver ssh:// links
  /// before the engine boots.
  @objc func handleGetURLEvent(
    _ event: NSAppleEventDescriptor,
    withReplyEvent reply: NSAppleEventDescriptor
  ) {
    guard
      let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?
        .stringValue,
      let url = URL(string: urlString)
    else {
      return
    }
    forwardOrBuffer(url: url)
  }

  private func forwardOrBuffer(url: URL) {
    let urlString = url.absoluteString
    if let channel = macosChannel {
      channel.invokeMethod("openUrl", arguments: urlString)
    } else {
      pendingUrls.append(urlString)
    }
  }

  private func drainPendingUrls() {
    guard let channel = macosChannel, !pendingUrls.isEmpty else { return }
    let buffered = pendingUrls
    pendingUrls.removeAll()
    for urlString in buffered {
      channel.invokeMethod("openUrl", arguments: urlString)
    }
  }

  // MARK: - Spotlight activation

  /// Cocoa hands us a `NSUserActivity` whenever the user activates a Spotlight
  /// result that points at SSHVault. For `CSSearchableItemActionType` the
  /// `userInfo[CSSearchableItemActivityIdentifier]` carries the host id we
  /// originally indexed — we forward it as `spotlightOpen(hostId)` on the
  /// existing macos channel so the Dart side can route to the connection.
  override func application(
    _ application: NSApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void
  ) -> Bool {
    if userActivity.activityType == CSSearchableItemActionType {
      if let hostId = userActivity.userInfo?[CSSearchableItemActivityIdentifier]
        as? String, !hostId.isEmpty
      {
        macosChannel?.invokeMethod("spotlightOpen", arguments: hostId)
        NSApp.activate(ignoringOtherApps: true)
        mainFlutterWindow?.makeKeyAndOrderFront(nil)
        return true
      }
    }
    return super.application(
      application,
      continue: userActivity,
      restorationHandler: restorationHandler
    )
  }

  // MARK: - NSAppearance live-follow

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if context == &appearanceContext, keyPath == "effectiveAppearance" {
      let name = NSApp.effectiveAppearance.name.rawValue
      macosChannel?.invokeMethod("appearanceChanged", arguments: name)
      return
    }
    super.observeValue(
      forKeyPath: keyPath,
      of: object,
      change: change,
      context: context
    )
  }

  // MARK: - Services menu

  /// Returns `self` for any compatible send type so the Services menu enables
  /// our entry whenever the user has an NSString selection on the pasteboard.
  @objc func validRequestor(
    forSendType sendType: NSPasteboard.PasteboardType?,
    returnType: NSPasteboard.PasteboardType?
  ) -> Any? {
    if let st = sendType, st == .string || st.rawValue == "NSStringPboardType" {
      return self
    }
    return nil
  }

  /// Selector wired through `Info.plist` (`NSMessage = connectWithSSHVault`).
  /// macOS hands us the active pasteboard; we read its NSString contents and
  /// forward them to Dart for parsing as `ssh://...` or `user@host`.
  @objc func connectWithSSHVault(
    _ pboard: NSPasteboard,
    userData: String?,
    error: AutoreleasingUnsafeMutablePointer<NSString>
  ) {
    guard
      let selection = pboard.string(forType: .string),
      !selection.isEmpty
    else {
      error.pointee = "SSHVault: no text on the pasteboard." as NSString
      return
    }
    // Light client-side normalization — Dart does the actual parse.
    let trimmed = selection.trimmingCharacters(
      in: .whitespacesAndNewlines
    )
    macosChannel?.invokeMethod("openUrl", arguments: trimmed)
    NSApp.activate(ignoringOtherApps: true)
  }

  // MARK: - Native menu bar

  private func installMainMenu() {
    let mainMenu = NSMenu()

    mainMenu.addItem(makeAppMenuItem())
    mainMenu.addItem(makeFileMenuItem())
    mainMenu.addItem(makeEditMenuItem())
    mainMenu.addItem(makeViewMenuItem())
    mainMenu.addItem(makeWindowMenuItem())
    mainMenu.addItem(makeHelpMenuItem())

    NSApp.mainMenu = mainMenu
  }

  // MARK: SSHVault menu

  private func makeAppMenuItem() -> NSMenuItem {
    let item = NSMenuItem()
    let menu = NSMenu(title: "SSHVault")

    menu.addItem(
      NSMenuItem(
        title: "About SSHVault",
        action: #selector(aboutSSHVault(_:)),
        keyEquivalent: ""
      )
    )
    menu.addItem(NSMenuItem.separator())

    let prefs = NSMenuItem(
      title: "Preferences\u{2026}",
      action: #selector(openPreferences(_:)),
      keyEquivalent: ","
    )
    prefs.keyEquivalentModifierMask = [.command]
    menu.addItem(prefs)
    menu.addItem(NSMenuItem.separator())

    menu.addItem(
      withTitle: "Hide SSHVault",
      action: #selector(NSApplication.hide(_:)),
      keyEquivalent: "h"
    )
    let hideOthers = NSMenuItem(
      title: "Hide Others",
      action: #selector(NSApplication.hideOtherApplications(_:)),
      keyEquivalent: "h"
    )
    hideOthers.keyEquivalentModifierMask = [.command, .option]
    menu.addItem(hideOthers)
    menu.addItem(
      withTitle: "Show All",
      action: #selector(NSApplication.unhideAllApplications(_:)),
      keyEquivalent: ""
    )
    menu.addItem(NSMenuItem.separator())

    let quit = NSMenuItem(
      title: "Quit SSHVault",
      action: #selector(NSApplication.terminate(_:)),
      keyEquivalent: "q"
    )
    quit.keyEquivalentModifierMask = [.command]
    menu.addItem(quit)

    item.submenu = menu
    return item
  }

  // MARK: File menu

  private func makeFileMenuItem() -> NSMenuItem {
    let item = NSMenuItem()
    let menu = NSMenu(title: "File")

    let newHost = NSMenuItem(
      title: "New Host\u{2026}",
      action: #selector(menuActionNewHost(_:)),
      keyEquivalent: "n"
    )
    newHost.keyEquivalentModifierMask = [.command]
    newHost.target = self
    menu.addItem(newHost)

    let openSshConfig = NSMenuItem(
      title: "Open SSH Config\u{2026}",
      action: #selector(menuActionOpenSshConfig(_:)),
      keyEquivalent: ""
    )
    openSshConfig.target = self
    menu.addItem(openSshConfig)
    menu.addItem(NSMenuItem.separator())

    let close = NSMenuItem(
      title: "Close",
      action: #selector(NSWindow.performClose(_:)),
      keyEquivalent: "w"
    )
    close.keyEquivalentModifierMask = [.command]
    menu.addItem(close)

    let quit = NSMenuItem(
      title: "Quit SSHVault",
      action: #selector(NSApplication.terminate(_:)),
      keyEquivalent: "q"
    )
    quit.keyEquivalentModifierMask = [.command]
    menu.addItem(quit)

    item.submenu = menu
    return item
  }

  // MARK: Edit menu

  private func makeEditMenuItem() -> NSMenuItem {
    let item = NSMenuItem()
    let menu = NSMenu(title: "Edit")

    let undo = NSMenuItem(
      title: "Undo",
      action: Selector(("undo:")),
      keyEquivalent: "z"
    )
    undo.keyEquivalentModifierMask = [.command]
    menu.addItem(undo)

    let redo = NSMenuItem(
      title: "Redo",
      action: Selector(("redo:")),
      keyEquivalent: "z"
    )
    redo.keyEquivalentModifierMask = [.command, .shift]
    menu.addItem(redo)
    menu.addItem(NSMenuItem.separator())

    menu.addItem(
      withTitle: "Cut",
      action: #selector(NSText.cut(_:)),
      keyEquivalent: "x"
    )
    menu.addItem(
      withTitle: "Copy",
      action: #selector(NSText.copy(_:)),
      keyEquivalent: "c"
    )
    menu.addItem(
      withTitle: "Paste",
      action: #selector(NSText.paste(_:)),
      keyEquivalent: "v"
    )
    menu.addItem(NSMenuItem.separator())
    menu.addItem(
      withTitle: "Select All",
      action: #selector(NSText.selectAll(_:)),
      keyEquivalent: "a"
    )

    item.submenu = menu
    return item
  }

  // MARK: View menu

  private func makeViewMenuItem() -> NSMenuItem {
    let item = NSMenuItem()
    let menu = NSMenu(title: "View")

    menu.addItem(
      withTitle: "Toggle Tab Bar",
      action: #selector(NSWindow.toggleTabBar(_:)),
      keyEquivalent: ""
    )
    menu.addItem(
      withTitle: "Toggle Sidebar",
      action: Selector(("toggleSidebar:")),
      keyEquivalent: ""
    )
    menu.addItem(NSMenuItem.separator())

    let fullScreen = NSMenuItem(
      title: "Enter Full Screen",
      action: #selector(NSWindow.toggleFullScreen(_:)),
      keyEquivalent: "f"
    )
    fullScreen.keyEquivalentModifierMask = [.command, .control]
    menu.addItem(fullScreen)

    item.submenu = menu
    return item
  }

  // MARK: Window menu

  private func makeWindowMenuItem() -> NSMenuItem {
    let item = NSMenuItem()
    let menu = NSMenu(title: "Window")

    let minimize = NSMenuItem(
      title: "Minimize",
      action: #selector(NSWindow.performMiniaturize(_:)),
      keyEquivalent: "m"
    )
    minimize.keyEquivalentModifierMask = [.command]
    menu.addItem(minimize)

    menu.addItem(
      withTitle: "Zoom",
      action: #selector(NSWindow.performZoom(_:)),
      keyEquivalent: ""
    )
    menu.addItem(NSMenuItem.separator())

    menu.addItem(
      withTitle: "Bring All to Front",
      action: #selector(NSApplication.arrangeInFront(_:)),
      keyEquivalent: ""
    )
    menu.addItem(NSMenuItem.separator())

    let nextTab = NSMenuItem(
      title: "Show Next Tab",
      action: #selector(NSWindow.selectNextTab(_:)),
      keyEquivalent: "\t"
    )
    nextTab.keyEquivalentModifierMask = [.control]
    menu.addItem(nextTab)

    let prevTab = NSMenuItem(
      title: "Show Previous Tab",
      action: #selector(NSWindow.selectPreviousTab(_:)),
      keyEquivalent: "\t"
    )
    prevTab.keyEquivalentModifierMask = [.control, .shift]
    menu.addItem(prevTab)

    item.submenu = menu
    NSApp.windowsMenu = menu
    return item
  }

  // MARK: Help menu

  private func makeHelpMenuItem() -> NSMenuItem {
    let item = NSMenuItem()
    let menu = NSMenu(title: "Help")

    let helpItem = NSMenuItem(
      title: "SSHVault Help",
      action: #selector(openHelp(_:)),
      keyEquivalent: "?"
    )
    helpItem.keyEquivalentModifierMask = [.command]
    helpItem.target = self
    menu.addItem(helpItem)

    item.submenu = menu
    NSApp.helpMenu = menu
    return item
  }

  // MARK: - Menu actions

  @objc func aboutSSHVault(_ sender: Any?) {
    macosChannel?.invokeMethod("menuAction", arguments: "about")
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  @IBAction func openPreferences(_ sender: Any) {
    // Legacy channel for back-compat with existing Dart-side handler.
    legacyMenuChannel?.invokeMethod("openSettings", arguments: nil)
    macosChannel?.invokeMethod("menuAction", arguments: "preferences")
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  @objc func menuActionNewHost(_ sender: Any?) {
    macosChannel?.invokeMethod("menuAction", arguments: "newHost")
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  @objc func menuActionOpenSshConfig(_ sender: Any?) {
    macosChannel?.invokeMethod("menuAction", arguments: "openSshConfig")
    mainFlutterWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  @objc func openHelp(_ sender: Any?) {
    if let url = URL(string: "https://github.com/Kiefer-Networks/sshvault") {
      NSWorkspace.shared.open(url)
    }
  }

  // MARK: - Teardown

  deinit {
    if NSApp != nil {
      NSApp.removeObserver(
        self,
        forKeyPath: "effectiveAppearance",
        context: &appearanceContext
      )
    }
    NSAppleEventManager.shared().removeEventHandler(
      forEventClass: AEEventClass(kInternetEventClass),
      andEventID: AEEventID(kAEGetURL)
    )
  }
}
