import 'package:flutter/material.dart';

/// Seed for the neutral surfaces (overflow menu, Settings, dialogs) - a nod to "255 is blue", the app's signature hue. The tap and Info screens are color-filled and ignore this.
const Color _seedColor = Color(0xFF0000EE);

/// Page transitions that paint no background behind the animating route. The platform defaults paint `ColorScheme.surface` there, which flashes at the screen edges during the transition between the color-filled Taps and Info screens; a transparent background lets the matching fill show through instead.
///
/// Every platform uses the same transparent zoom. iOS and macOS are out of scope for the first release, so they get the zoom rather than Cupertino - which keeps this Material file free of a `package:flutter/cupertino.dart` import as Material and Cupertino split into separate packages. To target iOS or macOS natively, add that import and map them to `CupertinoPageTransitionsBuilder()` for the native edge-swipe-back transition.
final PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
    TargetPlatform.values,
    value: (dynamic _) => ZoomPageTransitionsBuilder(backgroundColor: Colors.transparent),
  ),
);

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light),
  pageTransitionsTheme: _pageTransitionsTheme,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark),
  pageTransitionsTheme: _pageTransitionsTheme,
);
