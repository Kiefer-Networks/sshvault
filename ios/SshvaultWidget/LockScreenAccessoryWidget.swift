// LockScreenAccessoryWidget.swift
//
// iOS 16+ Lock Screen complication. Three families:
//
//   * `.accessoryCircular`    — single host icon (terminal glyph) that
//                               deep-links to the most recent host.
//   * `.accessoryRectangular` — host name + small icon. Tapping it
//                               deep-links to the same host.
//   * `.accessoryInline`      — single line "Last connected: <name>"
//                               text rendered in the lock-screen status
//                               area above the clock.
//
// Data source is the same shared App Group payload the Home Screen
// widget uses (see `SshvaultWidget.swift`).

import SwiftUI
import WidgetKit

@available(iOS 16.0, *)
struct LockScreenAccessoryWidget: Widget {
    let kind = "LockScreenAccessoryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PayloadProvider()) { entry in
            LockScreenAccessoryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("SSHVault Lock Screen")
        .description("Last connected host at a glance.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

@available(iOS 16.0, *)
struct LockScreenAccessoryView: View {
    @Environment(\.widgetFamily) var family
    let entry: PayloadEntry

    /// Picks the host to surface on the Lock Screen. We prefer the
    /// "last connected" entry the Flutter side populated; if it's nil
    /// we fall back to the first favorite so the complication is still
    /// useful on a fresh install.
    private var host: WidgetHost? {
        entry.payload.lastConnected ?? entry.payload.favorites.first
    }

    var body: some View {
        switch family {
        case .accessoryCircular:
            circularView
        case .accessoryRectangular:
            rectangularView
        case .accessoryInline:
            inlineView
        default:
            inlineView
        }
    }

    @ViewBuilder
    private var circularView: some View {
        if let host = host {
            Link(destination: deepLink(forHost: host.id)) {
                ZStack {
                    AccessoryWidgetBackground()
                    Image(systemName: "terminal.fill")
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        } else {
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "terminal")
            }
        }
    }

    @ViewBuilder
    private var rectangularView: some View {
        if let host = host {
            Link(destination: deepLink(forHost: host.id)) {
                HStack(spacing: 4) {
                    Image(systemName: "terminal.fill")
                        .font(.system(size: 14, weight: .semibold))
                    VStack(alignment: .leading, spacing: 0) {
                        Text(host.displayName)
                            .font(.headline)
                            .lineLimit(1)
                        if !host.name.isEmpty && !host.hostname.isEmpty {
                            Text(host.hostname)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                    }
                }
            }
        } else {
            HStack(spacing: 4) {
                Image(systemName: "terminal")
                Text("SSHVault")
                    .font(.headline)
            }
        }
    }

    /// Inline complications can only render a single Text view (with an
    /// optional leading SF Symbol via `Label`) — no Link, no nested
    /// layout. Tapping the inline complication opens the host app, so
    /// the deep-link routes through `AppDelegate` once Flutter takes
    /// over.
    @ViewBuilder
    private var inlineView: some View {
        if let host = host {
            Label("Last connected: \(host.displayName)", systemImage: "terminal.fill")
        } else {
            Label("SSHVault", systemImage: "terminal")
        }
    }
}
