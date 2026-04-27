// Widget bundle entry point for the SSHVault Live Activity extension.
//
// The bundle hosts a single `LiveActivityWidget` — there are no
// home-screen widgets in this target. iOS 16.1 is the minimum required
// for `ActivityKit`, so the bundle is gated behind the same availability
// check the rest of the extension uses.

import SwiftUI
import WidgetKit

@main
struct SshvaultLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.1, *) {
            LiveActivityWidget()
        }
    }
}
