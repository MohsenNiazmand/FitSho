import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';

abstract final class DietConstants {
  static const mealSlotKeys = [
    'breakfast',
    'morning_snack',
    'lunch',
    'afternoon_snack',
    'dinner',
  ];

  static const dayKeys = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  /// Returns the [dayKeys] entry for [date] (defaults to today), using
  /// the same Saturday-first week ordering as [dayKeys].
  static String todayKey([DateTime? date]) {
    final now = date ?? DateTime.now();
    // DateTime.weekday is Monday(1)..Sunday(7); dayKeys starts on
    // Saturday, so shift by one and wrap.
    return dayKeys[(now.weekday + 1) % 7];
  }

  static Map<String, MealSlotConfig> defaultMealSlots() {
    return const {
      'breakfast': MealSlotConfig(
        enabled: true,
        time: '08:00',
        notificationsEnabled: true,
      ),
      'morning_snack': MealSlotConfig(
        enabled: true,
        time: '10:30',
        notificationsEnabled: true,
      ),
      'lunch': MealSlotConfig(
        enabled: true,
        time: '13:00',
        notificationsEnabled: true,
      ),
      'afternoon_snack': MealSlotConfig(
        enabled: true,
        time: '16:30',
        notificationsEnabled: true,
      ),
      'dinner': MealSlotConfig(
        enabled: true,
        time: '20:00',
        notificationsEnabled: true,
      ),
    };
  }
}
