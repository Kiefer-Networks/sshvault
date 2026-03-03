import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shellvault/core/utils/platform_utils.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class NewDirectoryDialog extends StatefulWidget {
  const NewDirectoryDialog({super.key});

  @override
  State<NewDirectoryDialog> createState() => _NewDirectoryDialogState();
}

class _NewDirectoryDialogState extends State<NewDirectoryDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (useCupertinoDesign) {
      return CupertinoAlertDialog(
        title: Text(l10n.sftpNewFolder),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: CupertinoTextField(
            controller: _controller,
            autofocus: true,
            placeholder: l10n.sftpNewFolderName,
            onSubmitted: (value) => Navigator.pop(context, value.trim()),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, _controller.text.trim()),
            child: Text(l10n.create),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(l10n.sftpNewFolder),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.sftpNewFolderName,
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (value) => Navigator.pop(context, value.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
