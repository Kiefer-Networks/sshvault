package de.kiefer_networks.sshvault

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/**
 * Foreground service that keeps SSH sessions alive while the app is
 * backgrounded. The Dart side drives the lifecycle through the
 * `de.kiefer_networks.sshvault/session_service` method channel:
 *
 *   - `start(count, names)` is rebroadcast as an explicit intent that
 *     calls [onStartCommand]; the resulting notification is sticky and
 *     uses the LOW-importance `ssh_sessions` channel so it never makes
 *     noise.
 *   - `stop()` simply lets the Dart side call [Context.stopService].
 *
 * Tapping the "Disconnect all" action fires a broadcast on
 * [ACTION_DISCONNECT_ALL]; we receive it inside the service, write the
 * shared-preferences flag the Dart side polls/listens to, then stop
 * ourselves so Android tears the notification down.
 */
class SessionForegroundService : Service() {

    companion object {
        const val SESSION_NOTIF_ID = 0x55_48_56_01 // 'SHV\x01'
        const val CHANNEL_ID = "ssh_sessions"

        const val EXTRA_COUNT = "count"
        const val EXTRA_NAMES = "names"

        const val ACTION_START = "de.kiefer_networks.sshvault.action.START_SESSIONS"
        const val ACTION_DISCONNECT_ALL =
            "de.kiefer_networks.sshvault.action.DISCONNECT_ALL"

        /** Shared-prefs file inspected by the Dart side after a disconnect-all. */
        const val PREFS_NAME = "session_foreground_service"
        const val PREF_DISCONNECT_REQUESTED = "disconnect_all_requested"
    }

    private var receiverRegistered = false

    private val disconnectReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action != ACTION_DISCONNECT_ALL) return
            context
                .getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit()
                .putBoolean(PREF_DISCONNECT_REQUESTED, true)
                .apply()
            stopSelf()
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        ensureChannel()
        registerDisconnectReceiver()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val count = intent?.getIntExtra(EXTRA_COUNT, 0) ?: 0
        val names = intent?.getStringArrayListExtra(EXTRA_NAMES) ?: arrayListOf()
        val notification = buildNotification(count, names)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                SESSION_NOTIF_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC,
            )
        } else {
            @Suppress("DEPRECATION")
            startForeground(SESSION_NOTIF_ID, notification)
        }
        return START_STICKY
    }

    override fun onDestroy() {
        if (receiverRegistered) {
            try {
                unregisterReceiver(disconnectReceiver)
            } catch (_: IllegalArgumentException) {
                // Already unregistered — best-effort.
            }
            receiverRegistered = false
        }
        super.onDestroy()
    }

    private fun registerDisconnectReceiver() {
        if (receiverRegistered) return
        val filter = IntentFilter(ACTION_DISCONNECT_ALL)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(disconnectReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(disconnectReceiver, filter)
        }
        receiverRegistered = true
    }

    private fun ensureChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val mgr = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (mgr.getNotificationChannel(CHANNEL_ID) != null) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "SSH sessions",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Active SSH sessions kept alive in the background."
            setShowBadge(false)
        }
        mgr.createNotificationChannel(channel)
    }

    private fun buildNotification(count: Int, names: List<String>): Notification {
        val title = if (count <= 1) "SSH session active" else "$count SSH sessions active"
        val body = if (names.isEmpty()) {
            "Connections kept alive in the background"
        } else {
            names.joinToString(", ")
        }

        val contentIntent = packageManager
            .getLaunchIntentForPackage(packageName)
            ?.let { launch ->
                PendingIntent.getActivity(
                    this,
                    0,
                    launch,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
            }

        val disconnectIntent = Intent(ACTION_DISCONNECT_ALL).setPackage(packageName)
        val disconnectPi = PendingIntent.getBroadcast(
            this,
            0,
            disconnectIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setSmallIcon(android.R.drawable.stat_sys_data_bluetooth) // replaced by app icon at runtime
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setContentIntent(contentIntent)
            .addAction(
                0,
                "Disconnect all",
                disconnectPi,
            )
            .build()
    }
}
