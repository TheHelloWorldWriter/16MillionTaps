// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter_test/flutter_test.dart';

import 'package:sixteen_million_taps/services/tap_sound_player.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';
import 'package:sixteen_million_taps/utils/counter_formatter.dart';

import '../fakes/fake_settings_store.dart';
import '../fakes/fake_tap_sound_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads the saved numeral system', () {
    final controller = TapsController(FakeSettingsStore(numeralSystemRadix: 16));
    addTearDown(controller.dispose);
    expect(controller.numeralSystem, NumeralSystem.hexadecimal);
  });

  test('changing the numeral system persists its radix', () {
    final store = FakeSettingsStore();
    final controller = TapsController(store);
    addTearDown(controller.dispose);

    controller.numeralSystem = .binary;

    expect(controller.numeralSystem, NumeralSystem.binary);
    expect(store.numeralSystemRadix, 2);
  });

  test('changing the text size persists its name', () {
    final store = FakeSettingsStore();
    final controller = TapsController(store);
    addTearDown(controller.dispose);

    controller.counterTextSize = .large;

    expect(store.counterTextSizeName, 'large');
  });

  test('rejects an out-of-range jump and accepts a valid one', () {
    final controller = TapsController(FakeSettingsStore(count: 10));
    addTearDown(controller.dispose);

    controller.jumpTo(-1);
    expect(controller.count, 10);

    controller.jumpTo(1000);
    expect(controller.count, 1000);
  });

  test('defaults the progress hairline off', () {
    final controller = TapsController(FakeSettingsStore());
    addTearDown(controller.dispose);
    expect(controller.showProgressHairline, isFalse);
  });

  test('loads the saved progress-hairline preference', () {
    final controller = TapsController(FakeSettingsStore(showProgressHairline: true));
    addTearDown(controller.dispose);
    expect(controller.showProgressHairline, isTrue);
  });

  test('toggling the progress hairline persists it', () {
    final store = FakeSettingsStore();
    final controller = TapsController(store);
    addTearDown(controller.dispose);

    controller.showProgressHairline = true;

    expect(controller.showProgressHairline, isTrue);
    expect(store.showProgressHairline, isTrue);
  });

  test('reset returns the count and time to zero and persists', () {
    final store = FakeSettingsStore(count: 1000, totalTapSeconds: 4000);
    final controller = TapsController(store);
    addTearDown(controller.dispose);

    controller.reset();

    expect(controller.count, 0);
    expect(controller.totalTapTime, Duration.zero);
    expect(store.count, 0);
    expect(store.totalTapSeconds, 0);
  });

  test('defaults the tap sound to none', () {
    final controller = TapsController(FakeSettingsStore());
    addTearDown(controller.dispose);
    expect(controller.tapSound, TapSound.none);
  });

  test('plays the tap sound on increment when one is selected', () {
    final player = FakeTapSoundPlayer();
    final controller = TapsController(
      FakeSettingsStore(tapSoundName: 'ting'),
      soundPlayer: player,
    );
    addTearDown(controller.dispose);

    expect(controller.tapSound, TapSound.ting);
    controller.increment();
    expect(player.playCount, 1);
  });

  test('changing the tap sound loads it and persists', () {
    final store = FakeSettingsStore();
    final player = FakeTapSoundPlayer();
    final controller = TapsController(store, soundPlayer: player);
    addTearDown(controller.dispose);

    controller.tapSound = .chime;

    expect(controller.tapSound, TapSound.chime);
    expect(player.lastSound, TapSound.chime);
    expect(store.tapSoundName, 'chime');
  });
}
