import 'package:flutter/material.dart';

/// A progress indicator using [CircularProgressIndicator.adaptive].
class AdaptiveProgressIndicator extends StatelessWidget {
  final double? radius;

  const AdaptiveProgressIndicator({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive();
  }
}
