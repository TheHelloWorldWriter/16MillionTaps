// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../utils/color_utils.dart' as color_utils;

/// The overflow-menu actions on the tap screen's app bar.
enum TapsMenuAction { settings, copyColor, share, rate, help }

/// The tap screen's color-matched app bar: visible step-back and info buttons plus an overflow menu.
class TapsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TapsAppBar({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onStepBack,
    required this.onInfo,
    required this.onMenuAction,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onStepBack;
  final VoidCallback onInfo;
  final void Function(TapsMenuAction action) onMenuAction;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: color_utils.systemOverlayStyleFor(foregroundColor),
      actions: [
        IconButton(
          icon: const Icon(Icons.undo),
          tooltip: strings.goBackAction,
          onPressed: onStepBack,
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: strings.infoAction,
          onPressed: onInfo,
        ),
        PopupMenuButton<TapsMenuAction>(
          onSelected: onMenuAction,
          itemBuilder: (context) => const <PopupMenuEntry<TapsMenuAction>>[
            PopupMenuItem<TapsMenuAction>(
              value: TapsMenuAction.settings,
              child: Text(strings.settingsAction),
            ),
            PopupMenuItem<TapsMenuAction>(
              value: TapsMenuAction.copyColor,
              child: Text(strings.copyColorAction),
            ),
            PopupMenuItem<TapsMenuAction>(
              value: TapsMenuAction.share,
              child: Text(strings.shareJourneyAction),
            ),
            PopupMenuItem<TapsMenuAction>(
              value: TapsMenuAction.rate,
              child: Text(strings.rateAction),
            ),
            PopupMenuItem<TapsMenuAction>(
              value: TapsMenuAction.help,
              child: Text(strings.helpAction),
            ),
          ],
        ),
      ],
    );
  }
}
