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
  static const metadataBoxName = 'metadata_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
  }

  static Future<Box<T>> _openResilientBox<T>(String name) async {
    try {
      return await Hive.openBox<T>(name);
    } catch (e) {
      // In case of schema mismatch or corrupted data, delete and reopen
      await Hive.deleteBoxFromDisk(name);
      return await Hive.openBox<T>(name);
    }
  }

  static Future<Box<DietProfile>> openDietProfileBox() {
    return _openResilientBox<DietProfile>(dietProfileBoxName);
  }

  static Future<Box<DietPlan>> openDietPlanBox() {
    return _openResilientBox<DietPlan>(dietPlanBoxName);
  }

  static Future<Box<Supplement>> openSupplementsBox() {
    return _openResilientBox<Supplement>(supplementsBoxName);
  }

  static Future<Box<MealLog>> openTodayMealLogsBox() {
    return _openResilientBox<MealLog>(todayMealLogsBoxName);
  }

  static Future<Box<MealLog>> openLastMealLogBox() {
    return _openResilientBox<MealLog>(lastMealLogBoxName);
  }

  static Future<Box<dynamic>> openMetadataBox() {
    return _openResilientBox<dynamic>(metadataBoxName);
  }
}
