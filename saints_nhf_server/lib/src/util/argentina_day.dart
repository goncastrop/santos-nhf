/// The app's "day" is a calendar day in Argentina (UTC-3, no DST).
const argentinaOffset = Duration(hours: -3);

/// Current moment in Argentina time.
DateTime nowInArgentina() => DateTime.now().toUtc().add(argentinaOffset);

/// Key of the current Argentina calendar day, e.g. `2026-09-16`.
String todayKey() => dayKey(nowInArgentina());

/// Formats a date as `yyyy-MM-dd`.
String dayKey(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}
