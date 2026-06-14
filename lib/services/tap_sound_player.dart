import 'package:audioplayers/audioplayers.dart';

/// A selectable per-tap sound. [asset] is the bundled file under `assets/sounds/`, or null for [none] (silent).
enum TapSound {
  none(null),
  ting('ting.ogg'),
  bloop('bloop.ogg'),
  pluck('pluck.ogg'),
  drop('drop.ogg'),
  chime('chime.ogg'),
  block('block.ogg');

  const TapSound(this.asset);

  final String? asset;

  bool get isSilent => asset == null;
}

/// Plays the per-tap sound. An interface so the controller can run silently in tests and where audio is unavailable.
abstract interface class TapSoundPlayer {
  /// Loads [sound] so the next [play] is instant; [TapSound.none] stays silent.
  void setSound(TapSound sound);

  /// Restarts the loaded sound from the start, cutting off any still-playing instance.
  void play();

  void dispose();
}

/// A no-op player. The controller's default, so tests and audio-less contexts make no sound.
class SilentTapSoundPlayer implements TapSoundPlayer {
  const SilentTapSoundPlayer();

  @override
  void setSound(TapSound sound) {}

  @override
  void play() {}

  @override
  void dispose() {}
}

/// A [TapSoundPlayer] backed by a single warm `audioplayers` player, so a fast tap restarts the sound (seek to start) instead of layering overlapping copies.
class AudioplayersTapSoundPlayer implements TapSoundPlayer {
  AudioplayersTapSoundPlayer() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _player = AudioPlayer();
  TapSound _sound = TapSound.none;

  @override
  void setSound(TapSound sound) {
    _sound = sound;
    final asset = sound.asset;
    if (asset == null) {
      _player.stop();
    } else {
      // Preload so the first tap is not delayed by a fetch and decode.
      _player.setSource(AssetSource('sounds/$asset'));
    }
  }

  @override
  void play() {
    if (_sound.isSilent) return;
    _player.seek(Duration.zero);
    _player.resume();
  }

  @override
  void dispose() => _player.dispose();
}
