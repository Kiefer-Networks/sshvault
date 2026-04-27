// Native bridge for SSHVault's iOS 16.1+ Live Activity.
//
// Wires the `de.kiefer_networks.sshvault/live_activity` method channel
// to ActivityKit. Dart-side caller is `IosLiveActivityService`
// (`lib/core/services/ios_live_activity_service.dart`); the contract is:
//
//   start(count: Int, names: [String])
//     → If no activity is alive, request one. Otherwise update.
//   update(count: Int, names: [String])
//     → Push a new content state. No-op if no activity exists.
//   end()
//     → Tear down the current activity, if any. Idempotent.
//
// Swift-side state is intentionally tiny — a single optional handle. We
// never enumerate `Activity<...>.activities` because we always own the
// only one we care about.

import Flutter
import Foundation
import UIKit

#if canImport(ActivityKit)
import ActivityKit
#endif

/// Method-channel name shared with the Dart side. Renaming on either
/// side breaks the bridge — both must move together.
let kLiveActivityChannel = "de.kiefer_networks.sshvault/live_activity"

/// Thin wrapper around `Activity<SessionActivityAttributes>` that
/// exposes a synchronous `start/update/end` surface to Flutter. All
/// ActivityKit work happens on the main actor; we hop there from the
/// Flutter handler thread via `Task { @MainActor in … }`.
@available(iOS 16.1, *)
final class LiveActivityBridge {
    /// Single in-flight activity, if any. SSHVault never runs more than
    /// one live activity at a time so a scalar handle is sufficient.
    private var activity: Activity<SessionActivityAttributes>?

    /// Registers the channel handler on the supplied [messenger]. Safe
    /// to call from `didInitializeImplicitFlutterEngine`.
    static func register(with messenger: FlutterBinaryMessenger) {
        let bridge = LiveActivityBridge()
        let channel = FlutterMethodChannel(
            name: kLiveActivityChannel,
            binaryMessenger: messenger)
        channel.setMethodCallHandler { call, result in
            bridge.handle(call: call, result: result)
        }
    }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Live Activities require iOS 16.1 plus an explicit user opt-in
        // via `ActivityAuthorizationInfo`. Anything older / disabled
        // silently no-ops so the Dart side can call without guards.
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            result(nil)
            return
        }

        let args = call.arguments as? [String: Any] ?? [:]
        let count = args["count"] as? Int ?? 0
        let names = (args["names"] as? [String]) ?? []
        // Defensive trim — ActivityKit caps payloads at 4 KB. The Dart
        // side already clamps but we re-clamp here so a future caller
        // can't accidentally blow the budget.
        let trimmed = Array(names.prefix(5))

        switch call.method {
        case "start":
            Task { @MainActor in
                self.startOrUpdate(count: count, names: trimmed)
                result(nil)
            }
        case "update":
            Task { @MainActor in
                await self.update(count: count, names: trimmed)
                result(nil)
            }
        case "end":
            Task { @MainActor in
                await self.end()
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @MainActor
    private func startOrUpdate(count: Int, names: [String]) {
        let state = SessionActivityAttributes.ContentState(
            count: count, hostNames: names)
        if let existing = activity {
            // Already running — fold the start request into an update so
            // re-entering the foreground after a transient disconnect
            // doesn't spawn duplicate activities.
            Task {
                if #available(iOS 16.2, *) {
                    await existing.update(ActivityContent(state: state, staleDate: nil))
                } else {
                    await existing.update(using: state)
                }
            }
            return
        }

        let attributes = SessionActivityAttributes()
        do {
            if #available(iOS 16.2, *) {
                let content = ActivityContent(state: state, staleDate: nil)
                activity = try Activity.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil)
            } else {
                activity = try Activity.request(
                    attributes: attributes,
                    contentState: state,
                    pushToken: nil)
            }
        } catch {
            // ActivityKit refused the request (most often: user
            // disabled Live Activities for SSHVault in Settings, or the
            // 8-active-activity ceiling was hit). Swallow — the Dart
            // side treats `start` as best-effort.
            NSLog("LiveActivityBridge: failed to start activity: \(error)")
        }
    }

    @MainActor
    private func update(count: Int, names: [String]) async {
        guard let activity = activity else { return }
        let state = SessionActivityAttributes.ContentState(
            count: count, hostNames: names)
        if #available(iOS 16.2, *) {
            await activity.update(ActivityContent(state: state, staleDate: nil))
        } else {
            await activity.update(using: state)
        }
    }

    @MainActor
    private func end() async {
        guard let activity = activity else { return }
        if #available(iOS 16.2, *) {
            await activity.end(nil, dismissalPolicy: .immediate)
        } else {
            await activity.end(dismissalPolicy: .immediate)
        }
        self.activity = nil
    }
}
