import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'common/constants.dart' as constants;
import 'common/strings.dart' as strings;
import 'screens/taps_screen.dart';
import 'state/taps_controller.dart';
import 'theme/app_theme.dart';

/// The root widget. Wires the router and the light/dark themes (which follow the system).
class SixteenMillionTapsApp extends StatelessWidget {
  SixteenMillionTapsApp({super.key, required this.controller}) : _router = _buildRouter(controller);

  final TapsController controller;
  final GoRouter _router;

  static GoRouter _buildRouter(TapsController controller) {
    return GoRouter(
      routes: [
        GoRoute(
          path: constants.tapsRoute,
          builder: (context, state) => TapsScreen(controller: controller),
        ),
        // The /info and /settings routes are added with their screens in later phases.
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
