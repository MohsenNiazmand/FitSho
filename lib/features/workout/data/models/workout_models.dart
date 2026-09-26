import 'package:json_annotation/json_annotation.dart';

part 'workout_models.g.dart';

int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final normalized = value
        .trim()
        .replaceAllMapped(
          RegExp(r'[۰-۹]'),
          (match) => '۰۱۲۳۴۵۶۷۸۹'.indexOf(match.group(0)!).toString(),
        )
        .replaceAll(RegExp(r'[^\d.-]'), '');
    return int.tryParse(normalized);
  }
  return null;
}

int _parseInt(dynamic value, [int defaultValue = 0]) {
  return _parseNullableInt(value) ?? defaultValue;
}

List<int> _parseIntList(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => _parseInt(item)).toList();
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) {
    final normalized = value
        .trim()
        .replaceAllMapped(
          RegExp(r'[۰-۹]'),
          (match) => '۰۱۲۳۴۵۶۷۸۹'.indexOf(match.group(0)!).toString(),
        )
        .replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(normalized);
  }
  return null;
}

@JsonSerializable()
class WorkoutOptionItemModel {
  const WorkoutOptionItemModel({
    required this.id,
    required this.label,
    this.description,
    this.isAvailable = true,
  });

  factory WorkoutOptionItemModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutOptionItemModelFromJson(json);

  final String id;
  final String label;
  final String? description;
  final bool isAvailable;

  Map<String, dynamic> toJson() => _$WorkoutOptionItemModelToJson(this);
}

@JsonSerializable()
class DisciplineOptionModel {
  const DisciplineOptionModel({
    required this.id,
    required this.label,
    required this.description,
    this.isAvailable = true,
  });

  factory DisciplineOptionModel.fromJson(Map<String, dynamic> json) =>
      _$DisciplineOptionModelFromJson(json);

  final String id;
  final String label;
  final String description;
  final bool isAvailable;

  Map<String, dynamic> toJson() => _$DisciplineOptionModelToJson(this);
}

@JsonSerializable()
class StyleOptionModel {
  const StyleOptionModel({
    required this.id,
    required this.disciplineId,
    required this.label,
    required this.description,
    required this.minDays,
    required this.maxDays,
    required this.levels,
    this.isAvailable = true,
  });

  factory StyleOptionModel.fromJson(Map<String, dynamic> json) =>
      _$StyleOptionModelFromJson(json);

  final String id;
  final String disciplineId;
  final String label;
  final String description;

  @JsonKey(fromJson: _parseInt)
  final int minDays;

  @JsonKey(fromJson: _parseInt)
  final int maxDays;

  final List<String> levels;
  final bool isAvailable;

  Map<String, dynamic> toJson() => _$StyleOptionModelToJson(this);
}

@JsonSerializable()
class GoalOptionModel {
  const GoalOptionModel({
    required this.id,
    required this.label,
    required this.compatibleDisciplines,
    this.isAvailable = true,
  });

  factory GoalOptionModel.fromJson(Map<String, dynamic> json) =>
      _$GoalOptionModelFromJson(json);

  final String id;
  final String label;
  final List<String> compatibleDisciplines;
  final bool isAvailable;

  Map<String, dynamic> toJson() => _$GoalOptionModelToJson(this);
}

@JsonSerializable()
class InjuryOptionModel {
  const InjuryOptionModel({
    required this.id,
    required this.label,
    required this.description,
    required this.requiresReferral,
    this.isAvailable = true,
  });

  factory InjuryOptionModel.fromJson(Map<String, dynamic> json) =>
      _$InjuryOptionModelFromJson(json);

  final String id;
  final String label;
  final String description;
  final bool requiresReferral;
  final bool isAvailable;

  Map<String, dynamic> toJson() => _$InjuryOptionModelToJson(this);
}

@JsonSerializable()
class WorkoutOptionsModel {
  const WorkoutOptionsModel({
    required this.disciplines,
    required this.styles,
    required this.goals,
    required this.levels,
    required this.sessionMinutes,
    required this.locations,
    required this.equipment,
    required this.injuries,
    required this.maxDisciplines,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
  });

  factory WorkoutOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutOptionsModelFromJson(json);

  final List<DisciplineOptionModel> disciplines;
  final List<StyleOptionModel> styles;
  final List<GoalOptionModel> goals;
  final List<WorkoutOptionItemModel> levels;
  @JsonKey(fromJson: _parseIntList)
  final List<int> sessionMinutes;
  final List<WorkoutOptionItemModel> locations;
  final List<WorkoutOptionItemModel> equipment;
  final List<InjuryOptionModel> injuries;

  @JsonKey(fromJson: _parseInt)
  final int maxDisciplines;

  @JsonKey(fromJson: _parseInt)
  final int minDaysPerWeek;

