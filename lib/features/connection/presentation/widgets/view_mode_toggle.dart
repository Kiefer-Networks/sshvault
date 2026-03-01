import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/features/connection/presentation/providers/server_providers.dart';

class ViewModeToggle extends ConsumerWidget {
  const ViewModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(viewModeProvider);
    return SegmentedButton<ViewMode>(
      segments: const [
        ButtonSegment(
          value: ViewMode.list,
          icon: Icon(Icons.view_list, size: 20),
        ),
        ButtonSegment(
          value: ViewMode.grid,
          icon: Icon(Icons.grid_view, size: 20),
        ),
      ],
      selected: {viewMode},
      onSelectionChanged: (selected) {
        ref.read(viewModeProvider.notifier).state = selected.first;
      },
      showSelectedIcon: false,
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
