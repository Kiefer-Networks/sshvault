import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/features/sync/presentation/providers/sync_providers.dart';

/// Mixin that provides [triggerAutoSync] for AsyncNotifier subclasses.
///
/// Schedules a sync push when the user is authenticated and auto-sync is
/// enabled in settings.
mixin AutoSyncMixin<T> on AsyncNotifier<T> {
  void triggerAutoSync() {
    final authStatus = ref.read(authProvider).value;
    final settings = ref.read(settingsProvider).value;
    if (authStatus == AuthStatus.authenticated &&
        (settings?.autoSync ?? false)) {
      ref.read(syncProvider.notifier).schedulePush();
    }
  }
}
