import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

final vpnActiveProvider = StreamProvider<bool>((ref) async* {
  // Emit initial state
  yield await VpnConnectionDetector.isVpnActive();

  // Listen for changes
  final detector = VpnConnectionDetector();
  ref.onDispose(detector.dispose);

  await for (final state in detector.vpnConnectionStream) {
    yield state == VpnConnectionState.connected;
  }
});
