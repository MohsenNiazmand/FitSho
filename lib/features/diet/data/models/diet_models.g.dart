// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietProfileModel _$DietProfileModelFromJson(Map<String, dynamic> json) =>
    DietProfileModel(
      age: (json['age'] as num).toInt(),
      heightCm: (json['heightCm'] as num).toInt(),
      weightKg: json['weightKg'] as num,
      gender: json['gender'] as String,
      goal: json['goal'] as String,
      activityLevel: json['activityLevel'] as String,
      doesExercise: json['doesExercise'] as bool,
      job: json['job'] as String?,
      goalNotes: json['goalNotes'] as String?,
      exerciseType: json['exerciseType'] as String?,
      exerciseDaysPerWeek: (json['exerciseDaysPerWeek'] as num?)?.toInt(),
      dietaryPreferences:
          (json['dietaryPreferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergiesNotes: json['allergiesNotes'] as String?,
      bmi: json['bmi'] as num?,
      dailyCalorieTarget: (json['dailyCalorieTarget'] as num?)?.toInt(),
      mealSlots:
          (json['mealSlots'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              MealSlotConfigModel.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
      shouldRegeneratePlan: json['shouldRegeneratePlan'] as bool? ?? false,
    );

Map<String, dynamic> _$DietProfileModelToJson(DietProfileModel instance) =>
    <String, dynamic>{
      'age': instance.age,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'gender': instance.gender,
      'goal': instance.goal,
      'activityLevel': instance.activityLevel,
      'doesExercise': instance.doesExercise,
      'job': instance.job,
      'goalNotes': instance.goalNotes,
      'exerciseType': instance.exerciseType,
      'exerciseDaysPerWeek': instance.exerciseDaysPerWeek,
      'dietaryPreferences': instance.dietaryPreferences,
      'allergiesNotes': instance.allergiesNotes,
      'bmi': instance.bmi,
      'dailyCalorieTarget': instance.dailyCalorieTarget,
      'mealSlots': instance.mealSlots,
      'shouldRegeneratePlan': instance.shouldRegeneratePlan,
    };

UpsertDietProfileRequest _$UpsertDietProfileRequestFromJson(
  Map<String, dynamic> json,
) => UpsertDietProfileRequest(
  age: (json['age'] as num).toInt(),
  heightCm: (json['heightCm'] as num).toInt(),
  weightKg: json['weightKg'] as num,
  gender: json['gender'] as String,
  goal: json['goal'] as String,
  activityLevel: json['activityLevel'] as String,
  doesExercise: json['doesExercise'] as bool,
  job: json['job'] as String?,
  goalNotes: json['goalNotes'] as String?,
  exerciseType: json['exerciseType'] as String?,
  exerciseDaysPerWeek: (json['exerciseDaysPerWeek'] as num?)?.toInt(),
  dietaryPreferences:
      (json['dietaryPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  allergiesNotes: json['allergiesNotes'] as String?,
);

Map<String, dynamic> _$UpsertDietProfileRequestToJson(
  UpsertDietProfileRequest instance,
) => <String, dynamic>{
  'age': instance.age,
  'heightCm': instance.heightCm,
  'weightKg': instance.weightKg,
  'gender': instance.gender,
  'goal': instance.goal,
  'activityLevel': instance.activityLevel,
  'doesExercise': instance.doesExercise,
  'job': instance.job,
  'goalNotes': instance.goalNotes,
  'exerciseType': instance.exerciseType,
  'exerciseDaysPerWeek': instance.exerciseDaysPerWeek,
  'dietaryPreferences': instance.dietaryPreferences,
  'allergiesNotes': instance.allergiesNotes,
};

DietOptionItemModel _$DietOptionItemModelFromJson(Map<String, dynamic> json) =>
    DietOptionItemModel(
      id: json['id'] as String,
      label: json['label'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$DietOptionItemModelToJson(
  DietOptionItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'isAvailable': instance.isAvailable,
};

DietProfileOptionsModel _$DietProfileOptionsModelFromJson(
  Map<String, dynamic> json,
) => DietProfileOptionsModel(
  genders: (json['genders'] as List<dynamic>)
      .map((e) => DietOptionItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  goals: (json['goals'] as List<dynamic>)
      .map((e) => DietOptionItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  activityLevels: (json['activityLevels'] as List<dynamic>)
      .map((e) => DietOptionItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  dietaryPreferences: (json['dietaryPreferences'] as List<dynamic>)
      .map((e) => DietOptionItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DietProfileOptionsModelToJson(
  DietProfileOptionsModel instance,
) => <String, dynamic>{
  'genders': instance.genders.map((e) => e.toJson()).toList(),
  'goals': instance.goals.map((e) => e.toJson()).toList(),
  'activityLevels': instance.activityLevels.map((e) => e.toJson()).toList(),
  'dietaryPreferences': instance.dietaryPreferences
      .map((e) => e.toJson())
      .toList(),
};

MealSlotConfigModel _$MealSlotConfigModelFromJson(Map<String, dynamic> json) =>
    MealSlotConfigModel(
      enabled: json['enabled'] as bool,
      time: json['time'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$MealSlotConfigModelToJson(
  MealSlotConfigModel instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'time': instance.time,
  'notificationsEnabled': instance.notificationsEnabled,
};

UpsertMealSlotsRequest _$UpsertMealSlotsRequestFromJson(
  Map<String, dynamic> json,
) => UpsertMealSlotsRequest(
  mealSlots: (json['mealSlots'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, MealSlotConfigModel.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$UpsertMealSlotsRequestToJson(
  UpsertMealSlotsRequest instance,
) => <String, dynamic>{
  'mealSlots': instance.mealSlots.map((k, e) => MapEntry(k, e.toJson())),
};

DietMealModel _$DietMealModelFromJson(Map<String, dynamic> json) =>
    DietMealModel(
      title: json['title'] as String,
      description: json['description'] as String?,
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      calories: (json['calories'] as num).toInt(),
      proteinG: json['proteinG'] as num,
      carbsG: json['carbsG'] as num,
      fatG: json['fatG'] as num,
    );

Map<String, dynamic> _$DietMealModelToJson(DietMealModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
    };

DietDayModel _$DietDayModelFromJson(Map<String, dynamic> json) => DietDayModel(
  day: json['day'] as String,
  meals: (json['meals'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      e == null ? null : DietMealModel.fromJson(e as Map<String, dynamic>),
    ),
  ),
);

Map<String, dynamic> _$DietDayModelToJson(DietDayModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'meals': instance.meals.map((k, e) => MapEntry(k, e?.toJson())),
    };

DietPlanModel _$DietPlanModelFromJson(Map<String, dynamic> json) =>
    DietPlanModel(
      id: json['id'] as String,
      status: json['status'] as String,
      dailyCalorieTarget: (json['dailyCalorieTarget'] as num).toInt(),
      days: (json['days'] as List<dynamic>)
          .map((e) => DietDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      shouldRegeneratePlan: json['shouldRegeneratePlan'] as bool? ?? false,
    );

Map<String, dynamic> _$DietPlanModelToJson(DietPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'dailyCalorieTarget': instance.dailyCalorieTarget,
      'days': instance.days.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'shouldRegeneratePlan': instance.shouldRegeneratePlan,
    };

MealLogModel _$MealLogModelFromJson(Map<String, dynamic> json) => MealLogModel(
  id: json['id'] as String,
  slot: json['slot'] as String,
  day: json['day'] as String,
  loggedAt: DateTime.parse(json['loggedAt'] as String),
  mealTitle: json['mealTitle'] as String?,
);

Map<String, dynamic> _$MealLogModelToJson(MealLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slot': instance.slot,
      'day': instance.day,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'mealTitle': instance.mealTitle,
    };

LogMealRequest _$LogMealRequestFromJson(Map<String, dynamic> json) =>
    LogMealRequest(slot: json['slot'] as String, day: json['day'] as String);

Map<String, dynamic> _$LogMealRequestToJson(LogMealRequest instance) =>
    <String, dynamic>{'slot': instance.slot, 'day': instance.day};

SupplementModel _$SupplementModelFromJson(Map<String, dynamic> json) =>
    SupplementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dosageNote: json['dosageNote'] as String?,
      times:
          (json['times'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      linkedMealSlot: json['linkedMealSlot'] as String?,
    );

Map<String, dynamic> _$SupplementModelToJson(SupplementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dosageNote': instance.dosageNote,
      'times': instance.times,
      'linkedMealSlot': instance.linkedMealSlot,
    };

CreateSupplementRequest _$CreateSupplementRequestFromJson(
  Map<String, dynamic> json,
) => CreateSupplementRequest(
  name: json['name'] as String,
  dosageNote: json['dosageNote'] as String?,
  times:
      (json['times'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  linkedMealSlot: json['linkedMealSlot'] as String?,
);

Map<String, dynamic> _$CreateSupplementRequestToJson(
  CreateSupplementRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'dosageNote': instance.dosageNote,
  'times': instance.times,
  'linkedMealSlot': instance.linkedMealSlot,
};

UpdateSupplementRequest _$UpdateSupplementRequestFromJson(
  Map<String, dynamic> json,
) => UpdateSupplementRequest(
  name: json['name'] as String?,
  dosageNote: json['dosageNote'] as String?,
  times: (json['times'] as List<dynamic>?)?.map((e) => e as String).toList(),
  linkedMealSlot: json['linkedMealSlot'] as String?,
);

Map<String, dynamic> _$UpdateSupplementRequestToJson(
  UpdateSupplementRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'dosageNote': instance.dosageNote,
  'times': instance.times,
  'linkedMealSlot': instance.linkedMealSlot,
};

FcmTokenRegistrationRequest _$FcmTokenRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => FcmTokenRegistrationRequest(
  token: json['token'] as String,
  deviceId: json['deviceId'] as String,
  platform: json['platform'] as String,
);

Map<String, dynamic> _$FcmTokenRegistrationRequestToJson(
  FcmTokenRegistrationRequest instance,
) => <String, dynamic>{
  'token': instance.token,
  'deviceId': instance.deviceId,
  'platform': instance.platform,
};

ComplianceStatsModel _$ComplianceStatsModelFromJson(
  Map<String, dynamic> json,
) => ComplianceStatsModel(
  complianceRate: json['complianceRate'] as num,
  totalPlanned: (json['totalPlanned'] as num).toInt(),
  totalConsumed: (json['totalConsumed'] as num).toInt(),
);

Map<String, dynamic> _$ComplianceStatsModelToJson(
  ComplianceStatsModel instance,
) => <String, dynamic>{
  'complianceRate': instance.complianceRate,
  'totalPlanned': instance.totalPlanned,
  'totalConsumed': instance.totalConsumed,
};

DietProfileEnvelope _$DietProfileEnvelopeFromJson(Map<String, dynamic> json) =>
    DietProfileEnvelope(
      success: json['success'] as bool,
      data: DietProfileModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DietProfileEnvelopeToJson(
  DietProfileEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

DietProfileOptionsEnvelope _$DietProfileOptionsEnvelopeFromJson(
  Map<String, dynamic> json,
) => DietProfileOptionsEnvelope(
  success: json['success'] as bool,
  data: DietProfileOptionsModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DietProfileOptionsEnvelopeToJson(
  DietProfileOptionsEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

DietPlanEnvelope _$DietPlanEnvelopeFromJson(Map<String, dynamic> json) =>
    DietPlanEnvelope(
      success: json['success'] as bool,
      data: DietPlanModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DietPlanEnvelopeToJson(DietPlanEnvelope instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

DietPlanListEnvelope _$DietPlanListEnvelopeFromJson(
  Map<String, dynamic> json,
) => DietPlanListEnvelope(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => DietPlanModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DietPlanListEnvelopeToJson(
  DietPlanListEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

MealLogEnvelope _$MealLogEnvelopeFromJson(Map<String, dynamic> json) =>
    MealLogEnvelope(
      success: json['success'] as bool,
      data: MealLogModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MealLogEnvelopeToJson(MealLogEnvelope instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

MealLogListEnvelope _$MealLogListEnvelopeFromJson(Map<String, dynamic> json) =>
    MealLogListEnvelope(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => MealLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealLogListEnvelopeToJson(
  MealLogListEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

SupplementEnvelope _$SupplementEnvelopeFromJson(Map<String, dynamic> json) =>
    SupplementEnvelope(
      success: json['success'] as bool,
      data: SupplementModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupplementEnvelopeToJson(SupplementEnvelope instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

SupplementListEnvelope _$SupplementListEnvelopeFromJson(
  Map<String, dynamic> json,
) => SupplementListEnvelope(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => SupplementModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SupplementListEnvelopeToJson(
  SupplementListEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

ComplianceStatsEnvelope _$ComplianceStatsEnvelopeFromJson(
  Map<String, dynamic> json,
) => ComplianceStatsEnvelope(
  success: json['success'] as bool,
  data: ComplianceStatsModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ComplianceStatsEnvelopeToJson(
  ComplianceStatsEnvelope instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
