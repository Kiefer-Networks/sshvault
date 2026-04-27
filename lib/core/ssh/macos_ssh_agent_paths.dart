// macOS-specific ssh-agent socket detection.
//
// On macOS the user typically has one or more ssh-agent compatible
// sockets reachable via the Unix-domain socket protocol. The standard
// ones we probe — in priority order — are:
//
//   1. `$SSH_AUTH_SOCK`              — whatever the shell points us at
//                                       (usually the system ssh-agent or
//                                       a user-launched override).
//   2. 1Password (CLI shortcut path) — `~/.1password/agent.sock`, the
//                                       symlink/socket 1Password 8 places
//                                       in `$HOME` for convenience.
//   3. 1Password (group container)   — the canonical sandboxed location
//                                       under `~/Library/Group
//                                       Containers/2BUA8C4S2C.com.1password/
//                                       t/agent.sock`.
//   4. Secretive                     — Max Goedjen's hardware-key agent at
//                                       `~/Library/Containers/com.maxgoedjen.
//                                       Secretive.SecretAgent/Data/socket.ssh`.
//
// Only entries whose path actually exists on disk are returned, so call
// sites can present a deterministic picker UI without knowing which
// agents the user happens to have installed. On non-macOS hosts the
// helpers degrade to an empty list / `null`.

import 'dart:io';

/// Lightweight descriptor for a discovered ssh-agent Unix-domain socket.
class MacosSshAgent {
  /// Human-friendly label suitable for surfacing in the settings UI.
  final String displayName;

  /// Absolute filesystem path to the agent's Unix-domain socket.
  final String socketPath;

  const MacosSshAgent({required this.displayName, required this.socketPath});

  @override
  bool operator ==(Object other) =>
      other is MacosSshAgent &&
      other.displayName == displayName &&
      other.socketPath == socketPath;

  @override
  int get hashCode => Object.hash(displayName, socketPath);

  @override
  String toString() => 'MacosSshAgent($displayName, $socketPath)';
}

/// Internal candidate spec — the relative path is resolved against
/// `$HOME` when [home] is non-null; otherwise [path] is used verbatim.
class _Candidate {
  final String displayName;
  final String? home;
  final String path;
  const _Candidate({
    required this.displayName,
    required this.home,
    required this.path,
  });
}

/// Returns the macOS ssh-agent sockets that currently exist on disk, in
/// the priority order documented at the top of this file.
///
/// On non-macOS hosts the returned list is always empty.
///
/// The optional [environment] and [platformIsMacOS] parameters exist for
/// tests to inject a synthetic environment without touching real
/// `Platform.environment` or actually running on macOS.
Future<List<MacosSshAgent>> listAvailableAgents({
  Map<String, String>? environment,
  bool? platformIsMacOS,
}) async {
  final isMac = platformIsMacOS ?? Platform.isMacOS;
  if (!isMac) {
    return const <MacosSshAgent>[];
  }

  final env = environment ?? Platform.environment;
  final home = env['HOME'];
  final sshAuthSock = env['SSH_AUTH_SOCK'];

  final candidates = <_Candidate>[
    if (sshAuthSock != null && sshAuthSock.isNotEmpty)
      _Candidate(displayName: r'$SSH_AUTH_SOCK', home: null, path: sshAuthSock),
    if (home != null && home.isNotEmpty) ...<_Candidate>[
      _Candidate(
        displayName: '1Password',
        home: home,
        path: '.1password/agent.sock',
      ),
      _Candidate(
        displayName: '1Password (group container)',
        home: home,
        path: 'Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock',
      ),
      _Candidate(
        displayName: 'Secretive',
        home: home,
        path:
            'Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh',
      ),
    ],
  ];

  final results = <MacosSshAgent>[];
  final seen = <String>{};
  for (final c in candidates) {
    final resolved = c.home == null ? c.path : '${c.home}/${c.path}';
    if (!seen.add(resolved)) continue;
    if (File(resolved).existsSync()) {
      results.add(
        MacosSshAgent(displayName: c.displayName, socketPath: resolved),
      );
    }
  }
  return results;
}

/// Convenience wrapper that returns the path of the first available
/// macOS ssh-agent socket, or `null` if none are reachable (or the host
/// is not macOS).
Future<String?> detectActiveAgentSocket({
  Map<String, String>? environment,
  bool? platformIsMacOS,
}) async {
  final agents = await listAvailableAgents(
    environment: environment,
    platformIsMacOS: platformIsMacOS,
  );
  if (agents.isEmpty) return null;
  return agents.first.socketPath;
}
