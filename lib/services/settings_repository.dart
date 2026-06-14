// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';

/// Persistent storage for the counter and settings.
///
/// An interface so the controller can be exercised with an in-memory fake in tests.
abstract interface class SettingsStore {
  /// The persisted count.
  int get count;

  /// Persists the count.
  Future<void> setCount(int value);

  /// The persisted foreground seconds.
  int get totalTapSeconds;

  /// Persists the foreground seconds.
  Future<void> setTotalTapSeconds(int value);

  /// The persisted numeral-system radix, or null when unset.
  int? get numeralSystemRadix;

  /// Persists the numeral-system radix.
  Future<void> setNumeralSystemRadix(int radix);

  /// The persisted counter text-size name, or null when unset.
  String? get counterTextSizeName;

  /// Persists the counter text-size name.
  Future<void> setCounterTextSizeName(String name);

  /// The persisted progress-hairline visibility, or null when unset.
  bool? get showProgressHairline;

  /// Persists the progress-hairline visibility.
  Future<void> setShowProgressHairline(bool value);

  /// The persisted tap-sound name, or null when unset.
  String? get tapSoundName;

  /// Persists the tap-sound name.
  Future<void> setTapSoundName(String name);
}

/// A [SettingsStore] backed by shared_preferences via the cached API, so reads are synchronous once
/// [create] has completed.
class SettingsRepository implements SettingsStore {
  SettingsRepository._(this._prefs);

  /// The cached preferences, holding the allow-listed keys in memory.
  final SharedPreferencesWithCache _prefs;

  /// Opens shared_preferences with the app's keys allow-listed, for synchronous reads after.
  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{
          prefCountKey,
          prefNumeralSystemKey,
          prefCounterTextSizeKey,
          prefTotalTapSecondsKey,
          prefShowProgressHairlineKey,
          prefTapSoundKey,
        },
      ),
    );
    return SettingsRepository._(prefs);
  }

  @override
  int get count => _prefs.getInt(prefCountKey) ?? minCount;
  @override
  Future<void> setCount(int value) => _prefs.setInt(prefCountKey, value);

  @override
  int get totalTapSeconds => _prefs.getInt(prefTotalTapSecondsKey) ?? 0;
  @override
  Future<void> setTotalTapSeconds(int value) => _prefs.setInt(prefTotalTapSecondsKey, value);

  @override
  int? get numeralSystemRadix => _prefs.getInt(prefNumeralSystemKey);
  @override
  Future<void> setNumeralSystemRadix(int radix) => _prefs.setInt(prefNumeralSystemKey, radix);

  @override
  String? get counterTextSizeName => _prefs.getString(prefCounterTextSizeKey);
  @override
  Future<void> setCounterTextSizeName(String name) =>
      _prefs.setString(prefCounterTextSizeKey, name);

  @override
  bool? get showProgressHairline => _prefs.getBool(prefShowProgressHairlineKey);
  @override
  Future<void> setShowProgressHairline(bool value) =>
      _prefs.setBool(prefShowProgressHairlineKey, value);

  @override
  String? get tapSoundName => _prefs.getString(prefTapSoundKey);
  @override
  Future<void> setTapSoundName(String name) => _prefs.setString(prefTapSoundKey, name);
}
