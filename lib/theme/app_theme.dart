import 'package:flutter/material.dart';

/// Seed for the neutral surfaces (overflow menu, Settings, dialogs) - a nod to "255 is blue", the app's signature hue. The tap and Info screens are color-filled and ignore this.
const Color _seedColor = Color(0xFF0000EE);

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.light),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark),
);
