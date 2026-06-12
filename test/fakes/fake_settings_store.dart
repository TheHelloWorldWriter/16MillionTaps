import 'package:sixteen_million_taps/services/settings_repository.dart';

/// An in-memory [SettingsStore] for tests.
class FakeSettingsStore implements SettingsStore {
  FakeSettingsStore({
    this.count = 0,
    this.totalTapSeconds = 0,
    this.numeralSystemRadix,
    this.counterTextSizeName,
  });

  @override
  int count;
  @override
  int totalTapSeconds;
  @override
  int? numeralSystemRadix;
  @override
  String? counterTextSizeName;

  @override
  Future<void> setCount(int value) async => count = value;
  @override
  Future<void> setTotalTapSeconds(int value) async => totalTapSeconds = value;
  @override
  Future<void> setNumeralSystemRadix(int radix) async => numeralSystemRadix = radix;
  @override
  Future<void> setCounterTextSizeName(String name) async => counterTextSizeName = name;
}
