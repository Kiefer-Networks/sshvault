// ConnectToHostIntent.swift
//
// App Intent that opens SSHVault and connects to a saved host.
//
// The user provides the saved host's display name (auto-completed by Siri /
// Shortcuts via `HostNameQuery`). At `perform()` time we forward control to
// the Flutter app via the `sshvault://host?name=<name>` deep link, which the
// Dart router already understands. If the user has not yet provided a name,
// we fall back to the generic `sshvault://reopen-last` entry point so the
// shortcut still does something useful.
//
// Requires iOS 16.0 or later.

import AppIntents
import UIKit

@available(iOS 16.0, *)
struct ConnectToHostIntent: AppIntent {
    static var title: LocalizedStringResource = "Connect to host"
    static var description = IntentDescription(
        "Open SSHVault and connect to a saved host."
    )

    /// Launching the app from a Siri intent must happen in the foreground so
    /// the deep-link can be handled by the Flutter side.
    static var openAppWhenRun: Bool = true

    @Parameter(
        title: "Host",
        description: "The saved host to connect to.",
        requestValueDialog: IntentDialog("Which host would you like to connect to?")
    )
    var hostName: String

    static var parameterSummary: some ParameterSummary {
        Summary("Connect to \(\.$hostName) with SSHVault")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        let encoded = hostName.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? hostName
        let urlString = "sshvault://host?name=\(encoded)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let fallback = URL(string: "sshvault://reopen-last") {
            UIApplication.shared.open(fallback, options: [:], completionHandler: nil)
        }
        return .result()
    }
}
