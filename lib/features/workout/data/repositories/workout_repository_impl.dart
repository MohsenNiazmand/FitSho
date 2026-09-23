import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/utils/repository_guard.dart';
import 'package:fitsho/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:fitsho/features/workout/data/mappers/workout_mappers.dart';
import 'package:fitsho/features/workout/data/models/workout_models.dart';
import 'package:fitsho/features/workout/data/services/workout_api.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  const WorkoutRepositoryImpl({
    required WorkoutApi api,
    required WorkoutLocalDataSource localDataSource,
  })  : _api = api,
        _localDataSource = localDataSource;

  final WorkoutApi _api;
  final WorkoutLocalDataSource _localDataSource;

  @override
  WorkoutProfile? peekCachedProfile() {
    return _localDataSource.getCachedProfile()?.toEntity();
  }

  @override
  Future<WorkoutOptions?> peekCachedProfileOptions() async {
    final cached = await _localDataSource.getCachedProfileOptions();
    return cached?.toEntity();
  }

  @override
  Future<Either<Failure, WorkoutOptions>> getProfileOptions() async {
    final result = await guard(() async {
      final envelope = await _api.getProfileOptions();
      await _localDataSource.saveOptions(envelope.data);
      return envelope.data.toEntity();
    });

    return result.fold(
      (failure) async {
        if (failure is NetworkFailure) {
          final cached = await _localDataSource.getCachedProfileOptions();
          if (cached != null) {
            return Right(cached.toEntity());
          }
        }
        return Left(failure);
      },
      Right.new,
    );
  }

  @override
  Future<Either<Failure, WorkoutProfile?>> getProfile() async {
    final result = await guard(() async {
      final envelope = await _api.getProfile();
      await _localDataSource.saveProfile(envelope.profile);
      return envelope.profile.toEntity(
        shouldRegeneratePlan: envelope.shouldRegeneratePlan,
      );
    });

    return result.fold(
      (failure) async {
        if (failure is NotFoundFailure) {
          return const Right(null);
        }
        if (failure is NetworkFailure) {
          final cached = _localDataSource.getCachedProfile();
          if (cached != null) {
            return Right(cached.toEntity());
          }
        }
        return Left(failure);
      },
      Right.new,
    );
  }

  @override
  Future<Either<Failure, WorkoutProfile>> upsertProfile({
    required List<String> disciplines,
    required Map<String, String> styles,
    required String goal,
    required String level,
    required int daysPerWeek,
    required int sessionMinutes,
    required String location,
    required List<String> equipment,
    required List<String> injuries,
    String? injuryNotes,
    required int painLevel,
  }) async {
    return guard(() async {
      final request = UpsertWorkoutProfileRequest(
        disciplines: disciplines,
        styles: styles,
        goal: goal,
        level: level,
        daysPerWeek: daysPerWeek,
        sessionMinutes: sessionMinutes,
        location: location,
        equipment: equipment,
        injuries: injuries,
        injuryNotes: injuryNotes,
        painLevel: painLevel,
      );

      final envelope = await _api.upsertProfile(request);
      await _localDataSource.saveProfile(envelope.profile);

      return envelope.profile.toEntity(
        shouldRegeneratePlan: envelope.shouldRegeneratePlan,
      );
    });
  }

  @override
  Future<Either<Failure, WorkoutPlan>> generatePlan() async {
    return guard(() async {
      final envelope = await _api.generatePlan();
      await _localDataSource.saveActivePlan(envelope.data);
      return envelope.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, WorkoutPlan>> getActivePlan() async {
    final result = await guard(() async {
      final envelope = await _api.getActivePlan();
      await _localDataSource.saveActivePlan(envelope.data);
      return envelope.data.toEntity();
    });

    return result.fold(
      (failure) async {
        if (failure is NetworkFailure) {
          final cached = _localDataSource.getCachedActivePlan();
          if (cached != null) {
            return Right(cached.toEntity());
          }
        }
        return Left(failure);
      },
      Right.new,
    );
  }

  @override
  Future<Either<Failure, WorkoutPlanHistory>> getPlanHistory({
    int page = 1,
    int limit = 10,
  }) async {
    return guard(() async {
      final envelope = await _api.getPlanHistory(page, limit);
      final items = envelope.items.map((e) => e.toEntity()).toList();

      return WorkoutPlanHistory(
        items: items,
        total: envelope.total,
        page: envelope.page,
        limit: envelope.limit,
      );
    });
  }

  @override
  Future<Either<Failure, void>> deletePlan(String id) async {
    return guard(() async {
      await _api.deletePlan(id);
    });
  }

  @override
  Future<Either<Failure, WorkoutExerciseItem>> swapExercise({
    required String planId,
    required String day,
    required String itemId,
  }) async {
    return guard(() async {
      final request = SwapExerciseRequest(day: day, itemId: itemId);
      final envelope = await _api.swapExercise(planId, request);
      return envelope.item.toEntity();
    });
  }
}
