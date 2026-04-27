// QuickConnectWidget.swift
//
// Home Screen widget showing the user's top favorite SSH hosts as
// `Link(URL("sshvault://host/<id>"))` tiles. Three sizes:
//
//   * systemSmall  — 1 host  (single big tile)
//   * systemMedium — 4 hosts (2×2 grid)
//   * systemLarge  — 8 hosts (4×2 grid)
//
// Reads its data from the App Group via `WidgetPayload.loadFromAppGroup`
// (declared in `SshvaultWidget.swift`).

import SwiftUI
import WidgetKit

struct QuickConnectWidget: Widget {
    /// Maximum number of tiles rendered in `systemLarge`. Mirrors
    /// `IosWidgetService.kMaxTiles` on the Flutter side.
    static let maxTiles = 8

    let kind = "QuickConnectWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PayloadProvider()) { entry in
            QuickConnectWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("SSHVault Quick Connect")
        .description("Tap a favorite to open an SSH session.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct QuickConnectWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: PayloadEntry

    var body: some View {
        switch family {
        case .systemSmall:
            singleTile(entry.payload.favorites.first)
        case .systemMedium:
            grid(rows: 2, cols: 2, hosts: Array(entry.payload.favorites.prefix(4)))
        case .systemLarge:
            grid(rows: 2, cols: 4, hosts: Array(entry.payload.favorites.prefix(QuickConnectWidget.maxTiles)))
        default:
            singleTile(entry.payload.favorites.first)
        }
    }

    /// Single big tile — the systemSmall family. When no host is
    /// configured we render the placeholder so the widget reads as
    /// "tap to set up" rather than empty.
    @ViewBuilder
    private func singleTile(_ host: WidgetHost?) -> some View {
        if let host = host {
            Link(destination: deepLink(forHost: host.id)) {
                VStack(spacing: 6) {
                    Image(systemName: "terminal.fill")
                        .font(.system(size: 28, weight: .semibold))
                    Text(host.displayName)
                        .font(.headline)
                        .lineLimit(1)
                    if !host.name.isEmpty && !host.hostname.isEmpty {
                        Text(host.hostname)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            placeholderView
        }
    }

    /// Generic R×C grid for systemMedium / systemLarge. Empty cells are
    /// rendered as faint dashed placeholders so the layout stays even.
    @ViewBuilder
    private func grid(rows: Int, cols: Int, hosts: [WidgetHost]) -> some View {
        let total = rows * cols
        let padded: [WidgetHost?] = (0..<total).map { idx in
            idx < hosts.count ? hosts[idx] : nil
        }
        VStack(spacing: 6) {
            ForEach(0..<rows, id: \.self) { r in
                HStack(spacing: 6) {
                    ForEach(0..<cols, id: \.self) { c in
                        let idx = r * cols + c
                        cellView(padded[idx])
                    }
                }
            }
        }
        .padding(6)
    }

    @ViewBuilder
    private func cellView(_ host: WidgetHost?) -> some View {
        if let host = host {
            Link(destination: deepLink(forHost: host.id)) {
                VStack(spacing: 2) {
                    Image(systemName: "terminal.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text(host.displayName)
                        .font(.caption2)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background.secondary, in: RoundedRectangle(cornerRadius: 8))
            }
        } else {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.secondary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var placeholderView: some View {
        VStack(spacing: 4) {
            Image(systemName: "terminal")
                .font(.system(size: 24))
                .foregroundStyle(.secondary)
            Text("No favorites yet")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
