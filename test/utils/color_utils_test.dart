// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sixteen_million_taps/utils/color_utils.dart';

void main() {
  group('colorForCount', () {
    test('0 is opaque black', () {
      expect(colorForCount(0), const Color(0xFF000000));
    });
    test('0xFFFFFF is opaque white', () {
      expect(colorForCount(0xFFFFFF), const Color(0xFFFFFFFF));
    });
  });

  group('contrastColor', () {
    test('white on black', () {
      expect(contrastColor(const Color(0xFF000000)), Colors.white);
    });
    test('black on white', () {
      expect(contrastColor(const Color(0xFFFFFFFF)), Colors.black);
    });

    test('meets WCAG AA (>= 4.5:1) on every grey fill', () {
      for (var g = 0; g <= 0xFF; g++) {
        final fill = colorForCount(g << 16 | g << 8 | g);
        expect(
          _contrastRatio(fill, contrastColor(fill)),
          greaterThanOrEqualTo(4.5),
          reason: 'grey 0x${g.toRadixString(16)}',
        );
      }
    });

    test('meets WCAG AA (>= 4.5:1) across a broad colour sweep', () {
      for (var count = 0; count <= 0xFFFFFF; count += 0x000101) {
        final fill = colorForCount(count);
        expect(
          _contrastRatio(fill, contrastColor(fill)),
          greaterThanOrEqualTo(4.5),
          reason: 'count $count',
        );
      }
    });
  });

  group('hex', () {
    test('pads to six uppercase digits without a hash', () {
      expect(hex(0x0000EE), '0000EE');
      expect(hex(0), '000000');
      expect(hex(0xFFFFFF), 'FFFFFF');
    });
    test('hexWithHash adds the leading hash', () {
      expect(hexWithHash(0x0000EE), '#0000EE');
    });
  });

  group('rgb', () {
    test('formats the decimal components', () {
      expect(rgb(0xFFA500), '255, 165, 0');
      expect(rgb(0), '0, 0, 0');
    });
  });
}

/// WCAG relative-luminance contrast ratio between two colors.
double _contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}
