import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixteen_million_taps/common/strings.dart' as strings;
import 'package:sixteen_million_taps/screens/settings_screen.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';
import 'package:sixteen_million_taps/utils/counter_formatter.dart';

import '../fakes/fake_settings_store.dart';

void main() {
  Future<TapsController> pumpSettings(WidgetTester tester, FakeSettingsStore store) async {
    final controller = TapsController(store);
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(controller: controller)));
    return controller;
  }

  testWidgets('changing the numeral system updates the controller and subtitle', (tester) async {
    final controller = await pumpSettings(tester, FakeSettingsStore());
    expect(controller.numeralSystem, NumeralSystem.decimal);

    await tester.tap(find.text(strings.numeralSystemTitle));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.numeralBinaryLabel).last);
    await tester.pumpAndSettle();

    expect(controller.numeralSystem, NumeralSystem.binary);
    expect(
      find.text(strings.numeralSystemSummary(strings.numeralBinaryLabel)),
      findsOneWidget,
    );
  });

  testWidgets('changing the counter text size updates the controller', (tester) async {
    final controller = await pumpSettings(tester, FakeSettingsStore());
    final before = controller.counterTextSize;

    await tester.tap(find.text(strings.counterTextSizeTitle));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.textSizeLargeLabel).last);
    await tester.pumpAndSettle();

    expect(controller.counterTextSize, CounterTextSize.large);
    expect(controller.counterTextSize, isNot(before));
  });

  testWidgets('jump-to-number rejects out-of-range input and keeps the count', (tester) async {
    final controller = await pumpSettings(tester, FakeSettingsStore(count: 100));

    await tester.tap(find.text(strings.cheatModeTitle));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '99999999');
    await tester.tap(find.text('OK'));
    await tester.pump();

    expect(find.text(strings.cheatModeBadNumber), findsOneWidget);
    expect(controller.count, 100);
  });

  testWidgets('jump-to-number accepts a valid number and updates the count', (tester) async {
    final controller = await pumpSettings(tester, FakeSettingsStore(count: 100));

    await tester.tap(find.text(strings.cheatModeTitle));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '500');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(controller.count, 500);
  });
}
