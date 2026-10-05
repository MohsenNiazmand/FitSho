import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/metadata/default_catalog.dart';
import 'package:fitsho/core/metadata/domain/entities/metadata_catalog.dart';
import 'package:fitsho/core/metadata/domain/repositories/metadata_repository.dart';
import 'package:fitsho/core/metadata/presentation/providers/metadata_provider.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/providers/workout_providers.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_profile_form.dart';
import 'package:fitsho/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _MockMetadataRepo implements MetadataRepository {
  @override
  Future<MetadataCatalog> getInitialCatalog() async =>
      DefaultCatalog.asCatalog();

  @override
  Future<Either<Failure, int>> checkVersion() async => right(2);

  @override
  Future<Either<Failure, MetadataCatalog?>> syncCatalogIfNeeded(
    int currentVersion,
  ) async =>
      right(null);

  @override
  Future<Either<Failure, MetadataCatalog>> fetchFreshCatalog() async =>
      right(DefaultCatalog.asCatalog());
}

class _MockWorkoutOptionsNotifier extends WorkoutOptionsNotifier {
  _MockWorkoutOptionsNotifier(this._options);
  final WorkoutOptions _options;

  @override
  Future<WorkoutOptions> build() async => _options;
}

class _MockWorkoutProfileNotifier extends WorkoutProfileNotifier {
  _MockWorkoutProfileNotifier(this._profile);
  final WorkoutProfile? _profile;

  @override
  Future<WorkoutProfile?> build() async => _profile;
}

Widget _buildTestApp({
  required WorkoutOptions options,
  required WorkoutProfile profile,
  Locale locale = const Locale('fa'),
  double textScaleFactor = 1.0,
}) {
  return ProviderScope(
    overrides: [
      metadataRepositoryProvider.overrideWithValue(_MockMetadataRepo()),
      workoutOptionsNotifierProvider.overrideWith(
        () => _MockWorkoutOptionsNotifier(options),
      ),
      workoutProfileNotifierProvider.overrideWith(
        () => _MockWorkoutProfileNotifier(profile),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fa'), Locale('en')],
      locale: locale,
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(320, 640),
          textScaler: TextScaler.linear(textScaleFactor),
        ),
        child: const Scaffold(
          body: WorkoutProfileForm(initialStep: 3),
        ),
      ),
    ),
  );
}

