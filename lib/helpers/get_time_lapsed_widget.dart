import 'package:flutter/material.dart';

List<Widget> getTimeElapsed(String timestamp) {
  // Parse the input timestamp to DateTime
  // timestamp is in ISO 8601 format (e.g., "2025-03-12T13:44:00")
  DateTime pastTime;
  try {
    pastTime = DateTime.parse(timestamp);
  } catch (e) {
    return [Text("-")];
  }

  // Get current time in UTC to match parsed timestamp (if it's in UTC)
  DateTime now = DateTime.now().toUtc();

  // Calculate the difference
  Duration difference = now.difference(pastTime);

  // Extract time components
  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;
  int seconds = difference.inSeconds % 60;

  // Build the result widget list
  List<Widget> parts = [];
  // parts.add(Text("Time lapsed: ", style: TextStyle(fontSize: 14)));
  if (days > 0) {
    parts.add(Text("$days",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));
    parts.add(Text("d ", style: TextStyle(fontSize: 14)));
  }
  if (hours > 0) {
    parts.add(Text("$hours",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));
    parts.add(
        Text("hr${hours == 1 ? '' : 's'} ", style: TextStyle(fontSize: 14)));
  }
  if (minutes > 0) {
    parts.add(Text("$minutes",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));
    parts.add(
        Text("min${minutes == 1 ? '' : 's'} ", style: TextStyle(fontSize: 14)));
  }
  if (seconds >= 0 || parts.isEmpty) {
    parts.add(Text("$seconds",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)));
    parts.add(Text("s", style: TextStyle(fontSize: 14)));
  }

  return parts;
}
