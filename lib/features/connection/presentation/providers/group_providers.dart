// Re-export folder_providers for backward compatibility during migration.
// All new code should import folder_providers.dart directly.
export 'folder_providers.dart';

import 'package:shellvault/features/connection/presentation/providers/folder_providers.dart';

// Legacy aliases — use folderListProvider / folderTreeProvider in new code.
final groupListProvider = folderListProvider;
final groupTreeProvider = folderTreeProvider;

typedef GroupListNotifier = FolderListNotifier;
