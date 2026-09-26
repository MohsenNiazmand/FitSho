import 'package:fitsho/features/workout/data/models/workout_models.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';

extension WorkoutOptionItemModelX on WorkoutOptionItemModel {
  WorkoutOptionItem toEntity() {
    return WorkoutOptionItem(
      id: id,
      label: label,
      description: description,
      isAvailable: isAvailable,
    );
  }
}

extension DisciplineOptionModelX on DisciplineOptionModel {
  DisciplineOption toEntity() {
    return DisciplineOption(
      id: id,
      label: label,
      description: description,
      isAvailable: isAvailable,
    );
  }
}

extension StyleOptionModelX on StyleOptionModel {
  StyleOption toEntity() {
    return StyleOption(
      id: id,
      disciplineId: disciplineId,
      label: label,
      description: description,
      minDays: minDays,
      maxDays: maxDays,
      levels: levels,
      isAvailable: isAvailable,
    );
  }
}

extension GoalOptionModelX on GoalOptionModel {
  GoalOption toEntity() {
    return GoalOption(
      id: id,
      label: label,
      compatibleDisciplines: compatibleDisciplines,
      isAvailable: isAvailable,
    );
  }
}

extension InjuryOptionModelX on InjuryOptionModel {
  InjuryOption toEntity() {
    return InjuryOption(
      id: id,
      label: label,
      description: description,
      requiresReferral: requiresReferral,
      isAvailable: isAvailable,
    );
  }
}

extension WorkoutOptionsModelX on WorkoutOptionsModel {
  WorkoutOptions toEntity() {
    return WorkoutOptions(
      disciplines: disciplines.map((e) => e.toEntity()).toList(),
      styles: styles.map((e) => e.toEntity()).toList(),
      goals: goals.map((e) => e.toEntity()).toList(),
      levels: levels.map((e) => e.toEntity()).toList(),
      sessionMinutes: sessionMinutes,
      locations: locations.map((e) => e.toEntity()).toList(),
      equipment: equipment.map((e) => e.toEntity()).toList(),
      injuries: injuries.map((e) => e.toEntity()).toList(),
      maxDisciplines: maxDisciplines,
      minDaysPerWeek: minDaysPerWeek,
      maxDaysPerWeek: maxDaysPerWeek,
    );
  }
}

extension WorkoutProfileModelX on WorkoutProfileModel {
  WorkoutProfile toEntity({bool shouldRegeneratePlan = false}) {
    return WorkoutProfile(
      id: id,
      userId: userId,
      disciplines: disciplines,
      styles: styles,
      goal: goal,
      level: level,
      daysPerWeek: daysPerWeek,
      sessionMinutes: sessionMinutes,
      location: location,
      equipment: equipment,
      injuries: injuries,
      injuryNotes: injuryNotes,
      painLevel: painLevel,
      shouldRegeneratePlan: shouldRegeneratePlan,
    );
  }
}

extension WorkoutExerciseItemModelX on WorkoutExerciseItemModel {
  WorkoutExerciseItem toEntity() {
    return WorkoutExerciseItem(
      itemId: itemId,
      exerciseId: exerciseId,
      name: name,
      sets: sets,
      reps: reps,
      durationSec: durationSec,
      restSec: restSec,
      rpe: rpe,
      notes: notes,
    );
  }
}

extension WorkoutDayModelX on WorkoutDayModel {
  WorkoutDay toEntity() {
    return WorkoutDay(
      day: day,
      isRest: isRest,
      title: title,
      focus: focus,
      durationMin: durationMin,
      warmup: warmup.map((e) => e.toEntity()).toList(),
      main: main.map((e) => e.toEntity()).toList(),
      cooldown: cooldown.map((e) => e.toEntity()).toList(),
    );
  }
}

extension WorkoutNotesModelX on WorkoutNotesModel {
  WorkoutNotes toEntity() {
    return WorkoutNotes(progression: progression, safety: safety);
  }
}

extension WorkoutProfileSnapshotModelX on WorkoutProfileSnapshotModel {
  WorkoutProfileSnapshot toEntity() {
    return WorkoutProfileSnapshot(
      disciplines: disciplines,
      styles: styles,
      goal: goal,
      level: level,
      daysPerWeek: daysPerWeek,
      sessionMinutes: sessionMinutes,
      location: location,
      equipment: equipment,
      injuries: injuries,
      painLevel: painLevel,
    );
  }
}

extension WorkoutPlanModelX on WorkoutPlanModel {
  WorkoutPlan toEntity() {
    return WorkoutPlan(
      id: id,
      userId: userId,
      status: status,
      summary: summary,
      notes: notes.toEntity(),
      days: days.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      profileSnapshot: profileSnapshot?.toEntity(),
      remainingFullGenerations: remainingFullGenerations,
      remainingExerciseSwaps: remainingExerciseSwaps,
    );
  }
}

extension WorkoutExerciseItemX on WorkoutExerciseItem {
  WorkoutExerciseItemModel toModel() {
    return WorkoutExerciseItemModel(
      itemId: itemId,
      exerciseId: exerciseId,
      name: name,
      sets: sets,
      reps: reps,
      durationSec: durationSec,
      restSec: restSec,
      rpe: rpe,
      notes: notes,
    );
  }
}

extension WorkoutDayX on WorkoutDay {
  WorkoutDayModel toModel() {
    return WorkoutDayModel(
      day: day,
      isRest: isRest,
      title: title,
      focus: focus,
      durationMin: durationMin,
      warmup: warmup.map((e) => e.toModel()).toList(),
      main: main.map((e) => e.toModel()).toList(),
      cooldown: cooldown.map((e) => e.toModel()).toList(),
    );
  }
}

extension WorkoutNotesX on WorkoutNotes {
  WorkoutNotesModel toModel() {
    return WorkoutNotesModel(progression: progression, safety: safety);
  }
}

extension WorkoutProfileSnapshotX on WorkoutProfileSnapshot {
  WorkoutProfileSnapshotModel toModel() {
    return WorkoutProfileSnapshotModel(
      disciplines: disciplines,
      styles: styles,
      goal: goal,
      level: level,
      daysPerWeek: daysPerWeek,
      sessionMinutes: sessionMinutes,
      location: location,
      equipment: equipment,
      injuries: injuries,
      painLevel: painLevel,
    );
  }
}

extension WorkoutPlanX on WorkoutPlan {
  WorkoutPlanModel toModel() {
    return WorkoutPlanModel(
      id: id,
      userId: userId,
      status: status,
      summary: summary,
      notes: notes.toModel(),
      days: days.map((e) => e.toModel()).toList(),
      createdAt: createdAt,
      profileSnapshot: profileSnapshot?.toModel(),
      remainingFullGenerations: remainingFullGenerations,
      remainingExerciseSwaps: remainingExerciseSwaps,
    );
  }
}
