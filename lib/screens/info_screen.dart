// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

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
            systemOverlayStyle: color_utils.systemOverlayStyleFor(onColor),
            title: const Text(strings.infoTitle),
          ),
          body: SafeArea(
            top: false,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: rows.length,
              separatorBuilder: (context, _) =>
                  Divider(height: 1, thickness: 1, color: onColor.withValues(alpha: 0.2)),
              itemBuilder: (context, index) {
                final (label, value) = rows[index];
                return _InfoRow(label: label, value: value, color: onColor);
              },
            ),
          ),
        );
      },
    );
  }
}

/// A row showing a value over its label, with a button that copies the value.
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
    return ListTile(
      title: Text(
        value,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(label, style: TextStyle(color: color.withValues(alpha: 0.7))),
      trailing: IconButton(
        icon: const Icon(Icons.copy, size: 20),
        color: color,
        tooltip: strings.infoCopyValueTooltip(label),
        onPressed: () => _copy(context),
      ),
    );
  }
}
