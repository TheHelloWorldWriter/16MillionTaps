// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/color_name_service.dart';
import 'services/settings_repository.dart';
import 'services/tap_sound_player.dart';
import 'state/taps_controller.dart';

/// App entry point: configures web URLs and the system UI, loads settings, then runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clean web URLs without a leading '#'; a no-op on other platforms.
  usePathUrlStrategy();
  // Draw the color behind the system bars so they match the fill (Android).
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final repository = await SettingsRepository.create();
  runApp(
    SixteenMillionTapsApp(
      controller: TapsController(repository, soundPlayer: SoloudTapSoundPlayer()),
      colorNames: ColorNameService(),
    ),
  );
}
