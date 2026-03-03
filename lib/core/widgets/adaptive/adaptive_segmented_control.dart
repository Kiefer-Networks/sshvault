import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';

/// A platform-adaptive segmented control.
///
/// On iOS/macOS: [CNSegmentedControl] (Liquid Glass on iOS 26+).
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
      final keys = segments.keys.toList();
      final labels = segments.values.toList();
      final selectedIndex = keys.indexOf(selected);

      return SizedBox(
        width: double.infinity,
        child: CNSegmentedControl(
          labels: labels,
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
          onValueChanged: (index) {
            if (index >= 0 && index < keys.length) {
              onChanged(keys[index]);
            }
          },
        ),
      );
    }

    return SegmentedButton<T>(
      segments: segments.entries
          .map((e) => ButtonSegment<T>(value: e.key, label: Text(e.value)))
          .toList(),
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
      showSelectedIcon: false,
    );
  }
}
