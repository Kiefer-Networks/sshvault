// Invoked by verify_ssh_agent.py against an isolated localhost SSH server.
import 'dart:convert';
import 'dart:io';
import 'package:dartssh2/dartssh2.dart';
import 'package:sshvault/core/ssh/agent_identities.dart';
import 'package:sshvault/core/ssh/host_key_fingerprint.dart';
import 'package:sshvault/core/ssh/local_agent_forwarder.dart';
import 'package:sshvault/core/ssh/ssh_algorithms.dart';

Future<void> main(List<String> args) async {
  final expectedBlob = File(args[1]).readAsStringSync().trim().split(' ')[1];
  final identities = (await loadAgentIdentities())
      .where((key) => base64.encode(key.toPublicKey().encode()) == expectedBlob)
      .toList();
  if (identities.length != 1) {
    throw StateError('Temporary identity not found in agent');
  }
  final socket = await SSHSocket.connect(
    '127.0.0.1',
    int.parse(args[0]),
    timeout: const Duration(seconds: 10),
  );
  final client = SSHClient(
    socket,
    username: 'sshvault-audit',
    algorithms: sshVaultAlgorithms,
    agentHandler: LocalAgentForwarder(),
    identities: identities,
    // The Python harness supplies the fingerprint of its freshly generated host key.
    onVerifyHostKey: (type, fingerprint) =>
        base64.encode(hostKeyDigest(fingerprint)) == args[2],
  );
  try {
    await client.authenticated.timeout(const Duration(seconds: 10));
    final result = await client
        .run('agent-auth-check')
        .timeout(const Duration(seconds: 10));
    if (utf8.decode(result) != 'agent-auth-ok ä😀\n') {
      throw StateError('SSH output mismatch');
    }
    stdout.writeln(
      'PASS: real agent authentication, forwarding list/sign, and UTF-8 output',
    );
  } finally {
    await client.close();
  }
}
