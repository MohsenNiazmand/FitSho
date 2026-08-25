import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/repositories/diet_repository.dart';

part 'diet_providers.g.dart';

@riverpod
class DietOptionsNotifier extends _$DietOptionsNotifier {
  @override
  Future<DietProfileOptions> build() async {
    final result = await getIt<DietRepository>().getProfileOptions();
    return result.fold(
      (failure) => throw StateError(failure.message),
      (options) => options,
    );
  }
}

@riverpod
class DietProfileNotifier extends _$DietProfileNotifier {
  @override
  Future<DietProfile?> build() async {
    final result = await getIt<DietRepository>().getProfile();
    return result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          return null;
        }
        throw StateError(failure.message);
      },
      (profile) => profile,
    );
  }

  Future<Failure?> save(DietProfile profile) async {
    final result = await getIt<DietRepository>().saveProfile(profile);
    return result.fold(
      (failure) => failure,
      (saved) {
        state = AsyncValue.data(saved);
        ref.invalidate(dietPlanNotifierProvider);
        return null;
      },
    );
  }
}

@riverpod
class DietPlanNotifier extends _$DietPlanNotifier {
  @override
  Future<DietPlan?> build() async {
    final result = await getIt<DietRepository>().getActivePlan();
    return result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          return null;
        }
        throw StateError(failure.message);
      },
      (plan) => plan,
    );
  }

  Future<Failure?> generate() async {
    state = const AsyncValue.loading();
    final result = await getIt<DietRepository>().generatePlan();
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (plan) {
        state = AsyncValue.data(plan);
        return null;
      },
    );
  }

  Future<void> refreshPlan() async {
    ref.invalidateSelf();
    await future;
  }

  Future<Failure?> delete(String id) async {
    final result = await getIt<DietRepository>().deletePlan(id);
    return result.fold(
      (failure) => failure,
      (_) {
        ref.invalidateSelf();
        ref.invalidate(dietPlanHistoryNotifierProvider);
        return null;
      },
    );
  }
}

@riverpod
class DietPlanHistoryNotifier extends _$DietPlanHistoryNotifier {
  @override
  Future<List<DietPlan>> build() async {
    final result = await getIt<DietRepository>().getPlanHistory();
    return result.fold(
      (failure) => [],
      (list) => list,
    );
  }

  Future<void> refreshHistory() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class LastMealLogNotifier extends _$LastMealLogNotifier {
  @override
  Future<MealLog?> build() async {
    final result = await getIt<DietRepository>().getLastMealLog();
    return result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          return null;
        }
        throw StateError(failure.message);
      },
      (log) => log,
    );
  }

  Future<void> refreshLog() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class TodayMealLogsNotifier extends _$TodayMealLogsNotifier {
  @override
  Future<List<MealLog>> build() async {
    final result = await getIt<DietRepository>().getTodayMealLogs();
    return result.fold(
      (failure) => [],
      (logs) => logs,
    );
  }

  Future<void> refreshLogs() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class ComplianceStatsNotifier extends _$ComplianceStatsNotifier {
  @override
  Future<ComplianceStats?> build() async {
    final result = await getIt<DietRepository>().getComplianceStats();
    return result.fold(
      (failure) => null,
      (stats) => stats,
    );
  }

  Future<void> refreshStats() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class LogMealNotifier extends _$LogMealNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> logMeal({
    required String slot,
    required String day,
  }) async {
    state = const AsyncValue.loading();
    final result = await getIt<DietRepository>().logMeal(
      slot: slot,
      day: day,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) {
        ref.invalidate(lastMealLogNotifierProvider);
        ref.invalidate(todayMealLogsNotifierProvider);
        ref.invalidate(complianceStatsNotifierProvider);
        state = const AsyncValue.data(null);
        return null;
      },
    );
  }
}

@riverpod
class MealSlotsNotifier extends _$MealSlotsNotifier {
  @override
  Future<Map<String, MealSlotConfig>> build() async {
    final result = await getIt<DietRepository>().getMealSlots();
    return result.fold(
      (failure) => throw StateError(failure.message),
      (slots) => slots,
    );
  }

  Future<Failure?> save(Map<String, MealSlotConfig> slots) async {
    final result = await getIt<DietRepository>().saveMealSlots(slots);
    return result.fold(
      (failure) => failure,
      (saved) {
        state = AsyncValue.data(saved);
        return null;
      },
    );
  }
}

@riverpod
class SupplementsNotifier extends _$SupplementsNotifier {
  @override
  Future<List<Supplement>> build() async {
    final result = await getIt<DietRepository>().listSupplements();
    return result.fold(
      (failure) => throw StateError(failure.message),
      (items) => items,
    );
  }

  Future<void> refreshList() async {
    ref.invalidateSelf();
    await future;
  }

  Future<Failure?> create({
    required String name,
    String? dosageNote,
    List<String> times = const [],
    String? linkedMealSlot,
  }) async {
    final result = await getIt<DietRepository>().createSupplement(
      name: name,
      dosageNote: dosageNote,
      times: times,
      linkedMealSlot: linkedMealSlot,
    );

    return result.fold(
      (failure) => failure,
      (_) {
        ref.invalidateSelf();
        return null;
      },
    );
  }

  Future<Failure?> updateSupplement({
    required String id,
    String? name,
    String? dosageNote,
    List<String>? times,
    String? linkedMealSlot,
  }) async {
    final result = await getIt<DietRepository>().updateSupplement(
      id: id,
      name: name,
      dosageNote: dosageNote,
      times: times,
      linkedMealSlot: linkedMealSlot,
    );

    return result.fold(
      (failure) => failure,
      (_) {
        ref.invalidateSelf();
        return null;
      },
    );
  }

  Future<Failure?> delete(String id) async {
    final result = await getIt<DietRepository>().deleteSupplement(id);
    return result.fold(
      (failure) => failure,
      (_) {
        ref.invalidateSelf();
        return null;
      },
    );
  }
}
