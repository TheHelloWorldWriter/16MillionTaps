// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:sixteen_million_taps/app.dart';
import 'package:sixteen_million_taps/screens/taps_screen.dart';
import 'package:sixteen_million_taps/services/color_name_service.dart';
import 'package:sixteen_million_taps/services/settings_repository.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';
import 'package:sixteen_million_taps/utils/color_utils.dart' as color_utils;

/// End-to-end check of the core loop on a real device: tapping advances the count and repaints the
/// fill, and the count survives a restart through the real persistence layer.
///
/// Uses the real [SettingsRepository] (shared_preferences), not the in-memory fake, so the genuine
/// save-and-restore path is exercised - which is the point of putting this in integration_test. The
/// first run sets its own baseline with [TapsController.jumpTo], so the assertions do not depend on
/// whatever count storage already holds. Counts stay under 1000 so the on-screen decimal text
/// carries no locale-dependent grouping.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget app(TapsController controller) => SixteenMillionTapsApp(
    controller: controller,
    colorNames: ColorNameService.withNames(const {}),
  );

  testWidgets('tapping advances the color and the count resumes after a restart', (tester) async {
    const baseline = 100;
    const taps = 3;
    const resumed = baseline + taps;

    final firstRun = await SettingsRepository.create();
    final firstController = TapsController(firstRun)..jumpTo(baseline);
    addTearDown(firstController.dispose);

    await tester.pumpWidget(app(firstController));
    await tester.pumpAndSettle();

    expect(find.text('$baseline'), findsOneWidget);
    final baselineColor = firstController.fillColor;

    for (var i = 0; i < taps; i++) {
      await tester.tap(find.byType(TapsScreen));
      await tester.pump();
    }

    expect(firstController.count, resumed);
    expect(firstController.fillColor, isNot(baselineColor));
    expect(find.text('$resumed'), findsOneWidget);

    // Persist as if the app went to the background: the controller saves on the paused lifecycle
    // event. Resume immediately and never pump while paused - the live integration binding produces
    // no frames in the paused state, so pumpAndSettle would loop until its 10-minute timeout
    // (flutter/flutter#73355).
    tester.binding.handleAppLifecycleStateChanged(.paused);
    tester.binding.handleAppLifecycleStateChanged(.resumed);
    // Let the fire-and-forget write reach the real store before reopening.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 300)));

    // Reopen: a fresh repository and controller must read the count back from storage.
    final secondRun = await SettingsRepository.create();
    final secondController = TapsController(secondRun);
    addTearDown(secondController.dispose);

    expect(secondController.count, resumed);

    await tester.pumpWidget(app(secondController));
    await tester.pumpAndSettle();

    expect(find.text('$resumed'), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, color_utils.colorForCount(resumed));
  });
}
