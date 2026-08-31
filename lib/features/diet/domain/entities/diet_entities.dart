import 'package:hive_ce/hive.dart';
import 'package:fitsho/shared/domain/entities/ingredient.dart';

part 'diet_entities.g.dart';

@HiveType(typeId: 4)
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
    this.shouldRegeneratePlan = false,
  });

  @HiveField(0)
  final int age;
  @HiveField(1)
  final int heightCm;
  @HiveField(2)
  final double weightKg;
  @HiveField(3)
  final String gender;
  @HiveField(4)
  final String goal;
  @HiveField(5)
  final String activityLevel;
  @HiveField(6)
  final bool doesExercise;
  @HiveField(7)
  final String? job;
  @HiveField(8)
  final String? goalNotes;
  @HiveField(9)
  final String? exerciseType;
  @HiveField(10)
  final int? exerciseDaysPerWeek;
  @HiveField(11)
  final List<String> dietaryPreferences;
  @HiveField(12)
  final String? allergiesNotes;
  @HiveField(13)
  final double? bmi;
  @HiveField(14)
  final int? dailyCalorieTarget;
  @HiveField(15)
  final Map<String, MealSlotConfig> mealSlots;
  @HiveField(16)
  final bool shouldRegeneratePlan;
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

@HiveType(typeId: 1)
class MealSlotConfig {
  const MealSlotConfig({
    required this.enabled,
    required this.time,
    this.notificationsEnabled = true,
  });

  MealSlotConfig copyWith({
    bool? enabled,
    String? time,
    bool? notificationsEnabled,
  }) {
    return MealSlotConfig(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @HiveField(0)
  final bool enabled;
  @HiveField(1)
  final String time;
  @HiveField(2)
  final bool notificationsEnabled;
}

@HiveType(typeId: 2)
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

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final List<Ingredient> ingredients;
  @HiveField(3)
  final int calories;
  @HiveField(4)
  final double proteinG;
  @HiveField(5)
  final double carbsG;
  @HiveField(6)
  final double fatG;
}

@HiveType(typeId: 3)
class DietDay {
  const DietDay({
    required this.day,
    required this.meals,
  });

  @HiveField(0)
  final String day;
  @HiveField(1)
  final Map<String, DietMeal?> meals;
}

@HiveType(typeId: 5)
class DietPlan {
  const DietPlan({
    required this.id,
    required this.status,
    required this.dailyCalorieTarget,
    required this.days,
    required this.createdAt,
    this.shouldRegeneratePlan = false,
    this.remainingFullGenerations,
    this.remainingMealSwaps,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String status;
  @HiveField(2)
  final int dailyCalorieTarget;
  @HiveField(3)
  final List<DietDay> days;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final bool shouldRegeneratePlan;
  @HiveField(6)
  final int? remainingFullGenerations;
  @HiveField(7)
  final int? remainingMealSwaps;

  DietPlan copyWith({
    String? id,
    String? status,
    int? dailyCalorieTarget,
    List<DietDay>? days,
    DateTime? createdAt,
    bool? shouldRegeneratePlan,
    int? remainingFullGenerations,
    int? remainingMealSwaps,
  }) {
    return DietPlan(
      id: id ?? this.id,
      status: status ?? this.status,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
      shouldRegeneratePlan: shouldRegeneratePlan ?? this.shouldRegeneratePlan,
      remainingFullGenerations:
          remainingFullGenerations ?? this.remainingFullGenerations,
      remainingMealSwaps: remainingMealSwaps ?? this.remainingMealSwaps,
    );
  }
}

@HiveType(typeId: 6)
class MealLog {
  const MealLog({
    required this.id,
    required this.slot,
    required this.day,
    required this.loggedAt,
    this.mealTitle,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String slot;
  @HiveField(2)
  final String day;
  @HiveField(3)
  final DateTime loggedAt;
  @HiveField(4)
  final String? mealTitle;
}

@HiveType(typeId: 7)
class Supplement {
  const Supplement({
    required this.id,
    required this.name,
    this.dosageNote,
    this.times = const [],
    this.linkedMealSlot,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? dosageNote;
  @HiveField(3)
  final List<String> times;
  @HiveField(4)
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
