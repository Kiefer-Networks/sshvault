import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;
  final double size;

  const StatusBadge({super.key, required this.isActive, this.size = 10});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // The pill is intentionally tiny (default 10 logical px). On HiDPI
    // monitors with a fractional scale (1.25 / 1.5) the rounded circle can
    // come out off-center by half a physical pixel, which is visible at this
    // size. Snap the rendered size to a whole number of physical pixels by
    // multiplying by the device pixel ratio and dividing back. This keeps
    // the API (a logical size) the same but produces a crisper edge.
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final snapped = dpr <= 0 ? size : (size * dpr).roundToDouble() / dpr;
    return Container(
      width: snapped,
      height: snapped,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? colorScheme.tertiary : colorScheme.outlineVariant,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: colorScheme.tertiary.withAlpha(AppConstants.alpha128),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
