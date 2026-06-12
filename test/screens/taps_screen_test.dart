import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixteen_million_taps/screens/taps_screen.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';

import '../fakes/fake_settings_store.dart';

void main() {
  Future<TapsController> pumpScreen(WidgetTester tester, FakeSettingsStore store) async {
    final controller = TapsController(store);
    addTearDown(controller.dispose);
    await tester.pumpWidget(MaterialApp(home: TapsScreen(controller: controller)));
    return controller;
  }

  testWidgets('tap increments the count and changes the fill color', (tester) async {
    final controller = await pumpScreen(tester, FakeSettingsStore(count: 41));

    expect(find.text('41'), findsOneWidget);
    final before = controller.fillColor;

    await tester.tap(find.byType(TapsScreen));
    await tester.pump();

    expect(find.text('42'), findsOneWidget);
    expect(controller.count, 42);
    expect(controller.fillColor, isNot(before));
  });

  testWidgets('resumes from the saved count, grouped in decimal', (tester) async {
    await pumpScreen(tester, FakeSettingsStore(count: 1000));
    expect(find.text('1,000'), findsOneWidget);
  });

  testWidgets('shows the count in the saved numeral system', (tester) async {
    await pumpScreen(tester, FakeSettingsStore(count: 255, numeralSystemRadix: 16));
    expect(find.text('0000FF'), findsOneWidget);
  });
}
