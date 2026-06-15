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

/// Triggers the color-name list load after the first frame.
class _TapsScreenState extends State<TapsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.colorNames.ensureLoaded();
    });
  }

  /// Shows [message] as a snackbar, replacing any current one.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Advances the count; a no-op at the maximum, where the closing line stays shown.
  void _onTap() => widget.controller.increment();

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
        // A quiet fixed note at each end of the journey; nothing in between.
        final endpointMessage = controller.atStart
            ? strings.firstTapHint
            : controller.atEnd
            ? strings.theEnd
            : null;
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
                child: Stack(
                  children: [
                    // Base layout: optional hairline above the centered counter. Unchanged through
                    // the middle of the journey - the bottom note below only exists at the two ends.
                    Column(
                      children: [
                        if (controller.showProgressHairline)
                          ProgressHairline(
                            progress: controller.progress,
                            color: controller.contrastColor,
                          ),
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
                    // A quiet endpoint note pinned to the bottom, only at 0 or the maximum, overlaid
                    // so the centered counter never shifts.
                    if (endpointMessage != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _EndpointHint(
                          message: endpointMessage,
                          color: controller.contrastColor,
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

/// A quiet note pinned near the bottom at the ends of the journey: the start hint at 0, the closing
/// line at the maximum. The middle of the journey shows nothing here.
class _EndpointHint extends StatelessWidget {
  /// Creates the endpoint note showing [message] in [color].
  const _EndpointHint({required this.message, required this.color});

  /// The start hint or the closing line.
  final String message;

  /// The contrast color for the text.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 15),
      ),
    );
  }
}
