import Flutter
import UIKit

/// iPadOS drag-and-drop bridge for SSH key / vault export / ssh_config files.
///
/// Mirrors the desktop drop bridges so a single Dart consumer
/// (`lib/core/services/file_drop_service.dart`) handles drops uniformly:
///
///   - Linux GTK   (`linux/runner/my_application.cc`, `text/uri-list`)
///   - Windows     (`windows/runner/flutter_window.cpp`, `WM_DROPFILES`)
///   - macOS       (`macos/Runner/MainFlutterWindow.swift`,
///                  `NSDraggingDestination` for `.fileURL`)
///
/// On iPadOS the system delivers drops through `UIDropInteractionDelegate`.
/// We attach a `UIDropInteraction` to the FlutterViewController's view (see
/// `SceneDelegate.swift`), accept drops carrying `URL`, `String`, or `Data`
/// (the three NSItemProvider kinds Files / Mail / Safari typically vend for
/// text-ish file payloads), and forward `file://` URLs to Flutter as a
/// single `dropFiles([paths])` call on the shared MethodChannel
/// `de.kiefer_networks.sshvault/drop`.
///
/// The 100 KB per-file size cap and the actual content classification
/// (private/public key, vault export, ssh_config) are enforced Dart-side in
/// `FileDropService` — keeping the platform layer thin and behaviour-identical
/// across all five supported OSes.
final class DragDropHandler: NSObject, UIDropInteractionDelegate {

  /// Shared channel name. Must stay in lock-step with the desktop bridges and
  /// `FileDropService._channel`.
  static let channelName = "de.kiefer_networks.sshvault/drop"

  /// MethodChannel held strongly so it outlives any in-flight drop session.
  private let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
  }

  /// Convenience: build the shared channel against a FlutterViewController's
  /// engine and install a drop interaction on its view.
  static func install(on controller: FlutterViewController) -> DragDropHandler {
    let channel = FlutterMethodChannel(
      name: DragDropHandler.channelName,
      binaryMessenger: controller.binaryMessenger
    )
    let handler = DragDropHandler(channel: channel)
    let interaction = UIDropInteraction(delegate: handler)
    controller.view.addInteraction(interaction)
    return handler
  }

  // MARK: - UIDropInteractionDelegate

  /// Accept any session that carries at least one item we know how to read.
  /// Mirrors the macOS `registerForDraggedTypes([.fileURL])` filter — we can
  /// only do something useful with file-like payloads.
  func dropInteraction(
    _ interaction: UIDropInteraction,
    canHandle session: UIDropSession
  ) -> Bool {
    return session.canLoadObjects(ofClass: URL.self)
      || session.canLoadObjects(ofClass: NSString.self)
      || session.hasItemsConforming(toTypeIdentifiers: ["public.data"])
  }

  /// Always proposes `.copy` — SSHVault never wants to move/delete the source
  /// file from its original location (Files app, Mail attachment, etc.).
  func dropInteraction(
    _ interaction: UIDropInteraction,
    sessionDidUpdate session: UIDropSession
  ) -> UIDropProposal {
    channel.invokeMethod("dragEnter", arguments: nil)
    return UIDropProposal(operation: .copy)
  }

  /// Pointer left the view without committing a drop — match the desktop
  /// `dragLeave` semantics so the Riverpod overlay clears.
  func dropInteraction(
    _ interaction: UIDropInteraction,
    sessionDidExit session: UIDropSession
  ) {
    channel.invokeMethod("dragLeave", arguments: nil)
  }

  /// Drop committed. Pull file URLs off the session and forward absolute
  /// paths to Flutter. We deliberately ignore string- and Data-only items
  /// here: the Dart classifier reads from disk, so a file URL is the only
  /// useful payload shape on iPadOS.
  func dropInteraction(
    _ interaction: UIDropInteraction,
    performDrop session: UIDropSession
  ) {
    guard session.canLoadObjects(ofClass: NSURL.self) else {
      channel.invokeMethod("dragLeave", arguments: nil)
      return
    }

    _ = session.loadObjects(ofClass: NSURL.self) { [weak self] items in
      guard let self = self else { return }
      let paths = items
        .compactMap { $0 as? URL }
        .filter { $0.isFileURL }
        .map { $0.path }

      DispatchQueue.main.async {
        if paths.isEmpty {
          self.channel.invokeMethod("dragLeave", arguments: nil)
        } else {
          // Mirror Linux/Windows/macOS: a single `dropFiles` call carrying
          // the list of absolute file paths.
          self.channel.invokeMethod("dropFiles", arguments: paths)
        }
      }
    }
  }

  // MARK: - Type predicate

  /// Whether a given item type can be turned into something the Dart side can
  /// consume. The bridge currently ingests file paths only, but `String` and
  /// `Data` are listed for parity with the desktop pasteboard predicates and
  /// to future-proof against pasted-text drops.
  static func canHandle(_ type: Any.Type) -> Bool {
    return type == URL.self || type == String.self || type == Data.self
  }
}
