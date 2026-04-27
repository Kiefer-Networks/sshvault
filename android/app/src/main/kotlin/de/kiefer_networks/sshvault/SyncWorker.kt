package de.kiefer_networks.sshvault

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import kotlinx.coroutines.withTimeout
import kotlinx.coroutines.TimeoutCancellationException

/**
 * Background sync worker stub.
 *
 * The actual sync logic lives in Dart so it can reuse the
 * `EncryptionService` / `SyncUseCases` pipeline that the foreground app
 * already exercises. The `workmanager` Flutter plugin (registered from
 * `AndroidBackgroundSyncService`) takes care of:
 *
 *   1. spinning up a headless Flutter engine (background isolate),
 *   2. invoking the `callbackDispatcher` top-level Dart entry point,
 *   3. dispatching the registered `taskName` (`sshvault.periodic-sync`)
 *      so the Dart side can execute the sync and return success/retry.
 *
 * We keep this Kotlin class as a documented seam in case we ever need to
 * fall back to a pure-Kotlin worker (e.g. doing a direct HTTP request
 * with OkHttp against the `/vault` endpoint, reading the master-key
 * wrapped blob from `EncryptedSharedPreferences`). Today it is *not*
 * registered in the manifest — the `workmanager` plugin's own worker is.
 *
 * A 15-minute hard timeout matches AndroidX WorkManager's recommended
 * upper bound for a single execution; longer-running operations should
 * be split into multiple work units.
 */
class SyncWorker(
    appContext: Context,
    workerParams: WorkerParameters,
) : CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result {
        return try {
            withTimeout(WORK_TIMEOUT_MS) {
                // Placeholder: when the `workmanager` plugin is the sole
                // dispatcher, this branch is never hit. Kept as a no-op
                // success so that an accidental direct registration of
                // this worker does not crash WorkManager's queue.
                Result.success()
            }
        } catch (_: TimeoutCancellationException) {
            // Re-queue with WorkManager's exponential backoff so
            // transient network / server outages don't burn battery.
            Result.retry()
        } catch (_: Throwable) {
            // Hard failure — drop this attempt, the periodic schedule
            // will retry on the next interval.
            Result.failure()
        }
    }

    companion object {
        const val UNIQUE_WORK_NAME = "sshvault.periodic-sync"
        private const val WORK_TIMEOUT_MS: Long = 15 * 60 * 1000L
    }
}
