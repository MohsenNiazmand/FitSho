import 'package:flutter/material.dart';

/// Combines a date from [baseDate] (e.g. today) with a time string in "HH:mm"
/// format.
DateTime combineDayAndTime(DateTime baseDate, String timeStr) {
  final parts = timeStr.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  
  return DateTime(
    baseDate.year,
    baseDate.month,
    baseDate.day,
    hour,
    minute,
  );
}

/// Converts a [TimeOfDay] to "HH:mm" string.
String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
