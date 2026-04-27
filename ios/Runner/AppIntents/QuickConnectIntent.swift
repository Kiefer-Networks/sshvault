// QuickConnectIntent.swift
//
// App Intent that opens SSHVault directly on the Quick Connect screen, the
// same surface that the Android Quick Settings tile and home-screen shortcut
// expose. Mirrors the `sshvault://quick-connect` deep link route.
//
// Requires iOS 16.0 or later.

import AppIntents
import UIKit

@available(iOS 16.0, *)
struct QuickConnectIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Connect"
    static var description = IntentDescription(
        "Open SSHVault on the Quick Connect screen."
    )

    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        if let url = URL(string: "sshvault://quick-connect") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .result()
    }
}
