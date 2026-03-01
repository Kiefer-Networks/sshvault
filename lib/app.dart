import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shellvault/core/routing/app_router.dart';
import 'package:shellvault/core/theme/app_theme.dart';

class ShellVaultApp extends ConsumerWidget {
  const ShellVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'ShellVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
