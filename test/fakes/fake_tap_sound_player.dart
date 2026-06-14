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
