import 'package:flutter_test/flutter_test.dart';
import 'package:fitsho/features/workout/data/models/workout_models.dart';

void main() {
  group('Workout Models JSON Parsing Tests', () {
    test(
      'WorkoutOptionsEnvelope should parse JSON correctly with string numbers',
      () {
        final json = {
          'success': true,
          'data': {
            'disciplines': [
              {
                'id': 'bodybuilding',
                'label': 'بدنسازی',
                'description': 'توضیحات بدنسازی',
                'isAvailable': true,
              },
            ],
            'styles': [
              {
                'id': 'full_body',
                'disciplineId': 'bodybuilding',
                'label': 'فول بادی',
                'description': 'توضیحات سبک',
                'minDays': '2',
                'maxDays': '3',
                'levels': ['beginner'],
                'isAvailable': true,
              },
            ],
            'goals': [
              {
                'id': 'muscle_gain',
                'label': 'حجم',
                'compatibleDisciplines': ['bodybuilding'],
                'isAvailable': true,
              },
            ],
            'levels': [
              {'id': 'beginner', 'label': 'مبتدی'},
            ],
            'sessionMinutes': ['30', '۶۰'],
            'locations': [
              {'id': 'gym', 'label': 'باشگاه'},
            ],
            'equipment': [
              {'id': 'dumbbell', 'label': 'دمبل'},
            ],
            'injuries': [
              {
                'id': 'knee',
                'label': 'زانو',
                'description': 'درد زانو',
                'requiresReferral': false,
              },
            ],
            'maxDisciplines': '2',
            'minDaysPerWeek': '2',
            'maxDaysPerWeek': '6',
          },
        };

        final envelope = WorkoutOptionsEnvelope.fromJson(json);
        expect(envelope.success, isTrue);
        expect(envelope.data.disciplines.length, equals(1));
        expect(envelope.data.styles.first.minDays, equals(2));
        expect(envelope.data.styles.first.maxDays, equals(3));
        expect(envelope.data.maxDisciplines, equals(2));
        expect(envelope.data.sessionMinutes, [30, 60]);
      },
    );

    test(
      'WorkoutProfileEnvelope should parse response with nested profile',
      () {
        final json = {
          'success': true,
          'data': {
            'profile': {
              'id': 'prof_1',
              'userId': 'user_1',
              'disciplines': ['bodybuilding'],
              'styles': {'bodybuilding': 'full_body'},
              'primaryGoal': 'muscle_gain',
              'level': 'beginner',
              'daysPerWeek': '3',
              'sessionMinutes': '60',
              'location': 'gym',
              'equipment': ['dumbbell'],
              'injuryAreas': <dynamic>[],
              'medicalConditions': <dynamic>[],
              'painLevel': '0',
            },
            'shouldRegeneratePlan': true,
          },
        };

        final envelope = WorkoutProfileEnvelope.fromJson(json);
        expect(envelope.success, isTrue);
        expect(envelope.profile, isNotNull);
        expect(envelope.profile!.id, equals('prof_1'));
        expect(envelope.profile!.daysPerWeek, equals(3));
        expect(envelope.shouldRegeneratePlan, isTrue);
      },
    );

    test('WorkoutPlanModel should parse string numbers and quota keys', () {
      final json = {
        'id': 'plan_1',
        'userId': 'user_1',
        'status': 'active',
        'summary': 'خلاصه تمرین',
        'profileSnapshot': {
          'disciplines': ['bodybuilding', 'fitness'],
          'styles': {'bodybuilding': 'full_body', 'fitness': 'hiit'},
          'primaryGoal': 'muscle_gain',
          'level': 'beginner',
          'daysPerWeek': '4',
          'sessionMinutes': '60',
          'location': 'gym',
          'equipment': ['dumbbell'],
          'injuryAreas': <dynamic>[],
          'medicalConditions': <dynamic>[],
          'painLevel': '0',
        },
        'notes': {
          'progression': 'پیشرفت',
          'safety': ['ایمنی'],
        },
        'sessions': [
          {
            'sessionId': 'session_1',
            'sessionNumber': 1,
            'title': 'تمرین اول',
            'focus': ['chest'],
            'durationMin': '60',
            'warmup': <dynamic>[],
            'main': [
              {
                'itemId': 'item_1',
                'exerciseId': 'db_bench',
                'name': 'پرس سینه دمبل',
                'sets': '3',
                'reps': '8-10',
                'durationSec': null,
                'restSec': '90',
                'rpe': '8.5',
                'notes': 'نکته',
              },
            ],
            'cooldown': <dynamic>[],
          },
        ],
        'createdAt': '2026-03-30T10:00:00.000Z',
        'remaining_full_generations': '2',
        'remaining_exercise_swaps': '4',
      };

      final plan = WorkoutPlanModel.fromJson(json);
      expect(plan.id, equals('plan_1'));
      expect(plan.remainingFullGenerations, equals(2));
      expect(plan.remainingExerciseSwaps, equals(4));
      expect(plan.profileSnapshot?.disciplines, ['bodybuilding', 'fitness']);
      expect(plan.profileSnapshot?.daysPerWeek, 4);

      final item = plan.sessions.first.main.first;
      expect(item.sets, equals(3));
      expect(item.restSec, equals(90));
      expect(item.rpe, equals(8.5));
    });

    test(
      'WorkoutPlanHistoryEnvelope should parse items array and pagination',
      () {
        final json = {
          'success': true,
          'data': {
            'items': [
              {
                'id': 'plan_1',
                'userId': 'user_1',
                'status': 'archived',
                'summary': 'برنامه قدیمی',
                'profileSnapshot': {
                  'disciplines': ['cardio'],
                  'daysPerWeek': 3,
                },
                'notes': {'progression': 'پیشرفت', 'safety': <dynamic>[]},
                'sessions': <dynamic>[],
                'createdAt': '2026-03-01T10:00:00.000Z',
              },
            ],
            'pagination': {'total': '1', 'page': '1', 'limit': '10'},
          },
        };

        final envelope = WorkoutPlanHistoryEnvelope.fromJson(json);
        expect(envelope.success, isTrue);
        expect(envelope.items.length, equals(1));
        expect(envelope.items.first.id, equals('plan_1'));
        expect(envelope.items.first.profileSnapshot?.disciplines, ['cardio']);
        expect(envelope.items.first.profileSnapshot?.daysPerWeek, 3);
        expect(envelope.total, equals(1));
        expect(envelope.page, equals(1));
      },
    );

    test('SwapExerciseEnvelope should parse item and remaining swaps', () {
      final json = {
        'success': true,
        'data': {
          'item': {
            'itemId': 'item_2',
            'exerciseId': 'push_up',
            'name': 'شنا سوئدی',
            'sets': '3',
            'reps': '12',
            'restSec': '60',
            'rpe': '7',
          },
          'remaining_exercise_swaps': '3',
        },
      };

      final envelope = SwapExerciseEnvelope.fromJson(json);
      expect(envelope.success, isTrue);
      expect(envelope.item.exerciseId, equals('push_up'));
      expect(envelope.remainingExerciseSwaps, equals(3));
    });
  });

  // ─────────────────────────────────────────────────────────────
  // Revision 2 — new contract tests
  // ─────────────────────────────────────────────────────────────
  group('Revision 2 Model Parsing', () {
    test(
      'WorkoutOptionsModel parses injuryAreas and medicalConditions separately',
      () {
        final json = {
          'success': true,
          'data': {
            'disciplines': [
              {
                'id': 'bodybuilding',
                'label': 'بدنسازی',
                'description': 'توضیح',
                'isAvailable': true,
              },
            ],
            'styles': [
              {
                'id': 'full_body',
                'disciplineId': 'bodybuilding',
                'label': 'فول بادی',
                'description': 'توضیح',
                'minDays': 2,
                'maxDays': 3,
                'levels': ['beginner'],
                'isAvailable': true,
              },
            ],
            'goals': [
              {
                'id': 'muscle_gain',
                'label': 'حجم',
                'compatibleDisciplines': ['bodybuilding'],
                'isAvailable': true,
              },
            ],
            'levels': [
              {
                'id': 'beginner',
                'label': 'مبتدی',
                'description': 'کمتر از ۶ ماه سابقه',
                'isAvailable': true,
              },
            ],
            'sessionMinutes': [30, 60],
            'locations': [{'id': 'gym', 'label': 'باشگاه', 'isAvailable': true}],
            'equipment': [{'id': 'dumbbell', 'label': 'دمبل', 'isAvailable': true}],
            'injuries': <dynamic>[],
            'injuryAreas': [
              {
                'id': 'knee',
                'label': 'زانو',
                'description': 'درد زانو',
                'requiresReferral': false,
                'isAvailable': true,
              },
              {
                'id': 'shoulder',
                'label': 'شانه',
                'description': 'درد شانه',
                'requiresReferral': false,
                'isAvailable': true,
              },
            ],
            'medicalConditions': [
              {
                'id': 'heart_condition',
                'label': 'عارضه قلبی',
                'description': 'سابقه بیماری قلبی',
                'requiresReferral': true,
                'isAvailable': true,
              },
            ],
            'maxDisciplines': 2,
            'minDaysPerWeek': 2,
            'maxDaysPerWeek': 6,
            'minSessionMinutes': 10,
            'maxSessionMinutes': 180,
          },
        };

        final envelope = WorkoutOptionsEnvelope.fromJson(json);
        final data = envelope.data;

        // Separate arrays exist and have correct content
        expect(data.injuryAreas.length, equals(2));
        expect(data.medicalConditions.length, equals(1));
        expect(data.injuryAreas.first.id, equals('knee'));
        expect(data.medicalConditions.first.id, equals('heart_condition'));
        expect(data.medicalConditions.first.requiresReferral, isTrue);

        // Session minute bounds
        expect(data.minSessionMinutes, equals(10));
        expect(data.maxSessionMinutes, equals(180));

        // Level description
        expect(data.levels.first.description, equals('کمتر از ۶ ماه سابقه'));
      },
    );

    test(
      'WorkoutProfileModel parses primaryGoal and secondaryGoal correctly',
      () {
        final json = {
          'id': 'prof_r2',
          'userId': 'user_1',
          'disciplines': ['bodybuilding', 'fitness'],
          'styles': {'bodybuilding': 'full_body', 'fitness': 'circuit'},
          'primaryGoal': 'muscle_gain',
          'secondaryGoal': 'fat_loss',
          'level': 'intermediate',
          'daysPerWeek': 4,
          'sessionMinutes': 47,
          'location': 'gym',
          'equipment': ['dumbbell'],
          'injuryAreas': ['knee'],
          'medicalConditions': ['hypertension'],
          'painLevel': 3,
        };

        final profile = WorkoutProfileModel.fromJson(json);
        expect(profile.primaryGoal, equals('muscle_gain'));
        expect(profile.secondaryGoal, equals('fat_loss'));
        expect(profile.injuryAreas, equals(['knee']));
        expect(profile.medicalConditions, equals(['hypertension']));
        expect(profile.sessionMinutes, equals(47));
      },
    );

    test(
      'WorkoutProfileModel falls back from legacy goal field to primaryGoal',
      () {
        final json = {
          'id': 'prof_legacy',
          'userId': 'user_1',
          'disciplines': ['bodybuilding'],
          'styles': {'bodybuilding': 'full_body'},
          'goal': 'strength', // old field
          'level': 'beginner',
          'daysPerWeek': 3,
          'sessionMinutes': 60,
          'location': 'gym',
          'equipment': <dynamic>[],
          'injuries': ['knee'], // old combined field
          'painLevel': 2,
        };

        final profile = WorkoutProfileModel.fromJson(json);
        expect(profile.primaryGoal, equals('strength'));
        // Old injuries field maps to injuryAreas
        expect(profile.injuryAreas, equals(['knee']));
        expect(profile.medicalConditions, isEmpty);
      },
    );

    test(
      'WorkoutPlanModel parses sessions (not days) and no rest sessions',
      () {
        final json = {
          'id': 'plan_r2',
          'userId': 'user_1',
          'status': 'active',
          'notes': {'progression': 'پیشرفت', 'safety': <dynamic>[]},
          'sessions': [
            {
              'sessionId': 'session_1',
              'sessionNumber': 1,
              'title': 'جلسه ۱',
              'focus': ['chest'],
              'durationMin': 60,
              'warmup': <dynamic>[],
              'main': [
                {
                  'itemId': 'i1',
                  'exerciseId': 'push_up',
                  'name': 'شنا',
                  'gifUrl': 'https://example.com/pushup.gif',
                  'videoUrl': 'https://example.com/pushup.mp4',
                  'sets': 3,
                  'reps': '12',
                  'restSec': 60,
                },
              ],
              'cooldown': <dynamic>[],
            },
            {
              'sessionId': 'session_2',
              'sessionNumber': 2,
              'title': 'جلسه ۲',
              'focus': ['back'],
              'durationMin': 55,
              'warmup': <dynamic>[],
              'main': [
                {
                  'itemId': 'i2',
                  'exerciseId': 'pullup',
                  'name': 'بارفیکس',
                  'sets': 3,
                  'reps': '8',
                  'restSec': 90,
                },
              ],
              'cooldown': <dynamic>[],
            },
          ],
          'createdAt': '2026-09-27T00:00:00.000Z',
        };

        final plan = WorkoutPlanModel.fromJson(json);
        expect(plan.sessions.length, equals(2));
        expect(plan.sessions[0].sessionId, equals('session_1'));
        expect(plan.sessions[0].sessionNumber, equals(1));
        expect(plan.sessions[1].sessionId, equals('session_2'));
        expect(plan.sessions[1].sessionNumber, equals(2));

        expect(plan.sessions[0].main[0].gifUrl, equals('https://example.com/pushup.gif'));
        expect(plan.sessions[0].main[0].videoUrl, equals('https://example.com/pushup.mp4'));
        expect(plan.sessions[1].main[0].gifUrl, isNull);

        // No isRest / day fields exist in sessions
        expect(plan.sessions[0].title, equals('جلسه ۱'));
      },
    );

    test(
      'WorkoutPlanModel falls back to days field if sessions is absent (legacy backward-compat)',
      () {
        final json = {
          'id': 'plan_legacy',
          'userId': 'user_1',
          'status': 'archived',
          'notes': {'progression': 'پیشرفت', 'safety': <dynamic>[]},
          'days': [
            {
              'sessionId': 'session_1',
              'sessionNumber': 1,
              'title': 'جلسه ۱',
              'focus': ['chest'],
              'durationMin': 60,
              'warmup': <dynamic>[],
              'main': <dynamic>[],
              'cooldown': <dynamic>[],
            },
          ],
          'createdAt': '2026-01-01T00:00:00.000Z',
        };

        final plan = WorkoutPlanModel.fromJson(json);
        expect(plan.sessions.length, equals(1));
        expect(plan.sessions.first.sessionId, equals('session_1'));
      },
    );

    test(
      'WorkoutProfileSnapshotModel with null/malformed snapshot does not crash',
      () {
        // Completely missing snapshot field is handled in WorkoutPlanModel
        final json = {
          'id': 'plan_no_snap',
          'userId': 'user_1',
          'status': 'active',
          'notes': {'progression': '', 'safety': <dynamic>[]},
          'sessions': <dynamic>[],
          'createdAt': '2026-09-27T00:00:00.000Z',
          // profileSnapshot is null
        };

        final plan = WorkoutPlanModel.fromJson(json);
        expect(plan.profileSnapshot, isNull);
      },
    );

    test(
      'WorkoutProfileModel.fromJson normalizes legacy pullup_bar to pull_up_bar',
      () {
        final json = {
          'id': 'prof_1',
          'userId': 'user_1',
          'disciplines': ['bodybuilding'],
          'level': 'intermediate',
          'daysPerWeek': 3,
          'sessionMinutes': 60,
          'location': 'home',
          'equipment': ['dumbbell', 'pullup_bar'],
          'injuryAreas': ['knee'],
          'painLevel': 0,
        };

        final profile = WorkoutProfileModel.fromJson(json);
        expect(profile.equipment, contains('pull_up_bar'));
        expect(profile.equipment, isNot(contains('pullup_bar')));
      },
    );
  });
}
