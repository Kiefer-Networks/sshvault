import Cocoa
import CoreServices
import CoreSpotlight
import FlutterMacOS
import UniformTypeIdentifiers

/// Bridges SSHVault's host list into macOS Core Spotlight so users can search
/// for hosts directly from Spotlight (Cmd-Space) and have results activate
/// SSHVault via `NSUserActivity` / `CSSearchableItemActionType`.
///
/// Channel: `de.kiefer_networks.sshvault/spotlight`
///
/// Methods:
///   * `index(items: [{id, title, subtitle, fingerprint}])`
///       — Re-indexes the provided hosts. Each entry becomes a
///         `CSSearchableItem` whose `displayName`, `contentDescription`, and
///         `keywords` are populated from the payload. The host id is used as
///         the searchable-item id (`uniqueIdentifier`) so the activation
///         callback in `AppDelegate.application(_:continue:)` can recover it.
///       — All items share the domain identifier
///         `de.kiefer_networks.SSHVault.hosts`, which lets us purge SSHVault's
///         entire Spotlight footprint with a single
///         `deleteSearchableItems(withDomainIdentifiers:)` call.
///
///   * `removeAll()`
///       — Drops every host SSHVault has indexed (uses the domain identifier
///         above). Called when the user signs out, clears the local vault, or
///         disables Spotlight indexing in Preferences.
///
/// The class itself is a minimal `NSObject` because Core Spotlight has no
/// delegate requirement; we just call into the framework synchronously and
/// surface any error back through the Flutter `result` callback.
final class SpotlightIndexer: NSObject {

    // MARK: - Constants

    /// Channel name shared with `lib/core/services/macos_spotlight_service.dart`.
    static let channelName = "de.kiefer_networks.sshvault/spotlight"

    /// Domain identifier attached to every indexed host. Matched verbatim by
    /// `removeAll()` and by the Dart-side helper that purges the index when
    /// the user disables Spotlight.
    static let domainIdentifier = "de.kiefer_networks.SSHVault.hosts"

    /// Stable item content type. We use the public generic `data` type rather
    /// than a custom UTI so Spotlight renders the result with a sensible
    /// fallback icon on machines that don't have SSHVault's UTI registered.
    private static let itemContentType: String = {
        if #available(macOS 11.0, *) {
            return UTType.data.identifier
        }
        return kUTTypeData as String
    }()

    // MARK: - Registration

    /// Singleton kept alive by `register(with:)`. Spotlight calls do not need
    /// a long-lived reference, but the method-channel handler does.
    private static var shared: SpotlightIndexer?

    /// Wire the channel into the Flutter engine. Idempotent — re-registering
    /// re-uses the existing handler so the previous shared instance is the
    /// canonical one. Mirrors the registration shape used elsewhere in this
    /// directory (e.g. `UNUserNotificationsPlugin.register(with:)`).
    @discardableResult
    static func register(messenger: FlutterBinaryMessenger) -> SpotlightIndexer {
        if let existing = shared { return existing }
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: messenger
        )
        let indexer = SpotlightIndexer()
        channel.setMethodCallHandler { [weak indexer] call, result in
            indexer?.handle(call, result: result)
        }
        shared = indexer
        return indexer
    }

    // MARK: - Method dispatch

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "index":
            guard let args = call.arguments as? [String: Any],
                  let rawItems = args["items"] as? [[String: Any]]
            else {
                result(
                    FlutterError(
                        code: "bad_args",
                        message: "index() expects {items: [...]}",
                        details: nil
                    )
                )
                return
            }
            indexItems(rawItems, result: result)
        case "removeAll":
            removeAll(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Indexing

    private func indexItems(
        _ raw: [[String: Any]],
        result: @escaping FlutterResult
    ) {
        let items: [CSSearchableItem] = raw.compactMap { dict in
            guard let id = dict["id"] as? String, !id.isEmpty else { return nil }
            let title = (dict["title"] as? String) ?? ""
            let subtitle = (dict["subtitle"] as? String) ?? ""
            let fingerprint = (dict["fingerprint"] as? String) ?? ""

            let attrs = CSSearchableItemAttributeSet(
                itemContentType: SpotlightIndexer.itemContentType
            )
            attrs.displayName = title.isEmpty ? id : title
            attrs.contentDescription = subtitle
            // Build a keyword list out of every meaningful token so the user
            // can match on host, user, alias, or fingerprint snippet without
            // typing an exact prefix. Empty fields are filtered out — passing
            // an empty string into `keywords` shows up as a stray match for
            // the empty query on some macOS versions.
            var keywords: [String] = ["sshvault", "ssh"]
            if !title.isEmpty { keywords.append(title) }
            if !subtitle.isEmpty { keywords.append(subtitle) }
            if !fingerprint.isEmpty { keywords.append(fingerprint) }
            attrs.keywords = keywords

            return CSSearchableItem(
                uniqueIdentifier: id,
                domainIdentifier: SpotlightIndexer.domainIdentifier,
                attributeSet: attrs
            )
        }

        if items.isEmpty {
            // Nothing to add — but the caller may have just emptied the host
            // list, so make sure stale entries get evicted too.
            removeAll(result: result)
            return
        }

        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error = error {
                result(
                    FlutterError(
                        code: "index_failed",
                        message: error.localizedDescription,
                        details: nil
                    )
                )
            } else {
                result(items.count)
            }
        }
    }

    private func removeAll(result: @escaping FlutterResult) {
        CSSearchableIndex.default().deleteSearchableItems(
            withDomainIdentifiers: [SpotlightIndexer.domainIdentifier]
        ) { error in
            if let error = error {
                result(
                    FlutterError(
                        code: "remove_failed",
                        message: error.localizedDescription,
                        details: nil
                    )
                )
            } else {
                result(true)
            }
        }
    }
}
