import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive progress indicator.
///
/// On iOS/macOS: [CupertinoActivityIndicator].
/// On Android/Desktop: [CircularProgressIndicator].
class AdaptiveProgressIndicator extends StatelessWidget {
  final double? radius;

  const AdaptiveProgressIndicator({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    if (useCupertinoDesign) {
      return CupertinoActivityIndicator(radius: radius ?? 10);
    }
    return const CircularProgressIndicator.adaptive();
  }
}
