import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/domain/repositories/workout_repository.dart';
import 'package:fitsho/features/workout/presentation/providers/workout_providers.dart';

class MockWorkoutRepository implements WorkoutRepository {
  WorkoutPlan? activePlan;
  Failure? activePlanFailure;
  Failure? generateFailure;
  WorkoutPlan? generatedPlan;

  @override
  WorkoutPlan? peekCachedActivePlan() => activePlan;

  @override
  WorkoutProfile? peekCachedProfile() => null;

  @override
  Future<WorkoutOptions?> peekCachedProfileOptions() async => null;

  @override
  Future<Either<Failure, WorkoutPlan>> getActivePlan() async {
    if (activePlanFailure != null) {
      return Left(activePlanFailure!);
    }
    if (activePlan != null) {
      return Right(activePlan!);
    }
    return const Left(NotFoundFailure());
  }

  @override
  Future<Either<Failure, WorkoutPlan>> generatePlan() async {
    if (generateFailure != null) {
      return Left(generateFailure!);
    }
    return Right(generatedPlan ?? _samplePlan);
  }

  @override
  Future<Either<Failure, void>> deletePlan(String id) async {
    activePlan = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, WorkoutOptions>> getProfileOptions() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkoutProfile?>> getProfile() async {
    throw UnimplementedError();
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
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkoutPlanHistory>> getPlanHistory({
    int page = 1,
    int limit = 10,
  }) async {
    requestedHistoryPages.add(page);
    final history = historyByPage[page];
    if (history == null) {
      return const Left(ValidationFailure('Missing test history page'));
    }
    return Right(history);
  }

  Failure? swapFailure;
  WorkoutExerciseItem? swappedItem;
  int swappedRemaining = 3;
  final Map<int, WorkoutPlanHistory> historyByPage = {};
  final List<int> requestedHistoryPages = [];

  @override
  Future<Either<Failure, (WorkoutExerciseItem, int)>> swapExercise({
    required String planId,
    required String day,
    required String itemId,
  }) async {
    if (swapFailure != null) {
      return Left(swapFailure!);
    }
    final item =
        swappedItem ??
        const WorkoutExerciseItem(
          itemId: 'item_1',
          exerciseId: 'cable_fly',
          name: 'قفسه سینه سیم‌کش',
          sets: 3,
          reps: '12-15',
          restSec: 60,
        );
    return Right((item, swappedRemaining));
  }
}

final _samplePlan = WorkoutPlan(
  id: 'plan_123',
  userId: 'user_1',
  status: 'active',
  summary: 'برنامه هفتگی تمرین',
  notes: const WorkoutNotes(
    progression: 'افزایش وزنه تدریجی',
    safety: ['گرم کردن کامل پیش از شروع'],
  ),
  days: [
    const WorkoutDay(
      day: 'saturday',
      isRest: false,
      title: 'تمرین سینه و پشت بازو',
      focus: ['chest', 'triceps'],
      durationMin: 60,
      warmup: [],
      main: [
        WorkoutExerciseItem(
          itemId: 'item_1',
          exerciseId: 'db_bench',
          name: 'پرس سینه دمبل',
          sets: 3,
          reps: '10-12',
          restSec: 90,
        ),
      ],
      cooldown: [],
    ),
    const WorkoutDay(
      day: 'sunday',
      isRest: true,
      title: 'استراحت',
      focus: [],
      durationMin: 0,
      warmup: [],
      main: [],
      cooldown: [],
    ),
  ],
  createdAt: DateTime(2026, 4, 1),
  remainingFullGenerations: 2,
  remainingExerciseSwaps: 4,
);

void main() {
  late MockWorkoutRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockWorkoutRepository();
    if (getIt.isRegistered<WorkoutRepository>()) {
      getIt.unregister<WorkoutRepository>();
    }
    getIt.registerSingleton<WorkoutRepository>(mockRepository);
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('WorkoutPlanNotifier returns null when no active plan exists', () async {
    mockRepository.activePlanFailure = const NotFoundFailure();

    final plan = await container.read(workoutPlanNotifierProvider.future);
    expect(plan, isNull);
  });

  test('WorkoutPlanNotifier returns cached plan when available', () async {
    mockRepository.activePlan = _samplePlan;

    final plan = await container.read(workoutPlanNotifierProvider.future);
    expect(plan, isNotNull);
    expect(plan!.id, equals('plan_123'));
    expect(plan.days.length, equals(2));
  });

  test('WorkoutPlanNotifier generate succeeds and updates state', () async {
    mockRepository.activePlan = null;
    mockRepository.generatedPlan = _samplePlan;

    final notifier = container.read(workoutPlanNotifierProvider.notifier);
    final failure = await notifier.generate();

    expect(failure, isNull);
    final currentState = container.read(workoutPlanNotifierProvider).value;
    expect(currentState?.id, equals('plan_123'));
  });

  test(
    'WorkoutPlanNotifier handles MedicalReferralFailure on generate',
    () async {
      mockRepository.generateFailure = const MedicalReferralFailure(
        'ابتدا به پزشک یا فیزیوتراپیست مراجعه کنید',
      );

      final notifier = container.read(workoutPlanNotifierProvider.notifier);
      final failure = await notifier.generate();

      expect(failure, isA<MedicalReferralFailure>());
      expect(
        failure?.message,
        equals('ابتدا به پزشک یا فیزیوتراپیست مراجعه کنید'),
      );
    },
  );

  test(
    'WorkoutPlanNotifier delete removes plan and invalidates self',
    () async {
      mockRepository.activePlan = _samplePlan;

      final notifier = container.read(workoutPlanNotifierProvider.notifier);
      final failure = await notifier.delete('plan_123');

      expect(failure, isNull);
      expect(mockRepository.activePlan, isNull);
    },
  );

  test(
    'WorkoutPlanNotifier swapExercise replaces item in-place and updates remainingSwaps',
    () async {
      mockRepository.activePlan = _samplePlan;

      // Load initial plan into notifier state
      await container.read(workoutPlanNotifierProvider.future);

      final notifier = container.read(workoutPlanNotifierProvider.notifier);
      final result = await notifier.swapExercise(
        day: 'saturday',
        itemId: 'item_1',
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse((_) => -1), equals(3));

      final updatedPlan = container.read(workoutPlanNotifierProvider).value;
      expect(updatedPlan, isNotNull);
      expect(updatedPlan!.remainingExerciseSwaps, equals(3));

      final saturday = updatedPlan.days.firstWhere((d) => d.day == 'saturday');
      final swappedExercise = saturday.main.firstWhere(
        (e) => e.itemId == 'item_1',
      );
      expect(swappedExercise.name, equals('قفسه سینه سیم‌کش'));
    },
  );

  test(
    'WorkoutPlanNotifier swapExercise returns failure when API fails',
    () async {
      mockRepository.activePlan = _samplePlan;
      mockRepository.swapFailure = const ValidationFailure(
        'No alternative exercise',
      );

      await container.read(workoutPlanNotifierProvider.future);

      final notifier = container.read(workoutPlanNotifierProvider.notifier);
      final result = await notifier.swapExercise(
        day: 'saturday',
        itemId: 'item_1',
      );

      expect(result.isLeft(), isTrue);
      final failure = result.fold((f) => f, (_) => null);
      expect(failure?.message, equals('No alternative exercise'));

      final plan = container.read(workoutPlanNotifierProvider).value;
      expect(plan!.remainingExerciseSwaps, equals(4));
      final saturday = plan.days.firstWhere((d) => d.day == 'saturday');
      expect(
        saturday.main.firstWhere((e) => e.itemId == 'item_1').name,
        equals('پرس سینه دمبل'),
      );
    },
  );

  test('WorkoutHistoryNotifier loads the next page', () async {
    mockRepository.historyByPage[1] = WorkoutPlanHistory(
      items: [_samplePlan],
      total: 2,
      page: 1,
      limit: 20,
    );
    mockRepository.historyByPage[2] = WorkoutPlanHistory(
      items: [_samplePlan],
      total: 2,
      page: 2,
      limit: 20,
    );

    await container.read(workoutHistoryNotifierProvider.future);
    await container.read(workoutHistoryNotifierProvider.notifier).loadMore();

    final history = container.read(workoutHistoryNotifierProvider).value;
    expect(history?.items, hasLength(2));
    expect(mockRepository.requestedHistoryPages, [1, 2]);
  });
}
