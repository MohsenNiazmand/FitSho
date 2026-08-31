import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/repositories/diet_repository.dart';

part 'diet_providers.g.dart';

@riverpod
class DietOptionsNotifier extends _$DietOptionsNotifier {
  bool _disposed = false;

  @override
  Future<DietProfileOptions> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = await getIt<DietRepository>().peekCachedProfileOptions();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<DietProfileOptions> _fetch() async {
    final result = await getIt<DietRepository>().getProfileOptions();
    return result.fold(
      (failure) => throw StateError(failure.message),
      (options) => options,
    );
  }

  void _revalidate() {
    getIt<DietRepository>().getProfileOptions().then((result) {
      if (_disposed) return;
      result.fold((_) {}, (options) => state = AsyncValue.data(options));
    });
  }
}

@riverpod
class DietProfileNotifier extends _$DietProfileNotifier {
  bool _disposed = false;

  @override
  Future<DietProfile?> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = getIt<DietRepository>().peekCachedProfile();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<DietProfile?> _fetch() async {
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

  void _revalidate() {
    getIt<DietRepository>().getProfile().then((result) {
      if (_disposed) return;
      result.fold(
        (failure) {
          if (failure is NotFoundFailure) {
            state = const AsyncValue.data(null);
          }
        },
        (profile) => state = AsyncValue.data(profile),
      );
    });
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
  bool _disposed = false;

  @override
  Future<DietPlan?> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = getIt<DietRepository>().peekCachedPlan();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<DietPlan?> _fetch() async {
    final result = await getIt<DietRepository>().getActivePlan();
    return result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          return null;
        }
        // If it's a mapping error (like String to num mismatch), return null to force reload
        if (failure.message.contains('type') && failure.message.contains('subtype')) {
          return null;
        }
        throw StateError(failure.message);
      },
      (plan) => plan,
    );
  }

  void _revalidate() {
    getIt<DietRepository>().getActivePlan().then((result) {
      if (_disposed) return;
      result.fold(
        (failure) {
          if (failure is NotFoundFailure) {
            state = const AsyncValue.data(null);
          }
        },
        (plan) => state = AsyncValue.data(plan),
      );
    });
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
  bool _disposed = false;

  @override
  Future<MealLog?> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = getIt<DietRepository>().peekCachedLastMealLog();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<MealLog?> _fetch() async {
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

  void _revalidate() {
    getIt<DietRepository>().getLastMealLog().then((result) {
      if (_disposed) return;
      result.fold(
        (failure) {
          if (failure is NotFoundFailure) {
            state = const AsyncValue.data(null);
          }
        },
        (log) => state = AsyncValue.data(log),
      );
    });
  }

  Future<void> refreshLog() async {
    ref.invalidateSelf();
    await future;
  }

  set state(AsyncValue<MealLog?> value) => super.state = value;
}

@riverpod
class TodayMealLogsNotifier extends _$TodayMealLogsNotifier {
  bool _disposed = false;

  @override
  Future<List<MealLog>> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = getIt<DietRepository>().peekCachedTodayMealLogs();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<List<MealLog>> _fetch() async {
    final result = await getIt<DietRepository>().getTodayMealLogs();
    return result.fold((failure) => [], (logs) => logs);
  }

  void _revalidate() {
    getIt<DietRepository>().getTodayMealLogs().then((result) {
      if (_disposed) return;
      result.fold((_) {}, (logs) => state = AsyncValue.data(logs));
    });
  }

  Future<void> refreshLogs() async {
    ref.invalidateSelf();
    await future;
  }

  set state(AsyncValue<List<MealLog>> value) {
    super.state = value;
  }
}

@riverpod
class ComplianceStatsNotifier extends _$ComplianceStatsNotifier {
  bool _disposed = false;

  @override
  Future<ComplianceStats?> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = await getIt<DietRepository>().peekCachedComplianceStats();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<ComplianceStats?> _fetch() async {
    final result = await getIt<DietRepository>().getComplianceStats();
    return result.fold((failure) => null, (stats) => stats);
  }

  void _revalidate() {
    getIt<DietRepository>().getComplianceStats().then((result) {
      if (_disposed) return;
      result.fold((_) {}, (stats) => state = AsyncValue.data(stats));
    });
  }

  Future<void> refreshStats() async {
    ref.invalidateSelf();
    await future;
  }

  set state(AsyncValue<ComplianceStats?> value) => super.state = value;
}

@riverpod
class LogMealNotifier extends _$LogMealNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> logMeal({
    required String slot,
    required String day,
  }) async {
    final previousLogs =
        ref.read(todayMealLogsNotifierProvider).valueOrNull ?? [];
    final previousLastMeal =
        ref.read(lastMealLogNotifierProvider).valueOrNull;
    final previousStats =
        ref.read(complianceStatsNotifierProvider).valueOrNull;

    // Optimistic Update Data
    final tempLog = MealLog(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      slot: slot,
      day: day,
      loggedAt: DateTime.now(),
    );

    // 1. Update Today Logs
    ref.read(todayMealLogsNotifierProvider.notifier).state =
        AsyncValue.data([...previousLogs, tempLog]);

    // 2. Update Last Meal Log
    ref.read(lastMealLogNotifierProvider.notifier).state =
        AsyncValue.data(tempLog);

    // 3. Update Compliance Stats
    if (previousStats != null && previousStats.totalPlanned > 0) {
      final newConsumed = previousStats.totalConsumed + 1;
      final newRate = (newConsumed / previousStats.totalPlanned) * 100;
      ref.read(complianceStatsNotifierProvider.notifier).state =
          AsyncValue.data(ComplianceStats(
        complianceRate: newRate,
        totalPlanned: previousStats.totalPlanned,
        totalConsumed: newConsumed,
      ));
    }

    final result = await getIt<DietRepository>().logMeal(
      slot: slot,
      day: day,
    );

    return result.fold(
      (failure) {
        // Rollback all
        ref.read(todayMealLogsNotifierProvider.notifier).state =
            AsyncValue.data(previousLogs);
        ref.read(lastMealLogNotifierProvider.notifier).state =
            AsyncValue.data(previousLastMeal);
        if (previousStats != null) {
          ref.read(complianceStatsNotifierProvider.notifier).state =
              AsyncValue.data(previousStats);
        }
        return failure;
      },
      (_) {
        // Re-invalidate to ensure we have the real server data (IDs, exact stats)
        ref.invalidate(lastMealLogNotifierProvider);
        ref.invalidate(todayMealLogsNotifierProvider);
        
        // Delay stats invalidation to allow server-side aggregation to finish
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.invalidate(complianceStatsNotifierProvider);
        });
        return null;
      },
    );
  }
}

