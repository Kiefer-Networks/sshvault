import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final vpnActiveProvider = StreamProvider<bool>((ref) async* {
  yield await _isVpnActive();

  // Poll every 5 seconds
  await for (final _ in Stream.periodic(const Duration(seconds: 5))) {
    yield await _isVpnActive();
  }
});

/// Detects VPN by checking for tun/tap/ppp/ipsec network interfaces.
/// Works on iOS, macOS, Android, and Linux without native plugins.
Future<bool> _isVpnActive() async {
  try {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.any,
    );
    for (final iface in interfaces) {
      final name = iface.name.toLowerCase();
      // Common VPN interface names across platforms
      if (name.startsWith('tun') ||
          name.startsWith('tap') ||
          name.startsWith('ppp') ||
          name.startsWith('ipsec') ||
          name.startsWith('utun') ||
          name.startsWith('wg') ||
          name.contains('vpn')) {
        return true;
      }
    }
    return false;
  } catch (_) {
    return false;
  }
}
