// Copyright (c) 2014-2026 The Hello World Writer
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://www.thehelloworldwriter.com/16milliontaps/license/.

/// All user-visible copy, kept in one place as the seam for future localization. Import as `strings` and reference members by prefix.
library;

// -------------------------------------------------------------------------------
// App
// -------------------------------------------------------------------------------

const String appName = '16 Million Taps';

// -------------------------------------------------------------------------------
// Taps (home) screen
// -------------------------------------------------------------------------------

const String firstTapHint = 'Start tapping: 0... 1... 2... 16,777,215';
const String noGoingBack = 'Sorry, no going back from 0';
const String theEnd = 'Done. Where can one go from here?';

/// Screen-reader label for the full-screen tap target.
const String tapToCountSemantic = 'Tap to count';

String copiedColor(String value) => '$value copied to clipboard.';
String cannotOpenUrl(String url) => 'Cannot open $url';

// -------------------------------------------------------------------------------
// App bar
// -------------------------------------------------------------------------------

const String goBackAction = 'Go back';
const String copyColorAction = 'Copy color';
const String shareJourneyAction = 'Share journey';
const String settingsAction = 'Settings';
const String rateAction = 'Rate app';
const String helpAction = 'Help';
const String infoAction = 'Info';

// -------------------------------------------------------------------------------
// Share journey
// -------------------------------------------------------------------------------

/// Caption shared with the image: the hex (and name, when known), then the app and its link.
String shareJourneyCaption({required String hex, String? name, required String url}) {
  final color = name == null ? hex : '$hex "$name"';
  return "I'm at $color on my color journey. $appName - $url";
}

const String shareFailed = 'Could not share the image.';

// -------------------------------------------------------------------------------
// Settings screen
// -------------------------------------------------------------------------------

const String settingsTitle = 'Settings';

const String numeralSystemTitle = 'Numeral system';
String numeralSystemSummary(String systemName) => 'Count from 0 to 16,777,215 in $systemName';

const String numeralBinaryLabel = 'Binary';
const String numeralOctalLabel = 'Octal';
const String numeralDecimalLabel = 'Decimal';
const String numeralHexadecimalLabel = 'Hexadecimal';

const String counterTextSizeTitle = 'Counter text size';
const String textSizeExtraSmallLabel = 'Extra Small';
const String textSizeSmallLabel = 'Small';
const String textSizeMediumLabel = 'Medium';
const String textSizeLargeLabel = 'Large';

const String progressIndicatorTitle = 'Progress indicator';
const String progressIndicatorSubtitle =
    'A faint line showing your place on the journey from black to white';

const String tapSoundTitle = 'Tap sound';
const String tapSoundNoneLabel = 'None';
const String tapSoundTingLabel = 'Ting';
const String tapSoundBloopLabel = 'Bloop';
const String tapSoundPluckLabel = 'Pluck';
const String tapSoundDropLabel = 'Drop';
const String tapSoundChimeLabel = 'Chime';
const String tapSoundBlockLabel = 'Block';

const String cheatModeTitle = 'Cheat mode';
const String cheatModeDialogTitle = 'Jump to a number';
const String cheatModeDialogBody =
    'Any number, 0 to 16,777,215 - though the slow way is the point.';
const String cheatModeBadNumber = 'Enter a number between 0 and 16,777,215';

const String resetTitle = 'Reset journey';
const String resetAction = 'Reset';
const String resetDialogTitle = 'Reset journey?';
const String resetDialogBody =
    'Sets the count back to 0 and clears your time in the app. This cannot be undone.';

// -------------------------------------------------------------------------------
// Info screen
// -------------------------------------------------------------------------------

const String infoTitle = 'Info';
const String infoCount = 'Count';
const String infoRemaining = 'Remaining';
const String infoCompleted = 'Completed';
const String infoColorName = 'Color name';
const String infoHex = 'Hex triplet';
const String infoRgb = 'RGB';
const String infoTimeSpent = 'Time in the app';
const String infoNoColorName = 'No name';
String infoCopyValueTooltip(String label) => 'Copy $label';
String infoCopied(String value) => '$value copied to clipboard';

// -------------------------------------------------------------------------------
// Durations (Info "time spent")
// -------------------------------------------------------------------------------

String durationDays(int n) => n == 1 ? '1 day ' : '$n days ';
String durationHours(int n) => n == 1 ? '1 hour ' : '$n hours ';
String durationMinutes(int n) => n == 1 ? '1 minute ' : '$n minutes ';
String durationSeconds(int n) => n == 1 ? '1 second' : '$n seconds';
