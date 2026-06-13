import 'package:flutter/material.dart';

/// A thin, low-opacity progress line along the top of the tap screen. Ambient by
/// design: it inches forward per tap and glides when the count jumps, unless the
/// platform's reduce-motion setting is on.
class ProgressHairline extends StatelessWidget {
  const ProgressHairline({super.key, required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: progress),
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, _) => LinearProgressIndicator(
        value: value,
        minHeight: 2,
        color: color.withValues(alpha: 0.5),
        backgroundColor: color.withValues(alpha: 0.12),
      ),
    );
  }
}
