import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitsho/features/workout/data/models/workout_models.dart';

abstract class WorkoutLocalDataSource {
  Future<WorkoutOptionsModel?> getOptions();
  Future<void> saveOptions(WorkoutOptionsModel options);

  Future<WorkoutProfileModel?> getProfile();
  Future<void> saveProfile(WorkoutProfileModel profile);

  Future<WorkoutPlanModel?> getActivePlan();
  Future<void> saveActivePlan(WorkoutPlanModel plan);

  Future<void> clear();
}

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  const WorkoutLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _optionsKey = 'workout_options';
  static const String _profileKey = 'workout_profile';
  static const String _activePlanKey = 'workout_active_plan';

  @override
  Future<WorkoutOptionsModel?> getOptions() async {
    final raw = _prefs.getString(_optionsKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return WorkoutOptionsModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveOptions(WorkoutOptionsModel options) async {
    final raw = jsonEncode(options.toJson());
    await _prefs.setString(_optionsKey, raw);
  }

  @override
  Future<WorkoutProfileModel?> getProfile() async {
    final raw = _prefs.getString(_profileKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return WorkoutProfileModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveProfile(WorkoutProfileModel profile) async {
    final raw = jsonEncode(profile.toJson());
    await _prefs.setString(_profileKey, raw);
  }

  @override
  Future<WorkoutPlanModel?> getActivePlan() async {
    final raw = _prefs.getString(_activePlanKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return WorkoutPlanModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveActivePlan(WorkoutPlanModel plan) async {
    final raw = jsonEncode(plan.toJson());
    await _prefs.setString(_activePlanKey, raw);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_optionsKey);
    await _prefs.remove(_profileKey);
    await _prefs.remove(_activePlanKey);
  }
}
