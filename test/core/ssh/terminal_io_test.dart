import 'dart:async';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/features/terminal/data/services/terminal_io.dart';
import 'package:xterm/xterm.dart';

class _Session extends Mock implements SSHSession {}

void main() {
  test(
    'terminal sends Unicode as UTF-8 and decodes split output characters',
    () async {
      final session = _Session();
      final stdout = StreamController<Uint8List>();
      final stderr = StreamController<Uint8List>();
      when(() => session.stdout).thenAnswer((_) => stdout.stream);
      when(() => session.stderr).thenAnswer((_) => stderr.stream);
      registerFallbackValue(Uint8List(0));
      final terminal = Terminal();
      final subscriptions = wireTerminalIo(session, terminal);
      terminal.textInput('ä😀');
      final sent = verify(() => session.write(captureAny())).captured.single;
      expect(sent, [195, 164, 240, 159, 152, 128]);
      stdout.add(Uint8List.fromList([195]));
      stdout.add(Uint8List.fromList([164]));
      await stdout.close();
      await stderr.close();
      expect(terminal.buffer.lines[0].getText().trim(), 'ä');
      await subscriptions.stdout.cancel();
      await subscriptions.stderr.cancel();
    },
  );
}
