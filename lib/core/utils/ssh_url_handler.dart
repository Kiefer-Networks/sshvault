import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sshvault/core/routing/app_router.dart';
import 'package:sshvault/core/routing/shell_navigation_provider.dart';
import 'package:sshvault/core/services/logging_service.dart';
import 'package:sshvault/core/utils/ssh_url_parser.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';
import 'package:sshvault/features/terminal/presentation/providers/terminal_providers.dart';

/// Glue between a parsed [SshUrl] and the rest of the app.
///
/// Called from `main()` after the app boots. Looks up an existing matching
/// server (hostname + username + port). On hit: opens the session and
/// switches to the Terminal branch. On miss: pushes `/server/new` with
/// prefilled values so the user can complete a quick-connect dialog.
///
/// For `sftp://` URLs the SFTP browser branch is opened after the session
/// is established (or alongside the new-server form for the miss path).
abstract final class SshUrlHandler {
  static const _tag = 'SshUrlHandler';

  /// Branch index of the Terminal tab in the shell route. Kept in sync with
  /// the order of `branches` in [AppRouter.router].
  static const int _terminalBranchIndex = 6;

  /// Branch index of the SFTP tab in the shell route.
  static const int _sftpBranchIndex = 1;

  /// Best-effort: pulls the first arg, parses it, and dispatches. No-op if
  /// args are empty or do not parse as a valid `ssh://` / `sftp://` URL.
  static Future<void> handleArgs(
    ProviderContainer container,
    List<String> args,
  ) async {
    if (args.isEmpty) return;
    final parsed = SshUrl.parse(args.first);
    if (parsed == null) return;
    await handle(container, parsed);
  }

  /// Apply the URL: match an existing server or open the new-server form.
  static Future<void> handle(ProviderContainer container, SshUrl url) async {
    final log = LoggingService.instance;
    log.info(_tag, 'Handling ${url.scheme} URL for ${url.hostname}');

    // Wait for serverListProvider to deliver its first value. On a fresh
    // launch the DB is loading; without this the lookup would always miss.
    final servers = await container.read(serverListProvider.future);

    final match = _findMatch(
      servers,
      hostname: url.hostname,
      username: url.username,
      port: url.port,
    );

    if (match != null) {
      log.info(_tag, 'Matched existing server ${match.id}');
      await container
          .read(sessionManagerProvider.notifier)
          .openSession(match.id);
      _switchBranch(
        container,
        url.isSftp ? _sftpBranchIndex : _terminalBranchIndex,
      );
      return;
    }

    log.info(_tag, 'No match, opening quick-connect form');
    final query = <String, String>{
      'host': url.hostname,
      'port': url.port.toString(),
      if (url.username != null) 'user': url.username!,
      if (url.isSftp) 'sftp': '1',
    };
    final target = Uri(path: '/server/new', queryParameters: query).toString();
    AppRouter.router.push(target);
  }

  static dynamic _findMatch(
    List<dynamic> servers, {
    required String hostname,
    required String? username,
    required int port,
  }) {
    final hostLower = hostname.toLowerCase();
    for (final s in servers) {
      // Duck-typed access: ServerEntity has hostname, username, port.
      final sHost = (s.hostname as String).toLowerCase();
      final sUser = s.username as String;
      final sPort = s.port as int;
      if (sHost != hostLower) continue;
      if (sPort != port) continue;
      if (username != null && username != sUser) continue;
      return s;
    }
    return null;
  }

  static void _switchBranch(ProviderContainer container, int index) {
    // Defer until the shell registered itself with the provider. Should be
    // immediate after first frame, but we tolerate a brief gap.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shell = container.read(shellNavigationProvider);
      shell?.goBranch(index, initialLocation: false);
    });
  }
}
