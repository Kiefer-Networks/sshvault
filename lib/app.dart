import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/routing/app_router.dart';
import 'package:shellvault/core/theme/app_theme.dart';
import 'package:shellvault/features/settings/presentation/providers/settings_providers.dart';

class ShellVaultApp extends ConsumerWidget {
  const ShellVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final themeMode =
        settingsAsync.valueOrNull?.themeMode ?? ThemeMode.system;

    return MaterialApp.router(
      title: 'ShellVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
