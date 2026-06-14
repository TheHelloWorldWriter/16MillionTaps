/// Non-translatable app constants: the counter range, external links, storage keys, and route paths. User-visible copy lives in `strings.dart`.
library;

/// The counter range. Each value maps directly to a 24-bit RGB color, from black (0) to white (0xFFFFFF).
const int minCount = 0x000000;
const int maxCount = 0xFFFFFF;

/// The bundled color-name dataset (a hex -> name map).
const String colorNamesAsset = 'assets/color_names.json';

// External links opened from the app bar. Rate points at a brand-page redirect that will fan out to store listings once they exist.
const String helpUrl = 'https://www.thehelloworldwriter.com/16milliontaps/';
const String rateUrl = 'https://www.thehelloworldwriter.com/16milliontaps/rate/';

// Shared preferences keys.
const String prefCountKey = 'count';
const String prefNumeralSystemKey = 'numeral_system';
const String prefCounterTextSizeKey = 'counter_text_size';
const String prefTotalTapSecondsKey = 'total_tap_seconds';
const String prefShowProgressHairlineKey = 'show_progress_hairline';
const String prefTapSoundKey = 'tap_sound';

// Route paths.
const String tapsRoute = '/';
const String infoRoute = '/info';
const String settingsRoute = '/settings';
