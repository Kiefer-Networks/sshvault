import 'package:flutter/material.dart';
import 'package:shellvault/l10n/generated/app_localizations.dart';
import 'package:shellvault/features/connection/domain/entities/auth_method.dart';

class AuthMethodSelector extends StatelessWidget {
  final AuthMethod selected;
  final ValueChanged<AuthMethod> onChanged;

  const AuthMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedButton<AuthMethod>(
      segments: AuthMethod.values
          .map(
            (method) => ButtonSegment(
              value: method,
              label: Text(_label(l10n, method)),
              icon: Icon(_iconForMethod(method), size: 18),
            ),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (selected) => onChanged(selected.first),
    );
  }

  String _label(AppLocalizations l10n, AuthMethod method) {
    return switch (method) {
      AuthMethod.password => l10n.authMethodPassword,
      AuthMethod.key => l10n.authMethodKey,
      AuthMethod.both => l10n.authMethodBoth,
    };
  }

  IconData _iconForMethod(AuthMethod method) {
    return switch (method) {
      AuthMethod.password => Icons.password,
      AuthMethod.key => Icons.vpn_key,
      AuthMethod.both => Icons.security,
    };
  }
}
