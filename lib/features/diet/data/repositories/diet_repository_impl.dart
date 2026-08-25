import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/exception_mapper.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/utils/repository_guard.dart';
import 'package:fitsho/features/diet/data/mappers/diet_mappers.dart';
import 'package:fitsho/features/diet/data/models/diet_models.dart';
import 'package:fitsho/features/diet/data/services/diet_api.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/repositories/diet_repository.dart';

class DietRepositoryImpl implements DietRepository {
  DietRepositoryImpl(this._dietApi);

  final DietApi _dietApi;

  @override
  Future<Either<Failure, DietProfileOptions>> getProfileOptions() {
    return guard(() async {
      final response = await _dietApi.getProfileOptions();
      return response.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, DietProfile>> getProfile() async {
    try {
      final response = await _dietApi.getProfile();
      return Right(response.data.toEntity());
    } on Object catch (error) {
      return Left(ExceptionMapper.mapException(error));
    }
  }

  @override
  Future<Either<Failure, DietProfile>> saveProfile(DietProfile profile) {
    return guard(() async {
      final response =
          await _dietApi.upsertProfile(profile.toRequest());
      return response.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, Map<String, MealSlotConfig>>> getMealSlots() async {
    try {
      final response = await _dietApi.getMealSlots();
      final slots = response.data.map(
        (key, value) => MapEntry(key, value.toEntity()),
      );
      return Right(slots.isEmpty ? DietConstants.defaultMealSlots() : slots);
    } on Object catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        return Right(DietConstants.defaultMealSlots());
      }
      return Left(ExceptionMapper.mapException(error));
    }
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
      return response.data.map(
        (key, value) => MapEntry(key, value.toEntity()),
      );
    });
  }

  @override
  Future<Either<Failure, DietPlan>> getActivePlan() async {
    try {
      final response = await _dietApi.getActivePlan();
      return Right(response.data.toEntity());
    } on Object catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        return const Left(NotFoundFailure('No active diet plan'));
      }
      return Left(ExceptionMapper.mapException(error));
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
      return response.data.toEntity();
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
      return Right(response.data.toEntity());
    } on Object catch (error) {
      if (error is DioException && error.response?.statusCode == 404) {
        return const Left(NotFoundFailure('No meal logs yet'));
      }
      return Left(ExceptionMapper.mapException(error));
    }
  }

  @override
  Future<Either<Failure, List<MealLog>>> getTodayMealLogs() {
    return guard(() async {
      final response = await _dietApi.getTodayMealLogs();
      return response.data.map((log) => log.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, ComplianceStats>> getComplianceStats() {
    return guard(() async {
      final response = await _dietApi.getComplianceStats();
      return response.data.toEntity();
    });
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
      return response.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<Supplement>>> listSupplements() {
    return guard(() async {
      final response = await _dietApi.listSupplements();
      return response.data.map((item) => item.toEntity()).toList();
    });
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
      return response.data.toEntity();
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
      return response.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteSupplement(String id) {
    return guard(() async {
      await _dietApi.deleteSupplement(id);
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
}
