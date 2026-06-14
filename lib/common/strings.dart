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
const String settingsAction = 'Settings';
const String rateAction = 'Rate app';
const String helpAction = 'Help';
const String infoAction = 'Info';

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

const String cheatModeTitle = 'Cheat mode';
const String cheatModeDialogTitle = 'Jump to a number';
const String cheatModeDialogBody =
    'Any number, 0 to 16,777,215 - though the slow way is the point.';
const String cheatModeBadNumber = 'Enter a number between 0 and 16,777,215';

const String resetAction = 'Reset';
const String resetDialogTitle = 'Start over?';
const String resetDialogBody =
    'Sets the count back to 0 - black again - and clears your time in the app. This cannot be undone.';

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
