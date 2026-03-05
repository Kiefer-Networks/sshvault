class SshConfigEntry {
  final String host;
  final String? hostName;
  final int port;
  final String? user;
  final String? identityFile;
  final String? proxyJump;

  const SshConfigEntry({
    required this.host,
    this.hostName,
    this.port = 22,
    this.user,
    this.identityFile,
    this.proxyJump,
  });
}

class SshConfigParser {
  List<SshConfigEntry> parse(String content) {
    final entries = <SshConfigEntry>[];
    String? currentHost;
    String? hostName;
    int port = 22;
    String? user;
    String? identityFile;
    String? proxyJump;

    void flushEntry() {
      if (currentHost != null) {
        entries.add(SshConfigEntry(
          host: currentHost!,
          hostName: hostName,
          port: port,
          user: user,
          identityFile: identityFile,
          proxyJump: proxyJump,
        ));
      }
      currentHost = null;
      hostName = null;
      port = 22;
      user = null;
      identityFile = null;
      proxyJump = null;
    }

    for (final rawLine in content.split('\n')) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final separatorIndex = line.indexOf(RegExp(r'[\s=]'));
      if (separatorIndex < 0) continue;

      final key = line.substring(0, separatorIndex).toLowerCase();
      var value = line.substring(separatorIndex + 1).trim();
      // Handle "Key = Value" (strip leading '=' if present)
      if (value.startsWith('=')) {
        value = value.substring(1).trim();
      }

      if (key == 'host') {
        flushEntry();
        // Skip wildcards
        if (value.contains('*') || value.contains('?')) continue;
        currentHost = value;
      } else if (currentHost != null) {
        switch (key) {
          case 'hostname':
            hostName = value;
          case 'port':
            port = int.tryParse(value) ?? 22;
          case 'user':
            user = value;
          case 'identityfile':
            identityFile = value;
          case 'proxyjump':
            proxyJump = value;
        }
      }
    }

    flushEntry();
    return entries;
  }
}
