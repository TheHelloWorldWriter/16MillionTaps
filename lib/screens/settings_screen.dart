import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../common/strings.dart' as strings;
import '../state/taps_controller.dart';
import '../utils/counter_formatter.dart';

enum _SettingsMenuAction { cheatMode }

/// The neutral, themed settings screen: numeral system and counter text size as rows, with cheat mode (jump-to-number) tucked into the app-bar overflow menu.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final TapsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.settingsTitle),
        actions: [
          PopupMenuButton<_SettingsMenuAction>(
            onSelected: (_) => _jumpToNumber(context),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _SettingsMenuAction.cheatMode,
                child: Text(strings.cheatModeTitle),
              ),
            ],
          ),
        ],
      ),
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
              SwitchListTile(
                title: const Text(strings.progressIndicatorTitle),
                subtitle: const Text(strings.progressIndicatorSubtitle),
                value: controller.showProgressHairline,
                onChanged: (value) => controller.showProgressHairline = value,
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
    final value = await showDialog<int>(
      context: context,
      builder: (context) => _JumpToNumberDialog(initialValue: controller.count),
    );
    if (value == null) return;
    controller.jumpTo(value);
    // The jump's payoff is the color on the Taps screen, so return there to show it.
    if (context.mounted) context.go(tapsRoute);
  }
}

/// Asks for a target count and validates it against the range, popping the chosen
/// value (or null on cancel). Owns its text controller so it is disposed only once
/// the dialog has fully left the tree.
class _JumpToNumberDialog extends StatefulWidget {
  const _JumpToNumberDialog({required this.initialValue});

  final int initialValue;

  @override
  State<_JumpToNumberDialog> createState() => _JumpToNumberDialogState();
}

class _JumpToNumberDialogState extends State<_JumpToNumberDialog> {
  late final TextEditingController _field = TextEditingController(
    text: widget.initialValue.toString(),
  );
  String? _errorText;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _submit() {
    final parsed = int.tryParse(_field.text);
    if (parsed == null || parsed < minCount || parsed > maxCount) {
      setState(() => _errorText = strings.cheatModeBadNumber);
    } else {
      Navigator.pop(context, parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      title: const Text(strings.cheatModeDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(strings.cheatModeDialogBody),
          const SizedBox(height: 16),
          TextField(
            controller: _field,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(errorText: _errorText),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.cancelButtonLabel),
        ),
        TextButton(onPressed: _submit, child: Text(localizations.okButtonLabel)),
      ],
    );
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
