import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class CreateSymlinkDialog extends StatefulWidget {
  const CreateSymlinkDialog({super.key});

  @override
  State<CreateSymlinkDialog> createState() => _CreateSymlinkDialogState();
}

class _CreateSymlinkDialogState extends State<CreateSymlinkDialog> {
  final _targetController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _targetController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (useCupertinoDesign) {
      return CupertinoAlertDialog(
        title: Text(l10n.sftpCreateSymlink),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: _targetController,
                autofocus: true,
                placeholder: l10n.sftpSymlinkTarget,
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _nameController,
                placeholder: l10n.sftpSymlinkName,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              final target = _targetController.text.trim();
              final name = _nameController.text.trim();
              if (target.isNotEmpty && name.isNotEmpty) {
                Navigator.pop(context, (target: target, name: name));
              }
            },
            child: Text(l10n.create),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(l10n.sftpCreateSymlink),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _targetController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.sftpSymlinkTarget,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.sftpSymlinkName,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final target = _targetController.text.trim();
            final name = _nameController.text.trim();
            if (target.isNotEmpty && name.isNotEmpty) {
              Navigator.pop(context, (target: target, name: name));
            }
          },
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
