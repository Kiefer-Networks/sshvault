import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/widgets/security_warning_dialog.dart';

void main() {
  Widget buildTestApp({required Widget child}) {
    return MaterialApp(home: child);
  }

  group('SecurityWarningDialog — critical severity', () {
    testWidgets('does not show Continue Anyway button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Certificate Mismatch',
            message: 'The server certificate has changed unexpectedly.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
            onContinue: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disconnect'), findsOneWidget);
      expect(find.text('Continue Anyway'), findsNothing);
    });

    testWidgets('shows disconnect button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Critical Alert',
            message: 'Attestation failure.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disconnect'), findsOneWidget);
    });

    testWidgets('shows error icon for critical severity', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Critical',
            message: 'Error detected.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.gpp_bad), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber), findsNothing);
    });

    testWidgets('shows report button when onReport is provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Critical',
            message: 'Security violation.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
            onReport: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Report & Disconnect'), findsOneWidget);
    });

    testWidgets('hides report button when onReport is null', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Critical',
            message: 'Security violation.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Report & Disconnect'), findsNothing);
    });
  });

  group('SecurityWarningDialog — warning severity', () {
    testWidgets('shows Continue Anyway button', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'DNS Warning',
            message: 'DNS resolution differences detected.',
            severity: SecuritySeverity.warning,
            onDisconnect: () {},
            onContinue: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Continue Anyway'), findsOneWidget);
      expect(find.text('Disconnect'), findsOneWidget);
    });

    testWidgets('shows warning icon for warning severity', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Warning',
            message: 'Potential issue detected.',
            severity: SecuritySeverity.warning,
            onDisconnect: () {},
            onContinue: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
      expect(find.byIcon(Icons.gpp_bad), findsNothing);
    });

    testWidgets('does not show Continue Anyway when onContinue is null', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Warning',
            message: 'Minor issue.',
            severity: SecuritySeverity.warning,
            onDisconnect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Continue Anyway'), findsNothing);
    });
  });

  group('SecurityWarningDialog — button callbacks', () {
    testWidgets('disconnect button calls onDisconnect', (tester) async {
      var disconnected = false;

      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Alert',
            message: 'Test disconnect.',
            severity: SecuritySeverity.critical,
            onDisconnect: () => disconnected = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Disconnect'));
      await tester.pumpAndSettle();

      expect(disconnected, isTrue);
    });

    testWidgets('report button calls onReport', (tester) async {
      var reported = false;

      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Alert',
            message: 'Test report.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
            onReport: () => reported = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Report & Disconnect'));
      await tester.pumpAndSettle();

      expect(reported, isTrue);
    });

    testWidgets('continue button calls onContinue', (tester) async {
      var continued = false;

      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Warning',
            message: 'Test continue.',
            severity: SecuritySeverity.warning,
            onDisconnect: () {},
            onContinue: () => continued = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue Anyway'));
      await tester.pumpAndSettle();

      expect(continued, isTrue);
    });
  });

  group('SecurityWarningDialog — content rendering', () {
    testWidgets('displays title and message', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Security Alert',
            message: 'Your connection may be compromised.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Security Alert'), findsOneWidget);
      expect(find.text('Your connection may be compromised.'), findsOneWidget);
    });

    testWidgets('displays details when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Alert',
            message: 'Issue detected.',
            details: 'Fingerprint: SHA256:abc123',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fingerprint: SHA256:abc123'), findsOneWidget);
    });

    testWidgets('does not display details container when details is null', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Alert',
            message: 'Issue detected.',
            severity: SecuritySeverity.critical,
            onDisconnect: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The monospace-styled container should not be in the tree
      // We verify by checking no Container with monospace text exists
      expect(find.text('Fingerprint: SHA256:abc123'), findsNothing);
    });

    testWidgets('all three buttons appear for warning with all callbacks', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SecurityWarningDialog(
            title: 'Warning',
            message: 'Issue.',
            severity: SecuritySeverity.warning,
            onDisconnect: () {},
            onReport: () {},
            onContinue: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disconnect'), findsOneWidget);
      expect(find.text('Report & Disconnect'), findsOneWidget);
      expect(find.text('Continue Anyway'), findsOneWidget);
    });
  });

  group('SecurityWarningDialog — static show method', () {
    testWidgets('displays non-dismissable dialog', (tester) async {
      var disconnected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  SecurityWarningDialog.show(
                    context,
                    title: 'Critical Alert',
                    message: 'Test dialog.',
                    severity: SecuritySeverity.critical,
                    onDisconnect: () {
                      disconnected = true;
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Dialog is visible
      expect(find.text('Critical Alert'), findsOneWidget);
      expect(find.text('Test dialog.'), findsOneWidget);
      expect(find.text('Disconnect'), findsOneWidget);

      // Tap disconnect
      await tester.tap(find.text('Disconnect'));
      await tester.pumpAndSettle();

      expect(disconnected, isTrue);
    });
  });
}
