import 'dart:ui';

import 'package:flutter/material.dart';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.blur = 10,
    this.backgroundColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor ??
                  Colors.white.withAlpha(13),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withAlpha(26),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
