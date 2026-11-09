String formatWithThousandSeparator(String digits) {
  if (digits.isEmpty) return '';

  // Remove any non-digit characters
  final cleanedDigits = digits.replaceAll(RegExp(r'\D'), '');

  // Try to parse the cleaned input as a number
  final number = int.tryParse(cleanedDigits);

  // If parsing fails (null), return "0"
  if (number == null) {
    return "0";
  }

  // Format with thousand separators
  return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}
