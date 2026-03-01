import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/xterm.dart';

enum SshConnectionStatus {
  connecting,
  authenticating,
  connected,
  disconnected,
  error,
}

class SshSessionEntity {
  final String id;
  final String serverId;
  String title;
  final Terminal terminal;
  SSHClient? client;
  SSHSession? session;
  SshConnectionStatus status;
  String? errorMessage;
  final DateTime createdAt;

  SshSessionEntity({
    required this.id,
    required this.serverId,
    required this.title,
    required this.terminal,
    this.client,
    this.session,
    this.status = SshConnectionStatus.connecting,
    this.errorMessage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
