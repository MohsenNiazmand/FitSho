import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
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
    return result.fold((failure) => throw failure, (options) => options);
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
    return result.fold((failure) {
      if (failure is NotFoundFailure) {
        return null;
      }
      throw failure;
    }, (profile) => profile);
  }

  void _revalidate() {
    getIt<WorkoutRepository>().getProfile().then((result) {
      if (_disposed) return;
      result.fold((failure) {
        if (failure is NotFoundFailure) {
          state = const AsyncValue.data(null);
        }
      }, (profile) => state = AsyncValue.data(profile));
    });
  }

  Future<(Failure?, WorkoutProfile?)> save({
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
    required int painLevel,
    String? injuryNotes,
  }) async {
    final result = await getIt<WorkoutRepository>().upsertProfile(
      disciplines: disciplines,
      styles: styles,
      primaryGoal: primaryGoal,
      secondaryGoal: secondaryGoal,
      level: level,
      daysPerWeek: daysPerWeek,
      sessionMinutes: sessionMinutes,
      location: location,
      equipment: equipment,
      injuryAreas: injuryAreas,
      medicalConditions: medicalConditions,
      injuryNotes: injuryNotes,
      painLevel: painLevel,
    );

    return result.fold((failure) => (failure, null), (saved) {
      state = AsyncValue.data(saved);
      return (null, saved);
    });
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
    return result.fold((failure) {
      if (failure is NotFoundFailure) {
        return null;
      }
      throw failure;
    }, (plan) => plan);
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
    return result.fold((failure) => failure, (_) {
      ref.invalidateSelf();
      return null;
    });
  }

  Future<Either<Failure, int>> swapExercise({
    required String sessionId,
    required String itemId,
  }) async {
    final currentPlan = state.valueOrNull;
    if (currentPlan == null) {
      return const Left(ValidationFailure('No active plan to swap'));
    }

    final result = await getIt<WorkoutRepository>().swapExercise(
      planId: currentPlan.id,
      sessionId: sessionId,
      itemId: itemId,
    );

    return result.fold(Left.new, (tuple) {
      final newItem = tuple.$1;
      final remainingSwaps = tuple.$2;

      final updatedSessions = currentPlan.sessions.map((session) {
        if (session.sessionId.toLowerCase() != sessionId.toLowerCase()) {
          return session;
        }

        List<WorkoutExerciseItem> replaceInList(
          List<WorkoutExerciseItem> list,
        ) {
          return list.map((item) {
            return item.itemId == itemId ? newItem : item;
          }).toList();
        }

        return WorkoutSession(
          sessionId: session.sessionId,
          sessionNumber: session.sessionNumber,
          title: session.title,
          focus: session.focus,
          durationMin: session.durationMin,
          warmup: replaceInList(session.warmup),
          main: replaceInList(session.main),
          cooldown: replaceInList(session.cooldown),
        );
      }).toList();

      final updatedPlan = WorkoutPlan(
        id: currentPlan.id,
        userId: currentPlan.userId,
        status: currentPlan.status,
        summary: currentPlan.summary,
        notes: currentPlan.notes,
        sessions: updatedSessions,
        createdAt: currentPlan.createdAt,
        profileSnapshot: currentPlan.profileSnapshot,
        remainingFullGenerations: currentPlan.remainingFullGenerations,
        remainingExerciseSwaps: remainingSwaps,
      );

      state = AsyncValue.data(updatedPlan);

      return Right(remainingSwaps);
    });
  }
}

@riverpod
class WorkoutHistoryNotifier extends _$WorkoutHistoryNotifier {
  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<WorkoutPlanHistory> build() async {
    return _fetch(page: 1);
  }

  Future<WorkoutPlanHistory> _fetch({required int page}) async {
    final result = await getIt<WorkoutRepository>().getPlanHistory(
      page: page,
      limit: 20,
    );
    return result.fold((failure) => throw failure, (history) => history);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (_isLoadingMore ||
        current == null ||
        current.items.length >= current.total) {
      return;
    }

    _isLoadingMore = true;
    final nextPage = current.page + 1;
    try {
      final result = await getIt<WorkoutRepository>().getPlanHistory(
        page: nextPage,
        limit: 20,
      );
      result.fold((_) {}, (nextHistory) {
        state = AsyncValue.data(
          WorkoutPlanHistory(
            items: [...current.items, ...nextHistory.items],
            total: nextHistory.total,
            page: nextHistory.page,
            limit: nextHistory.limit,
          ),
        );
      });
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(page: 1));
  }
}
