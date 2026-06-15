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
  /// Creates the Info screen for [controller] and [colorNames].
  const InfoScreen({super.key, required this.controller, required this.colorNames});

  /// Source of the count, color, and derived stats.
  final TapsController controller;

  /// Resolves the current color's name.
  final ColorNameService colorNames;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([controller, colorNames]),
      builder: (context, _) {
        final color = controller.fillColor;
        final onColor = controller.contrastColor;
        final formatDecimal = MaterialLocalizations.of(context).formatDecimal;

        // Journey stats: the count and how far it has come.
        final journeyRows = <(String, String)>[
          (strings.infoCount, formatDecimal(controller.count)),
          (strings.infoRemaining, formatDecimal(controller.remaining)),
          (strings.infoCompleted, '${controller.percentComplete.toStringAsFixed(3)}%'),
          (strings.infoTimeSpent, duration_formatter.formatDuration(controller.totalTapTime)),
        ];

        // Color codes for the current fill.
        final colorRows = <(String, String)>[
          (strings.infoColorName, colorNames.nameFor(controller.count) ?? strings.infoNoColorName),
          (strings.infoHex, color_utils.hexWithHash(controller.count)),
          (strings.infoRgb, color_utils.rgb(controller.count)),
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
            child: ListView(
              padding: const .only(bottom: 8),
              children: [
                _InfoSection(title: strings.infoJourneySection, rows: journeyRows, color: onColor),
                _InfoSection(title: strings.infoColorSection, rows: colorRows, color: onColor),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A titled group of rows: a subtle section header over its [_InfoRow]s, divided by hairlines.
class _InfoSection extends StatelessWidget {
  /// Creates a section headed by [title] over its [rows], drawn in [color].
  const _InfoSection({required this.title, required this.rows, required this.color});

  /// The section header shown above the rows.
  final String title;

  /// The label/value pairs in this section, in display order.
  final List<(String, String)> rows;

  /// The contrast color for the header, rows, and dividers.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .fromLTRB(16, 20, 16, 4),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: color.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: .w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        for (final (index, (label, value)) in rows.indexed) ...[
          if (index > 0) Divider(height: 1, thickness: 1, color: color.withValues(alpha: 0.2)),
          _InfoRow(label: label, value: value, color: color),
        ],
      ],
    );
  }
}

/// A row showing a value over its label, with a button that copies the value.
class _InfoRow extends StatelessWidget {
  /// Creates a row showing [value] over [label], drawn in [color].
  const _InfoRow({required this.label, required this.value, required this.color});

  /// The caption shown beneath the value.
  final String label;

  /// The value shown and copied.
  final String value;

  /// The contrast color for the text and copy icon.
  final Color color;

  /// Copies [value] to the clipboard and confirms with a snackbar.
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
        style: TextStyle(color: color, fontWeight: .w500),
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
