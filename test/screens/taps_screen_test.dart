import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixteen_million_taps/common/strings.dart' as strings;
import 'package:sixteen_million_taps/screens/taps_screen.dart';
import 'package:sixteen_million_taps/services/color_name_service.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';

import '../fakes/fake_settings_store.dart';

void main() {
  Future<TapsController> pumpScreen(
    WidgetTester tester,
    FakeSettingsStore store, {
    ColorNameService? colorNames,
  }) async {
    final controller = TapsController(store);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: TapsScreen(
          controller: controller,
          colorNames: colorNames ?? ColorNameService.withNames(const {}),
        ),
      ),
    );
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

  testWidgets('shows the color name when one exists', (tester) async {
    await pumpScreen(
      tester,
      FakeSettingsStore(count: 0x112358),
      colorNames: ColorNameService.withNames({0x112358: 'Fibonacci Blue'}),
    );
    expect(find.text('Fibonacci Blue'), findsOneWidget);
  });

  testWidgets('counter holds its position whether or not the color is named', (tester) async {
    const count = 0x112358;
    const decimal = '1,123,160';

    await pumpScreen(
      tester,
      FakeSettingsStore(count: count),
      colorNames: ColorNameService.withNames({count: 'Fibonacci Blue'}),
    );
    expect(find.text('Fibonacci Blue'), findsOneWidget);
    final namedY = tester.getTopLeft(find.text(decimal)).dy;

    await pumpScreen(
      tester,
      FakeSettingsStore(count: count),
      colorNames: ColorNameService.withNames(const {}),
    );
    expect(find.text('Fibonacci Blue'), findsNothing);
    final unnamedY = tester.getTopLeft(find.text(decimal)).dy;

    expect(namedY, unnamedY);
  });

  testWidgets('Copy color copies the name and hex for a named color', (tester) async {
    await pumpScreen(
      tester,
      FakeSettingsStore(count: 0x112358),
      colorNames: ColorNameService.withNames({0x112358: 'Fibonacci Blue'}),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.copyColorAction));
    await tester.pumpAndSettle();

    expect(find.text(strings.copiedColor('Fibonacci Blue #112358')), findsOneWidget);
  });

  testWidgets('Copy color copies just the hex for an unnamed color', (tester) async {
    await pumpScreen(tester, FakeSettingsStore(count: 0x000001));

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.copyColorAction));
    await tester.pumpAndSettle();

    expect(find.text(strings.copiedColor('#000001')), findsOneWidget);
  });
}
