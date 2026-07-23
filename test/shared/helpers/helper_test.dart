import 'package:flutter_test/flutter_test.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:intl/intl.dart';

void main() {
  group('toDateTime', () {
    test('parses UTC ISO timestamps as local DateTime values', () {
      const raw = '2026-05-28T10:00:00Z';
      final parsed = toDateTime(raw);

      expect(parsed, DateTime.parse(raw).toLocal());
    });

    test('preserves ISO offset timestamps as the same local instant', () {
      const raw = '2026-05-28T17:00:00+07:00';
      final parsed = toDateTime(raw);

      expect(parsed, DateTime.parse(raw).toLocal());
    });

    test('returns the default for empty or invalid values', () {
      final fallback = DateTime(2026);

      expect(toDateTime('', defaultValue: fallback), fallback);
      expect(toDateTime('not-a-date', defaultValue: fallback), fallback);
    });
  });

  group('toNullableDateTime', () {
    test('returns null for null, empty, and invalid values', () {
      expect(toNullableDateTime(null), isNull);
      expect(toNullableDateTime(''), isNull);
      expect(toNullableDateTime('not-a-date'), isNull);
    });
  });

  group('formatDateTime', () {
    test('formats values using the Laravel-style datetime pattern', () {
      final value = DateTime(2026, 5, 28, 17);
      final expected = DateFormat('hh:mm a, dd MMM yyyy').format(value);

      expect(formatDateTime(value), expected);
    });

    test('returns the default for null values', () {
      expect(formatDateTime(null), '');
      expect(formatDateTime(null, defaultValue: 'unknown'), 'unknown');
    });
  });
}
