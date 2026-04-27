// Riverpod glue for the local ssh-agent.
//
// Exposes:
//   * [sshAgentClientProvider]   — singleton client instance.
//   * [sshAgentAvailableProvider] — `Future<bool>` guard for UI sections.
//   * [agentKeysProvider]        — auto-refreshing list of keys currently
//                                   loaded in the running agent. Polls every
//                                   5 seconds while the host-add screen is
//                                   open (i.e. while it's being watched).

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';
import 'package:sshvault/core/ssh/windows_ssh_agent.dart';

/// Platform-aware SSH-agent client. Linux/macOS dispatch to the existing
/// unix-socket [SshAgentClient]; Windows dispatches through the
/// [WindowsSshAgent] facade which transparently selects between
/// OpenSSH-for-Windows (named pipe) and Pageant (WM_COPYDATA).
final sshAgentClientProvider = Provider<SshAgent>(
  (ref) => SshAgentClient.create(),
);

final sshAgentAvailableProvider = FutureProvider<bool>((ref) async {
  final client = ref.watch(sshAgentClientProvider);
  return client.isAvailable();
});

/// Windows-only: which agent backend is currently reachable. Surfaced as a
/// read-only chip in the security settings screen.
///
/// Returns [WindowsSshAgentBackend.none] on non-Windows platforms so the
/// UI can still build without conditional imports.
final windowsSshAgentBackendProvider = FutureProvider<WindowsSshAgentBackend>((
  ref,
) async {
  final client = ref.watch(sshAgentClientProvider);
  if (client is WindowsSshAgent) {
    return client.detectBackend();
  }
  return WindowsSshAgentBackend.none;
});

/// Auto-disposing stream that polls the agent every 5 s. Built as a stream so
/// that any number of widgets can `ref.watch` it without spawning extra
/// timers, and Riverpod cancels the timer once the last listener disappears.
final agentKeysProvider = StreamProvider.autoDispose<List<AgentKey>>((ref) {
  final client = ref.watch(sshAgentClientProvider);

  late StreamController<List<AgentKey>> controller;
  Timer? timer;

  Future<void> tick() async {
    try {
      final keys = await client.listKeys();
      if (!controller.isClosed) controller.add(keys);
    } catch (e, st) {
      if (!controller.isClosed) controller.addError(e, st);
    }
  }

  controller = StreamController<List<AgentKey>>(
    onListen: () {
      // Fire immediately, then every 5 s.
      tick();
      timer = Timer.periodic(const Duration(seconds: 5), (_) => tick());
    },
    onCancel: () {
      timer?.cancel();
    },
  );

  ref.onDispose(() {
    timer?.cancel();
    controller.close();
  });

  return controller.stream;
});
