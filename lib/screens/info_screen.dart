import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/strings.dart' as strings;
import '../services/color_name_service.dart';
import '../state/taps_controller.dart';
import '../utils/color_utils.dart' as color_utils;
import '../utils/duration_formatter.dart' as duration_formatter;

/// The Info screen: filled with the current color, listing its stats and codes, each copyable.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.controller, required this.colorNames});

  final TapsController controller;
  final ColorNameService colorNames;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller, colorNames]),
      builder: (context, _) {
        final color = controller.fillColor;
        final onColor = controller.contrastColor;
        final formatDecimal = MaterialLocalizations.of(context).formatDecimal;

        final rows = <(String, String)>[
          (strings.infoCount, formatDecimal(controller.count)),
          (strings.infoRemaining, formatDecimal(controller.remaining)),
          (strings.infoCompleted, '${controller.percentComplete.toStringAsFixed(3)}%'),
          (strings.infoColorName, colorNames.nameFor(controller.count) ?? strings.infoNoColorName),
          (strings.infoHex, color_utils.hexWithHash(controller.count)),
          (strings.infoRgb, color_utils.rgb(controller.count)),
          (strings.infoTimeSpent, duration_formatter.formatDuration(controller.totalTapTime)),
        ];

        return Scaffold(
          backgroundColor: color,
          appBar: AppBar(
            backgroundColor: color,
            foregroundColor: onColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text(strings.infoTitle),
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final (label, value) in rows)
                  _InfoRow(label: label, value: value, color: onColor),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A single labelled value with a copy button.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(strings.infoCopied(value))));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(color: color.withValues(alpha: 0.7))),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            color: color,
            tooltip: strings.infoCopyTooltip,
            onPressed: () => _copy(context),
          ),
        ],
      ),
    );
  }
}
