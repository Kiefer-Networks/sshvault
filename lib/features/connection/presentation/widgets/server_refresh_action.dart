import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/connection/domain/entities/server_entity.dart';
import 'package:sshvault/features/connection/presentation/providers/server_reachability_provider.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// "Refresh" action shared by every host row/detail menu: re-checks TCP
/// reachability immediately (always possible, no SSH session needed) and,
/// if the host has a live authenticated session open, re-collects its
/// system metrics (disks, CPU, Proxmox guests, ...) right now instead of
/// waiting for the periodic auto-refresh — which most users don't even
/// have enabled, per `settings.serverSystemInfoAutoRefresh`.
Future<void> refreshServerInfo(
  BuildContext context,
  WidgetRef ref,
  ServerEntity server,
) async {
  // Always cheap and always safe: a plain TCP probe, no auth required.
  ref.invalidate(serverReachabilityProvider(server));

  final refreshed = await ref
      .read(sessionManagerProvider.notifier)
      .refreshMetricsNow(server.id);

  if (!context.mounted) return;
  AdaptiveNotification.show(
    context,
    // Hardcoded English, matching the precedent already set elsewhere in
    // this desktop shell for brand-new strings (no existing l10n key, and
    // adding one means regenerating all 28 locales for two short lines).
    message: refreshed
        ? 'Refreshed ${server.name}'
        : '${server.name} needs an open connection to refresh its system info',
  );
}
