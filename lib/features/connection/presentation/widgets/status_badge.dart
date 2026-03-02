import 'package:flutter/material.dart';
import 'package:shellvault/core/constants/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;
  final double size;

  const StatusBadge({super.key, required this.isActive, this.size = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.greenAccent : Colors.grey,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.greenAccent.withAlpha(AppConstants.alpha128),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
