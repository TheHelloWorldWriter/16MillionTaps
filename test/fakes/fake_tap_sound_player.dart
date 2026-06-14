// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:sixteen_million_taps/services/tap_sound_player.dart';

/// A [TapSoundPlayer] that records calls instead of making sound.
class FakeTapSoundPlayer implements TapSoundPlayer {
  TapSound? lastSound;
  int playCount = 0;
  bool disposed = false;

  @override
  void setSound(TapSound sound) => lastSound = sound;

  @override
  void play() => playCount++;

  @override
  void dispose() => disposed = true;
}
