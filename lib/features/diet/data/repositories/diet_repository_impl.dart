import 'package:dio/dio.dart';
import 'package:fitsho/core/error/exception_mapper.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/utils/repository_guard.dart';
import 'package:fitsho/features/diet/data/datasources/diet_local_data_source.dart';
import 'package:fitsho/features/diet/data/mappers/diet_mappers.dart';
import 'package:fitsho/features/diet/data/models/diet_models.dart';
import 'package:fitsho/features/diet/data/services/diet_api.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/repositories/diet_repository.dart';
import 'package:fpdart/fpdart.dart';

class DietRepositoryImpl implements DietRepository {
  DietRepositoryImpl(this._dietApi, this._localDataSource);

  final DietApi _dietApi;
  final DietLocalDataSource _localDataSource;

  @override
  DietProfile? peekCachedProfile() => _localDataSource.getCachedProfile();

  @override
  DietPlan? peekCachedPlan() {
    try {
      return _localDataSource.getCachedPlan();
    } catch (_) {
      _localDataSource.savePlan(null);
      return null;
    }
  }

  @override
  List<Supplement>? peekCachedSupplements() {
    return _localDataSource.getCachedSupplements();
  }

  @override
  List<MealLog>? peekCachedTodayMealLogs() {
    return _localDataSource.getCachedTodayMealLogs();
  }

  @override
  MealLog? peekCachedLastMealLog() {
    return _localDataSource.getCachedLastMealLog();
  }

  @override
  Future<DietProfileOptions?> peekCachedProfileOptions() async {
    final cached = await _localDataSource.getCachedProfileOptions();
    return cached?.toEntity();
  }

  @override
  Future<ComplianceStats?> peekCachedComplianceStats() async {
    final cached = await _localDataSource.getCachedComplianceStats();
    return cached?.toEntity();
  }

