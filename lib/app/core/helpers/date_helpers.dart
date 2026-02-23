/// Converte uma string de data em diversos formatos para ISO 8601.
/// Aceita: dd/MM/yyyy, dd-MM-yyyy, yyyy-MM-dd, ISO completo.
/// Retorna null se vazio ou inválido.
String? toIso8601DateString(String? input) {
  if (input == null || input.trim().isEmpty) return null;
  final trimmed = input.trim();

  // yyyy-MM-dd ou ISO completo - DateTime.parse aceita
  final isoMatch = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(trimmed);
  if (isoMatch != null) {
    final year = int.tryParse(isoMatch.group(1)!);
    final month = int.tryParse(isoMatch.group(2)!);
    final day = int.tryParse(isoMatch.group(3)!);
    if (year != null && month != null && day != null) {
      try {
        final dt = DateTime.utc(year, month, day);
        return dt.toIso8601String();
      } catch (_) {}
    }
  }

  // dd/MM/yyyy ou dd-MM-yyyy
  final parts = trimmed.contains('/')
      ? trimmed.split('/')
      : trimmed.split(RegExp(r'[-.\s]'));
  if (parts.length == 3) {
    int? day, month, year;
    if (parts[0].length == 4) {
      year = int.tryParse(parts[0]);
      month = int.tryParse(parts[1]);
      day = int.tryParse(parts[2]);
    } else {
      day = int.tryParse(parts[0]);
      month = int.tryParse(parts[1]);
      year = int.tryParse(parts[2]);
    }
    if (day != null && month != null && year != null) {
      try {
        final dt = DateTime.utc(year, month, day);
        return dt.toIso8601String();
      } catch (_) {}
    }
  }
  return null;
}

/// Formata uma string ISO 8601 para exibição (dd/MM/yyyy).
/// Retorna a string original se não for uma data válida.
String formatIsoDateForDisplay(String? isoDate) {
  if (isoDate == null || isoDate.trim().isEmpty) return '';
  try {
    final dt = DateTime.parse(isoDate.trim());
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  } catch (_) {
    return isoDate;
  }
}
