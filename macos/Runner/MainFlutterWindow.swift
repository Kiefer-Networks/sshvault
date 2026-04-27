import Cocoa
import FlutterMacOS

/// The application's main window.
///
/// In addition to the Flutter view controller, this window wires up four
/// macOS-native features that round out the desktop experience:
///
///   1. **Drag-and-drop** — the content view becomes an `NSDraggingDestination`
///      for `.fileURL` so users can drop SSH keys / vault exports / ssh_config
///      files anywhere on the window. Events are forwarded to the Flutter side
///      on `de.kiefer_networks.sshvault/drop` (the same MethodChannel used by
///      the Linux GTK and Windows IDropTarget bridges).
///
///   2. **NSVisualEffectView vibrancy backdrop** — a sidebar-style blur sits
///      *behind* the Flutter view. The Flutter view itself paints with a
///      transparent background so the vibrancy bleeds through, giving the app
///      a native look-and-feel that matches Finder/Mail/Notes.
///
///   3. **Native window tabs** — `allowsAutomaticWindowTabbing` plus a stable
///      `tabbingIdentifier` lets macOS automatically tab additional SSHVault
///      windows together (Cmd-N spawns a tab when the window is full-screen
///      or when System Settings → Desktop & Dock → "Prefer tabs" is enabled).
///
///   4. **Unified compact toolbar** — on macOS 11+ the title bar and toolbar
///      collapse into a single `.unifiedCompact` strip, with
///      `titlebarAppearsTransparent` and `.fullSizeContentView` so the Flutter
///      content extends edge-to-edge underneath. An empty `NSToolbar` is
///      attached purely to establish the drag region; Flutter draws all the
///      actual chrome.
///
/// Window restoration is also enabled here (`isRestorable = true` plus a
/// stable `identifier`) so macOS persists window position and size across
/// launches without any extra plumbing.
class MainFlutterWindow: NSWindow {

  // MARK: - Constants

  /// The MethodChannel name shared with the Linux + Windows drop bridges.
  /// Mirrored in `lib/core/services/file_drop_service.dart`.
  private static let dropChannelName = "de.kiefer_networks.sshvault/drop"

  /// Tabbing identifier — windows with the same identifier are eligible to
  /// be merged into a single tabbed window by AppKit.
  private static let tabIdentifier = "de.kiefer_networks.SSHVault"

  /// Stable window identifier used by AppKit's window-restoration machinery.
  private static let restorationIdentifier = "MainFlutterWindow"

  // MARK: - State

  /// MethodChannel used to forward drag/drop events to the Flutter side.
  /// Retained on the window so it lives as long as the FlutterEngine.
  private var dropChannel: FlutterMethodChannel?

  /// Strong reference to the drag handler so its delegate-style methods
  /// stay alive across drag sessions.
  private var dropHandler: DropHandler?

  // MARK: - Lifecycle

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    configureWindowChrome()
    installVibrancyBackdrop(under: flutterViewController)
    configureToolbar()
    configureWindowRestoration()
    configureWindowTabs()
    installDragAndDrop(on: flutterViewController)

