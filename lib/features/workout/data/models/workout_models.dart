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

List<String> _parseStringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => item.toString()).toList();
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
    this.recommendedDays,
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

  @JsonKey(fromJson: _parseNullableInt)
  final int? recommendedDays;

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
    this.requiresReferral = false,
    this.isAvailable = true,
  });

  factory InjuryOptionModel.fromJson(Map<String, dynamic> json) =>
      _$InjuryOptionModelFromJson(json);

  final String id;
  final String label;
  final String description;
  @JsonKey(defaultValue: false)
  final bool requiresReferral;
  @JsonKey(defaultValue: true)
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
    this.injuryAreas = const [],
    this.medicalConditions = const [],
    required this.maxDisciplines,
    required this.minDaysPerWeek,
    required this.maxDaysPerWeek,
    this.minSessionMinutes = 10,
    this.maxSessionMinutes = 180,
  });

  factory WorkoutOptionsModel.fromJson(Map<String, dynamic> json) {
    final parsed = _$WorkoutOptionsModelFromJson(json);
    return WorkoutOptionsModel(
      disciplines: parsed.disciplines,
      styles: parsed.styles,
      goals: parsed.goals,
      levels: parsed.levels,
      sessionMinutes: parsed.sessionMinutes,
      locations: parsed.locations,
      equipment: parsed.equipment,
      injuries: parsed.injuries,
      // Revision 2: separate injuryAreas and medicalConditions
      injuryAreas: parsed.injuryAreas,
      medicalConditions: parsed.medicalConditions,
      maxDisciplines: parsed.maxDisciplines,
      minDaysPerWeek: parsed.minDaysPerWeek,
      maxDaysPerWeek: parsed.maxDaysPerWeek,
      minSessionMinutes:
          json.containsKey('minSessionMinutes') ||
              json.containsKey('min_session_minutes')
          ? _parseInt(
              json['minSessionMinutes'] ?? json['min_session_minutes'],
              10,
            )
          : 10,
      maxSessionMinutes:
          json.containsKey('maxSessionMinutes') ||
              json.containsKey('max_session_minutes')
          ? _parseInt(
              json['maxSessionMinutes'] ?? json['max_session_minutes'],
              180,
            )
          : 180,
    );
  }

  final List<DisciplineOptionModel> disciplines;
  final List<StyleOptionModel> styles;
  final List<GoalOptionModel> goals;
  final List<WorkoutOptionItemModel> levels;
  @JsonKey(fromJson: _parseIntList)
  final List<int> sessionMinutes;
  final List<WorkoutOptionItemModel> locations;
  final List<WorkoutOptionItemModel> equipment;
  final List<InjuryOptionModel> injuries;
  final List<InjuryOptionModel> injuryAreas;
  final List<InjuryOptionModel> medicalConditions;

  @JsonKey(fromJson: _parseInt)
  final int maxDisciplines;

  @JsonKey(fromJson: _parseInt)
  final int minDaysPerWeek;

  @JsonKey(fromJson: _parseInt)
  final int maxDaysPerWeek;

  @JsonKey(fromJson: _parseInt)
  final int minSessionMinutes;

  @JsonKey(fromJson: _parseInt)
  final int maxSessionMinutes;

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
  });

  factory WorkoutProfileModel.fromJson(Map<String, dynamic> json) {
    final primaryGoal =
        json['primaryGoal'] as String? ?? json['goal'] as String? ?? '';
    final secondaryGoal = json['secondaryGoal'] as String?;

    final injuryAreas = json.containsKey('injuryAreas')
        ? _parseStringList(json['injuryAreas'])
        : _parseStringList(json['injuries']);

    final medicalConditions = json.containsKey('medicalConditions')
        ? _parseStringList(json['medicalConditions'])
        : <String>[];

    return WorkoutProfileModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      disciplines: _parseStringList(json['disciplines']),
      styles:
          (json['styles'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          const {},
      primaryGoal: primaryGoal,
      secondaryGoal: secondaryGoal,
      level: json['level'] as String? ?? '',
      daysPerWeek: _parseInt(json['daysPerWeek']),
      sessionMinutes: _parseInt(json['sessionMinutes']),
      location: json['location'] as String? ?? '',
      equipment: _parseStringList(json['equipment'])
          .map((e) => e == 'pullup_bar' ? 'pull_up_bar' : e)
          .toList(),
      injuryAreas: injuryAreas,
      medicalConditions: medicalConditions,
      injuryNotes: json['injuryNotes'] as String?,
      painLevel: _parseInt(json['painLevel']),
    );
  }

  final String id;
  final String userId;
  final List<String> disciplines;
  final Map<String, String> styles;
  final String primaryGoal;
  final String? secondaryGoal;
  final String level;

  @JsonKey(fromJson: _parseInt)
  final int daysPerWeek;

  @JsonKey(fromJson: _parseInt)
  final int sessionMinutes;

  final String location;
  final List<String> equipment;
  final List<String> injuryAreas;
  final List<String> medicalConditions;
  final String? injuryNotes;

  @JsonKey(fromJson: _parseInt)
  final int painLevel;

  Map<String, dynamic> toJson() => _$WorkoutProfileModelToJson(this);
}

class WorkoutProfileEnvelope {
  const WorkoutProfileEnvelope({
    required this.success,
    this.profile,
    this.shouldRegeneratePlan = false,
  });

