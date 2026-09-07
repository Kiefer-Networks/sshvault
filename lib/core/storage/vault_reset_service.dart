import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/services/android_background_sync_service.dart';
import 'package:sshvault/core/services/ios_background_sync_service.dart';
import 'package:sshvault/core/storage/database_provider.dart';
import 'package:sshvault/core/storage/secure_storage_provider.dart';
import 'package:sshvault/features/account/presentation/providers/account_providers.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/folder_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/ssh_key_providers.dart';
import 'package:sshvault/features/connection/presentation/providers/tag_providers.dart';
import 'package:sshvault/features/host_key/presentation/providers/known_host_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/proxy_settings_provider.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sftp/presentation/providers/sftp_bookmark_providers.dart';
import 'package:sshvault/features/sftp/presentation/providers/sftp_providers.dart';
import 'package:sshvault/features/snippet/presentation/providers/snippet_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';
import 'package:sshvault/features/terminal/presentation/providers/session_history_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Drops cached vault records, including all parameterized detail providers.
/// Keep the database instance alive: desktop integrations retain its DAO.
void invalidateVaultData(ProviderContainer container) {
  container.invalidate(serverListProvider);
  container.invalidate(serverDetailProvider);
  container.invalidate(serverCredentialsProvider);
  container.invalidate(serversByGroupProvider);
  container.invalidate(serverCountByTagProvider);
  container.invalidate(folderGroupedServersProvider);
  container.invalidate(favoriteServersProvider);
  container.invalidate(recentServersProvider);
  container.invalidate(folderListProvider);
  container.invalidate(folderTreeProvider);
  container.invalidate(tagListProvider);
  container.invalidate(sshKeyListProvider);
  container.invalidate(sshKeyDetailProvider);
  container.invalidate(serversLinkedToKeyProvider);
  container.invalidate(snippetListProvider);
  container.invalidate(snippetDetailProvider);
  container.invalidate(snippetCountByTagProvider);
  container.invalidate(knownHostListProvider);
  container.invalidate(sftpBookmarksProvider);
  container.invalidate(settingsProvider);
  container.invalidate(globalProxyCredentialsProvider);
}

Future<void> resetLocalVault(ProviderContainer container) async {
  await container.read(androidBackgroundSyncServiceProvider).disable();
  await container.read(iosBackgroundSyncServiceProvider).disable();
  // Wait for writers before deleting: a decrypted sync payload must not be
  // able to repopulate the database after the wipe has returned.
  await container.read(syncProvider.notifier).stopAndWait();
  container.read(sessionManagerProvider.notifier).closeAllSessions();
  container.read(sftpConnectionManagerProvider).closeAll();
  final cleared = await container.read(secureStorageProvider).clearAllData();
  if (cleared.isFailure) throw cleared.failure;
  await container.read(keyringServiceProvider).deleteVaultKey();
  await container.read(databaseProvider).deleteAllData();

  invalidateVaultData(container);
  container.invalidate(serverFilterProvider);
  container.invalidate(snippetFilterProvider);
  container.invalidate(sessionHistoryProvider);
  container.invalidate(sftpPaneProvider);
  container.invalidate(transferManagerProvider);
  container.invalidate(authProvider);
  container.invalidate(userProfileProvider);
  container.invalidate(deviceListProvider);
  container.invalidate(auditLogsProvider);
  container.invalidate(syncProvider);
}