    super.awakeFromNib()
  }

  // MARK: - Window chrome

  /// Make the title bar transparent and let the content view draw underneath
  /// it. Combined with `.fullSizeContentView`, the Flutter UI now extends
  /// edge-to-edge, with the toolbar floating above it like in modern Mac
  /// apps (Mail, Notes, App Store, etc.).
  private func configureWindowChrome() {
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)
    // Keep the system traffic-light buttons visible — Flutter doesn't paint
    // its own. A transparent background lets the vibrancy view show through.
    self.isOpaque = false
    self.backgroundColor = .clear
  }

  // MARK: - Vibrancy backdrop

  /// Slide an `NSVisualEffectView` *underneath* the Flutter view so the
  /// system blur shows through any transparent pixels. The Flutter content
  /// view is left in place; we just re-parent it on top of the effect view.
  private func installVibrancyBackdrop(under controller: FlutterViewController) {
    guard let flutterView = controller.view as? NSView else { return }

    // The effect view fills the contentView and tracks resizes via auto-
    // resizing masks (the simplest option that works without constraints).
    let effectView = NSVisualEffectView(frame: flutterView.bounds)
    effectView.autoresizingMask = [.width, .height]
    effectView.material = .underWindowBackground
    effectView.blendingMode = .behindWindow
    effectView.state = .followsWindowActiveState
    effectView.wantsLayer = true

    // Wrap the existing Flutter view in a container that holds:
    //   [0] effectView (background)
    //   [1] flutterView (foreground, transparent BG)
    let container = NSView(frame: flutterView.bounds)
    container.autoresizingMask = [.width, .height]
    container.wantsLayer = true

    container.addSubview(effectView)
    flutterView.frame = container.bounds
    flutterView.autoresizingMask = [.width, .height]
    container.addSubview(flutterView)

    // Replace the controller's view with the wrapped container. AppKit will
    // pick up the change because contentViewController is still the same
    // FlutterViewController; we only swap its `view`.
    controller.view = container
  }

  // MARK: - Toolbar

  /// Attach an empty `NSToolbar` so AppKit lays out a proper drag region in
  /// the title bar. Flutter draws the actual toolbar content; this stub
  /// exists purely so macOS knows there *is* a toolbar.
  private func configureToolbar() {
    if #available(macOS 11.0, *) {
      self.toolbarStyle = .unifiedCompact
    }
    let toolbar = NSToolbar(identifier: "MainFlutterWindowToolbar")
    toolbar.displayMode = .iconOnly
    toolbar.showsBaselineSeparator = false
    self.toolbar = toolbar
  }

  // MARK: - Window tabs

  /// Opt into AppKit's automatic window tabbing. With this turned on, opening
  /// a second SSHVault window (e.g. Cmd-N) will surface as a tab in the same
  /// window group instead of a separate floating window — matching Safari,
  /// Terminal, and Finder behaviour.
  private func configureWindowTabs() {
    self.tabbingMode = .automatic
    self.tabbingIdentifier = MainFlutterWindow.tabIdentifier
    NSWindow.allowsAutomaticWindowTabbing = true
  }

  // MARK: - Window restoration

  private func configureWindowRestoration() {
    self.isRestorable = true
    self.identifier = NSUserInterfaceItemIdentifier(MainFlutterWindow.restorationIdentifier)
  }

  // MARK: - Drag and drop

  private func installDragAndDrop(on controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: MainFlutterWindow.dropChannelName,
      binaryMessenger: controller.engine.binaryMessenger
    )
    self.dropChannel = channel

    let handler = DropHandler(channel: channel)
    self.dropHandler = handler

    // Register the *content view* (i.e. the wrapped container that now
    // includes the vibrancy backdrop + Flutter view) as the drop target,
    // delegating the actual NSDraggingDestination calls to `DropHandler`
    // through a thin NSView subclass installed on top.
    if let contentView = self.contentView {
      let dropOverlay = DropOverlayView(handler: handler)
      dropOverlay.frame = contentView.bounds
      dropOverlay.autoresizingMask = [.width, .height]
      // Insert the overlay *above* every other subview so it intercepts
      // drag operations before they reach Flutter. It is otherwise fully
      // transparent and forwards mouse events.
      contentView.addSubview(dropOverlay, positioned: .above, relativeTo: nil)
      dropOverlay.registerForDraggedTypes([.fileURL])
    }
  }
}

// MARK: - Drop handling

/// Bridges `NSDraggingDestination` calls into `dragEnter` / `dragLeave` /
/// `dropFiles` MethodChannel events. Mirrors the Linux implementation in
/// `linux/runner/my_application.cc` so the Dart consumer (`FileDropService`)
/// gets the same payload shape on every platform.
final class DropHandler {
  private let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
  }

  func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    channel.invokeMethod("dragEnter", arguments: nil)
    return .copy
  }

  func draggingExited(_ sender: NSDraggingInfo?) {
    channel.invokeMethod("dragLeave", arguments: nil)
  }

  func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    let pasteboard = sender.draggingPasteboard
    guard let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL],
          !urls.isEmpty
    else {
      channel.invokeMethod("dragLeave", arguments: nil)
      return false
    }

    let paths = urls.map { $0.path }
    // Mirror Linux/Windows: a single `dropFiles` call with the list of
    // absolute file paths. The 100 KB per-file cap is enforced Dart-side
    // in `FileDropService._defaultReadFile`.
    channel.invokeMethod("dropFiles", arguments: paths)
    return true
  }
}

/// Transparent NSView subclass that owns the `NSDraggingDestination`
/// callbacks and forwards them to a `DropHandler`. Hit-testing returns nil
/// so mouse events still reach the Flutter view underneath.
final class DropOverlayView: NSView {
  private let handler: DropHandler

  init(handler: DropHandler) {
    self.handler = handler
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Pass-through hit testing — this overlay should never swallow mouse
  // clicks, only drag operations.
  override func hitTest(_ point: NSPoint) -> NSView? {
    return nil
  }

  override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    return handler.draggingEntered(sender)
  }

  override func draggingExited(_ sender: NSDraggingInfo?) {
    handler.draggingExited(sender)
  }

  override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    return handler.performDragOperation(sender)
  }

  override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
    return true
  }
}