  @JsonKey(fromJson: _parseInt)
  final int maxDaysPerWeek;

  Map<String, dynamic> toJson() => _$WorkoutOptionsModelToJson(this);
}

@JsonSerializable()
class WorkoutOptionsEnvelope {
  const WorkoutOptionsEnvelope({required this.success, required this.data});

  factory WorkoutOptionsEnvelope.fromJson(Map<String, dynamic> json) =>
      _$WorkoutOptionsEnvelopeFromJson(json);

  final bool success;
  final WorkoutOptionsModel data;

  Map<String, dynamic> toJson() => _$WorkoutOptionsEnvelopeToJson(this);
}

@JsonSerializable()
class WorkoutProfileModel {
  const WorkoutProfileModel({
    required this.id,
    required this.userId,
    required this.disciplines,
    required this.styles,
    required this.goal,
    required this.level,
    required this.daysPerWeek,
    required this.sessionMinutes,
    required this.location,
    required this.equipment,
    required this.injuries,
    this.injuryNotes,
    required this.painLevel,
  });

  factory WorkoutProfileModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutProfileModelFromJson(json);

  final String id;
  final String userId;
  final List<String> disciplines;
  final Map<String, String> styles;
  final String goal;
  final String level;

  @JsonKey(fromJson: _parseInt)
  final int daysPerWeek;

  @JsonKey(fromJson: _parseInt)
  final int sessionMinutes;

  final String location;
  final List<String> equipment;
  final List<String> injuries;
  final String? injuryNotes;

  @JsonKey(fromJson: _parseInt)
  final int painLevel;

  Map<String, dynamic> toJson() => _$WorkoutProfileModelToJson(this);
}

class WorkoutProfileEnvelope {
  const WorkoutProfileEnvelope({
    required this.success,
    required this.profile,
    this.shouldRegeneratePlan = false,
  });

  factory WorkoutProfileEnvelope.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool? ?? true;
    final data = json['data'] as Map<String, dynamic>;

    if (data.containsKey('profile')) {
      return WorkoutProfileEnvelope(
        success: success,
        profile: WorkoutProfileModel.fromJson(
          data['profile'] as Map<String, dynamic>,
        ),
        shouldRegeneratePlan: data['shouldRegeneratePlan'] as bool? ?? false,
      );
    } else {
      return WorkoutProfileEnvelope(
        success: success,
        profile: WorkoutProfileModel.fromJson(data),
        shouldRegeneratePlan: false,
      );
    }
  }

  final bool success;
  final WorkoutProfileModel profile;
  final bool shouldRegeneratePlan;
}

@JsonSerializable()
class UpsertWorkoutProfileRequest {
  const UpsertWorkoutProfileRequest({
    required this.disciplines,
    required this.styles,
    required this.goal,
    required this.level,
    required this.daysPerWeek,
    required this.sessionMinutes,
    required this.location,
    required this.equipment,
    required this.injuries,
    this.injuryNotes,
    required this.painLevel,
  });

  factory UpsertWorkoutProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpsertWorkoutProfileRequestFromJson(json);

  final List<String> disciplines;
  final Map<String, String> styles;
  final String goal;
  final String level;
  final int daysPerWeek;
  final int sessionMinutes;
  final String location;
  final List<String> equipment;
  final List<String> injuries;
  final String? injuryNotes;
  final int painLevel;

  Map<String, dynamic> toJson() => _$UpsertWorkoutProfileRequestToJson(this);
}

@JsonSerializable()
class WorkoutExerciseItemModel {
  const WorkoutExerciseItemModel({
    required this.itemId,
    required this.exerciseId,
    required this.name,
    required this.sets,
    this.reps,
    this.durationSec,
    required this.restSec,
    this.rpe,
    this.notes,
  });

  factory WorkoutExerciseItemModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseItemModelFromJson(json);

  final String itemId;
  final String exerciseId;
  final String name;

  @JsonKey(fromJson: _parseInt)
  final int sets;

  final String? reps;

  @JsonKey(fromJson: _parseNullableInt)
  final int? durationSec;

  @JsonKey(fromJson: _parseInt)
  final int restSec;

  @JsonKey(fromJson: _parseNullableDouble)
  final double? rpe;

  final String? notes;

  Map<String, dynamic> toJson() => _$WorkoutExerciseItemModelToJson(this);
}

@JsonSerializable()
class WorkoutDayModel {
  const WorkoutDayModel({
    required this.day,
    required this.isRest,
    required this.title,
    required this.focus,
    required this.durationMin,
    required this.warmup,
    required this.main,
    required this.cooldown,
  });

  factory WorkoutDayModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutDayModelFromJson(json);

  final String day;
  final bool isRest;
  final String title;
  final List<String> focus;

  @JsonKey(fromJson: _parseInt)
  final int durationMin;

