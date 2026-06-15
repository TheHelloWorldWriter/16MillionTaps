// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'color_utils.dart';

/// The numeral system used to display the counter. [radix] is the numeric base, matching the values
/// the original app persisted.
enum NumeralSystem {
  /// Base 2, rendered as the red/green/blue bytes on three lines.
  binary(2),

  /// Base 8.
  octal(8),

  /// Base 10, locale-grouped.
  decimal(10),

  /// Base 16, six uppercase digits.
  hexadecimal(16);

  const NumeralSystem(this.radix);

  /// The numeric base (2, 8, 10, or 16).
  final int radix;
}

/// Formats [count] in the given [system].
///
/// Decimal grouping is locale-dependent, so the caller may pass [formatDecimal]
/// (e.g. `MaterialLocalizations.formatDecimal`); without it, decimal is ungrouped.
String formatCount(int count, NumeralSystem system, {String Function(int count)? formatDecimal}) {
  return switch (system) {
    .binary => _binary(count),
    .octal => count.toRadixString(8),
    .decimal => formatDecimal?.call(count) ?? '$count',
    .hexadecimal => hex(count),
  };
}

/// The red, green, and blue bytes as three zero-padded 8-bit lines.
String _binary(int count) {
  final value = count & 0xFFFFFF;
  String byte(int v) => v.toRadixString(2).padLeft(8, '0');
  return '${byte((value >> 16) & 0xFF)}\n${byte((value >> 8) & 0xFF)}\n${byte(value & 0xFF)}';
}
