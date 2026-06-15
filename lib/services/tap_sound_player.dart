// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter_soloud/flutter_soloud.dart';

/// A selectable per-tap sound. [asset] is the bundled file under `assets/sounds/`, or null for
/// [none] (silent).
enum TapSound {
  /// No sound; the default.
  none(null),

  /// A bright "ting".
  ting('ting.ogg'),

  /// A soft "bloop".
  bloop('bloop.ogg'),

  /// A plucked note.
  pluck('pluck.ogg'),

  /// A short "drop".
  drop('drop.ogg'),

  /// A gentle chime.
  chime('chime.ogg'),

  /// A wooden "block".
  block('block.ogg');

  const TapSound(this.asset);

  /// The bundled file under `assets/sounds/`, or null for [none].
  final String? asset;

  /// Whether this sound plays nothing.
  bool get isSilent => asset == null;
}

/// Plays the per-tap sound.
///
/// An interface so the controller can run silently in tests and where audio is unavailable.
abstract interface class TapSoundPlayer {
  /// Loads [sound] so the next [play] is instant; [TapSound.none] stays silent.
  void setSound(TapSound sound);

  /// Plays the loaded sound. Fast taps mix as overlapping voices instead of cutting each other off.
  void play();

  /// Releases the audio engine and any loaded sound.
  void dispose();
}

/// A no-op player. The controller's default, so tests and audio-less contexts make no sound.
class SilentTapSoundPlayer implements TapSoundPlayer {
  /// Creates the silent player.
  const SilentTapSoundPlayer();

  @override
  void setSound(TapSound sound) {}

  @override
  void play() {}

  @override
  void dispose() {}
}

/// A [TapSoundPlayer] backed by the SoLoud engine.
///
/// Each tap plays a fresh, low-latency voice that mixes with any still-sounding ones, so rapid taps
/// stay in rhythm without the crackle or drop-outs of restarting a single clip player.
class SoloudTapSoundPlayer implements TapSoundPlayer {
  /// The shared SoLoud engine instance.
  final SoLoud _soloud = SoLoud.instance;

  /// The currently selected sound.
  TapSound _sound = .none;

  /// The loaded source for [_sound], once ready.
  AudioSource? _source;

  /// Bumped on each [setSound] so a slow async load can tell it is stale and bail.
  int _generation = 0;

  /// Set when [play] is called before the source has finished loading (e.g. a preview).
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

  /// Lazily starts the engine and loads [assetKey], discarding the result if a newer selection
  /// arrived in the meantime.
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

  /// Frees the current source, if any.
  void _disposeSource() {
    final source = _source;
    if (source != null) {
      _soloud.disposeSource(source);
      _source = null;
    }
  }
}
