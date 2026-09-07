import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sshvault/core/error/result.dart';
import 'package:sshvault/core/error/failures.dart';
import 'package:sshvault/core/network/api_provider.dart';
import 'package:sshvault/core/storage/secure_storage_service.dart';
import 'package:sshvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:sshvault/features/auth/domain/entities/auth_response.dart';
import 'package:sshvault/features/auth/domain/entities/user_entity.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_providers.dart';
import 'package:sshvault/features/auth/presentation/providers/auth_repository_providers.dart';
import 'package:sshvault/features/auth/presentation/screens/register_screen.dart';
import 'package:sshvault/l10n/generated/app_localizations.dart';

class _Storage extends Mock implements SecureStorageService {}

class _AuthRepo extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('login cannot authenticate when token persistence fails', () async {
    final storage = _Storage();
    final repository = _AuthRepo();
    when(
      () => storage.getAccessToken(),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => storage.getDeviceId(),
    ).thenAnswer((_) async => const Success('device'));
    when(
      () => storage.saveAccessToken(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => storage.saveRefreshToken(any()),
    ).thenAnswer((_) async => const Err(StorageFailure('keyring unavailable')));
    when(
      () => storage.saveUserEmail(any()),
    ).thenAnswer((_) async => const Success(null));
    when(
      () => storage.clearAuthTokens(),
    ).thenAnswer((_) async => const Success(null));
    when(
      () =>
          repository.login(any(), any(), deviceName: any(named: 'deviceName')),
    ).thenAnswer(
      (_) async => const Success(
        AuthResponse(
          user: UserEntity(id: 'user', email: 'user@example.com'),
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ),
    );
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        authRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authProvider.future);
    await container
        .read(authProvider.notifier)
        .login('user@example.com', 'password');
    expect(container.read(authProvider).hasError, isTrue);
    expect(container.read(authProvider).value, isNot(AuthStatus.authenticated));
  });
  testWidgets(
    'registration acceptance shows mailbox steps and never signs in',
    (tester) async {
      final storage = _Storage();
      final repository = _AuthRepo();
      when(
        () => storage.getAccessToken(),
      ).thenAnswer((_) async => const Success(null));
      when(
        () => repository.register(any(), any()),
      ).thenAnswer((_) async => const Success(null));
      final container = ProviderContainer(
        overrides: [
          secureStorageProvider.overrideWithValue(storage),
          authRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RegisterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'user@example.com');
      await tester.enterText(fields.at(1), 'password123');
      await tester.enterText(fields.at(2), 'password123');
      final submit = find.widgetWithText(FilledButton, 'Register');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.textContaining('check your email to verify'), findsOneWidget);
      expect(container.read(authProvider).value, AuthStatus.unauthenticated);
      verifyNever(() => storage.saveAccessToken(any()));
      verifyNever(() => storage.saveRefreshToken(any()));
    },
  );
}
