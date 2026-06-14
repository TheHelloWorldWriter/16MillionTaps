// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'common/constants.dart' as constants;
import 'common/strings.dart' as strings;
import 'screens/info_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/taps_screen.dart';
import 'services/color_name_service.dart';
import 'state/taps_controller.dart';
import 'theme/app_theme.dart';

/// The root widget. Wires the router and the light/dark themes (which follow the system).
class SixteenMillionTapsApp extends StatelessWidget {
  SixteenMillionTapsApp({super.key, required this.controller, required this.colorNames})
    : _router = _buildRouter(controller, colorNames);

  final TapsController controller;
  final ColorNameService colorNames;
  final GoRouter _router;

  static GoRouter _buildRouter(TapsController controller, ColorNameService colorNames) {
    return GoRouter(
      routes: [
        GoRoute(
          path: constants.tapsRoute,
          builder: (context, state) => TapsScreen(controller: controller, colorNames: colorNames),
        ),
        GoRoute(
          path: constants.infoRoute,
          builder: (context, state) => InfoScreen(controller: controller, colorNames: colorNames),
        ),
        GoRoute(
          path: constants.settingsRoute,
          builder: (context, state) => SettingsScreen(controller: controller),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: strings.appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
