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
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, WorkoutExerciseItem>> swapExercise({
    required String planId,
    required String day,
    required String itemId,
  }) async {
    throw UnimplementedError();
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

  test('WorkoutPlanNotifier handles MedicalReferralFailure on generate',
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
  });

  test('WorkoutPlanNotifier delete removes plan and invalidates self',
      () async {
    mockRepository.activePlan = _samplePlan;

    final notifier = container.read(workoutPlanNotifierProvider.notifier);
    final failure = await notifier.delete('plan_123');

    expect(failure, isNull);
    expect(mockRepository.activePlan, isNull);
  });
}
