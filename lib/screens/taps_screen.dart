import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/strings.dart' as strings;
import '../state/taps_controller.dart';
import '../utils/counter_formatter.dart';
import '../widgets/progress_hairline.dart';

/// The main screen: tap anywhere to advance the count and fill the screen with the matching color.
class TapsScreen extends StatefulWidget {
  const TapsScreen({super.key, required this.controller});

  final TapsController controller;

  @override
  State<TapsScreen> createState() => _TapsScreenState();
}

class _TapsScreenState extends State<TapsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.count == minCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showMessage(strings.firstTapHint);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final formatDecimal = MaterialLocalizations.of(context).formatDecimal;
        return Scaffold(
          backgroundColor: controller.fillColor,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onTap,
            child: SafeArea(
              child: Column(
                children: [
                  ProgressHairline(progress: controller.progress, color: controller.contrastColor),
                  Expanded(
                    child: Center(
                      child: Text(
                        formatCount(
                          controller.count,
                          controller.numeralSystem,
                          formatDecimal: formatDecimal,
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: controller.contrastColor, fontSize: 34),
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
