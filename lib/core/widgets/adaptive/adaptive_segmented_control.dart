import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive segmented control.
///
/// On iOS/macOS: [CupertinoSlidingSegmentedControl].
/// On Android/Desktop: [SegmentedButton].
class AdaptiveSegmentedControl<T extends Object> extends StatelessWidget {
  final T selected;
  final Map<T, String> segments;
  final ValueChanged<T> onChanged;

  const AdaptiveSegmentedControl({
    super.key,
    required this.selected,
    required this.segments,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (useCupertinoDesign) {
      return SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<T>(
          groupValue: selected,
          children: segments.map(
            (key, label) => MapEntry(
              key,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(label),
              ),
            ),
          ),
          onValueChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      );
    }

    return SegmentedButton<T>(
      segments: segments.entries
          .map(
            (e) => ButtonSegment<T>(value: e.key, label: Text(e.value)),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
      showSelectedIcon: false,
    );
  }
}
