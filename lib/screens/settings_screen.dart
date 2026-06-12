import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/strings.dart' as strings;
import '../state/taps_controller.dart';
import '../utils/counter_formatter.dart';

/// The neutral, themed settings screen: numeral system, counter text size, and jump-to-number.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final TapsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(strings.settingsTitle)),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return ListView(
            children: [
              ListTile(
                title: const Text(strings.numeralSystemTitle),
                subtitle: Text(
                  strings.numeralSystemSummary(_numeralSystemLabel(controller.numeralSystem)),
                ),
                onTap: () => _pickNumeralSystem(context),
              ),
              ListTile(
                title: const Text(strings.counterTextSizeTitle),
                subtitle: Text(_textSizeLabel(controller.counterTextSize)),
                onTap: () => _pickTextSize(context),
              ),
              ListTile(
                title: const Text(strings.cheatModeTitle),
                subtitle: const Text(strings.cheatModeSummary),
                onTap: () => _jumpToNumber(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickNumeralSystem(BuildContext context) async {
    final selected = await _pickOption<NumeralSystem>(
      context,
      strings.numeralSystemTitle,
      NumeralSystem.values,
      controller.numeralSystem,
      _numeralSystemLabel,
    );
    if (selected != null) controller.numeralSystem = selected;
  }

  Future<void> _pickTextSize(BuildContext context) async {
    final selected = await _pickOption<CounterTextSize>(
      context,
      strings.counterTextSizeTitle,
      CounterTextSize.values,
      controller.counterTextSize,
      _textSizeLabel,
    );
    if (selected != null) controller.counterTextSize = selected;
  }

  Future<void> _jumpToNumber(BuildContext context) async {
    final field = TextEditingController(text: controller.count.toString());
    final localizations = MaterialLocalizations.of(context);
    final value = await showDialog<int>(
      context: context,
      builder: (context) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(strings.cheatModeDialogTitle),
              content: TextField(
                controller: field,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(errorText: errorText),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    final parsed = int.tryParse(field.text);
                    if (parsed == null || parsed < minCount || parsed > maxCount) {
                      setState(() => errorText = strings.cheatModeBadNumber);
                    } else {
                      Navigator.pop(context, parsed);
                    }
                  },
                  child: Text(localizations.okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );
    field.dispose();
    if (value != null) controller.jumpTo(value);
  }
}

String _numeralSystemLabel(NumeralSystem system) => switch (system) {
  NumeralSystem.binary => strings.numeralBinaryLabel,
  NumeralSystem.octal => strings.numeralOctalLabel,
  NumeralSystem.decimal => strings.numeralDecimalLabel,
  NumeralSystem.hexadecimal => strings.numeralHexadecimalLabel,
};

String _textSizeLabel(CounterTextSize size) => switch (size) {
  CounterTextSize.extraSmall => strings.textSizeExtraSmallLabel,
  CounterTextSize.small => strings.textSizeSmallLabel,
  CounterTextSize.medium => strings.textSizeMediumLabel,
  CounterTextSize.large => strings.textSizeLargeLabel,
};

/// Shows a radio-style picker of [options] and returns the chosen one (or null).
Future<T?> _pickOption<T>(
  BuildContext context,
  String title,
  List<T> options,
  T current,
  String Function(T) label,
) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(title),
        children: [
          for (final option in options)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, option),
              child: Row(
                children: [
                  Icon(
                    option == current ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(label(option)),
                ],
              ),
            ),
        ],
      );
    },
  );
}
