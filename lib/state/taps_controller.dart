// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../services/settings_repository.dart';
import '../services/tap_sound_player.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/counter_formatter.dart';

/// The counter text-size presets and their font sizes.
enum CounterTextSize {
  /// The smallest preset.
  extraSmall(18),

  /// A small preset.
  small(24),

  /// The default preset.
  medium(32),

  /// The largest preset.
  large(46);

  const CounterTextSize(this.fontSize);

  /// The counter font size, in logical pixels.
  final double fontSize;
}

/// Holds the tap count and its derived color, the display settings, and the foreground time.
///
/// Persists the count and time when the app leaves the foreground, and each setting as it changes.
class TapsController extends ChangeNotifier with WidgetsBindingObserver {
  /// Loads the saved count, time, and settings from [_store], starts the foreground timer, and
  /// begins observing the app lifecycle.
  TapsController(this._store, {this._soundPlayer = const SilentTapSoundPlayer()}) {
    _count = _store.count.clamp(minCount, maxCount);
    _totalTapSeconds = _store.totalTapSeconds;
    _numeralSystem = _numeralSystemFromRadix(_store.numeralSystemRadix);
    _counterTextSize = _counterTextSizeFromName(_store.counterTextSizeName);
    _showProgressHairline = _store.showProgressHairline ?? false;
    _tapSound = _tapSoundFromName(_store.tapSoundName);
    _soundPlayer.setSound(_tapSound);
    _stopwatch.start();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Persistent storage for the count, time, and settings.
  final SettingsStore _store;

  /// Plays the per-tap sound; silent by default.
  final TapSoundPlayer _soundPlayer;

  /// Times the current foreground session, folded into the total on pause.
  final Stopwatch _stopwatch = Stopwatch();

  /// The current tap count.
  late int _count;

  /// Foreground seconds accumulated in previous sessions.
  late int _totalTapSeconds;

  /// How the count is displayed.
  late NumeralSystem _numeralSystem;

  /// The counter's text-size preset.
  late CounterTextSize _counterTextSize;

  /// Whether the progress hairline shows on the Taps screen.
  late bool _showProgressHairline;

  /// The selected per-tap sound.
  late TapSound _tapSound;

  /// The current tap count.
  int get count => _count;

  /// How the count is displayed.
  NumeralSystem get numeralSystem => _numeralSystem;

  /// The counter's text-size preset.
  CounterTextSize get counterTextSize => _counterTextSize;

  /// The counter font size, in logical pixels.
  double get counterFontSize => _counterTextSize.fontSize;

  /// Whether the progress hairline is shown on the Taps screen.
  bool get showProgressHairline => _showProgressHairline;

  /// The selected per-tap sound.
  TapSound get tapSound => _tapSound;

  /// The fill color for the current count.
  Color get fillColor => color_utils.colorForCount(_count);

  /// Black or white, whichever stays legible on [fillColor].
  Color get contrastColor => color_utils.contrastColor(fillColor);

  /// The count as a fraction of the maximum, 0..1.
  double get progress => _count / maxCount;

  /// How many counts remain until the maximum.
  int get remaining => maxCount - _count;

  /// Percent of the way to the maximum, 0..100.
  double get percentComplete => _count / maxCount * 100;

  /// Whether the count is at 0.
  bool get atStart => _count <= minCount;

  /// Whether the count is at the maximum.
  bool get atEnd => _count >= maxCount;

  /// Total foreground time spent tapping, including the current session.
  Duration get totalTapTime => Duration(seconds: _totalTapSeconds + _stopwatch.elapsed.inSeconds);

  /// Advances the count by one and plays the tap sound, unless already at the maximum.
  void increment() {
    if (atEnd) return;
    _soundPlayer.play();
    _setCount(_count + 1);
  }

  /// Steps the count back by one, unless already at 0.
  void decrement() {
    if (atStart) return;
    _setCount(_count - 1);
  }

  /// Jumps straight to [value] when it is in range; ignores out-of-range values.
  void jumpTo(int value) {
    if (value < minCount || value > maxCount) return;
    _setCount(value);
  }

  /// Starts over: count back to 0 and the accumulated foreground time (including the live session)
  /// back to zero. Display settings are left untouched.
  void reset() {
    _count = minCount;
    _totalTapSeconds = 0;
    _stopwatch.reset();
    notifyListeners();
    _store.setCount(_count);
    _store.setTotalTapSeconds(_totalTapSeconds);
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

  set showProgressHairline(bool value) {
    if (value == _showProgressHairline) return;
    _showProgressHairline = value;
    notifyListeners();
    _store.setShowProgressHairline(value);
  }

  set tapSound(TapSound value) {
    if (value == _tapSound) return;
    _tapSound = value;
    _soundPlayer.setSound(value);
    notifyListeners();
    _store.setTapSoundName(value.name);
  }

  /// Plays the current tap sound once, for previewing a choice in Settings.
  void previewTapSound() => _soundPlayer.play();

  /// Updates the count and notifies listeners.
  void _setCount(int value) {
    _count = value;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == .resumed) {
      _stopwatch.start();
    } else {
      _foldElapsedTime();
      _saveCountAndTime();
    }
  }

  /// Adds the current session's elapsed seconds to the total and resets the stopwatch.
  void _foldElapsedTime() {
    _totalTapSeconds += _stopwatch.elapsed.inSeconds;
    _stopwatch
      ..stop()
      ..reset();
  }

  /// Persists the count and accumulated foreground time.
  Future<void> _saveCountAndTime() async {
    await _store.setCount(_count);
    await _store.setTotalTapSeconds(_totalTapSeconds);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _foldElapsedTime();
    _saveCountAndTime();
    _soundPlayer.dispose();
    super.dispose();
  }
}

/// The numeral system for [radix], or decimal when unknown.
NumeralSystem _numeralSystemFromRadix(int? radix) {
  return .values.firstWhere(
    (system) => system.radix == radix,
    orElse: () => .decimal,
  );
}

/// The text-size preset named [name], or medium when unknown.
CounterTextSize _counterTextSizeFromName(String? name) {
  return .values.firstWhere(
    (size) => size.name == name,
    orElse: () => .medium,
  );
}

/// The tap sound named [name], or none when unknown.
TapSound _tapSoundFromName(String? name) {
  return .values.firstWhere(
    (sound) => sound.name == name,
    orElse: () => .none,
  );
}
