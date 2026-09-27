// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutOptionItemModel _$WorkoutOptionItemModelFromJson(
  Map<String, dynamic> json,
) => WorkoutOptionItemModel(
  id: json['id'] as String,
  label: json['label'] as String,
  description: json['description'] as String?,
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$WorkoutOptionItemModelToJson(
  WorkoutOptionItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'description': instance.description,
  'isAvailable': instance.isAvailable,
};

DisciplineOptionModel _$DisciplineOptionModelFromJson(
  Map<String, dynamic> json,
) => DisciplineOptionModel(
  id: json['id'] as String,
  label: json['label'] as String,
  description: json['description'] as String,
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$DisciplineOptionModelToJson(
  DisciplineOptionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'description': instance.description,
  'isAvailable': instance.isAvailable,
};

StyleOptionModel _$StyleOptionModelFromJson(Map<String, dynamic> json) =>
    StyleOptionModel(
      id: json['id'] as String,
      disciplineId: json['disciplineId'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
      minDays: _parseInt(json['minDays']),
      maxDays: _parseInt(json['maxDays']),
      levels: (json['levels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$StyleOptionModelToJson(StyleOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'disciplineId': instance.disciplineId,
      'label': instance.label,
      'description': instance.description,
      'minDays': instance.minDays,
      'maxDays': instance.maxDays,
      'levels': instance.levels,
      'isAvailable': instance.isAvailable,
    };

GoalOptionModel _$GoalOptionModelFromJson(Map<String, dynamic> json) =>
    GoalOptionModel(
      id: json['id'] as String,
      label: json['label'] as String,
      compatibleDisciplines: (json['compatibleDisciplines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$GoalOptionModelToJson(GoalOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'compatibleDisciplines': instance.compatibleDisciplines,
      'isAvailable': instance.isAvailable,
    };

InjuryOptionModel _$InjuryOptionModelFromJson(Map<String, dynamic> json) =>
    InjuryOptionModel(
      id: json['id'] as String,
      label: json['label'] as String,
      description: json['description'] as String,
      requiresReferral: json['requiresReferral'] as bool,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$InjuryOptionModelToJson(InjuryOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'description': instance.description,
      'requiresReferral': instance.requiresReferral,
      'isAvailable': instance.isAvailable,
    };

WorkoutOptionsModel _$WorkoutOptionsModelFromJson(
  Map<String, dynamic> json,
) => WorkoutOptionsModel(
  disciplines: (json['disciplines'] as List<dynamic>)
      .map((e) => DisciplineOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  styles: (json['styles'] as List<dynamic>)
      .map((e) => StyleOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  goals: (json['goals'] as List<dynamic>)
      .map((e) => GoalOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  levels: (json['levels'] as List<dynamic>)
      .map((e) => WorkoutOptionItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionMinutes: _parseIntList(json['sessionMinutes']),
  locations: (json['locations'] as List<dynamic>)
      .map((e) => WorkoutOptionItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  equipment: (json['equipment'] as List<dynamic>)
      .map((e) => WorkoutOptionItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  injuries: (json['injuries'] as List<dynamic>)
      .map((e) => InjuryOptionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  injuryAreas:
      (json['injuryAreas'] as List<dynamic>?)
          ?.map((e) => InjuryOptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  medicalConditions:
      (json['medicalConditions'] as List<dynamic>?)
          ?.map((e) => InjuryOptionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  maxDisciplines: _parseInt(json['maxDisciplines']),
  minDaysPerWeek: _parseInt(json['minDaysPerWeek']),
  maxDaysPerWeek: _parseInt(json['maxDaysPerWeek']),
  minSessionMinutes: json['minSessionMinutes'] == null
      ? 10
      : _parseInt(json['minSessionMinutes']),
  maxSessionMinutes: json['maxSessionMinutes'] == null
      ? 180
      : _parseInt(json['maxSessionMinutes']),
);

Map<String, dynamic> _$WorkoutOptionsModelToJson(
  WorkoutOptionsModel instance,
) => <String, dynamic>{
  'disciplines': instance.disciplines,
  'styles': instance.styles,
  'goals': instance.goals,
  'levels': instance.levels,
  'sessionMinutes': instance.sessionMinutes,
  'locations': instance.locations,
  'equipment': instance.equipment,
  'injuries': instance.injuries,
  'injuryAreas': instance.injuryAreas,
  'medicalConditions': instance.medicalConditions,
  'maxDisciplines': instance.maxDisciplines,
  'minDaysPerWeek': instance.minDaysPerWeek,
  'maxDaysPerWeek': instance.maxDaysPerWeek,
  'minSessionMinutes': instance.minSessionMinutes,
  'maxSessionMinutes': instance.maxSessionMinutes,
};

WorkoutOptionsEnvelope _$WorkoutOptionsEnvelopeFromJson(
  Map<String, dynamic> json,
) => WorkoutOptionsEnvelope(
  success: json['success'] as bool,
  data: WorkoutOptionsModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WorkoutOptionsEnvelopeToJson(
  WorkoutOptionsEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

WorkoutProfileModel _$WorkoutProfileModelFromJson(Map<String, dynamic> json) =>
    WorkoutProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      disciplines: (json['disciplines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      styles: Map<String, String>.from(json['styles'] as Map),
      primaryGoal: json['primaryGoal'] as String,
      secondaryGoal: json['secondaryGoal'] as String?,
      level: json['level'] as String,
      daysPerWeek: _parseInt(json['daysPerWeek']),
      sessionMinutes: _parseInt(json['sessionMinutes']),
      location: json['location'] as String,
      equipment: (json['equipment'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      injuryAreas: (json['injuryAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      medicalConditions: (json['medicalConditions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      injuryNotes: json['injuryNotes'] as String?,
      painLevel: _parseInt(json['painLevel']),
    );

Map<String, dynamic> _$WorkoutProfileModelToJson(
  WorkoutProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'disciplines': instance.disciplines,
  'styles': instance.styles,
  'primaryGoal': instance.primaryGoal,
  'secondaryGoal': instance.secondaryGoal,
  'level': instance.level,
  'daysPerWeek': instance.daysPerWeek,
  'sessionMinutes': instance.sessionMinutes,
  'location': instance.location,
  'equipment': instance.equipment,
  'injuryAreas': instance.injuryAreas,
  'medicalConditions': instance.medicalConditions,
  'injuryNotes': instance.injuryNotes,
  'painLevel': instance.painLevel,
};

UpsertWorkoutProfileRequest _$UpsertWorkoutProfileRequestFromJson(
  Map<String, dynamic> json,
) => UpsertWorkoutProfileRequest(
  disciplines: (json['disciplines'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  styles: Map<String, String>.from(json['styles'] as Map),
  primaryGoal: json['primaryGoal'] as String,
  secondaryGoal: json['secondaryGoal'] as String?,
  level: json['level'] as String,
  daysPerWeek: (json['daysPerWeek'] as num).toInt(),
  sessionMinutes: (json['sessionMinutes'] as num).toInt(),
  location: json['location'] as String,
  equipment: (json['equipment'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  injuryAreas: (json['injuryAreas'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  medicalConditions: (json['medicalConditions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  injuryNotes: json['injuryNotes'] as String?,
  painLevel: (json['painLevel'] as num).toInt(),
);

Map<String, dynamic> _$UpsertWorkoutProfileRequestToJson(
  UpsertWorkoutProfileRequest instance,
) => <String, dynamic>{
  'disciplines': instance.disciplines,
  'styles': instance.styles,
  'primaryGoal': instance.primaryGoal,
  'secondaryGoal': instance.secondaryGoal,
  'level': instance.level,
  'daysPerWeek': instance.daysPerWeek,
  'sessionMinutes': instance.sessionMinutes,
  'location': instance.location,
  'equipment': instance.equipment,
  'injuryAreas': instance.injuryAreas,
  'medicalConditions': instance.medicalConditions,
  'injuryNotes': instance.injuryNotes,
  'painLevel': instance.painLevel,
};

WorkoutExerciseItemModel _$WorkoutExerciseItemModelFromJson(
  Map<String, dynamic> json,
) => WorkoutExerciseItemModel(
  itemId: json['itemId'] as String,
  exerciseId: json['exerciseId'] as String,
  name: json['name'] as String,
  gifUrl: json['gifUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
  sets: _parseInt(json['sets']),
  reps: json['reps'] as String?,
  durationSec: _parseNullableInt(json['durationSec']),
  restSec: _parseInt(json['restSec']),
  rpe: _parseNullableDouble(json['rpe']),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$WorkoutExerciseItemModelToJson(
  WorkoutExerciseItemModel instance,
) => <String, dynamic>{
  'itemId': instance.itemId,
  'exerciseId': instance.exerciseId,
  'name': instance.name,
  'gifUrl': instance.gifUrl,
  'videoUrl': instance.videoUrl,
  'sets': instance.sets,
  'reps': instance.reps,
  'durationSec': instance.durationSec,
  'restSec': instance.restSec,
  'rpe': instance.rpe,
  'notes': instance.notes,
};

WorkoutSessionModel _$WorkoutSessionModelFromJson(
  Map<String, dynamic> json,
) => WorkoutSessionModel(
  sessionId: json['sessionId'] as String,
  sessionNumber: _parseInt(json['sessionNumber']),
  title: json['title'] as String,
  focus: (json['focus'] as List<dynamic>).map((e) => e as String).toList(),
  durationMin: _parseInt(json['durationMin']),
  warmup: (json['warmup'] as List<dynamic>)
      .map((e) => WorkoutExerciseItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  main: (json['main'] as List<dynamic>)
      .map((e) => WorkoutExerciseItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  cooldown: (json['cooldown'] as List<dynamic>)
      .map((e) => WorkoutExerciseItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkoutSessionModelToJson(
  WorkoutSessionModel instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'sessionNumber': instance.sessionNumber,
  'title': instance.title,
  'focus': instance.focus,
  'durationMin': instance.durationMin,
  'warmup': instance.warmup,
  'main': instance.main,
  'cooldown': instance.cooldown,
};

WorkoutNotesModel _$WorkoutNotesModelFromJson(Map<String, dynamic> json) =>
    WorkoutNotesModel(
      progression: json['progression'] as String,
      safety: (json['safety'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WorkoutNotesModelToJson(WorkoutNotesModel instance) =>
    <String, dynamic>{
      'progression': instance.progression,
      'safety': instance.safety,
    };

WorkoutProfileSnapshotModel _$WorkoutProfileSnapshotModelFromJson(
  Map<String, dynamic> json,
) => WorkoutProfileSnapshotModel(
  disciplines:
      (json['disciplines'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  styles:
      (json['styles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  primaryGoal: json['primaryGoal'] as String? ?? '',
  secondaryGoal: json['secondaryGoal'] as String?,
  level: json['level'] as String? ?? '',
  daysPerWeek: json['daysPerWeek'] == null ? 0 : _parseInt(json['daysPerWeek']),
  sessionMinutes: json['sessionMinutes'] == null
      ? 0
      : _parseInt(json['sessionMinutes']),
  location: json['location'] as String? ?? '',
  equipment:
      (json['equipment'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  injuryAreas:
      (json['injuryAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  medicalConditions:
      (json['medicalConditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  painLevel: json['painLevel'] == null ? 0 : _parseInt(json['painLevel']),
);

Map<String, dynamic> _$WorkoutProfileSnapshotModelToJson(
  WorkoutProfileSnapshotModel instance,
) => <String, dynamic>{
  'disciplines': instance.disciplines,
  'styles': instance.styles,
  'primaryGoal': instance.primaryGoal,
  'secondaryGoal': instance.secondaryGoal,
  'level': instance.level,
  'daysPerWeek': instance.daysPerWeek,
  'sessionMinutes': instance.sessionMinutes,
  'location': instance.location,
  'equipment': instance.equipment,
  'injuryAreas': instance.injuryAreas,
  'medicalConditions': instance.medicalConditions,
  'painLevel': instance.painLevel,
};

WorkoutPlanModel _$WorkoutPlanModelFromJson(Map<String, dynamic> json) =>
    WorkoutPlanModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      summary: json['summary'] as String?,
      notes: WorkoutNotesModel.fromJson(json['notes'] as Map<String, dynamic>),
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) => WorkoutSessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      profileSnapshot: json['profileSnapshot'] == null
          ? null
          : WorkoutProfileSnapshotModel.fromJson(
              json['profileSnapshot'] as Map<String, dynamic>,
            ),
      remainingFullGenerations: json['remaining_full_generations'] == null
          ? 3
          : _parseInt(json['remaining_full_generations']),
      remainingExerciseSwaps: json['remaining_exercise_swaps'] == null
          ? 5
          : _parseInt(json['remaining_exercise_swaps']),
    );

Map<String, dynamic> _$WorkoutPlanModelToJson(WorkoutPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': instance.status,
      'summary': instance.summary,
      'notes': instance.notes,
      'sessions': instance.sessions,
      'createdAt': instance.createdAt.toIso8601String(),
      'profileSnapshot': instance.profileSnapshot,
      'remaining_full_generations': instance.remainingFullGenerations,
      'remaining_exercise_swaps': instance.remainingExerciseSwaps,
    };

WorkoutPlanEnvelope _$WorkoutPlanEnvelopeFromJson(Map<String, dynamic> json) =>
    WorkoutPlanEnvelope(
      success: json['success'] as bool,
      data: WorkoutPlanModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkoutPlanEnvelopeToJson(
  WorkoutPlanEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

SwapExerciseRequest _$SwapExerciseRequestFromJson(Map<String, dynamic> json) =>
    SwapExerciseRequest(
      sessionId: json['sessionId'] as String,
      itemId: json['itemId'] as String,
    );

Map<String, dynamic> _$SwapExerciseRequestToJson(
  SwapExerciseRequest instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'itemId': instance.itemId,
};
