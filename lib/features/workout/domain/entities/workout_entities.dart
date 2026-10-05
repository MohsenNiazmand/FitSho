class WorkoutOptionItem {
  const WorkoutOptionItem({
    required this.id,
    required this.label,
    this.description,
    this.isAvailable = true,
  });

  final String id;
  final String label;
  final String? description;
  final bool isAvailable;
}

class DisciplineOption {
  const DisciplineOption({
    required this.id,
    required this.label,
    required this.description,
    this.isAvailable = true,
  });

  final String id;
  final String label;
  final String description;
  final bool isAvailable;
}

class StyleOption {
  const StyleOption({
    required this.id,
    required this.disciplineId,
    required this.label,
    required this.description,
    required this.minDays,
    required this.maxDays,
    required this.levels,
    this.isAvailable = true,
  });

  final String id;
  final String disciplineId;
  final String label;
  final String description;
  final int minDays;
  final int maxDays;
  final List<String> levels;
  final bool isAvailable;
}

class GoalOption {
  const GoalOption({
    required this.id,
    required this.label,
    required this.compatibleDisciplines,
    this.isAvailable = true,
  });

  final String id;
  final String label;
  final List<String> compatibleDisciplines;
  final bool isAvailable;
}

class InjuryOption {
  const InjuryOption({
    required this.id,
    required this.label,
    required this.description,
    required this.requiresReferral,
    this.isAvailable = true,
  });

  final String id;
  final String label;
  final String description;
  final bool requiresReferral;
  final bool isAvailable;
}

class WorkoutOptions {
  const WorkoutOptions({
    required this.disciplines,
    required this.styles,
    required this.goals,
    required this.levels,
    required this.sessionMinutes,
    required this.locations,
    required this.equipment,
    required this.injuries,
    this.injuryAreas = const [],
    this.medicalConditions = const [],
    required this.maxDisciplines,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    this.minSessionMinutes = 10,
    this.maxSessionMinutes = 180,
  });

  final List<DisciplineOption> disciplines;
  final List<StyleOption> styles;
  final List<GoalOption> goals;
  final List<WorkoutOptionItem> levels;
  final List<int> sessionMinutes;
  final List<WorkoutOptionItem> locations;
  final List<WorkoutOptionItem> equipment;
  final List<InjuryOption> injuries;
  final List<InjuryOption> injuryAreas;
  final List<InjuryOption> medicalConditions;
  final int maxDisciplines;
  final int minDaysPerWeek;
  final int maxDaysPerWeek;
  final int minSessionMinutes;
  final int maxSessionMinutes;
}

class WorkoutProfile {
  const WorkoutProfile({
    required this.id,
    required this.userId,
    required this.disciplines,
    required this.styles,
    required this.primaryGoal,
    this.secondaryGoal,
    required this.level,
    required this.daysPerWeek,
    required this.sessionMinutes,
    required this.location,
    required this.equipment,
    required this.injuryAreas,
    required this.medicalConditions,
    this.injuryNotes,
    required this.painLevel,
    this.shouldRegeneratePlan = false,
  });

  final String id;
  final String userId;
  final List<String> disciplines;
  final Map<String, String> styles; // { disciplineId: styleId }
  final String primaryGoal;
  final String? secondaryGoal;
  final String level;
  final int daysPerWeek;
  final int sessionMinutes;
  final String location;
  final List<String> equipment;
  final List<String> injuryAreas;
  final List<String> medicalConditions;
  final String? injuryNotes;
  final int painLevel;
  final bool shouldRegeneratePlan;
}

class WorkoutExerciseItem {
  const WorkoutExerciseItem({
    required this.itemId,
    required this.exerciseId,
    required this.name,
    this.gifUrl,
    this.videoUrl,
    this.cue,
    required this.sets,
    this.reps,
    this.durationSec,
    required this.restSec,
    this.rpe,
    this.notes,
  });

  final String itemId;
  final String exerciseId;
  final String name;
  final String? gifUrl;
  final String? videoUrl;
  final String? cue;
  final int sets;
  final String? reps;
  final int? durationSec;
  final int restSec;
  final double? rpe;
  final String? notes;
}

class WorkoutSession {
  const WorkoutSession({
    required this.sessionId,
    required this.sessionNumber,
    required this.title,
    required this.focus,
    required this.durationMin,
    required this.warmup,
    required this.main,
    required this.cooldown,
  });

  final String sessionId;
  final int sessionNumber;
  final String title;
  final List<String> focus;
  final int durationMin;
  final List<WorkoutExerciseItem> warmup;
  final List<WorkoutExerciseItem> main;
  final List<WorkoutExerciseItem> cooldown;
}

class WorkoutNotes {
  const WorkoutNotes({required this.progression, required this.safety});

  final String progression;
  final List<String> safety;
}

class WorkoutProfileSnapshot {
  const WorkoutProfileSnapshot({
    this.disciplines = const [],
    this.styles = const {},
    this.primaryGoal = '',
    this.secondaryGoal,
    this.level = '',
    this.daysPerWeek = 0,
    this.sessionMinutes = 0,
    this.location = '',
    this.equipment = const [],
    this.injuryAreas = const [],
    this.medicalConditions = const [],
    this.painLevel = 0,
  });

  final List<String> disciplines;
  final Map<String, String> styles;
  final String primaryGoal;
  final String? secondaryGoal;
  final String level;
  final int daysPerWeek;
  final int sessionMinutes;
  final String location;
  final List<String> equipment;
  final List<String> injuryAreas;
  final List<String> medicalConditions;
  final int painLevel;
}

class WorkoutPlan {
  const WorkoutPlan({
    required this.id,
    required this.userId,
    required this.status,
    this.summary,
    required this.notes,
    required this.sessions,
    required this.createdAt,
    this.profileSnapshot,
    this.remainingFullGenerations = 3,
    this.remainingExerciseSwaps = 5,
  });

  final String id;
  final String userId;
  final String status;
  final String? summary;
  final WorkoutNotes notes;
  final List<WorkoutSession> sessions;
  final DateTime createdAt;
  final WorkoutProfileSnapshot? profileSnapshot;
  final int remainingFullGenerations;
  final int remainingExerciseSwaps;
}

class WorkoutPlanHistory {
  const WorkoutPlanHistory({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<WorkoutPlan> items;
  final int total;
  final int page;
  final int limit;
}
