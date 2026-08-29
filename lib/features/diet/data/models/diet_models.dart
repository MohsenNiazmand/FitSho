import 'package:json_annotation/json_annotation.dart';
import 'package:fitsho/shared/data/models/ingredient_model.dart';

part 'diet_models.g.dart';

@JsonSerializable()
class DietProfileModel {
  const DietProfileModel({
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.goal,
    required this.activityLevel,
    required this.doesExercise,
    this.job,
    this.goalNotes,
    this.exerciseType,
    this.exerciseDaysPerWeek,
    this.dietaryPreferences = const [],
    this.allergiesNotes,
    this.bmi,
    this.dailyCalorieTarget,
    this.mealSlots = const {},
  });

  factory DietProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DietProfileModelFromJson(json);

  final int age;
  final int heightCm;
  final num weightKg;
  final String gender;
  final String goal;
  final String activityLevel;
  final bool doesExercise;
  final String? job;
  final String? goalNotes;
  final String? exerciseType;
  final int? exerciseDaysPerWeek;
  final List<String> dietaryPreferences;
  final String? allergiesNotes;
  final num? bmi;
  final int? dailyCalorieTarget;
  final Map<String, MealSlotConfigModel> mealSlots;

  Map<String, dynamic> toJson() => _$DietProfileModelToJson(this);
}

@JsonSerializable()
class UpsertDietProfileRequest {
  const UpsertDietProfileRequest({
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.goal,
    required this.activityLevel,
    required this.doesExercise,
    this.job,
    this.goalNotes,
    this.exerciseType,
    this.exerciseDaysPerWeek,
    this.dietaryPreferences = const [],
    this.allergiesNotes,
  });

  factory UpsertDietProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpsertDietProfileRequestFromJson(json);

  final int age;
  final int heightCm;
  final num weightKg;
  final String gender;
  final String goal;
  final String activityLevel;
  final bool doesExercise;
  final String? job;
  final String? goalNotes;
  final String? exerciseType;
  final int? exerciseDaysPerWeek;
  final List<String> dietaryPreferences;
  final String? allergiesNotes;

  Map<String, dynamic> toJson() => _$UpsertDietProfileRequestToJson(this);
}

@JsonSerializable()
class DietOptionItemModel {
  const DietOptionItemModel({
    required this.id,
    required this.label,
    @JsonKey(defaultValue: true) this.isAvailable = true,
  });

  factory DietOptionItemModel.fromJson(Map<String, dynamic> json) =>
      _$DietOptionItemModelFromJson(json);

  final String id;
  final String label;
  final bool isAvailable;

  Map<String, dynamic> toJson() => _$DietOptionItemModelToJson(this);
}

@JsonSerializable()
class DietProfileOptionsModel {
  const DietProfileOptionsModel({
    required this.genders,
    required this.goals,
    required this.activityLevels,
    required this.dietaryPreferences,
  });

  factory DietProfileOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$DietProfileOptionsModelFromJson(json);

  final List<DietOptionItemModel> genders;
  final List<DietOptionItemModel> goals;
  final List<DietOptionItemModel> activityLevels;
  final List<DietOptionItemModel> dietaryPreferences;

  Map<String, dynamic> toJson() => _$DietProfileOptionsModelToJson(this);
}

@JsonSerializable()
class MealSlotConfigModel {
  const MealSlotConfigModel({
    required this.enabled,
    required this.time,
    @JsonKey(defaultValue: true) this.notificationsEnabled = true,
  });

  factory MealSlotConfigModel.fromJson(Map<String, dynamic> json) =>
      _$MealSlotConfigModelFromJson(json);

  final bool enabled;
  final String time;
  final bool notificationsEnabled;

  Map<String, dynamic> toJson() => _$MealSlotConfigModelToJson(this);
}

@JsonSerializable()
class UpsertMealSlotsRequest {
  const UpsertMealSlotsRequest({
    required this.mealSlots,
  });

  factory UpsertMealSlotsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpsertMealSlotsRequestFromJson(json);

  final Map<String, MealSlotConfigModel> mealSlots;

  Map<String, dynamic> toJson() => _$UpsertMealSlotsRequestToJson(this);
}

