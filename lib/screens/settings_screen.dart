// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../common/constants.dart';
import '../common/strings.dart' as strings;
import '../services/tap_sound_player.dart';
import '../state/taps_controller.dart';
import '../utils/counter_formatter.dart';

/// The Settings app-bar overflow actions.
enum _SettingsMenuAction { cheatMode, reset }

/// The neutral, themed settings screen: numeral system and counter text size as rows, with cheat
/// mode (jump-to-number) and reset tucked into the app-bar overflow menu.
class SettingsScreen extends StatelessWidget {
  /// Creates the Settings screen driven by [controller].
  const SettingsScreen({super.key, required this.controller});

  /// Holds and persists the settings the screen edits.
  final TapsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.settingsTitle),
        actions: [
          // Overflow: cheat mode and reset, kept off the main list.
          PopupMenuButton<_SettingsMenuAction>(
            onSelected: (action) => _onMenuAction(context, action),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: .cheatMode,
                child: Text(strings.cheatModeTitle),
              ),
              PopupMenuItem(
                value: .reset,
                child: Text(strings.resetTitle),
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
              // The numeral system setting.
              ListTile(
                title: const Text(strings.numeralSystemTitle),
                subtitle: Text(
                  strings.numeralSystemSummary(_numeralSystemLabel(controller.numeralSystem)),
                ),
                onTap: () => _pickNumeralSystem(context),
              ),
              // The counter text size setting.
              ListTile(
                title: const Text(strings.counterTextSizeTitle),
                subtitle: Text(_textSizeLabel(controller.counterTextSize)),
                onTap: () => _pickTextSize(context),
              ),
              // The progress indicator setting.
              SwitchListTile(
                title: const Text(strings.progressIndicatorTitle),
                subtitle: const Text(strings.progressIndicatorSubtitle),
                value: controller.showProgressHairline,
                onChanged: (value) => controller.showProgressHairline = value,
              ),
              // The tap sound setting.
              ListTile(
                title: const Text(strings.tapSoundTitle),
                subtitle: Text(_tapSoundLabel(controller.tapSound)),
                onTap: () => _pickTapSound(context),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Opens the numeral-system picker and applies the choice.
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

  /// Opens the text-size picker and applies the choice.
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

  /// Opens the tap-sound picker, applies the choice, and previews it.
  Future<void> _pickTapSound(BuildContext context) async {
    final selected = await _pickOption<TapSound>(
      context,
      strings.tapSoundTitle,
      TapSound.values,
      controller.tapSound,
      _tapSoundLabel,
    );
    if (selected != null) {
      controller.tapSound = selected;
      controller.previewTapSound();
    }
  }

  /// Opens the jump-to-number dialog and, on confirm, jumps and returns to the Taps screen.
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

  /// Routes an overflow action to its handler.
  void _onMenuAction(BuildContext context, _SettingsMenuAction action) {
    switch (action) {
      case .cheatMode:
        _jumpToNumber(context);
      case .reset:
        _reset(context);
    }
  }

  /// Confirms the destructive reset, then clears the journey and returns to the Taps screen.
  Future<void> _reset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const _ResetDialog(),
    );
    if (confirmed != true) return;
    controller.reset();
    // Show the fresh start: a black Taps screen at 0.
    if (context.mounted) context.go(tapsRoute);
  }
}

/// Asks for a target count and validates it against the range, popping the chosen value (or null on
/// cancel). Owns its text controller so it is disposed only once the dialog fully leaves the tree.
class _JumpToNumberDialog extends StatefulWidget {
  /// Creates the dialog pre-filled with [initialValue].
  const _JumpToNumberDialog({required this.initialValue});

  /// The count the field starts on.
  final int initialValue;

  @override
  State<_JumpToNumberDialog> createState() => _JumpToNumberDialogState();
}

/// Owns the field controller and validation for [_JumpToNumberDialog].
class _JumpToNumberDialogState extends State<_JumpToNumberDialog> {
  /// The field's controller, disposed with the state (never mid-animation).
  late final TextEditingController _field = TextEditingController(
    text: widget.initialValue.toString(),
  );

  /// The current validation message, or null when the input is valid.
  String? _errorText;

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  /// Validates the input and pops the value, or shows an error.
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
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          const Text(strings.cheatModeDialogBody),
          const SizedBox(height: 16),
          TextField(
            controller: _field,
            autofocus: true,
            keyboardType: .number,
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

/// Confirms the destructive reset, popping true only when the user approves.
class _ResetDialog extends StatelessWidget {
  /// Creates the reset confirmation dialog.
  const _ResetDialog();

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      title: const Text(strings.resetDialogTitle),
      content: const Text(strings.resetDialogBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(localizations.cancelButtonLabel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text(strings.resetAction),
        ),
      ],
    );
  }
}

/// The display label for the numeral [system].
String _numeralSystemLabel(NumeralSystem system) => switch (system) {
  .binary => strings.numeralBinaryLabel,
  .octal => strings.numeralOctalLabel,
  .decimal => strings.numeralDecimalLabel,
  .hexadecimal => strings.numeralHexadecimalLabel,
};

/// The display label for the text [size] preset.
String _textSizeLabel(CounterTextSize size) => switch (size) {
  .extraSmall => strings.textSizeExtraSmallLabel,
  .small => strings.textSizeSmallLabel,
  .medium => strings.textSizeMediumLabel,
  .large => strings.textSizeLargeLabel,
};

/// The display label for the tap [sound].
String _tapSoundLabel(TapSound sound) => switch (sound) {
  .none => strings.tapSoundNoneLabel,
  .ting => strings.tapSoundTingLabel,
  .bloop => strings.tapSoundBloopLabel,
  .pluck => strings.tapSoundPluckLabel,
  .drop => strings.tapSoundDropLabel,
  .chime => strings.tapSoundChimeLabel,
  .block => strings.tapSoundBlockLabel,
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
