import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

/// Allows any screen within the shell to switch branches programmatically
/// via `ref.read(shellNavigationProvider)?.goBranch(index)`.
final shellNavigationProvider = StateProvider<StatefulNavigationShell?>(
  (ref) => null,
);
