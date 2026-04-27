package de.kiefer_networks.sshvault

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PictureInPictureParams
import android.content.Context
import android.content.Intent
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager
import android.content.res.Configuration
import android.graphics.drawable.Icon
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Rational
import android.view.HapticFeedbackConstants
import android.view.WindowManager
import androidx.activity.enableEdgeToEdge
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val channel = "de.kiefer-networks.sshvault/screen_protection"
    private val shortcutsChannel = "de.kiefer_networks.sshvault/shortcuts"
    private val sessionServiceChannel = "de.kiefer_networks.sshvault/session_service"
    private val pipChannel = "de.kiefer_networks.sshvault/pip"
    private val hapticChannel = "de.kiefer_networks.sshvault/haptic"
    private val intentChannel = "de.kiefer_networks.sshvault/intent"
    private val widgetChannel = "de.kiefer_networks.sshvault/widget"
    private var sessionServiceMethodChannel: MethodChannel? = null
    private var intentMethodChannel: MethodChannel? = null
    private var disconnectPrefsListener: android.content.SharedPreferences.OnSharedPreferenceChangeListener? = null

    // URLs that arrived before the Flutter engine wired up the intent
    // channel (cold launch via VIEW intent on ssh:// or content:// file
    // open). Drained as soon as configureFlutterEngine finishes. Mirrors
    // the macOS `pendingUrls` buffer in AppDelegate.swift.
    private val pendingUrls: MutableList<String> = mutableListOf()

    // PiP method channel — kept alive for the lifetime of the activity so
    // the Dart side can react to entering/leaving PiP mode and request a
    // programmatic transition via `enterPip`. The "session active" gate is
    // read from a SharedPreferences flag that the Dart side flips whenever
    // an SSH session is active, so we don't have to round-trip across the
    // method channel at home-button time.
    private var pipMethodChannel: MethodChannel? = null

    // Holds the WakeLock bridge; instantiated in configureFlutterEngine so
    // the binary messenger is available. Kept as a field to keep the
    // MethodChannel handler alive for the activity's lifetime.
    private var wakeLockHelper: WakeLockHelper? = null

    // Holds the AndroidKeystore bridge that exposes hardware-backed
    // (StrongBox / TEE) AES-256-GCM keys for the master vault key. Kept
    // alive for the activity lifetime so the MethodChannel handler does
    // not get GC'd between Dart invocations. See AndroidKeystoreHelper.kt
    // for the channel contract.
    private var keystoreHelper: AndroidKeystoreHelper? = null

    // Flipped to true once the Flutter engine has rendered its first frame,
    // releasing the Android 12+ system splash screen. See onCreate() below.
    @Volatile
    private var flutterReady: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        // Android 12+ Splash Screen API. Must be called before super.onCreate()
        // so the system attaches the splash window to this activity. The
        // animated icon and background are configured in styles.xml under the
        // `LaunchTheme` (parent: Theme.SplashScreen).
        val splashScreen = installSplashScreen()

        // Edge-to-edge for Android 15+ (SDK 35) compatibility. Android 15
        // enforces edge-to-edge for apps targeting SDK 35+. We:
        //   1. enableEdgeToEdge() — AndroidX helper that sets the right
        //      decorFitsSystemWindows flag and applies appropriate insets.
        //   2. Explicit WindowCompat call — defensive, also pins the
        //      behavior on older API levels.
        //   3. Transparent system bars — Flutter's AnnotatedRegion +
        //      SystemChrome.setSystemUIOverlayStyle drives the icon
        //      brightness from the Dart side based on the active theme.
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
        window.statusBarColor = android.graphics.Color.TRANSPARENT
        window.navigationBarColor = android.graphics.Color.TRANSPARENT

        // Keep the system splash visible until Flutter has produced its first
        // frame, then let it animate out (default Material exit transition).
        // FlutterFragmentActivity posts the first-frame callback on the main
        // thread, so flipping the flag from there is sufficient.
        splashScreen.setKeepOnScreenCondition { !flutterReady }
        window.decorView.post {
            // Defer the release one frame past the activity's first draw so
            // the Flutter view has a chance to mount; in practice this is
            // when the engine signals onFirstFrame, but `post` is a safe,
            // dependency-free lower bound that never blocks the splash.
            flutterReady = true
        }

        registerNotificationChannels()
    }

    /**
     * Registers the four per-severity notification channels used by SSHVault.
     *
     * Idempotent — `NotificationManager.createNotificationChannel` no-ops
     * if a channel with the same id already exists, so we can safely re-run
     * on every cold start without resetting user-tweaked settings.
     *
     * Channel ids must mirror those declared in
     * `lib/core/services/android_notification_channels.dart` — the Dart
     * registry referenced by every `AndroidNotificationDetails` call site.
     *
     * Notification channels were introduced in Android 8.0 (API 26).
     */
    private fun registerNotificationChannels() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val sessions = NotificationChannel(
            "ssh_sessions",
            "Active SSH connections",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Persistent notification shown while SSH terminal sessions are open."
            setSound(null, null)
            enableVibration(false)
            enableLights(false)
            setShowBadge(false)
        }
        nm.createNotificationChannel(sessions)

        val defaultSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
        val audioAttrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION_EVENT)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val fingerprint = NotificationChannel(
            "fingerprint_warnings",
            "Host key warnings",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description =
                "Security-critical alerts about SSH host key changes or fingerprint verification failures."
            setSound(defaultSound, audioAttrs)
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 250, 200, 250)
            enableLights(true)
        }
        nm.createNotificationChannel(fingerprint)

        val sync = NotificationChannel(
            "sync_errors",
            "Sync issues",
            NotificationManager.IMPORTANCE_DEFAULT,
        ).apply {
            description =
                "Errors and conflicts encountered while synchronising the vault with the configured backend."
            setSound(defaultSound, audioAttrs)
            enableVibration(false)
        }
        nm.createNotificationChannel(sync)

        val rotation = NotificationChannel(
            "key_rotation_reminders",
            "Key rotation reminders",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Reminders to rotate SSH keys that exceed the configured age."
            setSound(null, null)
            enableVibration(false)
        }
        nm.createNotificationChannel(rotation)
    }

    /**
     * Maps a Dart-side semantic haptic name to a `HapticFeedbackConstants`
     * value. The richer CONFIRM / REJECT / GESTURE_END constants are API
     * 30+ (Android 11). On older OS versions we fall back to the closest
     * legacy constant so the user still feels something at every call
     * site. Returns `null` for unknown names so the Dart side can degrade
     * to a Flutter-managed `HapticFeedback` call.
     */
    private fun mapHapticConstant(name: String): Int? {
        return when (name) {
            "confirm" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                HapticFeedbackConstants.CONFIRM
            } else {
                HapticFeedbackConstants.VIRTUAL_KEY
            }
            "reject" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                HapticFeedbackConstants.REJECT
            } else {
                HapticFeedbackConstants.LONG_PRESS
            }
            "gestureEnd" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                HapticFeedbackConstants.GESTURE_END
            } else {
                HapticFeedbackConstants.CONTEXT_CLICK
            }
            else -> null
        }
    }

    /**
     * Forwards any VIEW intent's data URI to the Dart side over the
     * `de.kiefer_networks.sshvault/intent` channel. If the engine has not
     * wired the channel yet (cold launch — onCreate runs before
     * configureFlutterEngine), the URL is buffered in [pendingUrls] and
     * replayed once the channel comes up.
     */
    private fun forwardIntentUri(intent: Intent?) {
        if (intent == null) return
        if (intent.action != Intent.ACTION_VIEW) return
        val data = intent.data ?: return
        // App Shortcut intents (sshvault://...) are routed by other code
        // paths already; only forward the schemes we registered for in this
        // pass to avoid double-handling.
        val scheme = data.scheme?.lowercase()
        when (scheme) {
            "ssh", "sftp", "content", "file" -> Unit
            else -> return
        }
        val urlString = data.toString()
        val ch = intentMethodChannel
        if (ch != null) {
            ch.invokeMethod("openUrl", urlString)
        } else {
            pendingUrls.add(urlString)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Replace the activity's "current" intent so subsequent calls to
        // getIntent() see the new URI (mirrors Flutter's
        // FlutterActivity.onNewIntent contract for plugins).
        setIntent(intent)
        forwardIntentUri(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setFlagSecure" -> {
                        val enable = call.argument<Boolean>("enable") ?: false
                        if (enable) {
                            window.setFlags(
                                WindowManager.LayoutParams.FLAG_SECURE,
                                WindowManager.LayoutParams.FLAG_SECURE
                            )
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // Wire up the WakeLock bridge used by PowerInhibitorService on
        // Android. See WakeLockHelper.kt for the channel contract.
        wakeLockHelper = WakeLockHelper(applicationContext, flutterEngine.dartExecutor.binaryMessenger)

        // Material 3 Haptic Feedback bridge. The Dart side uses this to
        // route `tapConfirm` / `tapReject` / `gestureEnd` to the richer
        // `HapticFeedbackConstants.CONFIRM / REJECT / GESTURE_END`
        // primitives (API 30+) instead of the coarse Flutter
        // `HapticFeedback.lightImpact / mediumImpact / heavyImpact`
        // palette. The bridge respects the system-wide haptic setting
        // (no FLAG_IGNORE_GLOBAL_SETTING) — that's part of Material 3's
        // contract.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, hapticChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "performHaptic" -> {
                        val name = call.argument<String>("type") ?: ""
                        val constant = mapHapticConstant(name)
                        if (constant != null) {
                            val view = window?.decorView
                            view?.performHapticFeedback(constant)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Wire up the AndroidKeystore bridge so the Dart KeyringService can
        // provision an explicit hardware-backed master vault key with
        // StrongBox preferred where available. See AndroidKeystoreHelper.kt.
        keystoreHelper = AndroidKeystoreHelper(flutterEngine.dartExecutor.binaryMessenger)

        // Dynamic App Shortcuts: Dart pushes the top-N favorite hosts here so
        // they appear alongside the static `quick_connect` / `new_host` /
        // `last_session` entries when the user long-presses the launcher icon.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, shortcutsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setFavorites" -> {
                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1) {
                            // ShortcutManager is API 25+. Older devices simply
                            // get the static shortcuts and nothing else.
                            result.success(null)
                            return@setMethodCallHandler
                        }
                        @Suppress("UNCHECKED_CAST")
                        val list = call.arguments as? List<Map<String, Any?>>
                            ?: emptyList()
                        try {
                            applyDynamicFavorites(list)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error(
                                "SHORTCUT_ERROR",
                                e.message ?: "failed to set dynamic shortcuts",
                                null
                            )
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Foreground-service bridge for the session-keepalive notification.
        // Dart calls `start(count, names)` when the session count goes
        // 0 -> >=1 and `stop()` when it falls back to zero. The native
        // notification action calls back into Dart via `disconnectAll()`
        // when the user taps "Disconnect all" — wired through a shared
        // preferences listener so the broadcast survives the service
        // tearing itself down.
        val sessionChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            sessionServiceChannel,
        )
        sessionServiceMethodChannel = sessionChannel
        sessionChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val count = call.argument<Int>("count") ?: 0
                    val names = call.argument<List<String>>("names") ?: emptyList()
                    val intent =
                        Intent(this, SessionForegroundService::class.java).apply {
                            action = SessionForegroundService.ACTION_START
                            putExtra(SessionForegroundService.EXTRA_COUNT, count)
                            putStringArrayListExtra(
                                SessionForegroundService.EXTRA_NAMES,
                                ArrayList(names),
                            )
                        }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "stop" -> {
                    stopService(Intent(this, SessionForegroundService::class.java))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // Listen for the disconnect-all flag the foreground service flips
        // when the user taps the notification action; forward to Dart.
        val prefs = applicationContext.getSharedPreferences(
            SessionForegroundService.PREFS_NAME,
            Context.MODE_PRIVATE,
        )
        val listener =
            android.content.SharedPreferences.OnSharedPreferenceChangeListener { sp, key ->
                if (key == SessionForegroundService.PREF_DISCONNECT_REQUESTED &&
                    sp.getBoolean(key, false)
                ) {
                    sp.edit().putBoolean(key, false).apply()
                    sessionServiceMethodChannel?.invokeMethod("disconnectAll", null)
                }
            }
        prefs.registerOnSharedPreferenceChangeListener(listener)
        disconnectPrefsListener = listener

        // Picture-in-Picture bridge. The Dart side both sets the
        // "session active" gate via SharedPreferences (read in
        // onUserLeaveHint() to decide whether to enter PiP automatically
        // when the user presses Home) and listens for `onPipChanged(bool)`
        // events that mirror the activity's PiP lifecycle so the terminal
        // screen can collapse its chrome while floating.
        val pip = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            pipChannel,
        )
        pipMethodChannel = pip
        pip.setMethodCallHandler { call, result ->
            when (call.method) {
                "enterPip" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        try {
                            val params = PictureInPictureParams.Builder()
                                .setAspectRatio(Rational(16, 9))
                                .build()
                            val ok = enterPictureInPictureMode(params)
                            result.success(ok)
                        } catch (e: Throwable) {
                            result.error(
                                "PIP_ENTER_FAILED",
                                e.message ?: "enterPictureInPictureMode failed",
                                null,
                            )
                        }
                    } else {
                        // PiP is API 26+. Older devices simply report
                        // "didn't enter" so the Dart layer can degrade
                        // gracefully instead of throwing.
                        result.success(false)
                    }
                }
                "setSessionActive" -> {
                    val active = call.argument<Boolean>("active") ?: false
                    applicationContext
                        .getSharedPreferences(PIP_PREFS_NAME, Context.MODE_PRIVATE)
                        .edit()
                        .putBoolean(PIP_PREF_SESSION_ACTIVE, active)
                        .apply()
                    result.success(null)
                }
                "setPipEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    applicationContext
                        .getSharedPreferences(PIP_PREFS_NAME, Context.MODE_PRIVATE)
                        .edit()
                        .putBoolean(PIP_PREF_ENABLED, enabled)
                        .apply()
                    result.success(null)
                }
                "isSupported" -> {
                    result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                }
                else -> result.notImplemented()
            }
        }

        // Intent / URL forwarding bridge. Surfaces ssh:// + sftp:// URL
        // opens AND VIEW intents on .pub / .pem / .ppk / vault-export
        // files (content:// or file://) to Dart over the
        // `de.kiefer_networks.sshvault/intent` channel — see
        // `lib/core/services/android_intent_service.dart`.
        //
        // The channel also exposes a `resolveContentUri(uri)` method that
        // reads the bytes behind a content:// Uri using ContentResolver, so
        // the Dart side can route SAF-provided files (Open With… from a
        // file manager / Drive / Files) through the existing
        // FileDropService import flow without needing READ_EXTERNAL_STORAGE.
        val intentChan = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            intentChannel,
        )
        intentMethodChannel = intentChan
        intentChan.setMethodCallHandler { call, result ->
            when (call.method) {
                "resolveContentUri" -> {
                    val arg = call.arguments as? String
                    if (arg.isNullOrEmpty()) {
                        result.error(
                            "INVALID_URI",
                            "resolveContentUri requires a non-empty Uri string",
                            null,
                        )
                        return@setMethodCallHandler
                    }
                    try {
                        val uri = Uri.parse(arg)
                        val resolver = applicationContext.contentResolver
                        val bytes = resolver.openInputStream(uri).use { stream ->
                            if (stream == null) {
                                ByteArray(0)
                            } else {
                                // Cap at 1 MiB — public keys, ssh_config and
                                // vault export JSON all fit comfortably; a
                                // larger blob is almost certainly the wrong
                                // file. Mirrors the Dart-side
                                // `_maxDropFileBytes` guard.
                                val cap = 1 * 1024 * 1024
                                val buf = ByteArray(8192)
                                val out = java.io.ByteArrayOutputStream()
                                var total = 0
                                while (true) {
                                    val n = stream.read(buf)
                                    if (n <= 0) break
                                    total += n
                                    if (total > cap) {
                                        result.error(
                                            "TOO_LARGE",
                                            "Content exceeds $cap bytes",
                                            null,
                                        )
                                        return@setMethodCallHandler
                                    }
                                    out.write(buf, 0, n)
                                }
                                out.toByteArray()
                            }
                        }
                        // Best-effort filename for the Dart side, derived
                        // from OpenableColumns.DISPLAY_NAME when available.
                        var name: String? = null
                        try {
                            resolver.query(uri, null, null, null, null)?.use { c ->
                                val idx = c.getColumnIndex(
                                    android.provider.OpenableColumns.DISPLAY_NAME,
                                )
                                if (idx >= 0 && c.moveToFirst()) {
                                    name = c.getString(idx)
                                }
                            }
                        } catch (_: Throwable) {
                            // Some providers throw on query() — non-fatal,
                            // the Dart side falls back to the URI's last
                            // path segment.
                        }
                        result.success(
                            mapOf(
                                "bytes" to bytes,
                                "name" to name,
                            ),
                        )
                    } catch (e: java.io.FileNotFoundException) {
                        result.error(
                            "NOT_FOUND",
                            e.message ?: "Content URI not found",
                            null,
                        )
                    } catch (e: SecurityException) {
                        result.error(
                            "PERMISSION_DENIED",
                            e.message ?: "No permission to read URI",
                            null,
                        )
                    } catch (e: Throwable) {
                        result.error(
                            "READ_FAILED",
                            e.message ?: "Failed to read URI",
                            null,
                        )
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Replay any URLs that arrived before the channel was wired up —
        // this happens on cold-launch via Open With… / a clicked ssh://
        // link. Capture and clear under the same reference to avoid losing
        // a URL that arrives concurrently from onNewIntent().
        if (pendingUrls.isNotEmpty()) {
            val buffered = pendingUrls.toList()
            pendingUrls.clear()
            for (urlString in buffered) {
                intentChan.invokeMethod("openUrl", urlString)
            }
        }

        // The activity may have been launched directly by a VIEW intent;
        // forwardIntentUri() will buffer the URL until configureFlutterEngine
        // finished (now), so trigger it here too. We also ran it from
        // onNewIntent() for warm-launch cases.
        forwardIntentUri(intent)

        // Home-screen widget bridge. Dart pushes the top-N favorites here as
        // a `List<Map<String, Object?>>` with `{id, name, hostname}` keys; we
        // persist the JSON in `QuickConnectWidget.PREFS_NAME` and broadcast
        // `WIDGET_REFRESH` so every active widget instance repaints. See
        // `lib/core/services/android_widget_service.dart` for the Dart side.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, widgetChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setFavorites" -> {
                        @Suppress("UNCHECKED_CAST")
                        val list = call.arguments as? List<Map<String, Any?>>
                            ?: emptyList()
                        try {
                            val json = org.json.JSONArray()
                            for (entry in list.take(QuickConnectWidget.MAX_TILES)) {
                                val id = entry["id"] as? String ?: continue
                                if (id.isBlank()) continue
                                val obj = org.json.JSONObject()
                                obj.put("id", id)
                                obj.put(
                                    "name",
                                    (entry["name"] as? String).orEmpty(),
                                )
                                obj.put(
                                    "hostname",
                                    (entry["hostname"] as? String).orEmpty(),
                                )
                                json.put(obj)
                            }
                            applicationContext
                                .getSharedPreferences(
                                    QuickConnectWidget.PREFS_NAME,
                                    Context.MODE_PRIVATE,
                                )
                                .edit()
                                .putString(
                                    QuickConnectWidget.PREF_HOSTS,
                                    json.toString(),
                                )
                                .apply()
                            QuickConnectWidget.requestRefresh(applicationContext)
                            result.success(null)
                        } catch (e: Exception) {
                            result.error(
                                "WIDGET_ERROR",
                                e.message ?: "failed to push widget favorites",
                                null,
                            )
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Auto-enter PiP when the user navigates Home, but only when:
     *   1. PiP is supported by the running OS (API 26+).
     *   2. A session is active — surfaced by the Dart layer through a
     *      SharedPreferences flag so we don't cross the binary messenger
     *      on the back-button path.
     *   3. The user has not disabled the feature in Settings.
     */
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val prefs = applicationContext.getSharedPreferences(
            PIP_PREFS_NAME,
            Context.MODE_PRIVATE,
        )
        val sessionActive = prefs.getBoolean(PIP_PREF_SESSION_ACTIVE, false)
        val pipEnabled = prefs.getBoolean(PIP_PREF_ENABLED, true)
        if (!sessionActive || !pipEnabled) return
        try {
            val params = PictureInPictureParams.Builder()
                .setAspectRatio(Rational(16, 9))
                .build()
            enterPictureInPictureMode(params)
        } catch (_: Throwable) {
            // Older OEM forks have been observed to throw here even on
            // API 26+. Best-effort: silently fall back to regular Home.
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration,
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        pipMethodChannel?.invokeMethod(
            "onPipChanged",
            isInPictureInPictureMode,
        )
    }

    override fun onDestroy() {
        disconnectPrefsListener?.let { listener ->
            applicationContext
                .getSharedPreferences(
                    SessionForegroundService.PREFS_NAME,
                    Context.MODE_PRIVATE,
                )
                .unregisterOnSharedPreferenceChangeListener(listener)
        }
        disconnectPrefsListener = null
        sessionServiceMethodChannel = null
        pipMethodChannel = null
        intentMethodChannel = null
        super.onDestroy()
    }

    companion object {
        // SharedPreferences-backed state shared with the Dart
        // `AndroidPipService`. Keep the names in sync.
        const val PIP_PREFS_NAME = "sshvault_pip_prefs"
        const val PIP_PREF_SESSION_ACTIVE = "session_active"
        const val PIP_PREF_ENABLED = "pip_enabled"
    }

    /**
     * Build [ShortcutInfo] entries for up to four favorite hosts and push them
     * via [ShortcutManager.setDynamicShortcuts]. Each entry deep-links into
     * `sshvault://host/<id>` so the Flutter side can route it the same way it
     * routes external URLs.
     */
    private fun applyDynamicFavorites(favorites: List<Map<String, Any?>>) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1) return
        val manager = getSystemService(Context.SHORTCUT_SERVICE) as? ShortcutManager
            ?: return

        // Platform caps total shortcuts (static + dynamic) at
        // ShortcutManager.maxShortcutCountPerActivity. Keep dynamic ones to
        // four to leave headroom for the three static entries.
        val limit = minOf(4, manager.maxShortcutCountPerActivity)
        val capped = favorites.take(limit)

        val infos = capped.mapNotNull { entry ->
            val id = entry["id"] as? String ?: return@mapNotNull null
            if (id.isBlank()) return@mapNotNull null
            val name = (entry["name"] as? String)?.takeIf { it.isNotBlank() } ?: id
            val subtitle = (entry["subtitle"] as? String).orEmpty()

            val intent = Intent(this, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("sshvault://host/$id")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            }

            ShortcutInfo.Builder(this, "fav_$id")
                .setShortLabel(if (name.length > 10) name.substring(0, 10) else name)
                .setLongLabel(if (subtitle.isNotEmpty()) "$name — $subtitle" else name)
                .setIcon(Icon.createWithResource(this, R.drawable.ic_shortcut_connect))
                .setIntent(intent)
                .build()
        }

        manager.dynamicShortcuts = infos
    }
}
