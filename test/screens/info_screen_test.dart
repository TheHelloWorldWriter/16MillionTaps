// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sixteen_million_taps/common/strings.dart' as strings;
import 'package:sixteen_million_taps/screens/info_screen.dart';
import 'package:sixteen_million_taps/services/color_name_service.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';

import '../fakes/fake_settings_store.dart';

void main() {
  Future<void> pumpInfo(WidgetTester tester, int count, ColorNameService colorNames) async {
    final controller = TapsController(FakeSettingsStore(count: count));
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: InfoScreen(controller: controller, colorNames: colorNames),
      ),
    );
  }

  testWidgets('shows the name, hex, RGB, and count for a named color', (tester) async {
    await pumpInfo(tester, 0x112358, ColorNameService.withNames({0x112358: 'Fibonacci Blue'}));

    expect(find.text('Fibonacci Blue'), findsOneWidget);
    expect(find.text('#112358'), findsOneWidget);
    expect(find.text('17, 35, 88'), findsOneWidget);
    expect(find.text('1,123,160'), findsOneWidget);
  });

  testWidgets('shows "No name" for an unnamed color', (tester) async {
    await pumpInfo(tester, 0x000001, ColorNameService.withNames(const {}));

    expect(find.text('No name'), findsOneWidget);
  });

  testWidgets('groups the rows under Journey and Color section headers', (tester) async {
    await pumpInfo(tester, 0x112358, ColorNameService.withNames(const {}));

    expect(find.text(strings.infoJourneySection.toUpperCase()), findsOneWidget);
    expect(find.text(strings.infoColorSection.toUpperCase()), findsOneWidget);
  });

  testWidgets('copying a value confirms with a snackbar', (tester) async {
    await pumpInfo(tester, 0x112358, ColorNameService.withNames(const {}));

    await tester.tap(find.byIcon(Icons.copy).first);
    await tester.pump();

    expect(find.textContaining('copied to clipboard'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });
}
