// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The opaque color whose RGB value equals [count] (0 = black, 0xFFFFFF = white).
Color colorForCount(int count) => .new(0xFF000000 | (count & 0xFFFFFF));

/// Black or white, whichever gives the higher WCAG contrast against [color]. Picking the better of
/// the two keeps text on every fill at >= 4.5:1 (AA), which a fixed brightness threshold cannot
/// guarantee near its cutoff.
Color contrastColor(Color color) {
  final luminance = color.computeLuminance();
  final whiteContrast = 1.05 / (luminance + 0.05);
  final blackContrast = (luminance + 0.05) / 0.05;
  return whiteContrast >= blackContrast ? Colors.white : Colors.black;
}

/// Transparent system bars whose icons take [contrastColor], so they stay legible over the live
/// fill drawn behind them in edge-to-edge mode (Android).
SystemUiOverlayStyle systemOverlayStyleFor(Color contrastColor) {
  final lightIcons = contrastColor == Colors.white;
  final iconBrightness = lightIcons ? Brightness.light : Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: iconBrightness,
    statusBarBrightness: lightIcons ? .dark : .light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: iconBrightness,
    systemNavigationBarContrastEnforced: false,
  );
}

/// Six uppercase hex digits with no leading `#` (for on-screen display).
String hex(int count) => (count & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

/// `#RRGGBB`, uppercase (for copying and the Info screen).
String hexWithHash(int count) => '#${hex(count)}';

/// The `R, G, B` decimal components of [count].
String rgb(int count) {
  final value = count & 0xFFFFFF;
  return '${(value >> 16) & 0xFF}, ${(value >> 8) & 0xFF}, ${value & 0xFF}';
}
