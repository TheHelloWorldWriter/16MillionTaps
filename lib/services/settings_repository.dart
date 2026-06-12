import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants.dart';

/// Persistent storage for the counter and settings. An interface so the controller can be exercised with an in-memory fake in tests.
abstract interface class SettingsStore {
  int get count;
  Future<void> setCount(int value);

  int get totalTapSeconds;
  Future<void> setTotalTapSeconds(int value);
}

/// A [SettingsStore] backed by shared_preferences via the cached API, so reads are synchronous once [create] has completed.
class SettingsRepository implements SettingsStore {
  SettingsRepository._(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static Future<SettingsRepository> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{
          prefCountKey,
          prefNumeralSystemKey,
          prefCounterTextSizeKey,
          prefFullBrightnessKey,
          prefTotalTapSecondsKey,
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
}
