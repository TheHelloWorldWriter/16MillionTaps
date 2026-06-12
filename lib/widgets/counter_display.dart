import 'package:flutter/material.dart';

import '../utils/counter_formatter.dart';

/// Renders the counter in the chosen numeral system, scaled down to fit the available space so large numbers and the three-line binary form never overflow.
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({
    super.key,
    required this.count,
    required this.numeralSystem,
    required this.fontSize,
    required this.color,
    required this.formatDecimal,
  });

  final int count;
  final NumeralSystem numeralSystem;
  final double fontSize;
  final Color color;
  final String Function(int count) formatDecimal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          formatCount(count, numeralSystem, formatDecimal: formatDecimal),
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: fontSize, height: 1.2),
        ),
      ),
    );
  }
}
