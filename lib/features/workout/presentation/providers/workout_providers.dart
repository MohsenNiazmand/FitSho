import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/features/workout/data/mappers/workout_mappers.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/domain/repositories/workout_repository.dart';

part 'workout_providers.g.dart';

@riverpod
class WorkoutOptionsNotifier extends _$WorkoutOptionsNotifier {
  bool _disposed = false;

  @override
  Future<WorkoutOptions> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = await getIt<WorkoutRepository>().peekCachedProfileOptions();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<WorkoutOptions> _fetch() async {
    final result = await getIt<WorkoutRepository>().getProfileOptions();
    return result.fold(
      (failure) => throw StateError(failure.message),
      (options) => options,
    );
  }

  void _revalidate() {
    getIt<WorkoutRepository>().getProfileOptions().then((result) {
      if (_disposed) return;
      result.fold((_) {}, (options) => state = AsyncValue.data(options));
    });
  }
}

@riverpod
class WorkoutProfileNotifier extends _$WorkoutProfileNotifier {
  bool _disposed = false;

  @override
  Future<WorkoutProfile?> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = getIt<WorkoutRepository>().peekCachedProfile();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<WorkoutProfile?> _fetch() async {
    final result = await getIt<WorkoutRepository>().getProfile();
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
    getIt<WorkoutRepository>().getProfile().then((result) {
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

  Future<Failure?> save({
    required List<String> disciplines,
    required Map<String, String> styles,
    required String goal,
    required String level,
    required int daysPerWeek,
    required int sessionMinutes,
    required String location,
    required List<String> equipment,
    required List<String> injuries,
    required int painLevel,
    String? injuryNotes,
  }) async {
    final result = await getIt<WorkoutRepository>().upsertProfile(
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
class WorkoutPlanNotifier extends _$WorkoutPlanNotifier {
  bool _disposed = false;

  @override
  Future<WorkoutPlan?> build() async {
    ref.onDispose(() => _disposed = true);
    final cached = getIt<WorkoutRepository>().peekCachedActivePlan();
    if (cached != null) {
      _revalidate();
      return cached;
    }
    return _fetch();
  }

  Future<WorkoutPlan?> _fetch() async {
    final result = await getIt<WorkoutRepository>().getActivePlan();
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

  void _revalidate() {
    getIt<WorkoutRepository>().getActivePlan().then((result) {
      if (_disposed) return;
      result.fold(
        (failure) {
          if (failure is NotFoundFailure) {
            state = const AsyncValue.data(null);
          }
        },
        (plan) {
          state = AsyncValue.data(plan);
        },
      );
    });
  }

  Future<Failure?> generate() async {
    final previousPlan = state.valueOrNull;
    state = AsyncLoading<WorkoutPlan?>().copyWithPrevious(state);
    final result = await getIt<WorkoutRepository>().generatePlan();
    return result.fold(
      (failure) {
        state = AsyncValue.data(previousPlan);
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
    final result = await getIt<WorkoutRepository>().deletePlan(id);
    return result.fold(
      (failure) => failure,
      (_) {
        ref.invalidateSelf();
        return null;
      },
    );
  }

  Future<Either<Failure, int>> swapExercise({
    required String day,
    required String itemId,
  }) async {
    final currentPlan = state.valueOrNull;
    if (currentPlan == null) {
      return const Left(ValidationFailure('No active plan to swap'));
    }

    final result = await getIt<WorkoutRepository>().swapExercise(
      planId: currentPlan.id,
      day: day,
      itemId: itemId,
    );

    return result.fold(
      Left.new,
      (tuple) {
        final newItem = tuple.$1;
        final remainingSwaps = tuple.$2;

        final updatedDays = currentPlan.days.map((workoutDay) {
          if (workoutDay.day.toLowerCase() != day.toLowerCase()) {
            return workoutDay;
          }

          List<WorkoutExerciseItem> replaceInList(
            List<WorkoutExerciseItem> list,
          ) {
            return list.map((item) {
              return item.itemId == itemId ? newItem : item;
            }).toList();
          }

          return WorkoutDay(
            day: workoutDay.day,
            isRest: workoutDay.isRest,
            title: workoutDay.title,
            focus: workoutDay.focus,
            durationMin: workoutDay.durationMin,
            warmup: replaceInList(workoutDay.warmup),
            main: replaceInList(workoutDay.main),
            cooldown: replaceInList(workoutDay.cooldown),
          );
        }).toList();

        final updatedPlan = WorkoutPlan(
          id: currentPlan.id,
          userId: currentPlan.userId,
          status: currentPlan.status,
          summary: currentPlan.summary,
          notes: currentPlan.notes,
          days: updatedDays,
          createdAt: currentPlan.createdAt,
          remainingFullGenerations: currentPlan.remainingFullGenerations,
          remainingExerciseSwaps: remainingSwaps,
        );

        state = AsyncValue.data(updatedPlan);

        return Right(remainingSwaps);
      },
    );
  }
}

@riverpod
class WorkoutHistoryNotifier extends _$WorkoutHistoryNotifier {
  @override
  Future<WorkoutPlanHistory> build() async {
    return _fetch(page: 1);
  }

  Future<WorkoutPlanHistory> _fetch({required int page}) async {
    final result = await getIt<WorkoutRepository>().getPlanHistory(
      page: page,
      limit: 20,
    );
    return result.fold(
      (failure) => throw StateError(failure.message),
      (history) => history,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.items.length >= current.total) return;

    final nextPage = current.page + 1;
    final result = await getIt<WorkoutRepository>().getPlanHistory(
      page: nextPage,
      limit: 20,
    );
    result.fold(
      (_) {},
      (nextHistory) {
        state = AsyncValue.data(
          WorkoutPlanHistory(
            items: [...current.items, ...nextHistory.items],
            total: nextHistory.total,
            page: nextHistory.page,
            limit: nextHistory.limit,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(page: 1));
  }
}



