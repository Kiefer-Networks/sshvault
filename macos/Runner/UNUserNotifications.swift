// UNUserNotifications.swift
//
// Native macOS notification plugin for SSHVault. Replaces the deprecated
// NSUserNotification path used by `local_notifier` 0.1.6 with the modern
// UNUserNotificationCenter API which is required for:
//
//   - Multiple inline action buttons (Reconnect / Disconnect / Show)
//   - Notification Center persistence on Big Sur+
//   - Permission handling via UNAuthorizationOptions
//   - Working on signed/notarized macOS apps without legacy entitlements
//
// Bridged to Dart via a single FlutterMethodChannel keyed
// `de.kiefer_networks.sshvault/macos_notif`. Methods:
//
//   * `requestAuthorization` -> Bool (granted)
//   * `show(id, title, body, categoryId, actions: [{id,label}])` -> Bool
//   * `dismiss(id)` -> Bool
//
// Outbound from Swift -> Dart:
//
//   * `onAction(notificationId, actionId)` — emitted when the user clicks
//     a button on the notification (including from Notification Center).
//   * `onClick(notificationId)` — emitted when the user clicks the body.
//
// The Dart side keeps the click router policy: it pattern-matches the
// `actionId` (e.g. `disconnect:HOST_ID`) and dispatches to the right
// session. Swift is intentionally dumb about the payload — it just
// round-trips opaque strings.

import Cocoa
import FlutterMacOS
import UserNotifications

@available(macOS 10.14, *)
public class UNUserNotificationsPlugin: NSObject, FlutterPlugin,
    UNUserNotificationCenterDelegate
{
    private static let channelName = "de.kiefer_networks.sshvault/macos_notif"

    private var channel: FlutterMethodChannel!

    /// Tracks category identifiers we've already registered with the
    /// notification center. Categories are global on macOS — re-registering
    /// the same id is cheap but pointless, so we de-dupe.
    private var registeredCategories: Set<String> = []

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger
        )
        let instance = UNUserNotificationsPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        UNUserNotificationCenter.current().delegate = instance
    }

    public func handle(
        _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        switch call.method {
        case "requestAuthorization":
            requestAuthorization(result: result)
        case "show":
            show(call: call, result: result)
        case "dismiss":
            dismiss(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Permissions

    private func requestAuthorization(result: @escaping FlutterResult) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            DispatchQueue.main.async { result(granted) }
        }
    }

    // MARK: - Show

    private func show(call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let args = call.arguments as? [String: Any],
            let identifier = args["id"] as? String
        else {
            result(
                FlutterError(
                    code: "bad_args",
                    message: "show() requires a String 'id'", details: nil))
            return
        }

        let title = args["title"] as? String ?? ""
        let body = args["body"] as? String ?? ""
        let categoryId = args["categoryId"] as? String ?? "ssh_session"
        let rawActions = args["actions"] as? [[String: String]] ?? []

        // Build category from supplied actions. We rebuild on every call
        // because action labels are localized and the disconnect tag
        // contains a session-specific suffix (e.g. `disconnect:abc-123`).
        var categoryActions: [UNNotificationAction] = []
        for entry in rawActions {
            guard let actId = entry["id"], let label = entry["label"] else {
                continue
            }
            let act = UNNotificationAction(
                identifier: actId,
                title: label,
                options: [.foreground]
            )
            categoryActions.append(act)
        }

        // Use a category id that's stable per-action-set so notifications
        // with different action lists don't clobber each other's category.
        // We hash the action ids together to keep this deterministic
        // without leaking payload contents.
        let categoryKey =
            "\(categoryId).\(categoryActions.map(\.identifier).joined(separator: "|"))"

        let category = UNNotificationCategory(
            identifier: categoryKey,
            actions: categoryActions,
            intentIdentifiers: [],
            options: []
        )

        let center = UNUserNotificationCenter.current()
        center.getNotificationCategories { existing in
            var merged = existing
            merged.insert(category)
            center.setNotificationCategories(merged)

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            content.categoryIdentifier = categoryKey

            // Replace-by-id semantics: removing any pending/delivered copy
            // first so Notification Center collapses into a single entry.
            center.removeDeliveredNotifications(withIdentifiers: [identifier])
            center.removePendingNotificationRequests(withIdentifiers: [
                identifier
            ])

            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: nil
            )
            center.add(request) { error in
                DispatchQueue.main.async {
                    result(error == nil)
                }
            }
        }
    }

    // MARK: - Dismiss

    private func dismiss(
        call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        guard let args = call.arguments as? [String: Any],
            let identifier = args["id"] as? String
        else {
            result(
                FlutterError(
                    code: "bad_args",
                    message: "dismiss() requires a String 'id'", details: nil))
            return
        }
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        result(true)
    }

    // MARK: - UNUserNotificationCenterDelegate

    /// Show the notification banner even if the app is foregrounded —
    /// SSHVault toasts are intentionally surface-while-active so users see
    /// session lifecycle changes immediately.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    /// Routes user interactions back to Dart. We always activate the app
    /// so the SSHVault window comes forward — the click handler in Dart
    /// then decides which terminal/branch to focus based on the action id.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        NSApp.activate(ignoringOtherApps: true)

        let notificationId = response.notification.request.identifier
        let actionId = response.actionIdentifier

        if actionId == UNNotificationDefaultActionIdentifier {
            channel?.invokeMethod(
                "onClick",
                arguments: ["id": notificationId]
            )
        } else if actionId != UNNotificationDismissActionIdentifier {
            channel?.invokeMethod(
                "onAction",
                arguments: ["id": notificationId, "action": actionId]
            )
        }
        completionHandler()
    }
}
