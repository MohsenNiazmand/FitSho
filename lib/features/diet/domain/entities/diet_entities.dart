import 'package:fitsho/shared/domain/entities/ingredient.dart';

class DietProfile {
  const DietProfile({
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

  final int age;
  final int heightCm;
  final double weightKg;
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
  final double? bmi;
  final int? dailyCalorieTarget;
  final Map<String, MealSlotConfig> mealSlots;
}

class DietOptionItem {
  const DietOptionItem({
    required this.id,
    required this.label,
    this.isAvailable = true,
  });

  final String id;
  final String label;
  final bool isAvailable;
}

class DietProfileOptions {
  const DietProfileOptions({
    required this.genders,
    required this.goals,
    required this.activityLevels,
    required this.dietaryPreferences,
  });

  final List<DietOptionItem> genders;
  final List<DietOptionItem> goals;
  final List<DietOptionItem> activityLevels;
  final List<DietOptionItem> dietaryPreferences;
}

class MealSlotConfig {
  const MealSlotConfig({
    required this.enabled,
    required this.time,
    this.notificationsEnabled = true,
  });

  final bool enabled;
  final String time;
  final bool notificationsEnabled;
}

class DietMeal {
  const DietMeal({
    required this.title,
    this.description,
    this.ingredients = const [],
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String title;
  final String? description;
  final List<Ingredient> ingredients;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
}

class DietDay {
  const DietDay({
    required this.day,
    required this.meals,
  });

  final String day;
  final Map<String, DietMeal?> meals;
}

class DietPlan {
  const DietPlan({
    required this.id,
    required this.status,
    required this.dailyCalorieTarget,
    required this.days,
    required this.createdAt,
    this.shouldRegeneratePlan = false,
  });

  final String id;
  final String status;
  final int dailyCalorieTarget;
  final List<DietDay> days;
  final DateTime createdAt;
  final bool shouldRegeneratePlan;
}

class MealLog {
  const MealLog({
    required this.id,
    required this.slot,
    required this.day,
    required this.loggedAt,
    this.mealTitle,
  });

  final String id;
  final String slot;
  final String day;
  final DateTime loggedAt;
  final String? mealTitle;
}

class Supplement {
  const Supplement({
    required this.id,
    required this.name,
    this.dosageNote,
    this.times = const [],
    this.linkedMealSlot,
  });

  final String id;
  final String name;
  final String? dosageNote;
  final List<String> times;
  final String? linkedMealSlot;
}

class FcmTokenRegistration {
  const FcmTokenRegistration({
    required this.token,
    required this.deviceId,
    required this.platform,
  });

  final String token;
  final String deviceId;
  final String platform;
}

class ComplianceStats {
  const ComplianceStats({
    required this.complianceRate,
    required this.totalPlanned,
    required this.totalConsumed,
  });

  final double complianceRate;
  final int totalPlanned;
  final int totalConsumed;
}
