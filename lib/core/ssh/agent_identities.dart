import 'package:dartssh2/dartssh2.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';

/// Persisted selector for keys held outside the vault. Never a vault key lookup.
const String kSshAgentSentinelKeyId = '__ssh_agent__';

Future<List<SSHIdentity>> loadAgentIdentities([SshAgent? agent]) async {
  final client = agent ?? SshAgentClient.create();
  final keys = await client.listKeys();
  return [
    for (final key in keys)
      if (key.keyType == 'ssh-ed25519' ||
          key.keyType == 'ssh-rsa' ||
          key.keyType.startsWith('ecdsa-sha2-'))
        SSHAgentKeyPair(
          publicKey: key.keyBlob,
          type: key.keyType == 'ssh-rsa' ? 'rsa-sha2-512' : key.keyType,
          signer: (data) => client.sign(
            publicKeyBlob: key.keyBlob,
            data: data,
            flags: key.keyType == 'ssh-rsa' ? 4 : 0,
          ),
        ),
  ];
}
