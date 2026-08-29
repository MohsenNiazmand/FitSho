import 'package:fitsho/features/diet/data/models/diet_models.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/shared/data/mappers/entity_mappers.dart';

extension DietProfileModelX on DietProfileModel {
  DietProfile toEntity() {
    return DietProfile(
      age: age,
      heightCm: heightCm,
      weightKg: weightKg.toDouble(),
      gender: gender,
      goal: goal,
      activityLevel: activityLevel,
      doesExercise: doesExercise,
      job: job,
      goalNotes: goalNotes,
      exerciseType: exerciseType,
      exerciseDaysPerWeek: exerciseDaysPerWeek,
      dietaryPreferences: dietaryPreferences,
      allergiesNotes: allergiesNotes,
      bmi: bmi?.toDouble(),
      dailyCalorieTarget: dailyCalorieTarget,
      mealSlots: mealSlots.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
      shouldRegeneratePlan: shouldRegeneratePlan,
    );
  }
}

extension DietOptionItemModelX on DietOptionItemModel {
  DietOptionItem toEntity() {
    return DietOptionItem(
      id: id,
      label: label,
      isAvailable: isAvailable,
    );
  }
}

extension DietProfileOptionsModelX on DietProfileOptionsModel {
  DietProfileOptions toEntity() {
    return DietProfileOptions(
      genders: genders.map((item) => item.toEntity()).toList(),
      goals: goals.map((item) => item.toEntity()).toList(),
      activityLevels: activityLevels.map((item) => item.toEntity()).toList(),
      dietaryPreferences:
          dietaryPreferences.map((item) => item.toEntity()).toList(),
    );
  }
}

extension MealSlotConfigModelX on MealSlotConfigModel {
  MealSlotConfig toEntity() {
    return MealSlotConfig(
      enabled: enabled,
      time: time,
      notificationsEnabled: notificationsEnabled,
    );
  }
}

extension DietMealModelX on DietMealModel {
  DietMeal toEntity() {
    return DietMeal(
      title: title,
      description: description,
      ingredients: ingredients.map((item) => item.toEntity()).toList(),
      calories: calories,
      proteinG: proteinG.toDouble(),
      carbsG: carbsG.toDouble(),
      fatG: fatG.toDouble(),
    );
  }
}

extension DietDayModelX on DietDayModel {
  DietDay toEntity() {
    return DietDay(
      day: day,
      meals: meals.map(
        (key, value) => MapEntry(key, value?.toEntity()),
      ),
    );
  }
}

extension DietPlanModelX on DietPlanModel {
  DietPlan toEntity() {
    return DietPlan(
      id: id,
      status: status,
      dailyCalorieTarget: dailyCalorieTarget,
      days: days.map((day) => day.toEntity()).toList(),
      createdAt: createdAt,
      shouldRegeneratePlan: shouldRegeneratePlan,
    );
  }
}

extension MealLogModelX on MealLogModel {
  MealLog toEntity() {
    return MealLog(
      id: id,
      slot: slot,
      day: day,
      loggedAt: loggedAt,
      mealTitle: mealTitle,
    );
  }
}

extension SupplementModelX on SupplementModel {
  Supplement toEntity() {
    return Supplement(
      id: id,
      name: name,
      dosageNote: dosageNote,
      times: times,
      linkedMealSlot: linkedMealSlot,
    );
  }
}

extension ComplianceStatsModelX on ComplianceStatsModel {
  ComplianceStats toEntity() {
    return ComplianceStats(
      complianceRate: complianceRate.toDouble(),
      totalPlanned: totalPlanned,
      totalConsumed: totalConsumed,
    );
  }
}

extension DietProfileX on DietProfile {
  UpsertDietProfileRequest toRequest() {
    return UpsertDietProfileRequest(
      age: age,
      heightCm: heightCm,
      weightKg: weightKg,
      gender: gender,
      goal: goal,
      activityLevel: activityLevel,
      doesExercise: doesExercise,
      job: job,
      goalNotes: goalNotes,
      exerciseType: exerciseType,
      exerciseDaysPerWeek: exerciseDaysPerWeek,
      dietaryPreferences: dietaryPreferences,
      allergiesNotes: allergiesNotes,
    );
  }
}

extension MealSlotConfigX on MealSlotConfig {
  MealSlotConfigModel toModel() {
    return MealSlotConfigModel(
      enabled: enabled,
      time: time,
      notificationsEnabled: notificationsEnabled,
    );
  }
}

extension FcmTokenRegistrationX on FcmTokenRegistration {
  FcmTokenRegistrationRequest toRequest() {
    return FcmTokenRegistrationRequest(
      token: token,
      deviceId: deviceId,
      platform: platform,
    );
  }
}