void main() {
  const optionsWith5Days = WorkoutOptions(
    disciplines: [
      DisciplineOption(
        id: 'bodybuilding',
        label: 'بدنسازی',
        description: 'بدنسازی',
      ),
    ],
    styles: [
      StyleOption(
        id: 'full_body',
        disciplineId: 'bodybuilding',
        label: 'فول بادی',
        description: 'سبک تمام بدن',
        minDays: 2,
        maxDays: 6,
        levels: ['beginner'],
      ),
    ],
    goals: [
      GoalOption(
        id: 'muscle',
        label: 'عضله سازی',
        compatibleDisciplines: ['bodybuilding'],
      ),
    ],
    levels: [
      WorkoutOptionItem(id: 'beginner', label: 'مبتدی'),
    ],
    sessionMinutes: [30, 60],
    locations: [],
    equipment: [],
    injuries: [],
    maxDisciplines: 2,
    minDaysPerWeek: 2,
    maxDaysPerWeek: 6,
  );

  const optionsWithFixedDays = WorkoutOptions(
    disciplines: [
      DisciplineOption(
        id: 'bodybuilding',
        label: 'بدنسازی',
        description: 'بدنسازی',
      ),
    ],
    styles: [
      StyleOption(
        id: 'bro_split',
        disciplineId: 'bodybuilding',
        label: 'اسپلیت تفکیکی',
        description: 'سبک ۵ روزه',
        minDays: 5,
        maxDays: 5,
        levels: ['advanced'],
      ),
    ],
    goals: [
      GoalOption(
        id: 'muscle',
        label: 'عضله سازی',
        compatibleDisciplines: ['bodybuilding'],
      ),
    ],
    levels: [
      WorkoutOptionItem(id: 'advanced', label: 'پیشرفته'),
    ],
    sessionMinutes: [30, 60],
    locations: [],
    equipment: [],
    injuries: [],
    maxDisciplines: 2,
    minDaysPerWeek: 2,
    maxDaysPerWeek: 6,
  );

  testWidgets(
    'renders 5 day chips in Wrap at 320px width and 1.5 text scale '
    'without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const profile = WorkoutProfile(
        id: 'prof_1',
        userId: 'user_1',
        disciplines: ['bodybuilding'],
        styles: {'bodybuilding': 'full_body'},
        primaryGoal: 'muscle',
        level: 'beginner',
        daysPerWeek: 3,
        sessionMinutes: 60,
        location: 'gym',
        equipment: [],
        injuryAreas: [],
        medicalConditions: [],
        painLevel: 0,
      );

      await tester.pumpWidget(
        _buildTestApp(
          options: optionsWith5Days,
          profile: profile,
          textScaleFactor: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      // Check all 5 day chips exist (2, 3, 4, 5, 6)
      expect(find.text('2 روز'), findsOneWidget);
      expect(find.text('3 روز'), findsOneWidget);
      expect(find.text('4 روز'), findsOneWidget);
      expect(find.text('5 روز'), findsOneWidget);
      expect(find.text('6 روز'), findsOneWidget);

      // Verify no overflow exception occurred
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'single-option case shows hint explaining fixed-day style (fa and en)',
    (tester) async {
      const profile = WorkoutProfile(
        id: 'prof_2',
        userId: 'user_1',
        disciplines: ['bodybuilding'],
        styles: {'bodybuilding': 'bro_split'},
        primaryGoal: 'muscle',
        level: 'advanced',
        daysPerWeek: 5,
        sessionMinutes: 60,
        location: 'gym',
        equipment: [],
        injuryAreas: [],
        medicalConditions: [],
        painLevel: 0,
      );

      // Test Persian hint
      await tester.pumpWidget(
        _buildTestApp(
          options: optionsWithFixedDays,
          profile: profile,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5 روز'), findsOneWidget);
      expect(
        find.text('این سبک تمرینی فقط با 5 روز در هفته طراحی شده است'),
        findsOneWidget,
      );

      // Test English hint
      await tester.pumpWidget(
        _buildTestApp(
          options: optionsWithFixedDays,
          profile: profile,
          locale: const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5 days'), findsOneWidget);
      expect(
        find.text('This style is designed for exactly 5 days per week.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'shows recommended badge on matching chip only when within range',
    (tester) async {
      const optionsWithRec = WorkoutOptions(
        disciplines: [
          DisciplineOption(
            id: 'bodybuilding',
            label: 'بدنسازی',
            description: 'بدنسازی',
          ),
        ],
        styles: [
          StyleOption(
            id: 'full_body',
            disciplineId: 'bodybuilding',
            label: 'فول بادی',
            description: 'تمام بدن',
            minDays: 2,
            maxDays: 4,
            levels: ['beginner'],
            recommendedDays: 3,
          ),
        ],
        goals: [
          GoalOption(
            id: 'muscle',
            label: 'عضله سازی',
            compatibleDisciplines: ['bodybuilding'],
          ),
        ],
        levels: [
          WorkoutOptionItem(id: 'beginner', label: 'مبتدی'),
        ],
        sessionMinutes: [30, 60],
        locations: [],
        equipment: [],
        injuries: [],
        maxDisciplines: 2,
        minDaysPerWeek: 2,
        maxDaysPerWeek: 6,
      );

      const profile = WorkoutProfile(
        id: 'prof_3',
        userId: 'user_1',
        disciplines: ['bodybuilding'],
        styles: {'bodybuilding': 'full_body'},
        primaryGoal: 'muscle',
        level: 'beginner',
        daysPerWeek: 2,
        sessionMinutes: 60,
        location: 'gym',
        equipment: [],
        injuryAreas: [],
        medicalConditions: [],
        painLevel: 0,
      );

      await tester.pumpWidget(
        _buildTestApp(
          options: optionsWithRec,
          profile: profile,
        ),
      );
      await tester.pumpAndSettle();

      // Exactly one recommended badge should be present (on chip 3)
      expect(find.text('پیشنهادی'), findsOneWidget);
    },
  );

  testWidgets(
    'does not show recommended badge when recommendedDays is null or out of range',
    (tester) async {
      // optionsWith5Days has recommendedDays = null
      const profile = WorkoutProfile(
        id: 'prof_4',
        userId: 'user_1',
        disciplines: ['bodybuilding'],
        styles: {'bodybuilding': 'full_body'},
        primaryGoal: 'muscle',
        level: 'beginner',
        daysPerWeek: 2,
        sessionMinutes: 60,
        location: 'gym',
        equipment: [],
        injuryAreas: [],
        medicalConditions: [],
        painLevel: 0,
      );

      await tester.pumpWidget(
        _buildTestApp(
          options: optionsWith5Days,
          profile: profile,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('پیشنهادی'), findsNothing);
    },
  );
}
