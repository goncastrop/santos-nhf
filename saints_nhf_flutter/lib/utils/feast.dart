const _months = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

const _monthsShort = [
  'ENE',
  'FEB',
  'MAR',
  'ABR',
  'MAY',
  'JUN',
  'JUL',
  'AGO',
  'SEP',
  'OCT',
  'NOV',
  'DIC',
];

const _weekdays = [
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];

/// Month names in Spanish, index 0 = enero.
List<String> get monthNames => _months;

/// "4 de octubre", or null when the saint has no feast day.
String? feastLong(int? month, int? day) {
  if (month == null || day == null) return null;
  return '$day de ${_months[month - 1]}';
}

/// "4 OCT", or null when the saint has no feast day.
String? feastShort(int? month, int? day) {
  if (month == null || day == null) return null;
  return '$day ${_monthsShort[month - 1]}';
}

/// Current moment in Argentina (UTC-3), the app's reference calendar.
DateTime nowInArgentina() =>
    DateTime.now().toUtc().subtract(const Duration(hours: 3));

/// "Miércoles 16 de septiembre".
String todayLong() {
  final now = nowInArgentina();
  final weekday = _weekdays[now.weekday - 1];
  final capitalized = weekday[0].toUpperCase() + weekday.substring(1);
  return '$capitalized ${now.day} de ${_months[now.month - 1]}';
}

/// "16 sep 2026, 14:05" for admin timestamps (local device time).
String dateTimeShort(DateTime value) {
  final local = value.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '${local.day} ${_monthsShort[local.month - 1].toLowerCase()} '
      '${local.year}, $h:$m';
}

/// Key of the current Argentina calendar day, `yyyy-MM-dd`. The daily card and
/// the daily question roll over when this changes.
String todayKey() {
  final now = nowInArgentina();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

/// Moment the Argentina calendar day changes next.
DateTime nextArgentinaMidnight() {
  final now = nowInArgentina();
  return DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
}
