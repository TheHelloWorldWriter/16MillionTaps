// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';

import '../utils/counter_formatter.dart';

/// The centered counter in the chosen numeral system.
///
/// Scaled down to fit the width so large numbers and the three-line binary form never overflow,
/// with the color name shown subtly below when one exists. The name's line is always reserved, so
/// landing on a named color never nudges the counter.
class CounterDisplay extends StatelessWidget {
  /// Creates the counter for [count] in [numeralSystem], drawn in [color] at [fontSize].
  const CounterDisplay({
    super.key,
    required this.count,
    required this.numeralSystem,
    required this.fontSize,
    required this.color,
    required this.formatDecimal,
    this.colorName,
  });

  /// The current tap count.
  final int count;

  /// How the count is rendered.
  final NumeralSystem numeralSystem;

  /// Font size for the counter text, in logical pixels.
  final double fontSize;

  /// The contrast color for the counter and name.
  final Color color;

  /// Locale-aware decimal grouping (typically `MaterialLocalizations.formatDecimal`).
  final String Function(int count) formatDecimal;

  /// The current color's name, or null when it has none.
  final String? colorName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: .min,
        children: [
          // The counter, scaled down to fit the available width.
          FittedBox(
            fit: .scaleDown,
            child: Text(
              formatCount(count, numeralSystem, formatDecimal: formatDecimal),
              textAlign: .center,
              style: TextStyle(color: color, fontSize: fontSize, height: 1.2),
            ),
          ),
          const SizedBox(height: 16),
          // The color name, with its line kept reserved even when unnamed so the counter holds its
          // place as you tap into and out of named colors.
          Visibility(
            visible: colorName != null,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Text(
              colorName ?? ' ',
              textAlign: .center,
              maxLines: 1,
              overflow: .ellipsis,
              style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
