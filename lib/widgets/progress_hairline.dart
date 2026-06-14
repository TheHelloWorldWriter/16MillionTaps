// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';

/// A thin, low-opacity progress line under the app bar.
///
/// Ambient by design and effectively static: one tap advances it far less than a pixel, so it reads
/// as "near the start of a vast journey" rather than live per-tap feedback. No animation, for the
/// same reason - there is nothing perceptible to animate.
class ProgressHairline extends StatelessWidget {
  /// Creates a hairline showing [progress] (0..1), painted in [color].
  const ProgressHairline({super.key, required this.progress, required this.color});

  /// How far the count is from 0 to the maximum, as a fraction 0..1.
  final double progress;

  /// The contrast color the line is painted in.
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
