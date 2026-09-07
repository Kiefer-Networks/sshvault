import 'package:flutter_test/flutter_test.dart';
import 'package:sshvault/features/settings/domain/entities/app_settings_entity.dart';

void main() {
  test('system information collection is opt-in and refresh is disabled by default', () {
    const settings = AppSettingsEntity();

    expect(settings.serverSystemInfoConsent, isFalse);
    expect(settings.serverSystemInfoAutoRefresh, isFalse);
    expect(settings.serverSystemInfoRefreshIntervalSecs, 300);
  });

  test('system information settings can be copied independently', () {
    const settings = AppSettingsEntity(
      serverSystemInfoConsent: true,
      serverSystemInfoAutoRefresh: true,
      serverSystemInfoRefreshIntervalSecs: 900,
    );

    final changed = settings.copyWith(serverSystemInfoRefreshIntervalSecs: 60);

    expect(changed.serverSystemInfoConsent, isTrue);
    expect(changed.serverSystemInfoAutoRefresh, isTrue);
    expect(changed.serverSystemInfoRefreshIntervalSecs, 60);
  });
}
