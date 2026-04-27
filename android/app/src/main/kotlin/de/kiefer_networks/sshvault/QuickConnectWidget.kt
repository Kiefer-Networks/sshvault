package de.kiefer_networks.sshvault

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray

/**
 * Home-screen widget that pins up to four favorite SSH hosts as quick-connect
 * tiles.
 *
 * Data flow:
 *   1. The Dart side (`AndroidWidgetService`) listens to `favoriteServersProvider`
 *      and pushes the current top-N favorites over the
 *      `de.kiefer_networks.sshvault/widget` MethodChannel as a JSON-encoded
 *      list (key `qc_widget_hosts` in the shared `SharedPreferences`).
 *   2. The Kotlin side writes the JSON, then broadcasts
 *      [ACTION_WIDGET_REFRESH] which routes back into [onReceive] →
 *      [onUpdate] for every active widget instance.
 *   3. [onUpdate] inflates [R.layout.widget_quick_connect], paints up to four
 *      tiles from the JSON, and wires each tile's click to a `VIEW`
 *      `PendingIntent` carrying `sshvault://host/<id>`. The deep link is
 *      handled by `MainActivity`'s existing `<data android:scheme="sshvault"
 *      android:host="host"/>` intent filter.
 *
 * Design notes:
 *   - We deliberately keep the layout pure RemoteViews — Glance is a Compose
 *     hosted runtime that doesn't co-exist cleanly with a Flutter Android
 *     view system. Plain RemoteViews has zero runtime cost when the user has
 *     no widget pinned.
 *   - `updatePeriodMillis` is `0` (see XML metadata) — we never auto-poll;
 *     refreshes are pull-driven from Dart.
 */
class QuickConnectWidget : AppWidgetProvider() {

    companion object {
        private const val TAG = "QuickConnectWidget"

        /** SharedPreferences file shared with the Dart side. */
        const val PREFS_NAME = "sshvault_widget"

        /** JSON-encoded list of `{"id": "...", "name": "...", "hostname": "..."}`. */
        const val PREF_HOSTS = "qc_widget_hosts"

        /** Maximum number of tiles painted in the 4×1 grid. */
        const val MAX_TILES = 4

        /** Custom broadcast Dart fires when favorites change. */
        const val ACTION_WIDGET_REFRESH =
            "de.kiefer_networks.sshvault.WIDGET_REFRESH"

        /** Tile root view ids — one entry per slot. */
        private val TILE_ROOTS = intArrayOf(
            R.id.widget_tile_0,
            R.id.widget_tile_1,
            R.id.widget_tile_2,
            R.id.widget_tile_3,
        )

        /** Tile label view ids — one entry per slot. */
        private val TILE_LABELS = intArrayOf(
            R.id.widget_tile_label_0,
            R.id.widget_tile_label_1,
            R.id.widget_tile_label_2,
            R.id.widget_tile_label_3,
        )

        /**
         * Force-refresh every active widget instance. Called by Kotlin once it
         * has persisted a new host list, and reachable via the
         * [ACTION_WIDGET_REFRESH] broadcast from anywhere in the app.
         */
        fun requestRefresh(context: Context) {
            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(
                ComponentName(context, QuickConnectWidget::class.java),
            )
            if (ids.isEmpty()) return
            val intent = Intent(context, QuickConnectWidget::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            }
            context.sendBroadcast(intent)
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val hosts = readHosts(context)
        for (id in appWidgetIds) {
            val views = buildRemoteViews(context, hosts)
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_WIDGET_REFRESH) {
            requestRefresh(context)
            return
        }
        super.onReceive(context, intent)
    }

    /**
     * Build the populated [RemoteViews] for a single widget instance. Visible
     * for testing — the painting logic is pure.
     */
    private fun buildRemoteViews(
        context: Context,
        hosts: List<HostTile>,
    ): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_quick_connect)

        for (slot in 0 until MAX_TILES) {
            val host = hosts.getOrNull(slot)
            if (host == null) {
                views.setViewVisibility(TILE_ROOTS[slot], View.INVISIBLE)
                continue
            }
            views.setViewVisibility(TILE_ROOTS[slot], View.VISIBLE)
            views.setTextViewText(TILE_LABELS[slot], host.displayLabel)
            views.setOnClickPendingIntent(
                TILE_ROOTS[slot],
                buildTilePendingIntent(context, host.id, slot),
            )
        }
        return views
    }

    /**
     * Each tile gets a unique request code (== slot index) so the
     * [PendingIntent.FLAG_UPDATE_CURRENT] update only mutates the matching
     * slot — without that the system would treat all four pending intents as
     * equivalent and they'd all collapse onto the same data URI.
     */
    private fun buildTilePendingIntent(
        context: Context,
        hostId: String,
        slot: Int,
    ): PendingIntent {
        val uri = Uri.parse("sshvault://host/$hostId")
        val intent = Intent(Intent.ACTION_VIEW, uri).apply {
            setClass(context, MainActivity::class.java)
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP,
            )
        }
        return PendingIntent.getActivity(
            context,
            slot,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
    }

    private fun readHosts(context: Context): List<HostTile> {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val raw = prefs.getString(PREF_HOSTS, null) ?: return emptyList()
        return parseHosts(raw)
    }

    /**
     * Tolerant parser for the JSON list pushed by Dart. Malformed payloads log
     * once and fall back to an empty list rather than crash the host launcher
     * — the Android system kills providers that throw from [onUpdate].
     */
    private fun parseHosts(raw: String): List<HostTile> {
        return try {
            val arr = JSONArray(raw)
            buildList(MAX_TILES) {
                var i = 0
                while (i < arr.length() && size < MAX_TILES) {
                    val o = arr.optJSONObject(i)
                    i++
                    if (o == null) continue
                    val id = o.optString("id").orEmpty()
                    if (id.isEmpty()) continue
                    val name = o.optString("name").orEmpty()
                    val hostname = o.optString("hostname").orEmpty()
                    add(HostTile(id = id, name = name, hostname = hostname))
                }
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to parse $PREF_HOSTS: ${e.message}")
            emptyList()
        }
    }

    /** Minimal value type carried from the Dart payload to the RemoteViews. */
    private data class HostTile(
        val id: String,
        val name: String,
        val hostname: String,
    ) {
        val displayLabel: String
            get() = name.takeIf { it.isNotBlank() } ?: hostname
    }
}
