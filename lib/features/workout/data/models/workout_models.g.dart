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
  maxDisciplines: _parseInt(json['maxDisciplines']),
  minDaysPerWeek: _parseInt(json['minDaysPerWeek']),
  maxDaysPerWeek: _parseInt(json['maxDaysPerWeek']),
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
  'maxDisciplines': instance.maxDisciplines,
  'minDaysPerWeek': instance.minDaysPerWeek,
  'maxDaysPerWeek': instance.maxDaysPerWeek,
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
      goal: json['goal'] as String,
      level: json['level'] as String,
      daysPerWeek: _parseInt(json['daysPerWeek']),
      sessionMinutes: _parseInt(json['sessionMinutes']),
      location: json['location'] as String,
      equipment: (json['equipment'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      injuries: (json['injuries'] as List<dynamic>)
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
  'goal': instance.goal,
  'level': instance.level,
  'daysPerWeek': instance.daysPerWeek,
  'sessionMinutes': instance.sessionMinutes,
  'location': instance.location,
  'equipment': instance.equipment,
  'injuries': instance.injuries,
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
  goal: json['goal'] as String,
  level: json['level'] as String,
  daysPerWeek: (json['daysPerWeek'] as num).toInt(),
  sessionMinutes: (json['sessionMinutes'] as num).toInt(),
  location: json['location'] as String,
  equipment: (json['equipment'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  injuries: (json['injuries'] as List<dynamic>)
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
  'goal': instance.goal,
  'level': instance.level,
  'daysPerWeek': instance.daysPerWeek,
  'sessionMinutes': instance.sessionMinutes,
  'location': instance.location,
  'equipment': instance.equipment,
  'injuries': instance.injuries,
  'injuryNotes': instance.injuryNotes,
  'painLevel': instance.painLevel,
};

WorkoutExerciseItemModel _$WorkoutExerciseItemModelFromJson(
  Map<String, dynamic> json,
) => WorkoutExerciseItemModel(
  itemId: json['itemId'] as String,
  exerciseId: json['exerciseId'] as String,
  name: json['name'] as String,
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
  'sets': instance.sets,
  'reps': instance.reps,
  'durationSec': instance.durationSec,
  'restSec': instance.restSec,
  'rpe': instance.rpe,
  'notes': instance.notes,
};

WorkoutDayModel _$WorkoutDayModelFromJson(
  Map<String, dynamic> json,
) => WorkoutDayModel(
  day: json['day'] as String,
  isRest: json['isRest'] as bool,
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

Map<String, dynamic> _$WorkoutDayModelToJson(WorkoutDayModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'isRest': instance.isRest,
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

WorkoutPlanModel _$WorkoutPlanModelFromJson(Map<String, dynamic> json) =>
    WorkoutPlanModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      summary: json['summary'] as String?,
      notes: WorkoutNotesModel.fromJson(json['notes'] as Map<String, dynamic>),
      days: (json['days'] as List<dynamic>)
          .map((e) => WorkoutDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
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
      'days': instance.days,
      'createdAt': instance.createdAt.toIso8601String(),
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
      day: json['day'] as String,
      itemId: json['itemId'] as String,
    );

Map<String, dynamic> _$SwapExerciseRequestToJson(
  SwapExerciseRequest instance,
) => <String, dynamic>{'day': instance.day, 'itemId': instance.itemId};
