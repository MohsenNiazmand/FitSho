import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitsho/features/diet/data/models/diet_models.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';

abstract class DietLocalDataSource {
  DietProfile? getCachedProfile();

  Future<void> saveProfile(DietProfile profile);

  DietPlan? getCachedPlan();

  Future<void> savePlan(DietPlan? plan);

  List<Supplement>? getCachedSupplements();

  Future<void> saveSupplements(List<Supplement> supplements);

  Future<void> upsertSupplement(Supplement supplement);

  Future<void> removeSupplement(String id);

  List<MealLog>? getCachedTodayMealLogs();

  Future<void> saveTodayMealLogs(List<MealLog> logs);

  Future<void> addTodayMealLog(MealLog log);

  MealLog? getCachedLastMealLog();

  Future<void> saveLastMealLog(MealLog log);

  Future<DietProfileOptionsModel?> getCachedProfileOptions();

  Future<void> saveProfileOptions(DietProfileOptionsModel options);

  Future<ComplianceStatsModel?> getCachedComplianceStats();

  Future<void> saveComplianceStats(ComplianceStatsModel stats);

  Future<void> clearCache();
}

class DietLocalDataSourceImpl implements DietLocalDataSource {
  DietLocalDataSourceImpl({
    required Box<DietProfile> profileBox,
    required Box<DietPlan> planBox,
    required Box<Supplement> supplementsBox,
    required Box<MealLog> todayMealLogsBox,
    required Box<MealLog> lastMealLogBox,
    required SharedPreferences prefs,
  }) : _profileBox = profileBox,
       _planBox = planBox,
       _supplementsBox = supplementsBox,
       _todayMealLogsBox = todayMealLogsBox,
       _lastMealLogBox = lastMealLogBox,
       _prefs = prefs;

  static const _singleValueKey = 'value';
  static const _profileOptionsPrefsKey = 'diet_profile_options_cache';
  static const _complianceStatsPrefsKey = 'diet_compliance_stats_cache';

  final Box<DietProfile> _profileBox;
  final Box<DietPlan> _planBox;
  final Box<Supplement> _supplementsBox;
  final Box<MealLog> _todayMealLogsBox;
  final Box<MealLog> _lastMealLogBox;
  final SharedPreferences _prefs;

  @override
  DietProfile? getCachedProfile() => _profileBox.get(_singleValueKey);

  @override
  Future<void> saveProfile(DietProfile profile) {
    return _profileBox.put(_singleValueKey, profile);
  }

  @override
  DietPlan? getCachedPlan() => _planBox.get(_singleValueKey);

  @override
  Future<void> savePlan(DietPlan? plan) {
    if (plan == null) return _planBox.delete(_singleValueKey);
    return _planBox.put(_singleValueKey, plan);
  }

  @override
  List<Supplement>? getCachedSupplements() {
    if (_supplementsBox.isEmpty) return null;
    return _supplementsBox.values.toList();
  }

  @override
  Future<void> saveSupplements(List<Supplement> supplements) async {
    await _supplementsBox.clear();
    await _supplementsBox.putAll({
      for (final item in supplements) item.id: item,
    });
  }

  @override
  Future<void> upsertSupplement(Supplement supplement) {
    return _supplementsBox.put(supplement.id, supplement);
  }

  @override
  Future<void> removeSupplement(String id) => _supplementsBox.delete(id);

  @override
  List<MealLog>? getCachedTodayMealLogs() {
    if (_todayMealLogsBox.isEmpty) return null;
    return _todayMealLogsBox.values.toList();
  }

  @override
  Future<void> saveTodayMealLogs(List<MealLog> logs) async {
    await _todayMealLogsBox.clear();
    await _todayMealLogsBox.putAll({
      for (final item in logs) item.id: item,
    });
  }

  @override
  Future<void> addTodayMealLog(MealLog log) {
    return _todayMealLogsBox.put(log.id, log);
  }

  @override
  MealLog? getCachedLastMealLog() => _lastMealLogBox.get(_singleValueKey);

  @override
  Future<void> saveLastMealLog(MealLog log) {
    return _lastMealLogBox.put(_singleValueKey, log);
  }

  @override
  Future<DietProfileOptionsModel?> getCachedProfileOptions() async {
    final raw = _prefs.getString(_profileOptionsPrefsKey);
    if (raw == null) return null;
    return DietProfileOptionsModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveProfileOptions(DietProfileOptionsModel options) {
    return _prefs.setString(
      _profileOptionsPrefsKey,
      jsonEncode(options.toJson()),
    );
  }

  @override
  Future<ComplianceStatsModel?> getCachedComplianceStats() async {
    final raw = _prefs.getString(_complianceStatsPrefsKey);
    if (raw == null) return null;
    return ComplianceStatsModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveComplianceStats(ComplianceStatsModel stats) {
    return _prefs.setString(
      _complianceStatsPrefsKey,
      jsonEncode(stats.toJson()),
    );
  }

  @override
  Future<void> clearCache() async {
    await _profileBox.clear();
    await _planBox.clear();
    await _supplementsBox.clear();
    await _todayMealLogsBox.clear();
    await _lastMealLogBox.clear();
    await _prefs.remove(_profileOptionsPrefsKey);
    await _prefs.remove(_complianceStatsPrefsKey);
  }
}