@JsonSerializable()
class DietMealModel {
  const DietMealModel({
    required this.title,
    this.description,
    this.ingredients = const [],
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  factory DietMealModel.fromJson(Map<String, dynamic> json) =>
      _$DietMealModelFromJson(json);

  final String title;
  final String? description;
  final List<IngredientModel> ingredients;
  final int calories;
  final num proteinG;
  final num carbsG;
  final num fatG;

  Map<String, dynamic> toJson() => _$DietMealModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DietDayModel {
  const DietDayModel({
    required this.day,
    required this.meals,
  });

  factory DietDayModel.fromJson(Map<String, dynamic> json) {
    final rawMeals = json['meals'];
    final parsedMeals = <String, DietMealModel?>{};

    if (rawMeals is Map<String, dynamic>) {
      rawMeals.forEach((key, value) {
        parsedMeals[key] = value == null
            ? null
            : DietMealModel.fromJson(value as Map<String, dynamic>);
      });
    }

    return DietDayModel(
      day: json['day'] as String,
      meals: parsedMeals,
    );
  }

  final String day;
  final Map<String, DietMealModel?> meals;

  Map<String, dynamic> toJson() => {
        'day': day,
        'meals': meals.map(
          (key, value) => MapEntry(key, value?.toJson()),
        ),
      };
}

@JsonSerializable(explicitToJson: true)
class DietPlanModel {
  const DietPlanModel({
    required this.id,
    required this.status,
    required this.dailyCalorieTarget,
    required this.days,
    required this.createdAt,
    @JsonKey(defaultValue: false) this.shouldRegeneratePlan = false,
  });

  factory DietPlanModel.fromJson(Map<String, dynamic> json) =>
      _$DietPlanModelFromJson(json);

  final String id;
  final String status;
  final int dailyCalorieTarget;
  final List<DietDayModel> days;
  final DateTime createdAt;
  final bool shouldRegeneratePlan;

  Map<String, dynamic> toJson() => _$DietPlanModelToJson(this);
}

@JsonSerializable()
class MealLogModel {
  const MealLogModel({
    required this.id,
    required this.slot,
    required this.day,
    required this.loggedAt,
    this.mealTitle,
  });

  factory MealLogModel.fromJson(Map<String, dynamic> json) =>
      _$MealLogModelFromJson(json);

  final String id;
  final String slot;
  final String day;
  final DateTime loggedAt;
  final String? mealTitle;

  Map<String, dynamic> toJson() => _$MealLogModelToJson(this);
}

@JsonSerializable()
class LogMealRequest {
  const LogMealRequest({
    required this.slot,
    required this.day,
  });

  factory LogMealRequest.fromJson(Map<String, dynamic> json) =>
      _$LogMealRequestFromJson(json);

  final String slot;
  final String day;

  Map<String, dynamic> toJson() => _$LogMealRequestToJson(this);
}

@JsonSerializable()
class SupplementModel {
  const SupplementModel({
    required this.id,
    required this.name,
    this.dosageNote,
    this.times = const [],
    this.linkedMealSlot,
  });

  factory SupplementModel.fromJson(Map<String, dynamic> json) =>
      _$SupplementModelFromJson(json);

  final String id;
  final String name;
  final String? dosageNote;
  final List<String> times;
  final String? linkedMealSlot;

  Map<String, dynamic> toJson() => _$SupplementModelToJson(this);
}

@JsonSerializable()
class CreateSupplementRequest {
  const CreateSupplementRequest({
    required this.name,
    this.dosageNote,
    this.times = const [],
    this.linkedMealSlot,
  });

  factory CreateSupplementRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSupplementRequestFromJson(json);

  final String name;
  final String? dosageNote;
  final List<String> times;
  final String? linkedMealSlot;

  Map<String, dynamic> toJson() => _$CreateSupplementRequestToJson(this);
}

@JsonSerializable()
class UpdateSupplementRequest {
  const UpdateSupplementRequest({
    this.name,
    this.dosageNote,
    this.times,
    this.linkedMealSlot,
  });

  factory UpdateSupplementRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSupplementRequestFromJson(json);

  final String? name;
  final String? dosageNote;
  final List<String>? times;
  final String? linkedMealSlot;

  Map<String, dynamic> toJson() => _$UpdateSupplementRequestToJson(this);
}

@JsonSerializable()
class FcmTokenRegistrationRequest {
  const FcmTokenRegistrationRequest({
    required this.token,
    required this.deviceId,
    required this.platform,
  });

  factory FcmTokenRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenRegistrationRequestFromJson(json);

  final String token;
  final String deviceId;
  final String platform;

  Map<String, dynamic> toJson() => _$FcmTokenRegistrationRequestToJson(this);
}

@JsonSerializable()
class ComplianceStatsModel {
  const ComplianceStatsModel({
    required this.complianceRate,
    required this.totalPlanned,
    required this.totalConsumed,
  });

  factory ComplianceStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ComplianceStatsModelFromJson(json);

  final num complianceRate;
  final int totalPlanned;
  final int totalConsumed;

  Map<String, dynamic> toJson() => _$ComplianceStatsModelToJson(this);
}

@JsonSerializable()
class DietProfileEnvelope {
  const DietProfileEnvelope({
    required this.success,
    required this.data,
  });

  factory DietProfileEnvelope.fromJson(Map<String, dynamic> json) =>
      _$DietProfileEnvelopeFromJson(json);

  final bool success;
  final DietProfileModel data;

  Map<String, dynamic> toJson() => _$DietProfileEnvelopeToJson(this);
}

@JsonSerializable()
class DietProfileOptionsEnvelope {
  const DietProfileOptionsEnvelope({
    required this.success,
    required this.data,
  });

  factory DietProfileOptionsEnvelope.fromJson(Map<String, dynamic> json) =>
      _$DietProfileOptionsEnvelopeFromJson(json);

  final bool success;
  final DietProfileOptionsModel data;

  Map<String, dynamic> toJson() => _$DietProfileOptionsEnvelopeToJson(this);
}

@JsonSerializable()
class MealSlotsEnvelope {
  const MealSlotsEnvelope({
    required this.success,
    required this.data,
  });

  factory MealSlotsEnvelope.fromJson(Map<String, dynamic> json) =>
      _$MealSlotsEnvelopeFromJson(json);

  final bool success;
  final Map<String, MealSlotConfigModel> data;

  Map<String, dynamic> toJson() => _$MealSlotsEnvelopeToJson(this);
}

@JsonSerializable()
class DietPlanEnvelope {
  const DietPlanEnvelope({
    required this.success,
    required this.data,
  });

  factory DietPlanEnvelope.fromJson(Map<String, dynamic> json) =>
      _$DietPlanEnvelopeFromJson(json);

  final bool success;
  final DietPlanModel data;

  Map<String, dynamic> toJson() => _$DietPlanEnvelopeToJson(this);
}

@JsonSerializable()
class DietPlanListEnvelope {
  const DietPlanListEnvelope({
    required this.success,
    required this.data,
  });

  factory DietPlanListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$DietPlanListEnvelopeFromJson(json);

  final bool success;
  final List<DietPlanModel> data;

  Map<String, dynamic> toJson() => _$DietPlanListEnvelopeToJson(this);
}

@JsonSerializable()
class MealLogEnvelope {
  const MealLogEnvelope({
    required this.success,
    required this.data,
  });

  factory MealLogEnvelope.fromJson(Map<String, dynamic> json) =>
      _$MealLogEnvelopeFromJson(json);

  final bool success;
  final MealLogModel data;

  Map<String, dynamic> toJson() => _$MealLogEnvelopeToJson(this);
}

@JsonSerializable()
class MealLogListEnvelope {
  const MealLogListEnvelope({
    required this.success,
    required this.data,
  });

  factory MealLogListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$MealLogListEnvelopeFromJson(json);

  final bool success;
  final List<MealLogModel> data;

  Map<String, dynamic> toJson() => _$MealLogListEnvelopeToJson(this);
}

@JsonSerializable()
class SupplementEnvelope {
  const SupplementEnvelope({
    required this.success,
    required this.data,
  });

  factory SupplementEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SupplementEnvelopeFromJson(json);

  final bool success;
  final SupplementModel data;

  Map<String, dynamic> toJson() => _$SupplementEnvelopeToJson(this);
}

@JsonSerializable()
class SupplementListEnvelope {
  const SupplementListEnvelope({
    required this.success,
    required this.data,
  });

  factory SupplementListEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SupplementListEnvelopeFromJson(json);

  final bool success;
  final List<SupplementModel> data;

  Map<String, dynamic> toJson() => _$SupplementListEnvelopeToJson(this);
}

@JsonSerializable()
class ComplianceStatsEnvelope {
  const ComplianceStatsEnvelope({
    required this.success,
    required this.data,
  });

  factory ComplianceStatsEnvelope.fromJson(Map<String, dynamic> json) =>
      _$ComplianceStatsEnvelopeFromJson(json);

  final bool success;
  final ComplianceStatsModel data;

  Map<String, dynamic> toJson() => _$ComplianceStatsEnvelopeToJson(this);
}
