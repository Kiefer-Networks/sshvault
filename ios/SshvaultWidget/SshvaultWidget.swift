// SshvaultWidget.swift
//
// Top-level `WidgetBundle` for SSHVault's iOS widget extension. Exposes
// two widgets:
//
//   * `QuickConnectWidget`         — Home Screen, three sizes (small /
//                                    medium / large) showing the user's
//                                    favorite hosts as deep-link tiles.
//   * `LockScreenAccessoryWidget`  — Lock Screen complication (iOS 16+),
//                                    three families (circular,
//                                    rectangular, inline) showing a
//                                    single host or "last connected"
//                                    text.
//
// Both widgets share a single timeline provider that reads its data from
// the App Group `group.de.kiefer_networks.sshvault` — the Flutter side
// publishes JSON into the group's shared `UserDefaults` (key
// `qc_widget_payload`) and calls
// `WidgetCenter.shared.reloadAllTimelines()` to refresh the OS-side
// timeline.

import SwiftUI
import WidgetKit

@main
struct SshvaultWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        QuickConnectWidget()
        if #available(iOS 16.0, *) {
            LockScreenAccessoryWidget()
        }
    }
}

// MARK: - Shared payload + provider

/// App Group identifier — must match `Runner.entitlements` and
/// `SshvaultWidget.entitlements`.
let kAppGroupID = "group.de.kiefer_networks.sshvault"

/// Shared UserDefaults key the Flutter side writes into via
/// `IosWidgetService.setFavorites`.
let kPayloadKey = "qc_widget_payload"

/// Single host tile rendered by both widgets.
struct WidgetHost: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let hostname: String

    /// Best-effort visible label — falls back to hostname when the user
    /// hasn't named the server.
    var displayName: String { name.isEmpty ? hostname : name }
}

/// Decoded payload pushed by the Flutter side. `favorites` is at most
/// `QuickConnectWidget.maxTiles` entries; `lastConnected` is `nil` when
/// the user has never connected to anything yet.
struct WidgetPayload: Codable {
    let favorites: [WidgetHost]
    let lastConnected: WidgetHost?

    static let empty = WidgetPayload(favorites: [], lastConnected: nil)

    /// Reads the latest payload the main app wrote into the shared App
    /// Group `UserDefaults`. Returns `.empty` if nothing has been written
    /// yet, or the JSON is malformed (defensive — the Flutter side
    /// always writes valid JSON, but a stale payload from an older app
    /// version shouldn't crash the widget).
    static func loadFromAppGroup() -> WidgetPayload {
        guard let defaults = UserDefaults(suiteName: kAppGroupID),
              let raw = defaults.string(forKey: kPayloadKey),
              let data = raw.data(using: .utf8) else {
            return .empty
        }
        do {
            return try JSONDecoder().decode(WidgetPayload.self, from: data)
        } catch {
            return .empty
        }
    }
}

/// Single timeline entry — both widgets reload every 30 minutes as a
/// safety net even though the main app calls
/// `WidgetCenter.shared.reloadAllTimelines()` whenever the payload
/// changes.
struct PayloadEntry: TimelineEntry {
    let date: Date
    let payload: WidgetPayload
}

struct PayloadProvider: TimelineProvider {
    func placeholder(in context: Context) -> PayloadEntry {
        PayloadEntry(date: Date(), payload: .empty)
    }

    func getSnapshot(in context: Context, completion: @escaping (PayloadEntry) -> Void) {
        completion(PayloadEntry(date: Date(), payload: WidgetPayload.loadFromAppGroup()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PayloadEntry>) -> Void) {
        let entry = PayloadEntry(date: Date(), payload: WidgetPayload.loadFromAppGroup())
        // Refresh ~30 min from now as a fallback. Real refreshes are
        // driven by `WidgetCenter.shared.reloadAllTimelines()` calls
        // from the Flutter side.
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

/// Builds the `sshvault://host/<id>` deep link the home-screen tiles
/// invoke through `Link(URL(...))`. The `AppDelegate` already handles
/// `sshvault://` URLs and routes them into the Dart side.
func deepLink(forHost id: String) -> URL {
    URL(string: "sshvault://host/\(id)")!
}
