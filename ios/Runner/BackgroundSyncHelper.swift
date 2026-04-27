// BackgroundSyncHelper — iOS counterpart to Android's WorkManager-driven
// auto-sync. Wraps `BGTaskScheduler` so the app can pull a fresh vault
// version from the sync server even while suspended.
//
// Design notes:
//
// * The task identifier `de.kiefer_networks.sshvault.sync` MUST also be
//   listed in `Info.plist` under `BGTaskSchedulerPermittedIdentifiers`,
//   otherwise `register(forTaskWithIdentifier:...)` returns `false` and
//   the system silently drops every submit.
//
// * `register()` is called from `application(_:didFinishLaunchingWithOptions:)`
//   *before* the first `runApp` returns — Apple requires registration
//   during the launch sequence; doing it later is rejected.
//
// * The actual sync work is owned by Dart. The iOS handler bounces over
//   the same `de.kiefer-networks.sshvault/background_sync` MethodChannel
//   that the Dart service calls into, awaits the Future via a semaphore,
//   then completes the `BGTask` with success / failure so the OS can
//   schedule the next slot. We re-arm the next task before invoking the
//   Dart side because the OS clears the request as soon as the handler
//   fires.
//
// * iOS background tasks have a strict ~30s wallclock budget. The
//   pipeline already times out individual SFTP / HTTP calls, so the
//   semaphore wait is bounded at 25s to leave room for the
//   `setTaskCompleted` ack.

import BackgroundTasks
import Flutter
import UIKit

@objc public final class BackgroundSyncHelper: NSObject {

  /// Must match `BGTaskSchedulerPermittedIdentifiers` in Info.plist and
  /// `_kIosSyncTaskIdentifier` on the Dart side.
  public static let taskIdentifier = "de.kiefer_networks.sshvault.sync"

  /// MethodChannel name shared with `IosBackgroundSyncService`. The
  /// channel is created lazily once Flutter's first engine attaches.
  public static let channelName = "de.kiefer-networks.sshvault/background_sync"

  /// Holds the live channel so the BGTask handler can dispatch into Dart.
  /// Set from `AppDelegate.didInitializeImplicitFlutterEngine` — until
  /// then the BGTask handler logs and reschedules without doing work.
  public static var channel: FlutterMethodChannel?

  /// Wallclock budget for the Dart sync round-trip. iOS gives the BGTask
  /// up to ~30s; we leave ~5s headroom for `setTaskCompleted` + teardown.
  private static let dartTimeout: DispatchTime = .now() + .seconds(25)

  /// Registers the BGTask handler. MUST be called from
  /// `application(_:didFinishLaunchingWithOptions:)`.
  ///
  /// Returns `true` when the system accepted the registration; on
  /// simulator builds and unsupported OS releases this is a no-op that
  /// returns `false`.
  @discardableResult
  @objc public static func register() -> Bool {
    let ok = BGTaskScheduler.shared.register(
      forTaskWithIdentifier: taskIdentifier,
      using: nil
    ) { task in
      handle(task: task)
    }
    if !ok {
      NSLog("[BgSync] BGTaskScheduler registration failed for \(taskIdentifier)")
    }
    return ok
  }

  /// Builds and submits a `BGAppRefreshTaskRequest`. The `interval` is
  /// passed straight through as `earliestBeginDate`; the OS may delay
  /// further based on usage heuristics.
  ///
  /// Safe to call repeatedly — submitting a fresh request replaces the
  /// previously-pending one with the same identifier.
  @objc public static func schedule(interval: TimeInterval) {
    let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
    request.earliestBeginDate = Date(timeIntervalSinceNow: interval)
    do {
      try BGTaskScheduler.shared.submit(request)
      NSLog("[BgSync] Scheduled BGAppRefreshTask in \(Int(interval))s")
    } catch {
      // Most common cause: the task identifier is missing from the
      // Info.plist allowlist or the user disabled Background App
      // Refresh in Settings. Either way the failure is non-fatal.
      NSLog("[BgSync] Failed to submit BGTaskRequest: \(error)")
    }
  }

  /// Cancels any pending request for our identifier. Used when the user
  /// flips the opt-in toggle off in the settings screen.
  @objc public static func cancel() {
    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskIdentifier)
    NSLog("[BgSync] Cancelled pending BGTaskRequest")
  }

  // MARK: - Private

  /// Bounces the OS-fired `BGTask` over the method channel into Dart's
  /// `callbackDispatcher`. Reschedules the next slot first so a crash
  /// in Dart-land still leaves us armed for the following window.
  private static func handle(task: BGTask) {
    // Re-arm BEFORE invoking Dart. If the Dart side throws or the task
    // gets killed by the watchdog the OS still has a request on file.
    // The default 1h cadence matches Android's WorkManager floor of
    // 15min plus a comfortable buffer; the Dart side updates this on
    // every interval change.
    schedule(interval: 60 * 60)

    guard let channel = BackgroundSyncHelper.channel else {
      NSLog("[BgSync] No Flutter channel attached — skipping run")
      task.setTaskCompleted(success: false)
      return
    }

    // Expiration handler: the OS calls this when our budget is about to
    // run out. We can only ack the task — Dart cannot be cancelled
    // cooperatively from the platform side.
    task.expirationHandler = {
      NSLog("[BgSync] BGTask expired before Dart finished")
      task.setTaskCompleted(success: false)
    }

    // The MethodChannel must be invoked on the main thread; the result
    // callback then signals a semaphore so we can hold the BGTask alive
    // while Dart runs. Without the semaphore the BGTask returns as soon
    // as `handle` exits and the system suspends us mid-sync.
    let semaphore = DispatchSemaphore(value: 0)
    var success = false

    DispatchQueue.main.async {
      channel.invokeMethod("runBackgroundSync", arguments: nil) { result in
        if let ok = result as? Bool {
          success = ok
        } else if let err = result as? FlutterError {
          NSLog("[BgSync] Dart returned error: \(err.message ?? err.code)")
          success = false
        } else {
          // `nil` from `result(nil)` on the Dart side — treat as a
          // successful no-op (e.g. user not authenticated).
          success = true
        }
        semaphore.signal()
      }
    }

    // `.success` ⇒ Dart finished within the budget. `.timedOut` ⇒ we
    // hit the 25s safety wall; ack as failure so iOS applies its own
    // backoff before the next slot.
    if semaphore.wait(timeout: dartTimeout) == .timedOut {
      NSLog("[BgSync] Dart sync timed out after 25s")
      task.setTaskCompleted(success: false)
      return
    }
    task.setTaskCompleted(success: success)
  }
}
