import 'package:flutter_test/flutter_test.dart';
import 'package:shellvault/core/utils/date_formatter.dart';

void main() {
  group('formatDate', () {
    test('formats date with zero-padded month and day', () {
      final date = DateTime(2025, 3, 5, 9, 7);
      expect(formatDate(date), '2025-03-05 09:07');
    });

    test('formats date without padding needed', () {
      final date = DateTime(2024, 12, 25, 14, 30);
      expect(formatDate(date), '2024-12-25 14:30');
    });

    test('handles midnight', () {
      final date = DateTime(2026, 1, 1, 0, 0);
      expect(formatDate(date), '2026-01-01 00:00');
    });

    test('handles end of day', () {
      final date = DateTime(2025, 6, 15, 23, 59);
      expect(formatDate(date), '2025-06-15 23:59');
    });
  });
}
