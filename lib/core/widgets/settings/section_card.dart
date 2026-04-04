import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';

enum SectionCardVariant { standard, elevated, outlined }

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final SectionCardVariant variant;

  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.variant = SectionCardVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color backgroundColor;
    final BorderSide? borderSide;
    final double elevation;

    switch (variant) {
      case SectionCardVariant.standard:
        backgroundColor = colorScheme.surfaceContainerLow;
        borderSide = null;
        elevation = 0;
      case SectionCardVariant.elevated:
        backgroundColor = colorScheme.surfaceContainer;
        borderSide = null;
        elevation = 1;
      case SectionCardVariant.outlined:
        backgroundColor = colorScheme.surface;
        borderSide = BorderSide(color: colorScheme.outlineVariant);
        elevation = 0;
    }

    return Card(
      elevation: elevation,
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: borderSide ?? BorderSide.none,
      ),
      color: backgroundColor,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? Spacing.paddingAllLg,
        child: child,
      ),
    );
  }
}
