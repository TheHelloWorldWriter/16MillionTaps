import 'package:flutter/material.dart';

/// A thin, low-opacity progress line under the app bar. Ambient by design and
/// effectively static: one tap advances it far less than a pixel, so it reads as
/// "near the start of a vast journey" rather than live per-tap feedback. No
/// animation, for the same reason - there is nothing perceptible to animate.
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
