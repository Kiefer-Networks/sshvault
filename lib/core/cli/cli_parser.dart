/// Command-line argv parser for SSHVault.
///
/// All parsing is pure-Dart and side-effect free — the result is a typed
/// [CliInvocation] that the caller (`main.dart`) inspects to decide whether
/// to run the GUI, print a message and exit, forward to a running instance
/// over DBus, or run a headless export. Nothing here imports Flutter.
///
/// Grammar accepted (mutually exclusive forms separated by `|`):
///
///   sshvault [--minimized] [--] [REMOTE_CMD ...]
///   sshvault HOSTNAME              # connect to host whose `name` matches
///   sshvault user@host[:port]      # quick-connect with prefilled values
///   sshvault ssh://...             # delegated to SshUrl.parse upstream
///   sshvault sftp://...            #   ditto
///   sshvault --import-config PATH
///   sshvault --import-keys DIR
///   sshvault --export-vault PATH
///   sshvault --quit
///   sshvault --list-hosts          # hidden, for shell completion
///   sshvault --version
///   sshvault --help
///
/// Conflicts (e.g. `--version` together with `--quit`, or two positionals)
/// are surfaced as [CliInvocationKind.error] with a human-readable message.
library;

import 'package:args/args.dart';

/// Top-level intent encoded in the parsed argv.
enum CliInvocationKind {
  /// Boot the GUI normally. Optional positional may be a HOSTNAME or
  /// `user@host[:port]` quick-connect target. May also carry a `--`
  /// separator and a remote command list.
  gui,

  /// `--version` — print the version banner and exit 0.
  version,

  /// `--help` — print usage and exit 0.
  help,

  /// `--quit` — call DBus `Quit` on a running instance and exit.
  quit,

  /// `--list-hosts` — print one host name per line and exit (for completion).
  listHosts,

  /// `--export-vault PATH` — run the export use case and exit.
  exportVault,

  /// One or more file paths were dropped onto the EXE / shortcut and arrived
  /// as `argv` (Windows shell delivers DnD-on-icon this way). All positionals
  /// ended in one of `.pub` / `.pem` / `.ppk` / `.json`, so the GUI should
  /// route them through `FileDropService.handleDroppedPaths` instead of the
  /// host-connect flow.
  importFiles,

  /// Parsing failed. [CliInvocation.errorMessage] is set.
  error,
}

/// Quick-connect target parsed from `user@host[:port]`.
class QuickConnectTarget {
  final String? username;
  final String hostname;
  final int port;

  const QuickConnectTarget({
    required this.hostname,
    required this.port,
    this.username,
  });

  @override
  String toString() =>
      'QuickConnectTarget(user: $username, host: $hostname, port: $port)';
}

/// Result of parsing argv.
class CliInvocation {
  final CliInvocationKind kind;

  /// True when `--minimized` was passed (or the equivalent env var was set
  /// upstream — env handling stays in `main.dart`).
  final bool minimized;

  /// True when `--new-host` was passed. Used as a fallback for the
  /// `[Desktop Action NewConnection]` Exec= line when DBus activation is
  /// unavailable. `main.dart` opens the /server/new screen on launch.
  final bool newHost;

  /// True when `--reopen-last` was passed. Used as a fallback for the
  /// `[Desktop Action ReopenLast]` Exec= line. `main.dart` re-opens the
  /// last-active host (if any) on launch.
  final bool reopenLast;

  /// `HOSTNAME` positional — looked up by `ServerEntity.name` exact match.
  final String? hostNameMatch;

  /// `user@host[:port]` positional, parsed.
  final QuickConnectTarget? quickConnect;

  /// One of the well-known schemes (`ssh://...` / `sftp://...`). Forwarded
  /// to [SshUrlHandler] verbatim.
  final String? sshUrl;

  /// `--import-config` argument (path to OpenSSH config file).
  final String? importConfigPath;

  /// `--import-keys` argument (path to a directory containing private keys).
  final String? importKeysDir;

  /// `--export-vault` argument (destination path).
  final String? exportVaultPath;

  /// Set when [kind] is [CliInvocationKind.importFiles] — every positional
  /// path the launcher passed in. The caller is responsible for handing these
  /// to `FileDropService.handleDroppedPaths`.
  final List<String> importFilePaths;

  /// Tokens after `--`. Forwarded as the SSH session's initial command.
  final List<String> remoteCommand;

