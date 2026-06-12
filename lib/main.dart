import 'package:flutter/material.dart';

import 'app.dart';
import 'services/color_name_service.dart';
import 'services/settings_repository.dart';
import 'state/taps_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await SettingsRepository.create();
  runApp(
    SixteenMillionTapsApp(
      controller: TapsController(repository),
      colorNames: ColorNameService(),
    ),
  );
}
