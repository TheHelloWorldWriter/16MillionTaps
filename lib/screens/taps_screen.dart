// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../common/strings.dart' as strings;
import '../services/color_name_service.dart';
import '../services/share_service.dart';
import '../services/url_launcher.dart';
import '../state/taps_controller.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/counter_formatter.dart';
import '../widgets/counter_display.dart';
import '../widgets/progress_hairline.dart';
import '../widgets/taps_app_bar.dart';

/// The main screen: tap anywhere to advance the count and fill the screen with the matching color.
class TapsScreen extends StatefulWidget {
  /// Creates the Taps screen backed by [controller] and [colorNames].
  const TapsScreen({super.key, required this.controller, required this.colorNames});

  /// Owns the count, color, and settings.
  final TapsController controller;

  /// Resolves the current color's name.
  final ColorNameService colorNames;

  @override
  State<TapsScreen> createState() => _TapsScreenState();
}

/// Triggers the name-list load and the first-run hint after the first frame.
class _TapsScreenState extends State<TapsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.colorNames.ensureLoaded();
      if (widget.controller.count == minCount) _showMessage(strings.firstTapHint);
    });
  }

  /// Shows [message] as a snackbar, replacing any current one.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Advances the count, or shows the end message once at the maximum.
  void _onTap() {
    if (widget.controller.atEnd) {
      _showMessage(strings.theEnd);
      return;
    }
    widget.controller.increment();
  }

  /// Steps the count back, or shows the no-going-back message at 0.
  void _onStepBack() {
    if (widget.controller.atStart) {
      _showMessage(strings.noGoingBack);
      return;
    }
    widget.controller.decrement();
  }

  /// Opens the Info screen.
  void _onInfo() => context.push(infoRoute);

  /// Copies the current color to the clipboard - the name and hex when named, else the hex.
  void _copyColor() {
    final count = widget.controller.count;
    final hex = color_utils.hexWithHash(count);
    final name = widget.colorNames.nameFor(count);
    final text = name == null ? hex : '$name $hex';
    Clipboard.setData(ClipboardData(text: text));
    _showMessage(strings.copiedColor(text));
  }

  /// Renders the current color and opens the platform share sheet.
  void _shareJourney() {
    final controller = widget.controller;
    final count = controller.count;
    final countText = formatCount(
      count,
      controller.numeralSystem,
      formatDecimal: MaterialLocalizations.of(context).formatDecimal,
    );
    shareJourney(
      context,
      count: count,
      countText: countText,
      fill: controller.fillColor,
      contrast: controller.contrastColor,
      colorName: widget.colorNames.nameFor(count),
    );
  }

  /// Routes an overflow-menu action to its handler.
  void _onMenuAction(TapsMenuAction action) {
    switch (action) {
      case TapsMenuAction.copyColor:
        _copyColor();
      case TapsMenuAction.share:
        _shareJourney();
      case TapsMenuAction.settings:
        context.push(settingsRoute);
      case TapsMenuAction.rate:
        openExternalUrl(context, rateUrl);
      case TapsMenuAction.help:
        openExternalUrl(context, helpUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller, widget.colorNames]),
      builder: (context, _) {
        final controller = widget.controller;
        final formatDecimal = MaterialLocalizations.of(context).formatDecimal;
        return Scaffold(
          backgroundColor: controller.fillColor,
          appBar: TapsAppBar(
            backgroundColor: controller.fillColor,
            foregroundColor: controller.contrastColor,
            onStepBack: _onStepBack,
            onInfo: _onInfo,
            onMenuAction: _onMenuAction,
          ),
          body: Semantics(
            button: true,
            label: strings.tapToCountSemantic,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onTap,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // The optional progress hairline, when enabled in Settings.
                    if (controller.showProgressHairline)
                      ProgressHairline(
                        progress: controller.progress,
                        color: controller.contrastColor,
                      ),
                    // The counter and color name, centered in the remaining space.
                    Expanded(
                      child: Center(
                        child: CounterDisplay(
                          count: controller.count,
                          numeralSystem: controller.numeralSystem,
                          fontSize: controller.counterFontSize,
                          color: controller.contrastColor,
                          formatDecimal: formatDecimal,
                          colorName: widget.colorNames.nameFor(controller.count),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
