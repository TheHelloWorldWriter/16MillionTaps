// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:sixteen_million_taps/utils/share_image.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ui.Image> decode(List<int> bytes) async {
    final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
    return (await codec.getNextFrame()).image;
  }

  test('renders a 1080x1080 PNG flooded with the color', () async {
    final bytes = await renderColorCard(
      fill: const Color(0xFF112358),
      contrast: Colors.white,
      countText: '1,123,160',
      colorName: 'Fibonacci Blue',
      url: 'https://16milliontaps.thehww.app/',
    );

    final image = await decode(bytes);
    expect(image.width, 1080);
    expect(image.height, 1080);

    // The fill reaches the corners (full-bleed).
    final pixels = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    expect(
      [pixels.getUint8(0), pixels.getUint8(1), pixels.getUint8(2), pixels.getUint8(3)],
      [0x11, 0x23, 0x58, 0xFF],
    );
  });

  test('renders an unnamed color without throwing', () async {
    final bytes = await renderColorCard(
      fill: const Color(0xFFFFFFFF),
      contrast: Colors.black,
      countText: 'FFFFFF',
      url: 'https://16milliontaps.thehww.app/',
    );
    expect(bytes, isNotEmpty);
  });
}
