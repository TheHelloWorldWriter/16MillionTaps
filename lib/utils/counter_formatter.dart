import 'color_utils.dart';

/// The numeral system used to display the counter. [radix] is the numeric base, matching the values the original app persisted.
enum NumeralSystem {
  binary(2),
  octal(8),
  decimal(10),
  hexadecimal(16);

  const NumeralSystem(this.radix);

  final int radix;
}

/// Formats [count] in the given [system].
///
/// Decimal grouping is locale-dependent, so the caller may pass [formatDecimal] (e.g. `MaterialLocalizations.formatDecimal`); without it, decimal is ungrouped.
String formatCount(int count, NumeralSystem system, {String Function(int count)? formatDecimal}) {
  return switch (system) {
    NumeralSystem.binary => _binary(count),
    NumeralSystem.octal => count.toRadixString(8),
    NumeralSystem.decimal => formatDecimal?.call(count) ?? '$count',
    NumeralSystem.hexadecimal => hex(count),
  };
}

/// The red, green, and blue bytes as three zero-padded 8-bit lines.
String _binary(int count) {
  final value = count & 0xFFFFFF;
  String byte(int v) => v.toRadixString(2).padLeft(8, '0');
  return '${byte((value >> 16) & 0xFF)}\n${byte((value >> 8) & 0xFF)}\n${byte(value & 0xFF)}';
}
