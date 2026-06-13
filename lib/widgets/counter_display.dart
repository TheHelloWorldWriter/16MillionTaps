import 'package:flutter/material.dart';

import '../utils/counter_formatter.dart';

/// The centered counter in the chosen numeral system, scaled down to fit the width so large numbers and the three-line binary form never overflow, with the color name shown subtly below when one exists. The name's line is always reserved, so landing on a named color never nudges the counter.
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({
    super.key,
    required this.count,
    required this.numeralSystem,
    required this.fontSize,
    required this.color,
    required this.formatDecimal,
    this.colorName,
  });

  final int count;
  final NumeralSystem numeralSystem;
  final double fontSize;
  final Color color;
  final String Function(int count) formatDecimal;
  final String? colorName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              formatCount(count, numeralSystem, formatDecimal: formatDecimal),
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: fontSize, height: 1.2),
            ),
          ),
          const SizedBox(height: 16),
          // Keep the name line reserved even when the color is unnamed, so the
          // counter holds its place as you tap into and out of named colors.
          Visibility(
            visible: colorName != null,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Text(
              colorName ?? ' ',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
