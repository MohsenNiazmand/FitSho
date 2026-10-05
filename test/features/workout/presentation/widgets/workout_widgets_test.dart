import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/metadata/default_catalog.dart';
import 'package:fitsho/core/metadata/domain/entities/metadata_catalog.dart';
import 'package:fitsho/core/metadata/domain/repositories/metadata_repository.dart';
import 'package:fitsho/core/metadata/presentation/providers/metadata_provider.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/widgets/empty_exercise_pool_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/medical_referral_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/medical_safety_warning_card.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_exercise_card.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_plan_header.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_rest_day_view.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_session_section.dart';
import 'package:fitsho/l10n/app_localizations.dart';
import 'package:fpdart/fpdart.dart';

class _MockMetadataRepo implements MetadataRepository {
  @override
  Future<MetadataCatalog> getInitialCatalog() async => DefaultCatalog.asCatalog();

  @override
  Future<Either<Failure, int>> checkVersion() async => right(2);

  @override
  Future<Either<Failure, MetadataCatalog?>> syncCatalogIfNeeded(int currentVersion) async => right(null);

  @override
  Future<Either<Failure, MetadataCatalog>> fetchFreshCatalog() async => right(DefaultCatalog.asCatalog());
}

Widget _createTestWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('fa'), Locale('en')],
    locale: const Locale('fa'),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('MedicalReferralDialog displays title and server message', (
    WidgetTester tester,
  ) async {
    const testMessage = 'به دلیل آسیب شانه به پزشک مراجعه کنید.';

    await tester.pumpWidget(
      _createTestWidget(const MedicalReferralDialog(message: testMessage)),
    );
    await tester.pumpAndSettle();

    expect(find.text(testMessage), findsOneWidget);
    expect(find.byIcon(Icons.medical_services_rounded), findsOneWidget);
  });

  testWidgets('EmptyExercisePoolDialog displays title and guidance message', (
    WidgetTester tester,
  ) async {
    const testMessage = 'امکان استخراج حرکات کافی با توجه به محدودیت‌ها وجود ندارد.';

    await tester.pumpWidget(
      _createTestWidget(const EmptyExercisePoolDialog(message: testMessage)),
    );
    await tester.pumpAndSettle();

    expect(find.text('تنظیم شرایط تمرین'), findsOneWidget);
    expect(find.text(testMessage), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(find.text('ویرایش پروفایل تمرین'), findsOneWidget);
  });

  testWidgets('MedicalSafetyWarningCard displays warning and health disclaimer', (
    WidgetTester tester,
  ) async {
    const testMessage = 'پیام تست ایمنی پزشکی';

    await tester.pumpWidget(
      _createTestWidget(const MedicalSafetyWarningCard(customMessage: testMessage)),
    );
    await tester.pumpAndSettle();

    expect(find.text(testMessage), findsOneWidget);
    expect(find.byIcon(Icons.health_and_safety_rounded), findsOneWidget);
  });

  testWidgets('WorkoutRestDayView displays rest title and description', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_createTestWidget(const WorkoutRestDayView()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.spa_rounded), findsOneWidget);
    expect(find.text('روز استراحت و ریکاوری'), findsOneWidget);
  });

  testWidgets('WorkoutExerciseCard displays exercise name, sets/reps, cue and notes', (
    WidgetTester tester,
  ) async {
    const item = WorkoutExerciseItem(
      itemId: 'i1',
      exerciseId: 'squat',
      name: 'اسکوات با هالتر',
      sets: 4,
      reps: '8-10',
      restSec: 120,
      rpe: 8,
      cue: 'زانوها در راستای پنجه پا باشند',
      notes: 'دامنه حرکتی کامل حفظ شود',
    );

    await tester.pumpWidget(
      _createTestWidget(const WorkoutExerciseCard(exercise: item)),
    );
    await tester.pumpAndSettle();

    expect(find.text('اسکوات با هالتر'), findsOneWidget);
    expect(find.text('دامنه حرکتی کامل حفظ شود'), findsOneWidget);
    expect(find.text('زانوها در راستای پنجه پا باشند'), findsOneWidget);
    expect(find.byIcon(Icons.tips_and_updates_outlined), findsOneWidget);
    expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
  });

  testWidgets('WorkoutPlanHeader disables new plan button when 0 quota', (
    WidgetTester tester,
  ) async {
    final plan = WorkoutPlan(
      id: 'p1',
      userId: 'u1',
      status: 'active',
      summary: 'برنامه تست',
      notes: const WorkoutNotes(progression: 'پیشرفت', safety: ['ایمنی']),
      sessions: [],
      createdAt: DateTime.now(),
      remainingFullGenerations: 0,
      remainingExerciseSwaps: 2,
    );

    await tester.pumpWidget(_createTestWidget(WorkoutPlanHeader(plan: plan)));
    await tester.pumpAndSettle();

    expect(find.text('برنامه تست'), findsOneWidget);
    final buttonFinder = find.widgetWithText(ElevatedButton, 'برنامه جدید');
    expect(buttonFinder, findsOneWidget);
    final elevatedButton = tester.widget<ElevatedButton>(buttonFinder);
    expect(elevatedButton.onPressed, isNull);
  });

  testWidgets('WorkoutSessionSection renders visually distinct Warmup, Main, and Cooldown sections', (
    WidgetTester tester,
  ) async {
    final plan = WorkoutPlan(
      id: 'p1',
      userId: 'u1',
      status: 'active',
      summary: 'برنامه تست',
      notes: const WorkoutNotes(progression: '', safety: []),
      sessions: [
        const WorkoutSession(
          sessionId: 'session_1',
          sessionNumber: 1,
          title: 'جلسه تمرینی ۱',
          focus: ['chest'],
          durationMin: 45,
          warmup: [
            WorkoutExerciseItem(
              itemId: 'w1',
              exerciseId: 'arm_circles',
              name: 'دایره دست',
              sets: 2,
              durationSec: 30,
              restSec: 30,
            ),
          ],
          main: [
            WorkoutExerciseItem(
              itemId: 'm1',
              exerciseId: 'bench_press',
              name: 'پرس سینه',
              sets: 3,
              reps: '10',
              restSec: 90,
            ),
          ],
          cooldown: [
            WorkoutExerciseItem(
              itemId: 'c1',
              exerciseId: 'chest_stretch',
              name: 'کشش سینه',
              sets: 2,
              durationSec: 30,
              restSec: 30,
            ),
          ],
        ),
      ],
      createdAt: DateTime.now(),
      remainingFullGenerations: 2,
      remainingExerciseSwaps: 2,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          metadataRepositoryProvider.overrideWithValue(_MockMetadataRepo()),
        ],
        child: _createTestWidget(
          SingleChildScrollView(
            child: WorkoutSessionSection(plan: plan),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('گرم کردن (پویایی)'), findsOneWidget);
    expect(find.text('تمرین اصلی (تمرینات اصلی و تعادلی)'), findsOneWidget);
    expect(find.text('سرد کردن (کشش و انعطاف)'), findsOneWidget);
    expect(find.byIcon(Icons.whatshot_rounded), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center_rounded), findsWidgets);
    expect(find.byIcon(Icons.self_improvement_rounded), findsOneWidget);
  });
}
