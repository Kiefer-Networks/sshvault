package de.kiefer_networks.sshvault

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import android.util.Log

/**
 * Quick Settings Tile that lets users reopen the last SSH session straight from
 * the Android status shade.
 *
 * Lifecycle:
 *  - The tile is `ACTIVE` (declared in `AndroidManifest.xml`) — Android only
 *    calls [onStartListening] when the user actually pulls down the shade and
 *    sees our tile, which keeps battery impact low.
 *  - [onClick] launches `MainActivity` with a `sshvault://reopen-last` deep
 *    link. Dart-side handlers route the URL to whatever logic owns "reopen the
 *    last active session" (or the new-host dialog if nothing is remembered).
 *  - [onStartListening] reads the cached host name written by the Dart side
 *    (`SharedPreferences` key `last_active_host_name`) and patches the visible
 *    label so the user sees "SSHVault: prod-1" instead of the generic
 *    placeholder.
 */
class QuickConnectTileService : TileService() {
    companion object {
        private const val TAG = "QuickConnectTile"

        /** Shared name used by the Dart side via `MethodChannel`. */
        const val PREFS_NAME = "sshvault_qs_tile"

        /** Key written by Dart through `updateLastHost`. */
        const val PREF_LAST_HOST = "last_active_host_name"

        /** Deep-link the tile fires; consumed by the Flutter routing layer. */
        const val REOPEN_LAST_URI = "sshvault://reopen-last"

        /** Default label shown when we have nothing cached. */
        const val DEFAULT_LABEL = "SSHVault — Quick connect"
    }

    override fun onTileAdded() {
        super.onTileAdded()
        Log.i(TAG, "Quick Settings tile added by user")
        updateTileLabel()
    }

    override fun onStartListening() {
        super.onStartListening()
        updateTileLabel()
    }

    override fun onClick() {
        super.onClick()

        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(REOPEN_LAST_URI)).apply {
            setClass(applicationContext, MainActivity::class.java)
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP,
            )
        }

        // `startActivityAndCollapse` is the recommended path on Android 12+
        // (API 31): it both launches the activity and collapses the shade in
        // one shot. The signature changed in Android 14 (API 34) — it now
        // takes a `PendingIntent` instead of an `Intent` to satisfy the
        // background-activity-launch restrictions.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val pi = android.app.PendingIntent.getActivity(
                this,
                0,
                intent,
                android.app.PendingIntent.FLAG_IMMUTABLE or
                    android.app.PendingIntent.FLAG_UPDATE_CURRENT,
            )
            startActivityAndCollapse(pi)
        } else {
            @Suppress("DEPRECATION", "StartActivityAndCollapseDeprecated")
            startActivityAndCollapse(intent)
        }
    }

    private fun updateTileLabel() {
        val tile = qsTile ?: return
        val prefs = applicationContext.getSharedPreferences(
            PREFS_NAME,
            Context.MODE_PRIVATE,
        )
        val name = prefs.getString(PREF_LAST_HOST, null)?.takeIf { it.isNotBlank() }

        tile.label = if (name != null) "SSHVault: $name" else DEFAULT_LABEL
        tile.contentDescription = tile.label
        tile.state = Tile.STATE_INACTIVE
        tile.updateTile()
    }
}
