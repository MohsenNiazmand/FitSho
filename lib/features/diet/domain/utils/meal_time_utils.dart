import 'package:flutter/material.dart';

/// Shared helpers for converting between the "HH:mm" strings persisted on
/// [MealSlotConfig] and the [TimeOfDay] / [DateTime] values the UI and
/// scheduling logic actually work with.
abstract final class MealTimeUtils {
  /// Parses a "HH:mm" string (as stored on `MealSlotConfig.time`) into a
  /// [TimeOfDay]. Throws a [FormatException] if [raw] isn't in that shape.
  static TimeOfDay parseTimeOfDay(String raw) {
    final parts = raw.split(':');
    if (parts.length != 2) {
      throw FormatException('Expected "HH:mm", got "$raw"');
    }
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Formats a [TimeOfDay] back into the "HH:mm" shape used for storage.
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Combines a calendar [day] with a [time] of day into a concrete
  /// [DateTime], e.g. for feeding into [getMealStatus].
  static DateTime combineDayAndTime(DateTime day, TimeOfDay time) {
    return DateTime(day.year, day.month, day.day, time.hour, time.minute);
  }

  /// Total minutes since midnight represented by [time] — convenient for
  /// cheap chronological/gap comparisons that don't need a full [DateTime].
  static int minutesSinceMidnight(TimeOfDay time) =>
      time.hour * 60 + time.minute;
}
