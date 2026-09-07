// ignore_for_file: implementation_imports
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:dartssh2/src/ssh_message.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';

/// Exposes listing and signing only; remote hosts cannot modify local agents.
class LocalAgentForwarder implements SSHAgentHandler {
  final SshAgent _agent;
  LocalAgentForwarder([SshAgent? agent])
    : _agent = agent ?? SshAgentClient.create();

  @override
  Future<Uint8List> handleRequest(Uint8List request) async {
    try {
      final reader = SSHMessageReader(request);
      final writer = SSHMessageWriter();
      switch (reader.readUint8()) {
        case SshAgentMessage.requestIdentities:
          final keys = await _agent.listKeys();
          writer.writeUint8(SshAgentMessage.identitiesAnswer);
          writer.writeUint32(keys.length);
          for (final key in keys) {
            writer.writeString(key.keyBlob);
            writer.writeUtf8(key.comment);
          }
          return writer.takeBytes();
        case SshAgentMessage.signRequest:
          final publicKey = reader.readString();
          final data = reader.readString();
          final flags = reader.readUint32();
          final signature = await _agent.sign(
            publicKeyBlob: publicKey,
            data: data,
            flags: flags,
          );
          writer.writeUint8(SshAgentMessage.signResponse);
          writer.writeString(signature);
          return writer.takeBytes();
        default:
          return Uint8List.fromList([SshAgentMessage.failure]);
      }
    } catch (_) {
      return Uint8List.fromList([SshAgentMessage.failure]);
    }
  }
}
