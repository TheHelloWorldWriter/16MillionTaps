import 'package:flutter_test/flutter_test.dart';
import 'package:sixteen_million_taps/utils/duration_formatter.dart';

void main() {
  group('formatDuration', () {
    test('zero is "0 seconds"', () {
      expect(formatDuration(Duration.zero), '0 seconds');
    });
    test('lists only non-zero units', () {
      expect(formatDuration(const Duration(minutes: 4, seconds: 30)), '4 minutes 30 seconds');
    });
    test('singular units', () {
      expect(
        formatDuration(const Duration(days: 1, hours: 1, minutes: 1, seconds: 1)),
        '1 day 1 hour 1 minute 1 second',
      );
    });
    test('skips zero hours and minutes between days and seconds', () {
      expect(formatDuration(const Duration(days: 2, seconds: 5)), '2 days 5 seconds');
    });
  });
}
