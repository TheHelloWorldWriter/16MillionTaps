import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sixteen_million_taps/screens/taps_screen.dart';
import 'package:sixteen_million_taps/services/settings_repository.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';

class FakeSettingsStore implements SettingsStore {
  FakeSettingsStore({this.count = 0, this.totalTapSeconds = 0});

  @override
  int count;
  @override
  int totalTapSeconds;

  @override
  Future<void> setCount(int value) async => count = value;
  @override
  Future<void> setTotalTapSeconds(int value) async => totalTapSeconds = value;
}

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
}
