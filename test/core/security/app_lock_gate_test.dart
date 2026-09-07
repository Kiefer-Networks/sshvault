import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/core/widgets/lock_screen.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';
import 'package:sshvault/features/settings/presentation/providers/settings_providers.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class _Settings extends SettingsNotifier {
  final Completer<AppSettingsEntity> result;
  _Settings(this.result);
  @override
  Future<AppSettingsEntity> build() => result.future;
}

void main() {
  testWidgets('protected content stays hidden while settings load or fail', (
    tester,
  ) async {
    final result = Completer<AppSettingsEntity>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsProvider.overrideWith(() => _Settings(result))],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppLockGate(child: Text('private server list')),
        ),
      ),
    );
    expect(find.text('private server list'), findsNothing);
    result.completeError(StateError('keyring unavailable'));
    await tester.pumpAndSettle();
    expect(find.text('private server list'), findsNothing);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
