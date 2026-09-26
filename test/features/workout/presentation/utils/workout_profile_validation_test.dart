import 'package:flutter_test/flutter_test.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/utils/workout_profile_validation.dart';

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
  );

  test('rejects a style that is not available at the selected level', () {
    final isValid = isWorkoutProfileStepValid(
      step: 1,
      options: options,
      selectedDisciplines: ['strength'],
      selectedStyles: {'strength': 'beginner_style'},
      selectedLevel: 'advanced',
      selectedGoal: null,
      daysPerWeek: 3,
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
      selectedGoal: 'mobility_goal',
      daysPerWeek: 3,
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
      selectedGoal: 'strength_goal',
      daysPerWeek: 4,
    );

    expect(isValid, isFalse);
  });
}
