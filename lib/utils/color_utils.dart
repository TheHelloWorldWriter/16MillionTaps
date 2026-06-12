import 'package:flutter/material.dart';

/// The opaque color whose RGB value equals [count] (0 = black, 0xFFFFFF = white).
Color colorForCount(int count) => Color(0xFF000000 | (count & 0xFFFFFF));

/// Black or white, whichever stays legible on [color].
Color contrastColor(Color color) =>
    ThemeData.estimateBrightnessForColor(color) == Brightness.dark ? Colors.white : Colors.black;

/// Six uppercase hex digits with no leading `#` (for on-screen display).
String hex(int count) => (count & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

/// `#RRGGBB`, uppercase (for copying and the Info screen).
String hexWithHash(int count) => '#${hex(count)}';

/// The `R, G, B` decimal components of [count].
String rgb(int count) {
  final value = count & 0xFFFFFF;
  return '${(value >> 16) & 0xFF}, ${(value >> 8) & 0xFF}, ${value & 0xFF}';
}
