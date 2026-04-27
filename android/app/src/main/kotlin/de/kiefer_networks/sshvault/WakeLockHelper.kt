package de.kiefer_networks.sshvault

import android.content.Context
import android.os.PowerManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

/**
 * Bridges the Dart [PowerInhibitorService] to Android's [PowerManager.WakeLock]
 * so an active SSH session can keep the CPU running while the screen is off.
 *
 * Mirrors the API exposed by the Linux/Windows/macOS backends:
 *   * `acquire(reason: String) -> String`  — returns an opaque key
 *   * `release(key: String) -> void`       — releases the matching wake lock
 *
 * We use a `PARTIAL_WAKE_LOCK` (CPU stays on, screen may sleep) with a
 * 1-hour timeout as a safety net so a stuck lock can never permanently
 * pin the CPU. The Dart side is expected to release explicitly when the
 * last SSH session closes; the timeout is a belt-and-braces fallback.
 *
 * Method-channel name MUST stay in sync with `kAndroidWakeLockChannel`
 * in `lib/core/services/power_inhibitor_service.dart`.
 */
class WakeLockHelper(context: Context, messenger: BinaryMessenger) {
    companion object {
        const val CHANNEL = "de.kiefer_networks.sshvault/wake_lock"
        // 1 hour — Android enforces a system-side cap on un-timed wake locks
        // and warns in logcat above 30 minutes. The Dart layer releases on
        // SSH disconnect; this timeout is just a safety valve.
        private const val WAKE_LOCK_TIMEOUT_MS = 60L * 60L * 1000L
        private const val TAG_PREFIX = "SSHVault::"
    }

    private val powerManager =
        context.applicationContext.getSystemService(Context.POWER_SERVICE) as PowerManager
    private val channel = MethodChannel(messenger, CHANNEL)
    private val locks = mutableMapOf<String, PowerManager.WakeLock>()

    init {
        channel.setMethodCallHandler { call, result -> onMethodCall(call, result) }
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "acquire" -> {
                val reason = call.argument<String>("reason") ?: "ssh-session"
                try {
                    val key = acquire(reason)
                    result.success(key)
                } catch (e: Throwable) {
                    result.error("WAKE_LOCK_ACQUIRE_FAILED", e.message, null)
                }
            }
            "release" -> {
                val key = call.argument<String>("key")
                if (key == null) {
                    result.error("WAKE_LOCK_MISSING_KEY", "key is required", null)
                    return
                }
                release(key)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun acquire(reason: String): String {
        val wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "$TAG_PREFIX$reason"
        ).apply {
            // Don't hold while the lock object is being created; setReferenceCounted(false)
            // ensures one acquire == one release semantics matching our key map.
            setReferenceCounted(false)
            acquire(WAKE_LOCK_TIMEOUT_MS)
        }
        val key = UUID.randomUUID().toString()
        locks[key] = wakeLock
        return key
    }

    private fun release(key: String) {
        val wakeLock = locks.remove(key) ?: return
        try {
            if (wakeLock.isHeld) {
                wakeLock.release()
            }
        } catch (_: Throwable) {
            // Best-effort: a wake lock auto-released by the OS timeout will
            // throw on a redundant release; we treat that as success.
        }
    }
}
