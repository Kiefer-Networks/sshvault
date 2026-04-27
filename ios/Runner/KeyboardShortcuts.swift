// iPadOS-only global UIKeyCommand registration.
//
// The Flutter `Shortcuts` widget at the app root catches keyboard events
// whenever Flutter has first-responder status, which covers ~95% of the
// iPadOS user flow. There are two cases where it does *not* fire:
//
//   1. A native menu (e.g. share sheet, document picker) is on top of the
//      Flutter view controller and steals first responder.
//   2. The Flutter view temporarily resigned first responder (e.g. while a
//      UITextField in a UIKit overlay has focus).
//
// To keep ⌘N / ⌘, working in those edge cases we register a small set of
// `UIKeyCommand`s on the `FlutterViewController` itself. The commands
// forward to a Flutter MethodChannel; the Dart side already has handlers
// for `openSettings` (see `app_shell.dart`'s `_DesktopShortcuts`) — we add
// `newHost` here so the Dart side can route both flows.
//
// This file is intentionally self-contained: it does *not* override
// `pressesBegan` / `pressesEnded`, because doing so would interfere with
// Flutter's own key-event pipeline (and break the Shortcuts widget for the
// 95% case). UIKeyCommand registration on the view controller plays nice
// with Flutter's responder chain.

import Flutter
import UIKit

/// Channel name shared with `app_shell.dart` (`_DesktopShortcuts._menuChannel`)
/// — keeping the same channel means we don't have to plumb a second handler
/// on the Dart side. The Dart handler accepts `openSettings`; this file
/// also emits `newHost`, which the iPad-specific Dart shortcut wrapper can
/// listen for if a future revision wants to surface menu-driven actions.
private let kMenuChannelName = "de.kiefer_networks.sshvault/menu"

/// Installs UIKeyCommand handlers on the given Flutter view controller.
/// Safe to call on iPhone — UIKeyCommand simply never fires without a
/// hardware keyboard attached.
@objc final class KeyboardShortcuts: NSObject {
  private weak var controller: FlutterViewController?
  private let channel: FlutterMethodChannel

  @objc init(controller: FlutterViewController) {
    self.controller = controller
    self.channel = FlutterMethodChannel(
      name: kMenuChannelName,
      binaryMessenger: controller.binaryMessenger)
    super.init()
    self.installKeyCommands()
  }

  private func installKeyCommands() {
    guard let controller = controller else { return }

    // ⌘, → settings. Title shows up in the iPad "hold ⌘" discoverability
    // overlay (iPadOS 13.4+).
    let settings = UIKeyCommand(
      input: ",",
      modifierFlags: .command,
      action: #selector(handleSettings))
    settings.title = "Settings"
    if #available(iOS 13.0, *) {
      settings.discoverabilityTitle = "Open Settings"
    }

    // ⌘N → new host.
    let newHost = UIKeyCommand(
      input: "N",
      modifierFlags: .command,
      action: #selector(handleNewHost))
    newHost.title = "New Host"
    if #available(iOS 13.0, *) {
      newHost.discoverabilityTitle = "New Host"
    }

    controller.addKeyCommand(settings)
    controller.addKeyCommand(newHost)
  }

  @objc private func handleSettings() {
    channel.invokeMethod("openSettings", arguments: nil)
  }

  @objc private func handleNewHost() {
    channel.invokeMethod("newHost", arguments: nil)
  }
}
