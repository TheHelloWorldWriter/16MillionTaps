// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter_soloud/flutter_soloud.dart';

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

  /// Plays the loaded sound. Fast taps mix as overlapping voices rather than cutting each other off.
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

/// A [TapSoundPlayer] backed by the SoLoud engine. Each tap plays a fresh, low-latency voice that mixes with any still-sounding ones, so rapid taps stay in rhythm without the crackle or drop-outs of restarting a single clip player.
class SoloudTapSoundPlayer implements TapSoundPlayer {
  final SoLoud _soloud = SoLoud.instance;

  TapSound _sound = TapSound.none;
  AudioSource? _source;

  // Loading is async and lazily starts the engine, so [_generation] discards a
  // slow load once the selection has moved on, and [_playWhenReady] lets a
  // preview fire as soon as the sound is ready.
  int _generation = 0;
  bool _playWhenReady = false;

  @override
  void setSound(TapSound sound) {
    if (sound == _sound) return;
    _sound = sound;
    _playWhenReady = false;
    final generation = ++_generation;
    _disposeSource();
    final asset = sound.asset;
    if (asset != null) {
      _loadSource('assets/sounds/$asset', generation);
    }
  }

  Future<void> _loadSource(String assetKey, int generation) async {
    try {
      if (!_soloud.isInitialized) {
        await _soloud.init();
      }
      if (generation != _generation) return;
      final source = await _soloud.loadAsset(assetKey);
      if (generation != _generation) {
        await _soloud.disposeSource(source);
        return;
      }
      _source = source;
      if (_playWhenReady) {
        _playWhenReady = false;
        _soloud.play(source);
      }
    } catch (_) {
      // Audio is a non-critical enhancement; on failure, stay silent.
    }
  }

  @override
  void play() {
    final source = _source;
    if (source != null) {
      _soloud.play(source);
    } else if (!_sound.isSilent) {
      // Still loading (e.g. a preview right after a pick); fire once ready.
      _playWhenReady = true;
    }
  }

  @override
  void dispose() {
    _generation++;
    _source = null;
    if (_soloud.isInitialized) {
      _soloud.deinit();
    }
  }

  void _disposeSource() {
    final source = _source;
    if (source != null) {
      _soloud.disposeSource(source);
      _source = null;
    }
  }
}
