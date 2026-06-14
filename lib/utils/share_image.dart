// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/painting.dart';

/// The side length of the square share image, in pixels.
const double _imageSize = 1080;

/// Line height for the (possibly multi-line) count, shared by layout and fitting.
const double _countLineHeight = 1.2;

/// Renders the full-bleed "share journey" card to a square PNG: the color fill,
/// the count centered and scaled to fit, the color name just below it when there
/// is one, and the app [url] near the bottom - all drawn in [contrast].
///
/// [countText] is the count already formatted in the user's numeral system, so the
/// image matches the Taps screen (including the three-line binary form).
Future<Uint8List> renderColorCard({
  required Color fill,
  required Color contrast,
  required String countText,
  required String url,
  String? colorName,
  double size = _imageSize,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size, size));
  canvas.drawRect(Rect.fromLTWH(0, 0, size, size), Paint()..color = fill);

  final margin = size * 0.08;
  final boxWidth = size - margin * 2;
  final muted = contrast.withValues(alpha: 0.7);

  final url0 = _painter(url, fontSize: size * 0.028, color: muted, boxWidth: boxWidth, maxLines: 1);
  url0.paint(canvas, Offset(margin, size - margin - url0.height));

  // Keep the count from dominating: a smaller base, capped in width and height so
  // wide numbers (the three-line binary form and 7-8 digit decimals) shrink to fit.
  final countFontSize = _fittedFontSize(countText, size * 0.14, size * 0.66, size * 0.34);
  final count0 = _painter(
    countText,
    fontSize: countFontSize,
    color: contrast,
    boxWidth: boxWidth,
    height: _countLineHeight,
  );
  final name0 = colorName == null
      ? null
      : _painter(colorName, fontSize: size * 0.045, color: muted, boxWidth: boxWidth, maxLines: 1);

  // Center the count (plus the name when present) a little above the middle.
  const gap = 28.0;
  final stackHeight = count0.height + (name0 == null ? 0.0 : gap + name0.height);
  final stackTop = size * 0.46 - stackHeight / 2;
  count0.paint(canvas, Offset(margin, stackTop));
  name0?.paint(canvas, Offset(margin, stackTop + count0.height + gap));

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.round(), size.round());
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return data!.buffer.asUint8List();
}

/// A painter laid out to a fixed [boxWidth] so its centered lines sit centered on
/// the canvas when painted at the left margin.
TextPainter _painter(
  String text, {
  required double fontSize,
  required Color color,
  required double boxWidth,
  double? height,
  int? maxLines,
}) {
  return TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: fontSize, height: height),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: maxLines,
    ellipsis: maxLines == null ? null : '…',
  )..layout(minWidth: boxWidth, maxWidth: boxWidth);
}

/// Shrinks [fontSize] so [text] fits within both [maxWidth] and [maxHeight],
/// never enlarging it. Measured at the same line height the count is drawn with.
double _fittedFontSize(String text, double fontSize, double maxWidth, double maxHeight) {
  final probe = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize, height: _countLineHeight),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  )..layout();
  final widthScale = probe.width > maxWidth ? maxWidth / probe.width : 1.0;
  final heightScale = probe.height > maxHeight ? maxHeight / probe.height : 1.0;
  return fontSize * (widthScale < heightScale ? widthScale : heightScale);
}
