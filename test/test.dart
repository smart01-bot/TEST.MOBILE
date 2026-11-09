void main() {
  DateTime pastTime;
  try {
    pastTime = DateTime.parse("2025-03-12T13:44:00");
    print("Past time: ${pastTime.toString()}");
  } catch (e) {
    print("Invalid date format: $e");
    return;
  }

  // Get current time in UTC to match parsed timestamp (if it's in UTC)
  DateTime now = DateTime.now();
  print("Current time: ${now.toString()}");

  // Calculate the difference
  Duration difference = now.difference(pastTime);

  // Extract time components
  int days = difference.inDays;
  int hours = difference.inHours % 24;
  print("Diff hours: $hours");
  int minutes = difference.inMinutes % 60;
  int seconds = difference.inSeconds % 60;

  // Build the result widget list
  List<String> parts = [];
  if (days > 0) {
    parts.add("$days");
    parts.add("d ");
  }
  if (hours > 0) {
    parts.add("$hours");
    parts.add("hr${hours == 1 ? '' : 's'} ");
  }
  if (minutes > 0) {
    parts.add("$minutes");
    parts.add("min${minutes == 1 ? '' : 's'} ");
  }
  if (seconds >= 0 || parts.isEmpty) {
    parts.add("$seconds");
    parts.add("s");
  }

  print("Time lapsed: ${parts.join(' ')}");
}
