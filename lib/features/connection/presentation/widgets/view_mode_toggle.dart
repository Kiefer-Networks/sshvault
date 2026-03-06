import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive.dart';
import 'package:sshvault/features/connection/presentation/providers/server_providers.dart';

class ViewModeToggle extends ConsumerWidget {
  const ViewModeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(viewModeProvider);
    return AdaptiveSegmentedControl<ViewMode>(
      selected: viewMode,
      segments: const {ViewMode.list: 'List', ViewMode.grid: 'Grid'},
      onChanged: (mode) {
        ref.read(viewModeProvider.notifier).state = mode;
      },
    );
  }
}
