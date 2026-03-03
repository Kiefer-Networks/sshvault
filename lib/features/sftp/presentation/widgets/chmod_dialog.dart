import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';

final _chmodPermissionsProvider = StateProvider.autoDispose<int>(
  (ref) => 0x1ED, // 755 octal
);

class ChmodDialog extends ConsumerStatefulWidget {
  final int? initialPermissions;

  const ChmodDialog({super.key, this.initialPermissions});

  @override
  ConsumerState<ChmodDialog> createState() => _ChmodDialogState();
}

class _ChmodDialogState extends ConsumerState<ChmodDialog> {
  late final TextEditingController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialPermissions ?? 0x1ED;
    _controller = TextEditingController(
      text: initial.toRadixString(8).padLeft(3, '0'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (widget.initialPermissions != null) {
        ref.read(_chmodPermissionsProvider.notifier).state =
            widget.initialPermissions!;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _toOctal() => ref.read(_chmodPermissionsProvider);

  void _toggleBit(int bit, bool value) {
    final current = ref.read(_chmodPermissionsProvider);
    final updated = value ? (current | bit) : (current & ~bit);
    ref.read(_chmodPermissionsProvider.notifier).state = updated;
    _controller.text = updated.toRadixString(8).padLeft(3, '0');
  }

  void _updateFromText(String text) {
    final value = int.tryParse(text, radix: 8);
    if (value != null && value >= 0 && value <= 0x1FF) {
      ref.read(_chmodPermissionsProvider.notifier).state = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mode = ref.watch(_chmodPermissionsProvider);

    final content = SingleChildScrollView(
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
          _buildGroup(l10n.sftpChmodOwner, l10n, mode, 0x100, 0x080, 0x040),
          _buildGroup(l10n.sftpChmodGroup, l10n, mode, 0x020, 0x010, 0x008),
          _buildGroup(l10n.sftpChmodOther, l10n, mode, 0x004, 0x002, 0x001),
        ],
      ),
    );

    return AlertDialog(
      title: Text(l10n.sftpChmodTitle),
      content: content,
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

  Widget _buildGroup(
    String label,
    AppLocalizations l10n,
    int mode,
    int readBit,
    int writeBit,
    int execBit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