@riverpod
class MealSlotsNotifier extends _$MealSlotsNotifier {
  @override
  Future<Map<String, MealSlotConfig>> build() async {
    // There is no dedicated GET endpoint for meal slots — they only ever
    // arrive embedded in the diet profile response, so derive from that
    // provider instead of issuing a separate (nonexistent) request.
    final profile = await ref.watch(dietProfileNotifierProvider.future);
    final slots = profile?.mealSlots ?? const {};
    return slots.isEmpty ? DietConstants.defaultMealSlots() : slots;
  }

  Future<Failure?> save(Map<String, MealSlotConfig> slots) async {
    final result = await getIt<DietRepository>().saveMealSlots(slots);
    return result.fold(
      (failure) => failure,
      (saved) {
        state = AsyncValue.data(saved);
        ref.invalidate(dietProfileNotifierProvider);
        return null;
      },
    );
  }
}

@riverpod
class SupplementsNotifier extends _$SupplementsNotifier {
  bool _disposed = false;

  @override
  Future<List<Supplement>> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = getIt<DietRepository>().peekCachedSupplements();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<List<Supplement>> _fetch() async {
    final result = await getIt<DietRepository>().listSupplements();
    return result.fold(
      (failure) => throw StateError(failure.message),
      (items) => items,
    );
  }

  void _revalidate() {
    getIt<DietRepository>().listSupplements().then((result) {
      if (_disposed) return;
      result.fold((_) {}, (items) => state = AsyncValue.data(items));
    });
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
