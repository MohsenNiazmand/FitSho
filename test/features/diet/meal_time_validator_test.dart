import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/utils/meal_time_validator.dart';
import 'package:fitsho/l10n/app_localizations.dart';

void main() {
  final trFa = lookupAppLocalizations(const Locale('fa'));
  final trEn = lookupAppLocalizations(const Locale('en'));

  group('MealTimeValidator (Persian Localized)', () {
    test('Default meal slots are valid', () {
      final slots = DietConstants.defaultMealSlots();
      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesValid>());
    });

    test('Ignores disabled slots during validation', () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
        'morning_snack': const MealSlotConfig(
          enabled: false,
          time: '08:30',
        ),
        'lunch': const MealSlotConfig(
          enabled: true,
          time: '12:00',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesValid>());
    });

    test('Fails when two consecutive enabled meals have identical times', () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
        'morning_snack': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesInvalid>());
      final invalid = result as MealTimesInvalid;
      expect(
        invalid.message,
        trFa.dietMealTimeSameError('صبحانه', 'میان‌وعده صبح'),
      );
    });

    test('Fails when chronological order is inverted', () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '10:00',
        ),
        'morning_snack': const MealSlotConfig(
          enabled: true,
          time: '09:00',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesInvalid>());
      final invalid = result as MealTimesInvalid;
      expect(
        invalid.message,
        trFa.dietMealTimeOrderError('میان‌وعده صبح', 'صبحانه'),
      );
    });

    test('Fails when lunch is set before morning snack with exact Persian error',
        () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
        'morning_snack': const MealSlotConfig(
          enabled: true,
          time: '10:00',
        ),
        'lunch': const MealSlotConfig(
          enabled: true,
          time: '09:30',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesInvalid>());
      final invalid = result as MealTimesInvalid;
      expect(
        invalid.message,
        'ساعت وعده «ناهار» باید بعد از «میان‌وعده صبح» باشد.',
      );
    });

    test('Fails when gap is less than 60 minutes', () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
        'morning_snack': const MealSlotConfig(
          enabled: true,
          time: '08:45',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesInvalid>());
      final invalid = result as MealTimesInvalid;
      expect(
        invalid.message,
        trFa.dietMealTimeGapError('صبحانه', 'میان‌وعده صبح'),
      );
    });

    test('Passes when gap is exactly 60 minutes', () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
        'morning_snack': const MealSlotConfig(
          enabled: true,
          time: '09:00',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesValid>());
    });

    test('Passes when only one meal is enabled', () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
        'lunch': const MealSlotConfig(
          enabled: false,
          time: '12:00',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trFa,
      );

      expect(result, isA<MealTimesValid>());
    });
  });

  group('MealTimeValidator (English Localized)', () {
    test('Localized in English properly', () {
      final slots = {
        'breakfast': const MealSlotConfig(
          enabled: true,
          time: '08:00',
        ),
        'morning_snack': const MealSlotConfig(
          enabled: true,
          time: '08:30',
        ),
      };

      final result = MealTimeValidator.validate(
        slots: slots,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: trEn,
      );

      expect(result, isA<MealTimesInvalid>());
      final invalid = result as MealTimesInvalid;
      expect(
        invalid.message,
        trEn.dietMealTimeGapError('Breakfast', 'Morning snack'),
      );
    });
  });
}
