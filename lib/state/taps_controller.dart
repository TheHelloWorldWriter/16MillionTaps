import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../services/settings_repository.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/counter_formatter.dart';

/// Holds the tap count and its derived color state, tracks foreground time, and persists both when the app leaves the foreground.
class TapsController extends ChangeNotifier with WidgetsBindingObserver {
  TapsController(this._store) {
    _count = _store.count.clamp(minCount, maxCount);
    _totalTapSeconds = _store.totalTapSeconds;
    _stopwatch.start();
    WidgetsBinding.instance.addObserver(this);
  }

  final SettingsStore _store;
  final Stopwatch _stopwatch = Stopwatch();

  late int _count;
  late int _totalTapSeconds;
  // Always decimal in this phase; the Settings screen makes it mutable later.
  final NumeralSystem _numeralSystem = NumeralSystem.decimal;

  int get count => _count;
  NumeralSystem get numeralSystem => _numeralSystem;

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
      _save();
    }
  }

  void _foldElapsedTime() {
    _totalTapSeconds += _stopwatch.elapsed.inSeconds;
    _stopwatch
      ..stop()
      ..reset();
  }

  Future<void> _save() async {
    await _store.setCount(_count);
    await _store.setTotalTapSeconds(_totalTapSeconds);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _foldElapsedTime();
    _save();
    super.dispose();
  }
}