  factory WorkoutProfileEnvelope.fromJson(Map<String, dynamic> json) {
    final success = json['success'] as bool? ?? true;
    final dynamic rawData = json['data'];

    if (rawData == null || rawData is! Map<String, dynamic>) {
      return WorkoutProfileEnvelope(
        success: success,
        profile: null,
        shouldRegeneratePlan: false,
      );
    }

    final data = rawData;

    if (data.containsKey('profile')) {
      final profileData = data['profile'];
      return WorkoutProfileEnvelope(
        success: success,
        profile: profileData is Map<String, dynamic>
            ? WorkoutProfileModel.fromJson(profileData)
            : null,
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
  final WorkoutProfileModel? profile;
  final bool shouldRegeneratePlan;
}

@JsonSerializable()
class UpsertWorkoutProfileRequest {
  const UpsertWorkoutProfileRequest({
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
  });

  factory UpsertWorkoutProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpsertWorkoutProfileRequestFromJson(json);

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

  factory WorkoutExerciseItemModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseItemModelFromJson(json);

  final String itemId;
  final String exerciseId;
  final String name;
  final String? gifUrl;
  final String? videoUrl;
  final String? cue;

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
class WorkoutSessionModel {
  const WorkoutSessionModel({
    required this.sessionId,
    required this.sessionNumber,
    required this.title,
    required this.focus,
    required this.durationMin,
    required this.warmup,
    required this.main,
    required this.cooldown,
  });

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    final sessionId =
        json['sessionId'] as String? ??
        json['session_id'] as String? ??
        json['day'] as String? ??
        'session_${json['sessionNumber'] ?? json['session_number'] ?? 1}';

    final sessionNumber = _parseInt(
      json['sessionNumber'] ?? json['session_number'],
      1,
    );

    return WorkoutSessionModel(
      sessionId: sessionId,
      sessionNumber: sessionNumber,
      title: json['title'] as String? ?? '',
      focus: _parseStringList(json['focus']),
      durationMin: _parseInt(json['durationMin'] ?? json['duration_min']),
      warmup:
          (json['warmup'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutExerciseItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      main:
          (json['main'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutExerciseItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      cooldown:
          (json['cooldown'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutExerciseItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );
  }

  final String sessionId;

  @JsonKey(fromJson: _parseInt)
  final int sessionNumber;

  final String title;
  final List<String> focus;

  @JsonKey(fromJson: _parseInt)
  final int durationMin;

  final List<WorkoutExerciseItemModel> warmup;
  final List<WorkoutExerciseItemModel> main;
  final List<WorkoutExerciseItemModel> cooldown;

  Map<String, dynamic> toJson() => _$WorkoutSessionModelToJson(this);
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

  factory WorkoutProfileSnapshotModel.fromJson(Map<String, dynamic> json) {
    final primaryGoal =
        json['primaryGoal'] as String? ?? json['goal'] as String? ?? '';
    final secondaryGoal = json['secondaryGoal'] as String?;

    final injuryAreas = json.containsKey('injuryAreas')
        ? _parseStringList(json['injuryAreas'])
        : _parseStringList(json['injuries']);

    final medicalConditions = json.containsKey('medicalConditions')
        ? _parseStringList(json['medicalConditions'])
        : <String>[];

    return WorkoutProfileSnapshotModel(
      disciplines: _parseStringList(json['disciplines']),
      styles:
          (json['styles'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          const {},
      primaryGoal: primaryGoal,
      secondaryGoal: secondaryGoal,
      level: json['level'] as String? ?? '',
      daysPerWeek: _parseInt(json['daysPerWeek']),
      sessionMinutes: _parseInt(json['sessionMinutes']),
      location: json['location'] as String? ?? '',
      equipment: _parseStringList(json['equipment'])
          .map((e) => e == 'pullup_bar' ? 'pull_up_bar' : e)
          .toList(),
      injuryAreas: injuryAreas,
      medicalConditions: medicalConditions,
      painLevel: _parseInt(json['painLevel']),
    );
  }

  final List<String> disciplines;
  final Map<String, String> styles;
  final String primaryGoal;
  final String? secondaryGoal;
  final String level;
  @JsonKey(fromJson: _parseInt)
  final int daysPerWeek;
  @JsonKey(fromJson: _parseInt)
  final int sessionMinutes;
  final String location;
  final List<String> equipment;
  final List<String> injuryAreas;
  final List<String> medicalConditions;
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
    required this.sessions,
    required this.createdAt,
    this.profileSnapshot,
    this.remainingFullGenerations = 3,
    this.remainingExerciseSwaps = 5,
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    final sessionsRaw =
        json['sessions'] as List<dynamic>? ??
        json['days'] as List<dynamic>? ??
        [];

    final sessions = sessionsRaw
        .map((e) => WorkoutSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return WorkoutPlanModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      summary: json['summary'] as String?,
      notes: json['notes'] != null
          ? WorkoutNotesModel.fromJson(json['notes'] as Map<String, dynamic>)
          : const WorkoutNotesModel(progression: '', safety: []),
      sessions: sessions,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      profileSnapshot: json['profileSnapshot'] != null
          ? WorkoutProfileSnapshotModel.fromJson(
              json['profileSnapshot'] as Map<String, dynamic>,
            )
          : null,
      remainingFullGenerations: _parseInt(
        json['remaining_full_generations'] ?? json['remainingFullGenerations'],
        3,
      ),
      remainingExerciseSwaps: _parseInt(
        json['remaining_exercise_swaps'] ?? json['remainingExerciseSwaps'],
        5,
      ),
    );
  }

  final String id;
  final String userId;
  final String status;
  final String? summary;
  final WorkoutNotesModel notes;
  final List<WorkoutSessionModel> sessions;
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
  const SwapExerciseRequest({required this.sessionId, required this.itemId});

  factory SwapExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$SwapExerciseRequestFromJson(json);

  final String sessionId;
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
