import 'package:flutter/material.dart';
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
    return SegmentedButton<AuthMethod>(
      segments: AuthMethod.values
          .map(
            (method) => ButtonSegment(
              value: method,
              label: Text(method.displayName),
              icon: Icon(_iconForMethod(method), size: 18),
            ),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (selected) => onChanged(selected.first),
    );
  }

  IconData _iconForMethod(AuthMethod method) {
    return switch (method) {
      AuthMethod.password => Icons.password,
      AuthMethod.key => Icons.vpn_key,
      AuthMethod.both => Icons.security,
    };
  }
}
