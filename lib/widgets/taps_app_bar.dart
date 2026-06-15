// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../utils/color_utils.dart' as color_utils;

/// The overflow-menu actions on the tap screen's app bar.
enum TapsMenuAction { copyColor, share, settings, rate, help }

/// The tap screen's color-matched app bar: visible step-back and info icons plus an overflow menu.
class TapsAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the app bar tinted with [backgroundColor]/[foregroundColor] and wired to the given
  /// action callbacks.
  const TapsAppBar({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onStepBack,
    required this.onInfo,
    required this.onMenuAction,
  });

  /// The current fill color, used as the bar background.
  final Color backgroundColor;

  /// The contrast color for the bar's icons and text.
  final Color foregroundColor;

  /// Called when the step-back action is tapped.
  final VoidCallback onStepBack;

  /// Called when the info action is tapped.
  final VoidCallback onInfo;

  /// Called with the chosen overflow-menu action.
  final void Function(TapsMenuAction action) onMenuAction;

  @override
  Size get preferredSize => const .fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: color_utils.systemOverlayStyleFor(foregroundColor),
      actions: [
        // The step-back action (always visible, but guarded at 0)
        IconButton(
          icon: const Icon(Icons.undo),
          tooltip: strings.goBackAction,
          onPressed: onStepBack,
        ),

        // The info action (always visible)
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: strings.infoAction,
          onPressed: onInfo,
        ),

        PopupMenuButton<TapsMenuAction>(
          onSelected: onMenuAction,
          itemBuilder: (context) => const <PopupMenuEntry<TapsMenuAction>>[
            // The copy color menu item
            PopupMenuItem<TapsMenuAction>(
              value: .copyColor,
              child: Text(strings.copyColorAction),
            ),

            // The share journey menu item
            PopupMenuItem<TapsMenuAction>(
              value: .share,
              child: Text(strings.shareJourneyAction),
            ),

            PopupMenuDivider(),

            // The settings menu item
            PopupMenuItem<TapsMenuAction>(
              value: .settings,
              child: Text(strings.settingsAction),
            ),

            // The rate app menu item
            PopupMenuItem<TapsMenuAction>(
              value: .rate,
              child: Text(strings.rateAction),
            ),

            // The help menu item
            PopupMenuItem<TapsMenuAction>(
              value: .help,
              child: Text(strings.helpAction),
            ),
          ],
        ),
      ],
    );
  }
}
