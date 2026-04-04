import 'package:flutter/material.dart';
import 'package:sshvault/core/widgets/adaptive/adaptive_dialog.dart';
import 'package:sshvault/core/constants/spacing_constants.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class ChmodDialog {
  static Future<int?> show(BuildContext context, {int? initialPermissions}) {
    final l10n = AppLocalizations.of(context)!;
    final permissions = ValueNotifier<int>(initialPermissions ?? 0x1ED);

    return showAdaptiveFormDialog<int>(
      context,
      title: l10n.sftpChmodTitle,
      content: _ChmodContent(permissions: permissions),
      materialActions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        Spacing.horizontalSm,
        FilledButton(
          onPressed: () => Navigator.pop(context, permissions.value),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

class _ChmodContent extends StatefulWidget {
  final ValueNotifier<int> permissions;

  const _ChmodContent({required this.permissions});

  @override
  State<_ChmodContent> createState() => _ChmodContentState();
}

class _ChmodContentState extends State<_ChmodContent> {
  late final TextEditingController _controller;
  bool _updatingFromCheckbox = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.permissions.value.toRadixString(8).padLeft(3, '0'),
    );
    widget.permissions.addListener(_onPermissionsChanged);
  }

  @override
  void dispose() {
    widget.permissions.removeListener(_onPermissionsChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onPermissionsChanged() {
    if (_updatingFromCheckbox) {
      _controller.text = widget.permissions.value
          .toRadixString(8)
          .padLeft(3, '0');
    }
  }

  void _toggleBit(int bit, bool value) {
    _updatingFromCheckbox = true;
    final current = widget.permissions.value;
    widget.permissions.value = value ? (current | bit) : (current & ~bit);
    _updatingFromCheckbox = false;
  }

  void _updateFromText(String text) {
    final value = int.tryParse(text, radix: 8);
    if (value != null && value >= 0 && value <= 0x1FF) {
      widget.permissions.value = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<int>(
      valueListenable: widget.permissions,
      builder: (context, mode, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: l10n.sftpChmodOctal,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 3,
              onChanged: _updateFromText,
            ),
            Spacing.verticalLg,
            _buildGroup(l10n.sftpChmodOwner, l10n, mode, 0x100, 0x080, 0x040),
            _buildGroup(l10n.sftpChmodGroup, l10n, mode, 0x020, 0x010, 0x008),
            _buildGroup(l10n.sftpChmodOther, l10n, mode, 0x004, 0x002, 0x001),
          ],
        );
      },
    );
  }

  Widget _buildGroup(
    String label,
    AppLocalizations l10n,
    int mode,
    int readBit,
    int writeBit,
    int execBit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          Row(
            children: [
              _checkboxLabel(l10n.sftpChmodRead, (mode & readBit) != 0, (v) {
                _toggleBit(readBit, v!);
              }),
              _checkboxLabel(l10n.sftpChmodWrite, (mode & writeBit) != 0, (v) {
                _toggleBit(writeBit, v!);
              }),
              _checkboxLabel(l10n.sftpChmodExecute, (mode & execBit) != 0, (v) {
                _toggleBit(execBit, v!);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkboxLabel(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: value, onChanged: onChanged),
          Flexible(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
