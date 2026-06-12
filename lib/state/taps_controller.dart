import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../services/settings_repository.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/counter_formatter.dart';

/// The counter text-size presets and their font sizes.
enum CounterTextSize {
  extraSmall(18),
  small(24),
  medium(32),
  large(46);

  const CounterTextSize(this.fontSize);

  final double fontSize;
}

/// Holds the tap count and its derived color, the display settings, and the foreground time. Persists the count and time when the app leaves the foreground, and each setting as it changes.
class TapsController extends ChangeNotifier with WidgetsBindingObserver {
  TapsController(this._store) {
    _count = _store.count.clamp(minCount, maxCount);
    _totalTapSeconds = _store.totalTapSeconds;
    _numeralSystem = _numeralSystemFromRadix(_store.numeralSystemRadix);
    _counterTextSize = _counterTextSizeFromName(_store.counterTextSizeName);
    _stopwatch.start();
    WidgetsBinding.instance.addObserver(this);
  }

  final SettingsStore _store;
  final Stopwatch _stopwatch = Stopwatch();

  late int _count;
  late int _totalTapSeconds;
  late NumeralSystem _numeralSystem;
  late CounterTextSize _counterTextSize;

  int get count => _count;
  NumeralSystem get numeralSystem => _numeralSystem;
  CounterTextSize get counterTextSize => _counterTextSize;
  double get counterFontSize => _counterTextSize.fontSize;

  Color get fillColor => color_utils.colorForCount(_count);
  Color get contrastColor => color_utils.contrastColor(fillColor);

  double get progress => _count / maxCount;
  int get remaining => maxCount - _count;
  double get percentComplete => _count / maxCount * 100;

  bool get atStart => _count <= minCount;
  bool get atEnd => _count >= maxCount;

  /// Total foreground time spent tapping, including the current session.
  Duration get totalTapTime => Duration(seconds: _totalTapSeconds + _stopwatch.elapsed.inSeconds);

  void increment() {
    if (atEnd) return;
    _setCount(_count + 1);
  }

  void decrement() {
    if (atStart) return;
    _setCount(_count - 1);
  }

  void jumpTo(int value) {
    if (value < minCount || value > maxCount) return;
    _setCount(value);
  }

  set numeralSystem(NumeralSystem value) {
    if (value == _numeralSystem) return;
    _numeralSystem = value;
    notifyListeners();
    _store.setNumeralSystemRadix(value.radix);
  }

  set counterTextSize(CounterTextSize value) {
    if (value == _counterTextSize) return;
    _counterTextSize = value;
    notifyListeners();
    _store.setCounterTextSizeName(value.name);
  }

  void _setCount(int value) {
    _count = value;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _stopwatch.start();
    } else {
      _foldElapsedTime();
      _saveCountAndTime();
    }
  }

  void _foldElapsedTime() {
    _totalTapSeconds += _stopwatch.elapsed.inSeconds;
    _stopwatch
      ..stop()
      ..reset();
  }

  Future<void> _saveCountAndTime() async {
    await _store.setCount(_count);
    await _store.setTotalTapSeconds(_totalTapSeconds);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _foldElapsedTime();
    _saveCountAndTime();
    super.dispose();
  }
}

NumeralSystem _numeralSystemFromRadix(int? radix) {
  return NumeralSystem.values.firstWhere(
    (system) => system.radix == radix,
    orElse: () => NumeralSystem.decimal,
  );
}

CounterTextSize _counterTextSizeFromName(String? name) {
  return CounterTextSize.values.firstWhere(
    (size) => size.name == name,
    orElse: () => CounterTextSize.medium,
  );
}
