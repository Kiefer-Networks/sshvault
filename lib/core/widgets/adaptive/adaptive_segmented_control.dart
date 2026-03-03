import 'package:flutter/material.dart';

/// A segmented control using Material [SegmentedButton].
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
