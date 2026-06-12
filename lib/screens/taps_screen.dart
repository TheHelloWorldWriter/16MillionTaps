import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../common/strings.dart' as strings;
import '../services/color_name_service.dart';
import '../services/url_launcher.dart';
import '../state/taps_controller.dart';
import '../utils/color_utils.dart' as color_utils;
import '../widgets/counter_display.dart';
import '../widgets/progress_hairline.dart';
import '../widgets/taps_app_bar.dart';

/// The main screen: tap anywhere to advance the count and fill the screen with the matching color.
class TapsScreen extends StatefulWidget {
  const TapsScreen({super.key, required this.controller, required this.colorNames});

  final TapsController controller;
  final ColorNameService colorNames;

  @override
  State<TapsScreen> createState() => _TapsScreenState();
}

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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onTap() {
    if (widget.controller.atEnd) {
      _showMessage(strings.theEnd);
      return;
    }
    widget.controller.increment();
  }

  void _onStepBack() {
    if (widget.controller.atStart) {
      _showMessage(strings.noGoingBack);
      return;
    }
    widget.controller.decrement();
  }

  void _onInfo() => context.push(infoRoute);

  Future<void> _copyColor() async {
    final hex = color_utils.hexWithHash(widget.controller.count);
    await Clipboard.setData(ClipboardData(text: hex));
    if (!mounted) return;
    _showMessage(strings.copiedColor(hex));
  }

  void _onMenuAction(TapsMenuAction action) {
    switch (action) {
      case TapsMenuAction.settings:
        context.push(settingsRoute);
      case TapsMenuAction.copyColor:
        _copyColor();
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
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  ProgressHairline(progress: controller.progress, color: controller.contrastColor),
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
        );
      },
    );
  }
}
