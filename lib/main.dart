import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'services/color_name_service.dart';
import 'services/settings_repository.dart';
import 'services/tap_sound_player.dart';
import 'state/taps_controller.dart';

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
