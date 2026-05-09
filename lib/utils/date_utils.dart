/// Formats [date] as `yyyy-MM-dd` for storage in date-only fields.
///
/// Returns null when [date] is null.
String? formatDateForStorage(DateTime? date) {
  if (date == null) return null;
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
