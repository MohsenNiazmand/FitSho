import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';

bool isWorkoutProfileStepValid({
  required int step,
  required WorkoutOptions options,
  required List<String> selectedDisciplines,
  required Map<String, String> selectedStyles,
  required String selectedLevel,
  required String? selectedGoal,
  required int daysPerWeek,
}) {
  switch (step) {
    case 0:
      return selectedDisciplines.isNotEmpty &&
          selectedDisciplines.length <= options.maxDisciplines &&
          selectedDisciplines.every(
            (id) => options.disciplines.any(
              (discipline) => discipline.id == id && discipline.isAvailable,
            ),
          );
    case 1:
      return selectedDisciplines.every((disciplineId) {
        final styleId = selectedStyles[disciplineId];
        return options.styles.any(
          (style) =>
              style.id == styleId &&
              style.disciplineId == disciplineId &&
              style.isAvailable &&
              style.levels.contains(selectedLevel),
        );
      });
    case 2:
      return options.goals.any(
        (goal) =>
            goal.id == selectedGoal &&
            goal.isAvailable &&
            goal.compatibleDisciplines.any(selectedDisciplines.contains),
      );
    case 3:
      var minDays = options.minDaysPerWeek;
      var maxDays = options.maxDaysPerWeek;
      if (selectedDisciplines.length == 1) {
        final styleId = selectedStyles[selectedDisciplines.single];
        for (final style in options.styles) {
          if (style.id == styleId &&
              style.disciplineId == selectedDisciplines.single &&
              style.isAvailable &&
              style.levels.contains(selectedLevel)) {
            minDays = style.minDays;
            maxDays = style.maxDays;
            break;
          }
        }
      }
      return daysPerWeek >= minDays && daysPerWeek <= maxDays;
    case 4:
      return true;
    default:
      return false;
  }
}
