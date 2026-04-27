// Live Activity attributes for SSHVault active SSH sessions.
//
// Mirrors the payload `LiveActivityBridge` posts from the main app over
// the `de.kiefer_networks.sshvault/live_activity` method channel:
//
//   - `count`     — number of currently active SSH sessions.
//   - `hostNames` — display names of those sessions, ordered by recency
//                   so the lock-screen card surfaces the most relevant
//                   ones first when truncation kicks in.
//
// `name` is empty because we only ever drive a single Live Activity per
// app instance (one SSHVault session group), so no per-instance
// disambiguation is required.

import ActivityKit
import Foundation

@available(iOS 16.1, *)
public struct SessionActivityAttributes: ActivityAttributes {
    /// Mutable content state pushed via `Activity.update(...)`. Kept tiny
    /// because ActivityKit gates updates behind a daily byte budget.
    public struct ContentState: Codable, Hashable {
        /// Number of currently connected SSH sessions.
        public var count: Int

        /// Display names of those sessions (most-recent-first). Trimmed
        /// at the call site to ~5 entries so the encoded payload stays
        /// well under ActivityKit's 4 KB cap.
        public var hostNames: [String]

        public init(count: Int, hostNames: [String]) {
            self.count = count
            self.hostNames = hostNames
        }
    }

    /// Static identifier for the activity group. The system uses this to
    /// dedupe the Dynamic Island slot — only one SSHVault activity is
    /// alive at a time so a constant string is fine.
    public let name: String

    public init(name: String = "sshvault.sessions") {
        self.name = name
    }
}
