import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/ssh/local_agent_forwarder.dart';
import 'package:sshvault/core/ssh/ssh_agent_client.dart';

class _Agent extends Mock implements SshAgent {}

void main() {
  test(
    'forwarded identities are returned using the agent wire format',
    () async {
      final agent = _Agent();
      when(() => agent.listKeys()).thenAnswer(
        (_) async => [
          AgentKey(
            keyBlob: Uint8List.fromList([42]),
            comment: 'A',
            keyType: 'test',
          ),
        ],
      );
      expect(
        await LocalAgentForwarder(
          agent,
        ).handleRequest(Uint8List.fromList([11])),
        [12, 0, 0, 0, 1, 0, 0, 0, 1, 42, 0, 0, 0, 1, 65],
      );
    },
  );
  test('remote mutation and malformed requests are rejected', () async {
    final forwarder = LocalAgentForwarder(_Agent());
    for (final request in [
      <int>[],
      [13],
      [17],
      [18],
      [19],
    ]) {
      expect(await forwarder.handleRequest(Uint8List.fromList(request)), [5]);
    }
  });
}
