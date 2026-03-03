import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

class ChmodDialog extends StatefulWidget {
  final int? initialPermissions;

  const ChmodDialog({super.key, this.initialPermissions});

  @override
  State<ChmodDialog> createState() => _ChmodDialogState();
}

class _ChmodDialogState extends State<ChmodDialog> {
  late final TextEditingController _controller;

  // Owner
  bool _ownerRead = true;
  bool _ownerWrite = true;
  bool _ownerExecute = true;
  // Group
  bool _groupRead = true;
  bool _groupWrite = false;
  bool _groupExecute = true;
  // Other
  bool _otherRead = true;
  bool _otherWrite = false;
  bool _otherExecute = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialPermissions != null) {
      _fromOctal(widget.initialPermissions!);
    }
    _controller = TextEditingController(text: _toOctalString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fromOctal(int mode) {
    _ownerRead = (mode & 0x100) != 0;
    _ownerWrite = (mode & 0x080) != 0;
    _ownerExecute = (mode & 0x040) != 0;
    _groupRead = (mode & 0x020) != 0;
    _groupWrite = (mode & 0x010) != 0;
    _groupExecute = (mode & 0x008) != 0;
    _otherRead = (mode & 0x004) != 0;
    _otherWrite = (mode & 0x002) != 0;
    _otherExecute = (mode & 0x001) != 0;
  }

  int _toOctal() {
    int mode = 0;
    if (_ownerRead) mode |= 0x100;
    if (_ownerWrite) mode |= 0x080;
    if (_ownerExecute) mode |= 0x040;
    if (_groupRead) mode |= 0x020;
    if (_groupWrite) mode |= 0x010;
    if (_groupExecute) mode |= 0x008;
    if (_otherRead) mode |= 0x004;
    if (_otherWrite) mode |= 0x002;
    if (_otherExecute) mode |= 0x001;
    return mode;
  }

  String _toOctalString() {
    return _toOctal().toRadixString(8).padLeft(3, '0');
  }

  void _updateFromCheckbox() {
    _controller.text = _toOctalString();
  }

  void _updateFromText(String text) {
    final value = int.tryParse(text, radix: 8);
    if (value != null && value >= 0 && value <= 0x1FF) {
      setState(() {
        _fromOctal(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.sftpChmodTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Octal input
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
            const SizedBox(height: 16),
            // Permission grid
            _buildGroup(l10n.sftpChmodOwner, l10n),
            _buildGroup(l10n.sftpChmodGroup, l10n),
            _buildGroup(l10n.sftpChmodOther, l10n),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _toOctal()),
          child: Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildGroup(String label, AppLocalizations l10n) {
    final isOwner = label == l10n.sftpChmodOwner;
    final isGroup = label == l10n.sftpChmodGroup;

    bool getRead() => isOwner
        ? _ownerRead
        : isGroup
        ? _groupRead
        : _otherRead;
    bool getWrite() => isOwner
        ? _ownerWrite
        : isGroup
        ? _groupWrite
        : _otherWrite;
    bool getExecute() => isOwner
        ? _ownerExecute
        : isGroup
        ? _groupExecute
        : _otherExecute;

    void setRead(bool v) {
      if (isOwner) {
        _ownerRead = v;
      } else if (isGroup) {
        _groupRead = v;
      } else {
        _otherRead = v;
      }
    }

    void setWrite(bool v) {
      if (isOwner) {
        _ownerWrite = v;
      } else if (isGroup) {
        _groupWrite = v;
      } else {
        _otherWrite = v;
      }
    }

    void setExecute(bool v) {
      if (isOwner) {
        _ownerExecute = v;
      } else if (isGroup) {
        _groupExecute = v;
      } else {
        _otherExecute = v;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          Row(
            children: [
              _checkboxLabel(l10n.sftpChmodRead, getRead(), (v) {
                setState(() {
                  setRead(v!);
                  _updateFromCheckbox();
                });
              }),
              _checkboxLabel(l10n.sftpChmodWrite, getWrite(), (v) {
                setState(() {
                  setWrite(v!);
                  _updateFromCheckbox();
                });
              }),
              _checkboxLabel(l10n.sftpChmodExecute, getExecute(), (v) {
                setState(() {
                  setExecute(v!);
                  _updateFromCheckbox();
                });
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