  @override
  Future<Either<Failure, DietProfileOptions>> getProfileOptions() async {
    try {
      final response = await _dietApi.getProfileOptions();
      await _localDataSource.saveProfileOptions(response.data);
      return Right(response.data.toEntity());
    } on Object catch (error) {
      final failure = ExceptionMapper.mapException(error);
      if (failure is NetworkFailure) {
        final cached = await _localDataSource.getCachedProfileOptions();
        if (cached != null) return Right(cached.toEntity());
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, DietProfile>> getProfile() async {
    try {
      final response = await _dietApi.getProfile();
      final entity = response.data.toEntity();
      await _localDataSource.saveProfile(entity);
      return Right(entity);
    } on Object catch (error) {
      final failure = ExceptionMapper.mapException(error);
      if (failure is NetworkFailure) {
        final cached = _localDataSource.getCachedProfile();
        if (cached != null) return Right(cached);
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, DietProfile>> saveProfile(DietProfile profile) {
    return guard(() async {
      final response = await _dietApi.upsertProfile(profile.toRequest());
      final entity = response.data.toEntity();
      await _localDataSource.saveProfile(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, Map<String, MealSlotConfig>>> saveMealSlots(
    Map<String, MealSlotConfig> slots,
  ) {
    return guard(() async {
      final slotsMap = slots.map(
        (key, value) => MapEntry(key, value.toModel()),
      );
      final response = await _dietApi.upsertMealSlots(
        UpsertMealSlotsRequest(mealSlots: slotsMap),
      );
      final entity = response.data.toEntity();
      await _localDataSource.saveProfile(entity);
      return entity.mealSlots;
    });
  }

  @override
  Future<Either<Failure, DietPlan>> getActivePlan() async {
    try {
      final response = await _dietApi.getActivePlan();
      final entity = response.data.toEntity();
      await _localDataSource.savePlan(entity);
      return Right(entity);
    } on Object catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        await _localDataSource.savePlan(null);
        return const Left(NotFoundFailure('No active diet plan'));
      }
      final failure = ExceptionMapper.mapException(error);
      if (failure is NetworkFailure) {
        final cached = _localDataSource.getCachedPlan();
        if (cached != null) return Right(cached);
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<DietPlan>>> getPlanHistory() {
    return guard(() async {
      final response = await _dietApi.getPlanHistory();
      return response.data.map((item) => item.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, DietPlan>> generatePlan() {
    return guard(() async {
      final response = await _dietApi.generatePlan();
      final entity = response.data.toEntity();
      await _localDataSource.savePlan(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, void>> deletePlan(String id) {
    return guard(() async {
      await _dietApi.deletePlan(id);
    });
  }

  @override
  Future<Either<Failure, MealLog>> getLastMealLog() async {
    try {
      final response = await _dietApi.getLastMealLog();
      final entity = response.data.toEntity();
      await _localDataSource.saveLastMealLog(entity);
      return Right(entity);
    } on Object catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        return const Left(NotFoundFailure('No meal logs yet'));
      }
      final failure = ExceptionMapper.mapException(error);
      if (failure is NetworkFailure) {
        final cached = _localDataSource.getCachedLastMealLog();
        if (cached != null) return Right(cached);
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<MealLog>>> getTodayMealLogs() async {
    try {
      final response = await _dietApi.getTodayMealLogs();
      final entities = response.data.map((log) => log.toEntity()).toList();
      await _localDataSource.saveTodayMealLogs(entities);
      return Right(entities);
    } on Object catch (error) {
      final failure = ExceptionMapper.mapException(error);
      if (failure is NetworkFailure) {
        final cached = _localDataSource.getCachedTodayMealLogs();
        if (cached != null) return Right(cached);
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ComplianceStats>> getComplianceStats() async {
    try {
      final response = await _dietApi.getComplianceStats();
      await _localDataSource.saveComplianceStats(response.data);
      return Right(response.data.toEntity());
    } on Object catch (error) {
      final failure = ExceptionMapper.mapException(error);
      if (failure is NetworkFailure) {
        final cached = await _localDataSource.getCachedComplianceStats();
        if (cached != null) return Right(cached.toEntity());
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, MealLog>> logMeal({
    required String slot,
    required String day,
  }) {
    return guard(() async {
      final response = await _dietApi.logMeal(
        LogMealRequest(slot: slot, day: day),
      );
      final entity = response.data.toEntity();
      await _localDataSource.addTodayMealLog(entity);
      await _localDataSource.saveLastMealLog(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, List<Supplement>>> listSupplements() async {
    try {
      final response = await _dietApi.listSupplements();
      final entities = response.data.map((item) => item.toEntity()).toList();
      await _localDataSource.saveSupplements(entities);
      return Right(entities);
    } on Object catch (error) {
      final failure = ExceptionMapper.mapException(error);
      if (failure is NetworkFailure) {
        final cached = _localDataSource.getCachedSupplements();
        if (cached != null) return Right(cached);
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Supplement>> createSupplement({
    required String name,
    String? dosageNote,
    List<String> times = const [],
    String? linkedMealSlot,
  }) {
    return guard(() async {
      final response = await _dietApi.createSupplement(
        CreateSupplementRequest(
          name: name,
          dosageNote: dosageNote,
          times: times,
          linkedMealSlot: linkedMealSlot,
        ),
      );
      final entity = response.data.toEntity();
      await _localDataSource.upsertSupplement(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, Supplement>> updateSupplement({
    required String id,
    String? name,
    String? dosageNote,
    List<String>? times,
    String? linkedMealSlot,
  }) {
    return guard(() async {
      final response = await _dietApi.updateSupplement(
        id,
        UpdateSupplementRequest(
          name: name,
          dosageNote: dosageNote,
          times: times,
          linkedMealSlot: linkedMealSlot,
        ),
      );
      final entity = response.data.toEntity();
      await _localDataSource.upsertSupplement(entity);
      return entity;
    });
  }

  @override
  Future<Either<Failure, void>> deleteSupplement(String id) {
    return guard(() async {
      await _dietApi.deleteSupplement(id);
      await _localDataSource.removeSupplement(id);
    });
  }

  @override
  Future<Either<Failure, void>> registerFcmToken(
    FcmTokenRegistration body,
  ) {
    return guard(() async {
      await _dietApi.registerFcmToken(body.toRequest());
    });
  }

  @override
  Future<Either<Failure, void>> unregisterFcmToken(String token) {
    return guard(() async {
      await _dietApi.unregisterFcmToken(token);
    });
  }
}
