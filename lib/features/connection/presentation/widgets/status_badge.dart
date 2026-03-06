import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;
  final double size;

  const StatusBadge({super.key, required this.isActive, this.size = 10});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
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
