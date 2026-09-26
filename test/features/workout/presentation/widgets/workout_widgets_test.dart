import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/widgets/medical_referral_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_exercise_card.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_plan_header.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_rest_day_view.dart';
import 'package:fitsho/l10n/app_localizations.dart';

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

  testWidgets('WorkoutRestDayView displays rest title and description', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_createTestWidget(const WorkoutRestDayView()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.spa_rounded), findsOneWidget);
    expect(find.text('روز استراحت و ریکاوری'), findsOneWidget);
  });

  testWidgets('WorkoutExerciseCard displays exercise name and sets/reps', (
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
      notes: 'دامنه حرکتی کامل حفظ شود',
    );

    await tester.pumpWidget(
      _createTestWidget(const WorkoutExerciseCard(exercise: item)),
    );
    await tester.pumpAndSettle();

    expect(find.text('اسکوات با هالتر'), findsOneWidget);
    expect(find.text('دامنه حرکتی کامل حفظ شود'), findsOneWidget);
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
}
