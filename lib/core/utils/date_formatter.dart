/// Formats a [DateTime] as `YYYY-MM-DD HH:mm`.
String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

/// Formats how long ago [value] was, e.g. `<1 min`, `5 min`, `3 h`, `2 d`.
String relativeTime(DateTime value) {
  final age = DateTime.now().difference(value);
  if (age.inMinutes < 1) return '<1 min';
  if (age.inMinutes < 60) return '${age.inMinutes} min';
  if (age.inHours < 24) return '${age.inHours} h';
  return '${age.inDays} d';
}
