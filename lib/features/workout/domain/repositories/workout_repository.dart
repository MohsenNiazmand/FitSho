import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';

abstract class WorkoutRepository {
  WorkoutProfile? peekCachedProfile();

  Future<WorkoutOptions?> peekCachedProfileOptions();

  WorkoutPlan? peekCachedActivePlan();

  Future<Either<Failure, WorkoutOptions>> getProfileOptions();

  Future<Either<Failure, WorkoutProfile?>> getProfile();

  Future<Either<Failure, WorkoutProfile>> upsertProfile({
    required List<String> disciplines,
    required Map<String, String> styles,
    required String primaryGoal,
    String? secondaryGoal,
    required String level,
    required int daysPerWeek,
    required int sessionMinutes,
    required String location,
    required List<String> equipment,
    required List<String> injuryAreas,
    required List<String> medicalConditions,
    String? injuryNotes,
    required int painLevel,
  });

  Future<Either<Failure, WorkoutPlan>> generatePlan();

  Future<Either<Failure, WorkoutPlan>> getActivePlan();

  Future<Either<Failure, WorkoutPlanHistory>> getPlanHistory({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, void>> deletePlan(String id);

  Future<Either<Failure, (WorkoutExerciseItem, int)>> swapExercise({
    required String planId,
    required String sessionId,
    required String itemId,
  });
}
