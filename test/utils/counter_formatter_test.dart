import 'package:flutter_test/flutter_test.dart';
import 'package:sixteen_million_taps/utils/counter_formatter.dart';

void main() {
  test('NumeralSystem radix values match the original app', () {
    expect(NumeralSystem.binary.radix, 2);
    expect(NumeralSystem.octal.radix, 8);
    expect(NumeralSystem.decimal.radix, 10);
    expect(NumeralSystem.hexadecimal.radix, 16);
  });

  group('formatCount', () {
    test('binary renders R/G/B as three 8-bit lines', () {
      expect(formatCount(0x0000EE, NumeralSystem.binary), '00000000\n00000000\n11101110');
    });
    test('octal is plain', () {
      expect(formatCount(8, NumeralSystem.octal), '10');
    });
    test('decimal is ungrouped without a formatter', () {
      expect(formatCount(1234567, NumeralSystem.decimal), '1234567');
    });
    test('decimal uses the provided grouping formatter', () {
      expect(
        formatCount(1234567, NumeralSystem.decimal, formatDecimal: (c) => '1,234,567'),
        '1,234,567',
      );
    });
    test('hexadecimal is six uppercase digits without a hash', () {
      expect(formatCount(0x0000EE, NumeralSystem.hexadecimal), '0000EE');
    });
  });
}
