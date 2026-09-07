import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:xterm/xterm.dart';

/// Connects a terminal to SSH, preserving UTF-8 across transport packets.
({StreamSubscription<String> stdout, StreamSubscription<String> stderr})
wireTerminalIo(
  SSHSession session,
  Terminal terminal, {
  void Function()? onDone,
}) {
  terminal.onOutput = (data) =>
      session.write(Uint8List.fromList(utf8.encode(data)));
  terminal.onResize = (width, height, pixelWidth, pixelHeight) {
    session.resizeTerminal(width, height);
  };
  return (
    stdout: session.stdout
        .cast<List<int>>()
        .transform(const Utf8Decoder(allowMalformed: true))
        .listen(terminal.write, onDone: onDone),
    stderr: session.stderr
        .cast<List<int>>()
        .transform(const Utf8Decoder(allowMalformed: true))
        .listen(terminal.write),
  );
}
