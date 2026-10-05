import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitsho/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:fitsho/features/workout/data/models/workout_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('removeCachedActivePlan removes the active plan cache entry', () async {
    final preferences = await SharedPreferences.getInstance();
    final dataSource = WorkoutLocalDataSourceImpl(preferences);
    final plan = WorkoutPlanModel(
      id: 'plan_1',
      userId: 'user_1',
      status: 'active',
      notes: WorkoutNotesModel(progression: '', safety: []),
      sessions: [],
      createdAt: DateTime(2026, 1, 1),
    );

    await dataSource.saveActivePlan(plan);
    expect(dataSource.getCachedActivePlan()?.id, 'plan_1');

    await dataSource.removeCachedActivePlan();

    expect(dataSource.getCachedActivePlan(), isNull);
  });

  test('removeCachedProfile removes the cached workout profile', () async {
    final preferences = await SharedPreferences.getInstance();
    final dataSource = WorkoutLocalDataSourceImpl(preferences);
    const profile = WorkoutProfileModel(
      id: 'profile_1',
      userId: 'user_1',
      disciplines: ['strength'],
      styles: {'strength': 'full_body'},
      primaryGoal: 'strength',
      level: 'beginner',
      daysPerWeek: 3,
      sessionMinutes: 60,
      location: 'gym',
      equipment: [],
      injuryAreas: [],
      medicalConditions: [],
      painLevel: 0,
    );

    await dataSource.saveProfile(profile);
    expect(dataSource.getCachedProfile()?.id, 'profile_1');

    await dataSource.removeCachedProfile();

    expect(dataSource.getCachedProfile(), isNull);
  });
}
