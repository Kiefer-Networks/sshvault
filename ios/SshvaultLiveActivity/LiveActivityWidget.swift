// SwiftUI presentation layer for the SSHVault Live Activity.
//
// Renders three Dynamic Island modes (compact, expanded, minimal) plus
// the lock-screen / banner card. Everything is read-only: state arrives
// via `Activity.update(...)` from the main app's `LiveActivityBridge`,
// nothing here mutates it.

import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct LiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionActivityAttributes.self) { context in
            // -- Lock Screen / banner --
            // Full-bleed card surfaced on the lock screen and as a
            // pull-down banner. Shows the count + a truncated host list
            // so the user can tell *which* sessions are alive without
            // unlocking the device.
            LockScreenView(state: context.state)
                .padding(16)
                .activityBackgroundTint(Color.black.opacity(0.6))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                // -- Expanded (long-press / glance) --
                DynamicIslandExpandedRegion(.leading) {
                    Label {
                        Text("SSHVault")
                            .font(.caption.weight(.semibold))
                    } icon: {
                        Image(systemName: "terminal.fill")
                            .foregroundColor(.green)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.count)")
                        .font(.title2.monospacedDigit().weight(.bold))
                        .foregroundColor(.green)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(sessionWord(context.state.count))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.hostNames.isEmpty {
                        Text("No active sessions")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    } else {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(context.state.hostNames.prefix(3), id: \.self) { name in
                                Text(name)
                                    .font(.footnote.monospaced())
                                    .lineLimit(1)
                                    .truncationMode(.middle)
                            }
                            if context.state.hostNames.count > 3 {
                                Text("+\(context.state.hostNames.count - 3) more")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            } compactLeading: {
                // -- Compact (idle Dynamic Island, left of the cutout) --
                Image(systemName: "terminal.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                // -- Compact (right of the cutout) --
                Text("\(context.state.count)")
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .foregroundColor(.green)
            } minimal: {
                // -- Minimal (multiple activities competing for the slot) --
                Image(systemName: "terminal.fill")
                    .foregroundColor(.green)
            }
            .keylineTint(.green)
        }
    }

    /// Pluralization helper. Kept inline so the extension doesn't pull
    /// in a localization bundle — the activity is English-only for now.
    private func sessionWord(_ count: Int) -> String {
        return count == 1 ? "session" : "sessions"
    }
}

@available(iOS 16.1, *)
private struct LockScreenView: View {
    let state: SessionActivityAttributes.ContentState

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "terminal.fill")
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("SSHVault")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(state.count)")
                        .font(.headline.monospacedDigit())
                        .foregroundColor(.green)
                }

                if state.hostNames.isEmpty {
                    Text("No active sessions")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                } else {
                    Text(hostSummary)
                        .font(.subheadline.monospaced())
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                        .truncationMode(.middle)
                }
            }
        }
    }

    /// Comma-joined view-model. We cap at five names (the bridge already
    /// trims, but defensive truncation here keeps the card legible if a
    /// future caller forgets to clamp).
    private var hostSummary: String {
        let trimmed = state.hostNames.prefix(5)
        let extra = state.hostNames.count - trimmed.count
        let base = trimmed.joined(separator: ", ")
        return extra > 0 ? "\(base) +\(extra)" : base
    }
}
