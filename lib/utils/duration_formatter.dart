import '../common/strings.dart' as strings;

/// A human-readable duration listing only the non-zero days/hours/minutes/seconds (e.g. "2 hours 13 minutes"). Zero is shown as "0 seconds".
String formatDuration(Duration duration) {
  if (duration.inSeconds <= 0) return strings.durationSeconds(0);

  final buffer = StringBuffer();
  final days = duration.inDays;
  final hours = duration.inHours % Duration.hoursPerDay;
  final minutes = duration.inMinutes % Duration.minutesPerHour;
  final seconds = duration.inSeconds % Duration.secondsPerMinute;

  if (days > 0) buffer.write(strings.durationDays(days));
  if (hours > 0) buffer.write(strings.durationHours(hours));
  if (minutes > 0) buffer.write(strings.durationMinutes(minutes));
  if (seconds > 0) buffer.write(strings.durationSeconds(seconds));

  return buffer.toString().trimRight();
}
