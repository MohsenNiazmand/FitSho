import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/hive_registrar.g.dart';

class HiveInitializer {
  HiveInitializer._();

  static const dietProfileBoxName = 'diet_profile_box';
  static const dietPlanBoxName = 'diet_plan_box';
  static const supplementsBoxName = 'supplements_box';
  static const todayMealLogsBoxName = 'today_meal_logs_box';
  static const lastMealLogBoxName = 'last_meal_log_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
  }

  static Future<Box<DietProfile>> openDietProfileBox() {
    return Hive.openBox<DietProfile>(dietProfileBoxName);
  }

  static Future<Box<DietPlan>> openDietPlanBox() {
    return Hive.openBox<DietPlan>(dietPlanBoxName);
  }

  static Future<Box<Supplement>> openSupplementsBox() {
    return Hive.openBox<Supplement>(supplementsBoxName);
  }

  static Future<Box<MealLog>> openTodayMealLogsBox() {
    return Hive.openBox<MealLog>(todayMealLogsBoxName);
  }

  static Future<Box<MealLog>> openLastMealLogBox() {
    return Hive.openBox<MealLog>(lastMealLogBoxName);
  }
}
