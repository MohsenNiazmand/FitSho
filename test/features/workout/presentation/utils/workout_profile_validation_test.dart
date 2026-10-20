import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/utils/workout_profile_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('removing a discipline also removes its selected style', () {
    final selection = removeWorkoutDisciplineSelection(
      disciplines: ['bodybuilding', 'fitness'],
      styles: {'bodybuilding': 'full_body', 'fitness': 'hiit'},
      disciplineId: 'fitness',
    );

    expect(selection.disciplines, ['bodybuilding']);
    expect(selection.styles, {'bodybuilding': 'full_body'});
  });

  const options = WorkoutOptions(
    disciplines: [
      DisciplineOption(
        id: 'strength',
        label: 'قدرتی',
        description: 'تمرین قدرتی',
      ),
      DisciplineOption(
        id: 'bodybuilding',
        label: 'بدنسازی',
        description: 'بدنسازی',
      ),
    ],
    styles: [
      StyleOption(
        id: 'beginner_style',
        disciplineId: 'strength',
        label: 'مبتدی',
        description: 'سبک مبتدی',
        minDays: 2,
        maxDays: 3,
        levels: ['beginner'],
      ),
      StyleOption(
        id: 'advanced_style',
        disciplineId: 'strength',
        label: 'پیشرفته',
        description: 'سبک پیشرفته',
        minDays: 4,
        maxDays: 6,
        levels: ['advanced'],
      ),
      StyleOption(
        id: 'full_body',
        disciplineId: 'bodybuilding',
        label: 'فول بادی',
        description: 'تمام بدن',
        minDays: 2,
        maxDays: 4,
        levels: ['beginner', 'intermediate'],
        recommendedDays: 3,
      ),
      StyleOption(
        id: 'bro_split',
        disciplineId: 'bodybuilding',
        label: 'اسپلیت تفکیکی',
        description: 'اسپلیت ۵ روزه',
        minDays: 5,
        maxDays: 5,
        levels: ['intermediate', 'advanced'],
        recommendedDays: 5,
      ),
    ],
    goals: [
      GoalOption(
        id: 'strength_goal',
        label: 'قدرت',
        compatibleDisciplines: ['strength'],
      ),
      GoalOption(
        id: 'mobility_goal',
        label: 'تحرک',
        compatibleDisciplines: ['mobility'],
      ),
    ],
    levels: [],
    sessionMinutes: [30, 60],
    locations: [],
    equipment: [],
    injuries: [],
    maxDisciplines: 2,
    minDaysPerWeek: 2,
    maxDaysPerWeek: 6,
    minSessionMinutes: 10,
    maxSessionMinutes: 180,
  );

  test('rejects a style that is not available at the selected level', () {
    final isValid = isWorkoutProfileStepValid(
      step: 1,
      options: options,
      selectedDisciplines: ['strength'],
      selectedStyles: {'strength': 'beginner_style'},
      selectedLevel: 'advanced',
      primaryGoal: null,
      daysPerWeek: 3,
      sessionMinutes: 60,
    );

    expect(isValid, isFalse);
  });

  test('rejects a goal incompatible with the selected disciplines', () {
    final isValid = isWorkoutProfileStepValid(
      step: 2,
      options: options,
      selectedDisciplines: ['strength'],
      selectedStyles: {'strength': 'beginner_style'},
      selectedLevel: 'beginner',
      primaryGoal: 'mobility_goal',
      daysPerWeek: 3,
      sessionMinutes: 60,
    );

    expect(isValid, isFalse);
  });

  test('applies the selected style day range', () {
    final isValid = isWorkoutProfileStepValid(
      step: 3,
      options: options,
      selectedDisciplines: ['strength'],
      selectedStyles: {'strength': 'beginner_style'},
      selectedLevel: 'beginner',
      primaryGoal: 'strength_goal',
      daysPerWeek: 4,
      sessionMinutes: 60,
    );

    expect(isValid, isFalse);
  });

  test('validates injury areas max 2 selection in step 4', () {
    final validInjuries = isWorkoutProfileStepValid(
      step: 4,
      options: options,
      selectedDisciplines: ['strength'],
      selectedStyles: {'strength': 'beginner_style'},
      selectedLevel: 'beginner',
      primaryGoal: 'strength_goal',
      daysPerWeek: 3,
      sessionMinutes: 60,
      injuryAreas: ['knee', 'lower_back'],
    );
    expect(validInjuries, isTrue);

    final invalidInjuries = isWorkoutProfileStepValid(
      step: 4,
      options: options,
      selectedDisciplines: ['strength'],
      selectedStyles: {'strength': 'beginner_style'},
      selectedLevel: 'beginner',
      primaryGoal: 'strength_goal',
      daysPerWeek: 3,
      sessionMinutes: 60,
      injuryAreas: ['knee', 'lower_back', 'shoulder'],
    );
    expect(invalidInjuries, isFalse);
  });

  group('allowedWorkoutDaysRange', () {
    test(
      'one discipline + bro_split returns style range and recommendedDays',
      () {
        final range = allowedWorkoutDaysRange(
          options: options,
          disciplines: ['bodybuilding'],
          styles: {'bodybuilding': 'bro_split'},
          level: 'advanced',
        );
        expect(range.min, 5);
        expect(range.max, 5);
        expect(range.recommended, 5);
      },
    );

    test(
      'one discipline + full_body returns style range and recommendedDays',
      () {
        final range = allowedWorkoutDaysRange(
          options: options,
          disciplines: ['bodybuilding'],
          styles: {'bodybuilding': 'full_body'},
          level: 'beginner',
        );
        expect(range.min, 2);
        expect(range.max, 4);
        expect(range.recommended, 3);
      },
    );

    test(
      'two disciplines returns global options range and no recommendation',
      () {
        final range = allowedWorkoutDaysRange(
          options: options,
          disciplines: ['bodybuilding', 'strength'],
          styles: {'bodybuilding': 'bro_split', 'strength': 'advanced_style'},
          level: 'advanced',
        );
        expect(range.min, options.minDaysPerWeek);
        expect(range.max, options.maxDaysPerWeek);
        expect(range.recommended, isNull);
      },
    );

    test(
      'unavailable style or mismatched level returns global options range',
      () {
        // bro_split is only available for 'advanced', not 'beginner'
        final range = allowedWorkoutDaysRange(
          options: options,
          disciplines: ['bodybuilding'],
          styles: {'bodybuilding': 'bro_split'},
          level: 'beginner',
        );
        expect(range.min, options.minDaysPerWeek);
        expect(range.max, options.maxDaysPerWeek);
        expect(range.recommended, isNull);
      },
    );
  });

  group('syncDaysPerWeek', () {
    test('keeps current value if still within range', () {
      final synced = syncDaysPerWeek(
        currentDays: 3,
        min: 2,
        max: 4,
        recommended: 3,
      );
      expect(synced, 3);
    });

    test('uses recommended when current value is out of range', () {
      final synced = syncDaysPerWeek(
        currentDays: 3,
        min: 5,
        max: 5,
        recommended: 5,
      );
      expect(synced, 5);
    });

    test('clamps to min when below range and no recommended', () {
      final synced = syncDaysPerWeek(
        currentDays: 2,
        min: 4,
        max: 6,
      );
      expect(synced, 4);
    });

    test('clamps to max when above range and no recommended', () {
      final synced = syncDaysPerWeek(
        currentDays: 7,
        min: 2,
        max: 5,
      );
      expect(synced, 5);
    });
  });

  group('Step-3 validity with allowedWorkoutDaysRange', () {
    test(
      'stale value (3 with a 5-only style) is invalid, synced value (5) is valid',
      () {
      final isStaleValid = isWorkoutProfileStepValid(
        step: 3,
        options: options,
        selectedDisciplines: ['bodybuilding'],
        selectedStyles: {'bodybuilding': 'bro_split'},
        selectedLevel: 'advanced',
        primaryGoal: 'strength_goal',
        daysPerWeek: 3, // Stale default
        sessionMinutes: 60,
      );
      expect(isStaleValid, isFalse);

      final range = allowedWorkoutDaysRange(
        options: options,
        disciplines: ['bodybuilding'],
        styles: {'bodybuilding': 'bro_split'},
        level: 'advanced',
      );
      final syncedDays = syncDaysPerWeek(
        currentDays: 3,
        min: range.min,
        max: range.max,
        recommended: range.recommended,
      );
      expect(syncedDays, 5);

      final isSyncedValid = isWorkoutProfileStepValid(
        step: 3,
        options: options,
        selectedDisciplines: ['bodybuilding'],
        selectedStyles: {'bodybuilding': 'bro_split'},
        selectedLevel: 'advanced',
        primaryGoal: 'strength_goal',
        daysPerWeek: syncedDays,
        sessionMinutes: 60,
      );
      expect(isSyncedValid, isTrue);
    });
  });

  group('pruneStylesForLevel', () {
    test('keeps valid styles when compatible with new level', () {
      final result = pruneStylesForLevel(
        options: options,
        styles: {'bodybuilding': 'full_body'},
        level: 'intermediate',
      );
      expect(result.styles, {'bodybuilding': 'full_body'});
      expect(result.removedDisciplineIds, isEmpty);
    });

    test('removes invalid styles and reports removed discipline IDs', () {
      final result = pruneStylesForLevel(
        options: options,
        styles: {
          'bodybuilding': 'bro_split',
          'strength': 'beginner_style',
        },
        level: 'beginner',
      );
      // bro_split is only intermediate/advanced -> removed
      // beginner_style is beginner -> kept
      expect(result.styles, {'strength': 'beginner_style'});
      expect(result.removedDisciplineIds, ['bodybuilding']);
    });

    test('a level change from intermediate to beginner removes bro_split', () {
      final result = pruneStylesForLevel(
        options: options,
        styles: {'bodybuilding': 'bro_split'},
        level: 'beginner',
      );
      expect(result.styles, isEmpty);
      expect(result.removedDisciplineIds, ['bodybuilding']);
    });
  });
}
