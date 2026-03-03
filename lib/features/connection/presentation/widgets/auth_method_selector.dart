import 'package:flutter/material.dart';
import 'package:shellvault/core/widgets/adaptive/adaptive.dart';
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
    return AdaptiveSegmentedControl<AuthMethod>(
      selected: selected,
      segments: {
        for (final method in AuthMethod.values) method: _label(l10n, method),
      },
      onChanged: onChanged,
    );
  }

  String _label(AppLocalizations l10n, AuthMethod method) {
    return switch (method) {
      AuthMethod.password => l10n.authMethodPassword,
      AuthMethod.key => l10n.authMethodKey,
      AuthMethod.both => l10n.authMethodBoth,
    };
  }
}
