// Unified Windows SSH-agent facade.
//
// Windows users can have *either* (or both) of two SSH agents running:
//
//   * OpenSSH-for-Windows  — Microsoft's optional `ssh-agent.exe` service,
//                            reachable via the named pipe
//                            `\\.\pipe\openssh-ssh-agent`.
//   * Pageant              — PuTTY's tray agent, reachable via WM_COPYDATA
//                            against a hidden window with class+title set
//                            to "Pageant".
//
// This facade probes them in priority order — OpenSSH first, because it
// speaks the modern protocol natively and is the default `ssh.exe` ships
// with on Windows 11 — and dispatches each method to whichever backend is
// currently available. The selection is re-resolved on every call so
// users that toggle Pageant on/off during a session get the right backend
// without a process restart.
//
// All methods conform to the [SshAgent] interface declared in
// `ssh_agent_client.dart`, so call sites that expect an `SshAgent` (e.g.
// `sshAgentClientProvider`) work transparently.

import 'dart:async';
import 'dart:typed_data';

import 'package:sshvault/core/ssh/openssh_for_windows_client.dart';
import 'package:sshvault/core/ssh/pageant_client.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';
import 'package:sshvault/features/connection/domain/entities/ssh_key_entity.dart';

/// Identifier for the currently-active backend, surfaced in the security
/// settings UI.
enum WindowsSshAgentBackend {
  /// Neither agent is reachable.
  none,

  /// OpenSSH-for-Windows named-pipe agent.
  opensshForWindows,

  /// PuTTY's Pageant.
  pageant,
}

extension WindowsSshAgentBackendLabel on WindowsSshAgentBackend {
  String get label {
    switch (this) {
      case WindowsSshAgentBackend.none:
        return 'No agent detected';
      case WindowsSshAgentBackend.opensshForWindows:
        return 'OpenSSH for Windows';
      case WindowsSshAgentBackend.pageant:
        return 'Pageant (PuTTY)';
    }
  }
}

/// Facade that picks the best Windows ssh-agent backend on each call.
class WindowsSshAgent implements SshAgent {
  final OpenSshForWindowsClient _openssh;
  final PageantClient _pageant;

  /// The constructor accepts pre-built backend clients so tests can inject
  /// fakes that exercise the dispatch logic without touching Win32.
  WindowsSshAgent({OpenSshForWindowsClient? openssh, PageantClient? pageant})
    : _openssh = openssh ?? OpenSshForWindowsClient(),
      _pageant = pageant ?? PageantClient();

  @override
  String get backendId => 'windows';

  /// Resolves the currently-preferred backend without doing a full
  /// round-trip beyond what `isAvailable()` already does. Used by the UI
  /// to render the read-only "Detected: …" chip.
  Future<WindowsSshAgentBackend> detectBackend() async {
    if (await _openssh.isAvailable()) {
      return WindowsSshAgentBackend.opensshForWindows;
    }
    if (await _pageant.isAvailable()) {
      return WindowsSshAgentBackend.pageant;
    }
    return WindowsSshAgentBackend.none;
  }

  Future<SshAgent> _select() async {
    if (await _openssh.isAvailable()) return _openssh;
    if (await _pageant.isAvailable()) return _pageant;
    throw const SshAgentException(
      'No Windows ssh-agent detected (neither OpenSSH-for-Windows nor '
      'Pageant is running).',
    );
  }

  @override
  Future<bool> isAvailable() async {
    if (await _openssh.isAvailable()) return true;
    if (await _pageant.isAvailable()) return true;
    return false;
  }

  @override
  Future<List<AgentKey>> listKeys() async {
    final backend = await _select();
    return backend.listKeys();
  }

  @override
  Future<Uint8List> sign({
    required Uint8List publicKeyBlob,
    required Uint8List data,
    int flags = 0,
  }) async {
    final backend = await _select();
    return backend.sign(publicKeyBlob: publicKeyBlob, data: data, flags: flags);
  }

  @override
  Future<void> addKey(
    SshKeyEntity key, {
    required String unencryptedPrivateKey,
    Duration? lifetime,
  }) async {
    final backend = await _select();
    return backend.addKey(
      key,
      unencryptedPrivateKey: unencryptedPrivateKey,
      lifetime: lifetime,
    );
  }

  @override
  Future<void> removeKey(Uint8List publicKeyBlob) async {
    final backend = await _select();
    return backend.removeKey(publicKeyBlob);
  }
}
