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
}


