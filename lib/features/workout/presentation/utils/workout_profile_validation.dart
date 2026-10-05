import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';

({List<String> disciplines, Map<String, String> styles})
removeWorkoutDisciplineSelection({
  required List<String> disciplines,
  required Map<String, String> styles,
  required String disciplineId,
}) {
  final updatedDisciplines = List<String>.from(disciplines)
    ..remove(disciplineId);
  final updatedStyles = Map<String, String>.from(styles)..remove(disciplineId);
  return (disciplines: updatedDisciplines, styles: updatedStyles);
}

({int min, int max, int? recommended}) allowedWorkoutDaysRange({
  required WorkoutOptions options,
  required List<String> disciplines,
  required Map<String, String> styles,
  required String level,
}) {
  if (disciplines.length == 1) {
    final disciplineId = disciplines.single;
    final styleId = styles[disciplineId];
    if (styleId != null && styleId.isNotEmpty) {
      for (final style in options.styles) {
        if (style.id == styleId &&
            style.disciplineId == disciplineId &&
            style.isAvailable &&
            style.levels.contains(level)) {
          return (
            min: style.minDays,
            max: style.maxDays,
            recommended: style.recommendedDays,
          );
        }
      }
    }
  }
  return (
    min: options.minDaysPerWeek,
    max: options.maxDaysPerWeek,
    recommended: null,
  );
}

int syncDaysPerWeek({
  required int currentDays,
  required int min,
  required int max,
  int? recommended,
}) {
  if (currentDays >= min && currentDays <= max) {
    return currentDays;
  }
  if (recommended != null && recommended >= min && recommended <= max) {
    return recommended;
  }
  return currentDays.clamp(min, max);
}

bool isWorkoutProfileStepValid({
  required int step,
  required WorkoutOptions options,
  required List<String> selectedDisciplines,
  required Map<String, String> selectedStyles,
  required String selectedLevel,
  required String? primaryGoal,
  required int daysPerWeek,
  required int sessionMinutes,
  String? secondaryGoal,
  List<String> injuryAreas = const [],
  List<String> medicalConditions = const [],
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
      if (!options.levels.any((l) => l.id == selectedLevel && l.isAvailable)) {
        return false;
      }
      return selectedDisciplines.every((disciplineId) {
        final styleId = selectedStyles[disciplineId];
        if (styleId == null || styleId.isEmpty) return false;
        return options.styles.any(
          (style) =>
              style.id == styleId &&
              style.disciplineId == disciplineId &&
              style.isAvailable &&
              style.levels.contains(selectedLevel),
        );
      });
    case 2:
      if (primaryGoal == null || primaryGoal.isEmpty) return false;

      final isPrimaryValid = options.goals.any(
        (goal) =>
            goal.id == primaryGoal &&
            goal.isAvailable &&
            goal.compatibleDisciplines.any(selectedDisciplines.contains),
      );
      if (!isPrimaryValid) return false;

      if (secondaryGoal != null && secondaryGoal.isNotEmpty) {
        if (secondaryGoal == primaryGoal) return false;
        final isSecondaryValid = options.goals.any(
          (goal) =>
              goal.id == secondaryGoal &&
              goal.isAvailable &&
              goal.compatibleDisciplines.any(selectedDisciplines.contains),
        );
        if (!isSecondaryValid) return false;
      }

      return true;
    case 3:
      final range = allowedWorkoutDaysRange(
        options: options,
        disciplines: selectedDisciplines,
        styles: selectedStyles,
        level: selectedLevel,
      );
      final isDaysValid = daysPerWeek >= range.min && daysPerWeek <= range.max;
      final isMinutesValid =
          sessionMinutes >= options.minSessionMinutes &&
          sessionMinutes <= options.maxSessionMinutes;

      return isDaysValid && isMinutesValid;
    case 4:
      return injuryAreas.length <= 2;
    default:
      return false;
  }
}
