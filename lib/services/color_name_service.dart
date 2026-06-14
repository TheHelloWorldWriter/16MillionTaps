// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../common/constants.dart';

/// Looks up the human name for a color. Loads the bundled, sparse name list lazily on first use and notifies listeners once it is ready, so names appear without blocking startup.
class ColorNameService extends ChangeNotifier {
  ColorNameService();

  /// Creates a pre-loaded service for tests.
  ColorNameService.withNames(Map<int, String> names) : _names = names;

  Map<int, String>? _names;
  Future<void>? _loading;

  /// Loads the name list once; safe to call repeatedly.
  Future<void> ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    if (_names != null) return;
    final raw = await rootBundle.loadString(colorNamesAsset);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _names = {
      for (final entry in decoded.entries) int.parse(entry.key, radix: 16): entry.value as String,
    };
    notifyListeners();
  }

  /// The name for [rgb], or null if the color has no name or the list is not loaded yet.
  String? nameFor(int rgb) => _names?[rgb & 0xFFFFFF];
}