  final List<WorkoutExerciseItemModel> warmup;
  final List<WorkoutExerciseItemModel> main;
  final List<WorkoutExerciseItemModel> cooldown;

  Map<String, dynamic> toJson() => _$WorkoutDayModelToJson(this);
}

@JsonSerializable()
class WorkoutNotesModel {
  const WorkoutNotesModel({required this.progression, required this.safety});

  factory WorkoutNotesModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutNotesModelFromJson(json);

  final String progression;
  final List<String> safety;

  Map<String, dynamic> toJson() => _$WorkoutNotesModelToJson(this);
}

@JsonSerializable()
class WorkoutProfileSnapshotModel {
  const WorkoutProfileSnapshotModel({
    this.disciplines = const [],
    this.styles = const {},
    this.goal = '',
    this.level = '',
    this.daysPerWeek = 0,
    this.sessionMinutes = 0,
    this.location = '',
    this.equipment = const [],
    this.injuries = const [],
    this.painLevel = 0,
  });

  factory WorkoutProfileSnapshotModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutProfileSnapshotModelFromJson(json);

  final List<String> disciplines;
  final Map<String, String> styles;
  final String goal;
  final String level;
  @JsonKey(fromJson: _parseInt)
  final int daysPerWeek;
  @JsonKey(fromJson: _parseInt)
  final int sessionMinutes;
  final String location;
  final List<String> equipment;
  final List<String> injuries;
  @JsonKey(fromJson: _parseInt)
  final int painLevel;

  Map<String, dynamic> toJson() => _$WorkoutProfileSnapshotModelToJson(this);
}

@JsonSerializable()
class WorkoutPlanModel {
  const WorkoutPlanModel({
    required this.id,
    required this.userId,
    required this.status,
    this.summary,
    required this.notes,
    required this.days,
    required this.createdAt,
    this.profileSnapshot,
    this.remainingFullGenerations = 3,
    this.remainingExerciseSwaps = 5,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanModelFromJson(json);

  final String id;
  final String userId;
  final String status;
  final String? summary;
  final WorkoutNotesModel notes;
  final List<WorkoutDayModel> days;
  final DateTime createdAt;
  final WorkoutProfileSnapshotModel? profileSnapshot;

  @JsonKey(name: 'remaining_full_generations', fromJson: _parseInt)
  final int remainingFullGenerations;

  @JsonKey(name: 'remaining_exercise_swaps', fromJson: _parseInt)
  final int remainingExerciseSwaps;

  Map<String, dynamic> toJson() => _$WorkoutPlanModelToJson(this);
}

@JsonSerializable()
class WorkoutPlanEnvelope {
  const WorkoutPlanEnvelope({required this.success, required this.data});

  factory WorkoutPlanEnvelope.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanEnvelopeFromJson(json);

  final bool success;
  final WorkoutPlanModel data;

  Map<String, dynamic> toJson() => _$WorkoutPlanEnvelopeToJson(this);
}

class WorkoutPlanHistoryEnvelope {
  const WorkoutPlanHistoryEnvelope({
    required this.success,
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory WorkoutPlanHistoryEnvelope.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool? ?? true;
    final data = json['data'] as Map<String, dynamic>;

    final itemsRaw = data['items'] as List<dynamic>? ?? [];
    final items = itemsRaw
        .map((e) => WorkoutPlanModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final pagination = data['pagination'] as Map<String, dynamic>? ?? {};
    final total = _parseInt(pagination['total']);
    final page = _parseInt(pagination['page'], 1);
    final limit = _parseInt(pagination['limit'], 10);

    return WorkoutPlanHistoryEnvelope(
      success: success,
      items: items,
      total: total,
      page: page,
      limit: limit,
    );
  }

  final bool success;
  final List<WorkoutPlanModel> items;
  final int total;
  final int page;
  final int limit;
}

@JsonSerializable()
class SwapExerciseRequest {
  const SwapExerciseRequest({required this.day, required this.itemId});

  factory SwapExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$SwapExerciseRequestFromJson(json);

  final String day;
  final String itemId;

  Map<String, dynamic> toJson() => _$SwapExerciseRequestToJson(this);
}

class SwapExerciseEnvelope {
  const SwapExerciseEnvelope({
    required this.success,
    required this.item,
    required this.remainingExerciseSwaps,
  });

  factory SwapExerciseEnvelope.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool? ?? true;
    final data = json['data'] as Map<String, dynamic>;

    final itemModel = WorkoutExerciseItemModel.fromJson(
      data['item'] as Map<String, dynamic>,
    );
    final remainingSwaps = _parseInt(data['remaining_exercise_swaps']);

    return SwapExerciseEnvelope(
      success: success,
      item: itemModel,
      remainingExerciseSwaps: remainingSwaps,
    );
  }

  final bool success;
  final WorkoutExerciseItemModel item;
  final int remainingExerciseSwaps;
}
