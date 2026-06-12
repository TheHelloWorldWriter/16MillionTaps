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
