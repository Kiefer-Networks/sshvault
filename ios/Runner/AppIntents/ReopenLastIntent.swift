// ReopenLastIntent.swift
//
// App Intent that reopens the most recently used SSH session in SSHVault,
// matching the Android `ReopenLast` shortcut/tile behaviour. Forwards control
// to the Flutter app via the `sshvault://reopen-last` deep link.
//
// Requires iOS 16.0 or later.

import AppIntents
import UIKit

@available(iOS 16.0, *)
struct ReopenLastIntent: AppIntent {
    static var title: LocalizedStringResource = "Reopen last session"
    static var description = IntentDescription(
        "Reopen the most recently used SSH session in SSHVault."
    )

    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        if let url = URL(string: "sshvault://reopen-last") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .result()
    }
}

// MARK: - App Shortcuts

/// Registers the three intents as App Shortcuts so they appear in the Siri /
/// Shortcuts UI without the user having to assemble them manually. Phrases
/// must contain `\(.applicationName)` per Apple's requirements.
@available(iOS 16.0, *)
struct SshvaultAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ConnectToHostIntent(),
            phrases: [
                "Connect to host with \(.applicationName)",
                "Open a host in \(.applicationName)",
                "SSH to host with \(.applicationName)",
            ],
            shortTitle: "Connect to host",
            systemImageName: "terminal"
        )
        AppShortcut(
            intent: QuickConnectIntent(),
            phrases: [
                "Quick connect with \(.applicationName)",
                "Open Quick Connect in \(.applicationName)",
            ],
            shortTitle: "Quick Connect",
            systemImageName: "bolt.fill"
        )
        AppShortcut(
            intent: ReopenLastIntent(),
            phrases: [
                "Reopen last session in \(.applicationName)",
                "Reopen the last \(.applicationName) session",
                "Resume \(.applicationName)",
            ],
            shortTitle: "Reopen last",
            systemImageName: "arrow.uturn.backward"
        )
    }

    static var shortcutTileColor: ShortcutTileColor = .navy
}
