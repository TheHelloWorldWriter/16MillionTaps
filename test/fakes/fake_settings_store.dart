// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:sixteen_million_taps/services/settings_repository.dart';

/// An in-memory [SettingsStore] for tests.
class FakeSettingsStore implements SettingsStore {
  FakeSettingsStore({
    this.count = 0,
    this.totalTapSeconds = 0,
    this.numeralSystemRadix,
    this.counterTextSizeName,
    this.showProgressHairline,
    this.tapSoundName,
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
  bool? showProgressHairline;
  @override
  String? tapSoundName;

  @override
  Future<void> setCount(int value) async => count = value;
  @override
  Future<void> setTotalTapSeconds(int value) async => totalTapSeconds = value;
  @override
  Future<void> setNumeralSystemRadix(int radix) async => numeralSystemRadix = radix;
  @override
  Future<void> setCounterTextSizeName(String name) async => counterTextSizeName = name;
  @override
  Future<void> setShowProgressHairline(bool value) async => showProgressHairline = value;
  @override
  Future<void> setTapSoundName(String name) async => tapSoundName = name;
}
