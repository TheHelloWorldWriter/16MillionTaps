import 'package:flutter_test/flutter_test.dart';
import 'package:sixteen_million_taps/state/taps_controller.dart';
import 'package:sixteen_million_taps/utils/counter_formatter.dart';

import '../fakes/fake_settings_store.dart';

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

    controller.numeralSystem = NumeralSystem.binary;

    expect(controller.numeralSystem, NumeralSystem.binary);
    expect(store.numeralSystemRadix, 2);
  });

  test('changing the text size persists its name', () {
    final store = FakeSettingsStore();
    final controller = TapsController(store);
    addTearDown(controller.dispose);

    controller.counterTextSize = CounterTextSize.large;

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
}
