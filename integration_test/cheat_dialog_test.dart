// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:sixteen_million_taps/app.dart';
import 'package:sixteen_million_taps/common/strings.dart' as strings;
import 'package:sixteen_million_taps/services/color_name_service.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';

import '../test/fakes/fake_settings_store.dart';

/// End-to-end guard for the jump-to-number ("cheat") dialog: dismissing it while
/// the soft keyboard is still up must not crash. The original code disposed the
/// dialog's text controller during the route's exit animation, which threw a
/// framework assertion - reliably so with the keyboard open. Runs on a device so
/// the real platform keyboard takes part, which a widget test cannot reproduce.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Drives the real app to the open cheat dialog. The dialog's TextField
  // autofocuses, so once the test's fake text input is unregistered the real
  // platform keyboard rises - matching the reported repro on dismiss.
  Future<TapsController> openCheatDialogWithKeyboard(WidgetTester tester) async {
    final controller = TapsController(FakeSettingsStore(count: 100));
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      SixteenMillionTapsApp(
        controller: controller,
        colorNames: ColorNameService.withNames(const {}),
      ),
    );
    await tester.pumpAndSettle();

    tester.testTextInput.unregister();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.settingsAction).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.cheatModeTitle));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    return controller;
  }

  testWidgets('confirming with the keyboard open dismisses without crashing', (tester) async {
    final controller = await openCheatDialogWithKeyboard(tester);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AlertDialog), findsNothing);
    expect(controller.count, 100);
  });

  testWidgets('cancelling with the keyboard open dismisses without crashing', (tester) async {
    final controller = await openCheatDialogWithKeyboard(tester);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AlertDialog), findsNothing);
    expect(controller.count, 100);
  });
}
