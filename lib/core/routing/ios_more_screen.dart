import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shellvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:shellvault/features/settings/presentation/widgets/about_dialog.dart'
    as app;
import 'package:shellvault/l10n/generated/app_localizations.dart';

/// The "More" tab screen shown in the iOS CupertinoTabBar.
///
/// Provides grouped navigation to secondary branches (SSH Keys, Groups, Tags,
/// Export/Import) and utility routes (Sync, Settings, About).
class IosMoreScreen extends ConsumerWidget {
  /// Called when the user taps a branch item (SSH Keys, Groups, Tags,
  /// Export/Import). The callback receives the GoRouter branch index.
  final ValueChanged<int> onBranchSelected;

  const IosMoreScreen({super.key, required this.onBranchSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAuthenticated =
        ref.watch(authProvider).value == AuthStatus.authenticated;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.navMore)),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            // ── Section 1: Branch items ──
            CupertinoListSection.insetGrouped(
              header: Text(l10n.navManagement),
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.lock),
                  title: Text(l10n.navSshKeys),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => onBranchSelected(3),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.folder),
                  title: Text(l10n.navGroups),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => onBranchSelected(4),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.tag),
                  title: Text(l10n.navTags),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => onBranchSelected(5),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.arrow_right_arrow_left),
                  title: Text(l10n.navExportImport),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => onBranchSelected(6),
                ),
              ],
            ),
            // ── Section 2: Utility routes ──
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.cloud),
                  title: Text(l10n.settingsSectionSync),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    if (isAuthenticated) {
                      context.push('/sync-settings');
                    } else {
                      context.push('/login');
                    }
                  },
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.gear),
                  title: Text(l10n.navSettings),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => context.push('/settings'),
                ),
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.info),
                  title: Text(l10n.navAbout),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => app.showAppAboutDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
