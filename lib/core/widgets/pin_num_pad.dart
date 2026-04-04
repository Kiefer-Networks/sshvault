import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';

class PinDotIndicator extends StatelessWidget {
  final int length;
  final int maxLength;
  final bool hasError;

  const PinDotIndicator({
    super.key,
    required this.length,
    this.maxLength = 6,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (i) {
        final filled = i < length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: Spacing.paddingHorizontalSm,
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? (hasError ? colorScheme.error : colorScheme.primary)
                : Colors.transparent,
            border: Border.all(
              color: hasError
                  ? colorScheme.error
                  : (filled
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant),
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

class PinNumPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onConfirm;
  final Widget? bottomRightChild;

  const PinNumPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onConfirm,
    this.bottomRightChild,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['backspace', '0', 'confirm'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Spacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key == 'backspace') {
                return _NumPadButton(
                  onPressed: onBackspace,
                  child: const Icon(Icons.backspace_outlined),
                );
              }
              if (key == 'confirm') {
                return bottomRightChild != null
                    ? _NumPadButton(
                        onPressed: onConfirm,
                        child: bottomRightChild!,
                      )
                    : _NumPadButton(
                        onPressed: onConfirm,
                        child: const Icon(Icons.check),
                      );
              }
              return _NumPadButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onDigit(key);
                },
                child: Text(
                  key,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumPadButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const _NumPadButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.md),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Material(
          color: colorScheme.surfaceContainerHigh,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
