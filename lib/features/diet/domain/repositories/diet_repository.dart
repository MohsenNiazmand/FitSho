import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';

abstract class DietRepository {
  Future<Either<Failure, DietProfileOptions>> getProfileOptions();

  Future<Either<Failure, DietProfile>> getProfile();

  Future<Either<Failure, DietProfile>> saveProfile(DietProfile profile);

  Future<Either<Failure, Map<String, MealSlotConfig>>> getMealSlots();

  Future<Either<Failure, Map<String, MealSlotConfig>>> saveMealSlots(
    Map<String, MealSlotConfig> slots,
  );

  Future<Either<Failure, DietPlan>> getActivePlan();

  Future<Either<Failure, List<DietPlan>>> getPlanHistory();

  Future<Either<Failure, DietPlan>> generatePlan();

  Future<Either<Failure, void>> deletePlan(String id);

  Future<Either<Failure, MealLog>> getLastMealLog();

  Future<Either<Failure, List<MealLog>>> getTodayMealLogs();

  Future<Either<Failure, ComplianceStats>> getComplianceStats();

  Future<Either<Failure, MealLog>> logMeal({
    required String slot,
    required String day,
  });

  Future<Either<Failure, List<Supplement>>> listSupplements();

  Future<Either<Failure, Supplement>> createSupplement({
    required String name,
    String? dosageNote,
    List<String> times,
    String? linkedMealSlot,
  });

  Future<Either<Failure, Supplement>> updateSupplement({
    required String id,
    String? name,
    String? dosageNote,
    List<String>? times,
    String? linkedMealSlot,
  });

  Future<Either<Failure, void>> deleteSupplement(String id);

  Future<Either<Failure, void>> registerFcmToken(FcmTokenRegistration body);
}
