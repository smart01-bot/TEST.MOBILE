import 'package:intl/intl.dart';

String formatDate(String input) {
  input = input.trim();

  final isoRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$'); // Matches YYYY-MM-DD
  final euroRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$'); // Matches DD/MM/YYYY

  DateTime? parsedDate;

  try {
    if (isoRegex.hasMatch(input)) {
      // Parse YYYY-MM-DD
      parsedDate = DateTime.parse(input);
    } else if (euroRegex.hasMatch(input)) {
      // Parse DD/MM/YYYY
      final parts = input.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      parsedDate = DateTime(year, month, day);
    } else {
      return '-'; // Invalid format
    }

    // Return formatted date: 28 May 2025
    return DateFormat('dd MMMM yyyy').format(parsedDate);
  } catch (e) {
    return '-'; // Parsing error
  }
}
