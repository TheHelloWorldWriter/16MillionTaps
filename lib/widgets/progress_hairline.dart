import 'package:flutter/material.dart';

/// A thin, low-opacity progress line along the top of the tap screen. Ambient by design: it moves imperceptibly per tap.
class ProgressHairline extends StatelessWidget {
  const ProgressHairline({super.key, required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      minHeight: 2,
      color: color.withValues(alpha: 0.5),
      backgroundColor: color.withValues(alpha: 0.12),
    );
  }
}
