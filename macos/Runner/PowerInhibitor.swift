import Foundation
import FlutterMacOS
import IOKit
import IOKit.pwr_mgt

/// Native power-management bridge for the macOS host of SSHVault.
///
/// While at least one SSH session is connected we want to prevent the
/// system from suspending due to user-idle timeouts (matching the Linux
/// `logind!Inhibit` and Windows `SetThreadExecutionState` backends in
/// `lib/core/services/power_inhibitor_service.dart`).
///
/// On macOS the supported API is `IOPMAssertionCreateWithName` from
/// `IOKit/pwr_mgt`. Each call returns a 32-bit assertion id that the
/// caller must later release via `IOPMAssertionRelease`. The Dart side
/// stores the returned id (boxed as a Dart `int`) and hands it back when
/// the lock is released; we keep no in-process state here beyond what
/// IOKit itself tracks.
///
/// MethodChannel: `de.kiefer_networks.sshvault/power_inhibit`.
///
/// Methods:
///   * `acquire(reason: String) -> Int`
///       Creates a `PreventUserIdleSystemSleep` assertion. Returns the
///       assertion id on success; throws a `FlutterError` on failure.
///   * `release(id: Int) -> nil`
///       Releases the previously-acquired assertion. Idempotent at the
///       IOKit level — releasing an unknown id is logged and otherwise
///       ignored.
final class PowerInhibitor {

  /// Channel name matched on the Dart side. Must stay in sync with
  /// `PowerInhibitorService` in the Flutter code.
  static let channelName = "de.kiefer_networks.sshvault/power_inhibit"

  private let channel: FlutterMethodChannel

  init(messenger: FlutterBinaryMessenger) {
    self.channel = FlutterMethodChannel(
      name: PowerInhibitor.channelName,
      binaryMessenger: messenger
    )
    self.channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call: call, result: result)
    }
  }

  // MARK: - Method dispatch

  private func handle(
    call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    switch call.method {
    case "acquire":
      let reason: String
      if let args = call.arguments as? [String: Any],
         let r = args["reason"] as? String, !r.isEmpty {
        reason = r
      } else if let s = call.arguments as? String, !s.isEmpty {
        reason = s
      } else {
        reason = "Active SSH session"
      }
      acquire(reason: reason, result: result)

    case "release":
      let id: Int?
      if let args = call.arguments as? [String: Any] {
        id = args["id"] as? Int
      } else if let n = call.arguments as? Int {
        id = n
      } else {
        id = nil
      }
      guard let assertionId = id else {
        result(FlutterError(
          code: "invalid_args",
          message: "release requires an integer assertion id",
          details: nil
        ))
        return
      }
      release(id: assertionId, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - IOPMAssertion bridge

  private func acquire(reason: String, result: @escaping FlutterResult) {
    var assertionId: IOPMAssertionID = 0
    let status = IOPMAssertionCreateWithName(
      kIOPMAssertionTypePreventUserIdleSystemSleep as CFString,
      IOPMAssertionLevel(kIOPMAssertionLevelOn),
      reason as CFString,
      &assertionId
    )
    if status == kIOReturnSuccess {
      // IOPMAssertionID is a UInt32; widen to Int for the Dart channel.
      result(Int(assertionId))
    } else {
      result(FlutterError(
        code: "iopm_failed",
        message: "IOPMAssertionCreateWithName returned \(status)",
        details: nil
      ))
    }
  }

  private func release(id: Int, result: @escaping FlutterResult) {
    let assertionId = IOPMAssertionID(UInt32(truncatingIfNeeded: id))
    let status = IOPMAssertionRelease(assertionId)
    if status == kIOReturnSuccess {
      result(nil)
    } else {
      // Releasing an unknown / already-released id is non-fatal — the
      // Dart layer treats release as best-effort, mirroring the Linux fd
      // close and Windows clear-on-zero semantics.
      result(FlutterError(
        code: "iopm_release_failed",
        message: "IOPMAssertionRelease returned \(status)",
        details: nil
      ))
    }
  }
}
