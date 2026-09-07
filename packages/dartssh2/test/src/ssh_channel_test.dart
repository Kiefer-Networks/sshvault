import 'dart:typed_data';

import 'package:dartssh2/src/message/msg_channel.dart';
import 'package:dartssh2/src/ssh_channel.dart';
import 'package:dartssh2/src/ssh_errors.dart';
import 'package:dartssh2/src/ssh_message.dart';
import 'package:test/test.dart';

void main() {
  group('SSHChannelController', () {
    test('exposes distinct local and remote channel IDs', () {
      final controller = _createController();

      final channel = controller.channel;

      expect(channel.channelId, 1);
      expect(channel.remoteChannelId, 42);
    });

    test('adjusts the local window when it is exactly exhausted', () async {
      final sent = <SSHMessage>[];
      final controller = _createController(
        localInitialWindowSize: 4,
        localMaximumPacketSize: 4,
        sendMessage: sent.add,
      );
      final subscription = controller.channel.stream.listen((_) {});

      controller.handleMessage(
        SSH_Message_Channel_Data(
          recipientChannel: 1,
          data: Uint8List(4),
        ),
      );

      final adjustment = sent.single as SSH_Message_Channel_Window_Adjust;
      expect(adjustment.recipientChannel, 42);
      expect(adjustment.bytesToAdd, 4);
      await subscription.cancel();
    });

    test('defers the grant until half the window has been consumed', () async {
      final sent = <SSHMessage>[];
      final controller = _createController(
        localInitialWindowSize: 100,
        localMaximumPacketSize: 10,
        sendMessage: sent.add,
      );
      final subscription = controller.channel.stream.listen((_) {});

      // Four packets, 40 bytes consumed in total: under the 50-byte half
      // window, so the peer still holds 60 bytes of credit and needs nothing.
      for (var i = 0; i < 4; i++) {
        controller.handleMessage(
          SSH_Message_Channel_Data(
            recipientChannel: 1,
            data: Uint8List(10),
          ),
        );
      }
      expect(
        sent.whereType<SSH_Message_Channel_Window_Adjust>(),
        isEmpty,
        reason: 'each inbound packet used to be answered with an uplink one',
      );

      // The packet that crosses the threshold grants everything at once.
      controller.handleMessage(
        SSH_Message_Channel_Data(
          recipientChannel: 1,
          data: Uint8List(10),
        ),
      );

      final adjustment =
          sent.whereType<SSH_Message_Channel_Window_Adjust>().single;
      expect(adjustment.bytesToAdd, 50);
      await subscription.cancel();
    });

    test('never lets the peer run out of credit while deferring', () async {
      final sent = <SSHMessage>[];
      const windowSize = 1024;
      final controller = _createController(
        localInitialWindowSize: windowSize,
        localMaximumPacketSize: 64,
        sendMessage: sent.add,
      );
      final subscription = controller.channel.stream.listen((_) {});

      // Deferring is only safe if the peer always has window left to send
      // into. Track the credit it is entitled to across a long run.
      var credit = windowSize;
      var adjustments = 0;
      for (var i = 0; i < 200; i++) {
        expect(credit, greaterThan(0), reason: 'peer starved at packet $i');
        controller.handleMessage(
          SSH_Message_Channel_Data(
            recipientChannel: 1,
            data: Uint8List(64),
          ),
        );
        credit -= 64;
        for (final m in sent.whereType<SSH_Message_Channel_Window_Adjust>()) {
          credit += m.bytesToAdd;
          adjustments++;
        }
        sent.clear();
      }

      // Credit alone does not discriminate: granting per packet also keeps it
      // positive. The count is what separates the two — 200 packets of 64 B
      // against a 1024 B window is 12800 bytes, one grant per 512 consumed.
      expect(adjustments, lessThan(40));
      expect(adjustments, greaterThan(0));
      await subscription.cancel();
    });

    test('a resumed consumer gets its window back below the threshold',
        () async {
      final sent = <SSHMessage>[];
      final controller = _createController(
        localInitialWindowSize: 100,
        localMaximumPacketSize: 10,
        sendMessage: sent.add,
      );

      final subscription = controller.channel.stream.listen((_) {});
      subscription.pause();

      controller.handleMessage(
        SSH_Message_Channel_Data(
          recipientChannel: 1,
          data: Uint8List(10),
        ),
      );
      // Paused: suppressed, which is the documented backpressure mechanism.
      expect(sent.whereType<SSH_Message_Channel_Window_Adjust>(), isEmpty);

      subscription.resume();
      await Future<void>.delayed(Duration.zero);

      // 10 bytes is under the 50-byte threshold, but resuming must still
      // hand the credit back — this is what `force` exists for.
      final adjustment =
          sent.whereType<SSH_Message_Channel_Window_Adjust>().single;
      expect(adjustment.bytesToAdd, 10);
      await subscription.cancel();

      // Control: the same 10 bytes WITHOUT a pause/resume must not grant, or
      // the assertion above would pass for any implementation that always
      // grants, including a revert of the threshold entirely.
      final control = <SSHMessage>[];
      final unpaused = _createController(
        localInitialWindowSize: 100,
        localMaximumPacketSize: 10,
        sendMessage: control.add,
      );
      final unpausedSubscription = unpaused.channel.stream.listen((_) {});
      unpaused.handleMessage(
        SSH_Message_Channel_Data(
          recipientChannel: 1,
          data: Uint8List(10),
        ),
      );
      expect(control.whereType<SSH_Message_Channel_Window_Adjust>(), isEmpty);
      await unpausedSubscription.cancel();
    });

    test('the first listener flushes what arrived before it', () async {
      // A controller with no listener reports isPaused, so every grant is
      // suppressed. A peer may legally fill the whole window in that gap —
      // the README's remote forwarding example awaits Socket.connect() before
      // subscribing — and Dart delivers the first subscription as onListen,
      // not onResume. Without the onListen hook the peer is left at zero
      // credit and no further data can arrive to trigger a grant.
      final sent = <SSHMessage>[];
      const windowSize = 2 * 1024 * 1024;
      const packetSize = 32 * 1024;
      final controller = _createController(
        localInitialWindowSize: windowSize,
        localMaximumPacketSize: packetSize,
        sendMessage: sent.add,
      );

      for (var i = 0; i < windowSize ~/ packetSize; i++) {
        controller.handleMessage(
          SSH_Message_Channel_Data(
            recipientChannel: 1,
            data: Uint8List(packetSize),
          ),
        );
      }
      expect(
        sent.whereType<SSH_Message_Channel_Window_Adjust>(),
        isEmpty,
        reason: 'nothing can be granted while there is no listener',
      );

      final subscription = controller.channel.stream.listen((_) {});
      await Future<void>.delayed(Duration.zero);

      final adjustment =
          sent.whereType<SSH_Message_Channel_Window_Adjust>().single;
      expect(adjustment.bytesToAdd, windowSize);
      await subscription.cancel();
    });

    test('small windows keep a full packet of credit in reserve', () async {
      // W < 2P: deferring to half would leave the peer 4 bytes with a 5 byte
      // maximum packet. It may not overrun the window and nothing obliges it
      // to split a buffered chunk, so both sides could wait indefinitely.
      final sent = <SSHMessage>[];
      final controller = _createController(
        localInitialWindowSize: 6,
        localMaximumPacketSize: 5,
        sendMessage: sent.add,
      );
      final subscription = controller.channel.stream.listen((_) {});

      controller.handleMessage(
        SSH_Message_Channel_Data(
          recipientChannel: 1,
          data: Uint8List(2),
        ),
      );

      final adjustment =
          sent.whereType<SSH_Message_Channel_Window_Adjust>().single;
      expect(adjustment.bytesToAdd, 2);
      await subscription.cancel();
    });

    test('allows the remote window to reach uint32 max without wrapping', () {
      final controller = _createController(remoteInitialWindowSize: 0);

      controller.handleMessage(
        SSH_Message_Channel_Window_Adjust(
          recipientChannel: 1,
          bytesToAdd: 0xffffffff,
        ),
      );

      expect(
        () => controller.handleMessage(
          SSH_Message_Channel_Window_Adjust(
            recipientChannel: 1,
            bytesToAdd: 1,
          ),
        ),
        throwsA(isA<SSHStateError>()),
      );
    });

    test('fails the channel on data larger than the maximum packet size',
        () async {
      final sent = <SSHMessage>[];
      final controller = _createController(
        localInitialWindowSize: 8,
        localMaximumPacketSize: 4,
        sendMessage: sent.add,
      );

      final error = expectLater(
        controller.channel.stream,
        emitsError(isA<SSHStateError>()),
      );

      // The violation must not escape as an exception: it would travel up to
      // the transport and take the whole connection down with it.
      controller.handleMessage(
        SSH_Message_Channel_Data(recipientChannel: 1, data: Uint8List(5)),
      );

      await error;
      expect(controller.channel.done, completes);
      expect(sent.whereType<SSH_Message_Channel_Close>(), hasLength(1));
    });

    test('fails the channel on data larger than the remaining window',
        () async {
      final sent = <SSHMessage>[];
      final controller = _createController(
        localInitialWindowSize: 4,
        localMaximumPacketSize: 8,
        sendMessage: sent.add,
      );

      final error = expectLater(
        controller.channel.stream,
        emitsError(isA<SSHStateError>()),
      );

      controller.handleMessage(
        SSH_Message_Channel_Data(recipientChannel: 1, data: Uint8List(5)),
      );

      await error;
      expect(controller.channel.done, completes);
      expect(sent.whereType<SSH_Message_Channel_Close>(), hasLength(1));
    });

    test('applies packet and window limits to extended data', () async {
      final sent = <SSHMessage>[];
      final controller = _createController(
        localInitialWindowSize: 4,
        localMaximumPacketSize: 4,
        sendMessage: sent.add,
      );
      final subscription = controller.channel.stream.listen((_) {});

      controller.handleMessage(
        SSH_Message_Channel_Extended_Data(
          recipientChannel: 1,
          dataTypeCode: SSH_Message_Channel_Extended_Data.dataTypeStderr,
          data: Uint8List(4),
        ),
      );

      final adjustment = sent.single as SSH_Message_Channel_Window_Adjust;
      expect(adjustment.bytesToAdd, 4);

      await subscription.cancel();

      final oversized = _createController(
        localInitialWindowSize: 4,
        localMaximumPacketSize: 4,
      );
      final oversizedError = expectLater(
        oversized.channel.stream,
        emitsError(isA<SSHStateError>()),
      );
      oversized.handleMessage(
        SSH_Message_Channel_Extended_Data(
          recipientChannel: 1,
          dataTypeCode: SSH_Message_Channel_Extended_Data.dataTypeStderr,
          data: Uint8List(5),
        ),
      );
      await oversizedError;

      final windowController = _createController(
        localInitialWindowSize: 4,
        localMaximumPacketSize: 8,
      );
      final windowError = expectLater(
        windowController.channel.stream,
        emitsError(isA<SSHStateError>()),
      );
      windowController.handleMessage(
        SSH_Message_Channel_Extended_Data(
          recipientChannel: 1,
          dataTypeCode: SSH_Message_Channel_Extended_Data.dataTypeStderr,
          data: Uint8List(5),
        ),
      );
      await windowError;
    });
  });
}

SSHChannelController _createController({
  int localInitialWindowSize = 1024,
  int localMaximumPacketSize = 1024,
  int remoteInitialWindowSize = 0,
  void Function(SSHMessage)? sendMessage,
}) {
  return SSHChannelController(
    localId: 1,
    localMaximumPacketSize: localMaximumPacketSize,
    localInitialWindowSize: localInitialWindowSize,
    remoteId: 42,
    remoteMaximumPacketSize: 1024,
    remoteInitialWindowSize: remoteInitialWindowSize,
    sendMessage: sendMessage ?? (_) {},
  );
}