  /// Set when [kind] is [CliInvocationKind.error].
  final String? errorMessage;

  /// Pre-rendered usage string. Always populated so callers can print it
  /// from the `--help` branch and from error branches uniformly.
  final String usage;

  const CliInvocation({
    required this.kind,
    required this.usage,
    this.minimized = false,
    this.newHost = false,
    this.reopenLast = false,
    this.hostNameMatch,
    this.quickConnect,
    this.sshUrl,
    this.importConfigPath,
    this.importKeysDir,
    this.exportVaultPath,
    this.importFilePaths = const <String>[],
    this.remoteCommand = const <String>[],
    this.errorMessage,
  });

  /// Convenience: a positional was passed (any of the four mutually
  /// exclusive forms). Used by `main.dart` to decide whether to defer to the
  /// existing URL/host handler after `runApp`.
  bool get hasPositional =>
      hostNameMatch != null || quickConnect != null || sshUrl != null;
}

/// Pure parser. Never throws, never touches `dart:io` or `dart:ui`.
abstract final class CliParser {
  /// Builds the [ArgParser] used for both parsing and help generation.
  /// Exposed so tests can introspect the registered options.
  static ArgParser buildArgParser() {
    final parser = ArgParser(allowTrailingOptions: false)
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Print this usage information and exit.',
      )
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Print "SSHVault <version> (build <build>)" and exit.',
      )
      ..addFlag(
        'minimized',
        negatable: false,
        help: 'Start hidden in the system tray (no main window on launch).',
      )
      ..addFlag(
        'quit',
        negatable: false,
        help: 'Tell the running SSHVault instance to exit (DBus).',
      )
      ..addFlag(
        'list-hosts',
        negatable: false,
        hide: true,
        help: 'Print one host name per line (for shell completion).',
      )
      ..addFlag(
        'new-host',
        negatable: false,
        hide: true,
        help: 'Open the New host form on launch (desktop action fallback).',
      )
      ..addFlag(
        'reopen-last',
        negatable: false,
        hide: true,
        help:
            'Re-open the last active host on launch (desktop action fallback).',
      )
      ..addOption(
        'import-config',
        valueHelp: 'PATH',
        help: 'Import the OpenSSH config file at PATH on launch.',
      )
      ..addOption(
        'import-keys',
        valueHelp: 'DIR',
        help: 'Import every private key found in DIR on launch.',
      )
      ..addOption(
        'export-vault',
        valueHelp: 'PATH',
        help: 'Run the vault export to PATH and exit (no GUI).',
      );
    return parser;
  }

  /// Parses [argv]. Tolerates ordering, recognises the `--` end-of-options
  /// terminator, and reports conflicts.
  static CliInvocation parse(List<String> argv) {
    final parser = buildArgParser();
    final usage = _buildUsage(parser);

    // Manually split on the first standalone `--` so we can preserve the
    // trailing remote command verbatim. `args` 2.x splits on `--` itself,
    // but we want to keep its rest under our own typed field rather than
    // using `ArgResults.rest`.
    final separatorIdx = argv.indexOf('--');
    final List<String> head;
    final List<String> remoteCmd;
    if (separatorIdx >= 0) {
      head = argv.sublist(0, separatorIdx);
      remoteCmd = argv.sublist(separatorIdx + 1);
    } else {
      head = argv;
      remoteCmd = const <String>[];
    }

    final ArgResults results;
    try {
      results = parser.parse(head);
    } on FormatException catch (e) {
      return CliInvocation(
        kind: CliInvocationKind.error,
        usage: usage,
        errorMessage: e.message,
      );
    }

    final help = results['help'] as bool;
    final version = results['version'] as bool;
    final minimized = results['minimized'] as bool;
    final quit = results['quit'] as bool;
    final listHosts = results['list-hosts'] as bool;
    final newHost = results['new-host'] as bool;
    final reopenLast = results['reopen-last'] as bool;
    final importConfig = results['import-config'] as String?;
    final importKeys = results['import-keys'] as String?;
    final exportVault = results['export-vault'] as String?;
    final positionals = results.rest;

    // ── Single-action flags. Conflicts are an error.
    final exclusive = <String>[
      if (help) '--help',
      if (version) '--version',
      if (quit) '--quit',
      if (listHosts) '--list-hosts',
      if (exportVault != null) '--export-vault',
    ];
    if (exclusive.length > 1) {
      return CliInvocation(
        kind: CliInvocationKind.error,
        usage: usage,
        errorMessage:
            'Conflicting flags: ${exclusive.join(', ')} cannot be combined.',
      );
    }

    // ── File-import dispatch (e.g. user drags `key1.pub key2.pem` onto the
    // SSHVault.exe shortcut on Windows; the shell forwards them as argv). If
    // every positional ends in one of the recognised key / export extensions
    // and no exclusive action flag or remote command was supplied, route the
    // whole batch through the file-drop importer instead of the connect flow.
    if (exclusive.isEmpty &&
        remoteCmd.isEmpty &&
        positionals.isNotEmpty &&
        positionals.every(_looksLikeImportablePath)) {
      return CliInvocation(
        kind: CliInvocationKind.importFiles,
        usage: usage,
        minimized: minimized,
        importFilePaths: List.unmodifiable(positionals),
        importConfigPath: importConfig,
        importKeysDir: importKeys,
      );
    }

    // Positionals are not allowed alongside any standalone-action flag. The
    // import-* flags are tolerated alongside a positional (so users can
    // import-on-launch and immediately connect).
    if (positionals.length > 1) {
      return CliInvocation(
        kind: CliInvocationKind.error,
        usage: usage,
        errorMessage:
            'At most one positional argument is accepted, got ${positionals.length}: ${positionals.join(' ')}',
      );
    }
    final positional = positionals.isEmpty ? null : positionals.first;

    if (exclusive.isNotEmpty && positional != null) {
      return CliInvocation(
        kind: CliInvocationKind.error,
        usage: usage,
        errorMessage:
            '${exclusive.first} does not accept a positional argument ($positional).',
      );
    }
    if (exclusive.isNotEmpty && remoteCmd.isNotEmpty) {
      return CliInvocation(
        kind: CliInvocationKind.error,
        usage: usage,
        errorMessage:
            '${exclusive.first} cannot be combined with a "--" remote command.',
      );
    }

    // Empty option values (e.g. `--import-config=`) are user errors.
    final emptyOption = <String>[
      if (importConfig != null && importConfig.trim().isEmpty)
        '--import-config',
      if (importKeys != null && importKeys.trim().isEmpty) '--import-keys',
      if (exportVault != null && exportVault.trim().isEmpty) '--export-vault',
    ];
    if (emptyOption.isNotEmpty) {
      return CliInvocation(
        kind: CliInvocationKind.error,
        usage: usage,
        errorMessage: '${emptyOption.first} requires a non-empty value.',
      );
    }

    if (help) {
      return CliInvocation(kind: CliInvocationKind.help, usage: usage);
    }
    if (version) {
      return CliInvocation(kind: CliInvocationKind.version, usage: usage);
    }
    if (quit) {
      return CliInvocation(kind: CliInvocationKind.quit, usage: usage);
    }
    if (listHosts) {
      return CliInvocation(kind: CliInvocationKind.listHosts, usage: usage);
    }
    if (exportVault != null) {
      return CliInvocation(
        kind: CliInvocationKind.exportVault,
        usage: usage,
        exportVaultPath: exportVault,
      );
    }

    // ── GUI form. Classify the (optional) positional.
    String? hostNameMatch;
    QuickConnectTarget? quickConnect;
    String? sshUrl;
    if (positional != null) {
      if (positional.startsWith('ssh://') ||
          positional.startsWith('sftp://') ||
          positional.startsWith('sshvault://')) {
        sshUrl = positional;
      } else if (positional.contains('@')) {
        final parsed = _parseUserAtHost(positional);
        if (parsed == null) {
          return CliInvocation(
            kind: CliInvocationKind.error,
            usage: usage,
            errorMessage: 'Could not parse "$positional" as user@host[:port].',
          );
        }
        quickConnect = parsed;
      } else {
        // Bare HOSTNAME — exact-match against ServerEntity.name. Reject
        // obviously bogus input (whitespace, control chars).
        if (positional.trim().isEmpty ||
            RegExp(r'\s').hasMatch(positional) ||
            positional.startsWith('-')) {
          return CliInvocation(
            kind: CliInvocationKind.error,
            usage: usage,
            errorMessage: 'Invalid HOSTNAME "$positional".',
          );
        }
        hostNameMatch = positional;
      }
    }

    return CliInvocation(
      kind: CliInvocationKind.gui,
      usage: usage,
      minimized: minimized,
      newHost: newHost,
      reopenLast: reopenLast,
      hostNameMatch: hostNameMatch,
      quickConnect: quickConnect,
      sshUrl: sshUrl,
      importConfigPath: importConfig,
      importKeysDir: importKeys,
      remoteCommand: List.unmodifiable(remoteCmd),
    );
  }

  /// Parses `user@host[:port]`. Returns `null` if the format is invalid.
  static QuickConnectTarget? _parseUserAtHost(String input) {
    final at = input.indexOf('@');
    if (at <= 0 || at == input.length - 1) return null;
    final user = input.substring(0, at);
    final rest = input.substring(at + 1);
    if (user.isEmpty || rest.isEmpty) return null;

    String host;
    int port = 22;

    // IPv6 literal: [::1]:2222
    if (rest.startsWith('[')) {
      final close = rest.indexOf(']');
      if (close < 0) return null;
      host = rest.substring(1, close);
      if (host.isEmpty) return null;
      final tail = rest.substring(close + 1);
      if (tail.isNotEmpty) {
        if (!tail.startsWith(':')) return null;
        final parsedPort = int.tryParse(tail.substring(1));
        if (parsedPort == null || parsedPort < 1 || parsedPort > 65535) {
          return null;
        }
        port = parsedPort;
      }
    } else {
      final colon = rest.lastIndexOf(':');
      // No port if there's no colon, or the colon is part of an IPv6 literal
      // without brackets (multiple colons → ambiguous, reject).
      final colonCount = ':'.allMatches(rest).length;
      if (colon < 0 || colonCount > 1) {
        host = rest;
      } else {
        host = rest.substring(0, colon);
        final portStr = rest.substring(colon + 1);
        if (portStr.isEmpty) return null;
        final parsedPort = int.tryParse(portStr);
        if (parsedPort == null || parsedPort < 1 || parsedPort > 65535) {
          return null;
        }
        port = parsedPort;
      }
      if (host.isEmpty) return null;
    }

    if (RegExp(r'\s').hasMatch(host) || RegExp(r'\s').hasMatch(user)) {
      return null;
    }

    return QuickConnectTarget(username: user, hostname: host, port: port);
  }

  /// True when [arg] looks like an importable file path: ends in one of the
  /// recognised SSH-key or vault-export extensions (case-insensitive). Used
  /// to dispatch a "drag onto EXE icon" launch into the importer instead of
  /// the host-connect flow.
  static bool _looksLikeImportablePath(String arg) {
    if (arg.isEmpty) return false;
    final lower = arg.toLowerCase();
    return lower.endsWith('.pub') ||
        lower.endsWith('.pem') ||
        lower.endsWith('.ppk') ||
        lower.endsWith('.json');
  }

  static String _buildUsage(ArgParser parser) {
    final buf = StringBuffer()
      ..writeln('SSHVault — secure self-hosted SSH client')
      ..writeln()
      ..writeln('Usage:')
      ..writeln(
        '  sshvault [options]                            launch the GUI',
      )
      ..writeln(
        '  sshvault HOSTNAME                             connect to host with that exact name',
      )
      ..writeln(
        '  sshvault user@host[:port]                     quick-connect with prefilled values',
      )
      ..writeln(
        '  sshvault ssh://user@host[:port][/path]        connect via ssh:// URL',
      )
      ..writeln(
        '  sshvault sftp://user@host[:port][/path]       browse via sftp:// URL',
      )
      ..writeln(
        '  sshvault --import-config PATH                 import OpenSSH config on launch',
      )
      ..writeln(
        '  sshvault --import-keys DIR                    import every private key in DIR',
      )
      ..writeln(
        '  sshvault --export-vault PATH                  run export and exit (no GUI)',
      )
      ..writeln(
        '  sshvault --quit                               tell the running instance to exit',
      )
      ..writeln(
        '  sshvault --version                            print version and exit',
      )
      ..writeln(
        '  sshvault --help                               print this help and exit',
      )
      ..writeln(
        '  sshvault [HOSTNAME] -- <remote command...>    forward command to ssh session',
      )
      ..writeln()
      ..writeln('Options:')
      ..write(parser.usage);
    return buf.toString();
  }
}
