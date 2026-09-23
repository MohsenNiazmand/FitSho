import 'package:flutter_test/flutter_test.dart';
import 'package:fitsho/features/workout/data/models/workout_models.dart';

void main() {
  group('Workout Models JSON Parsing Tests', () {
    test('WorkoutOptionsEnvelope should parse JSON correctly with string numbers', () {
      final json = {
        'success': true,
        'data': {
          'disciplines': [
            {
              'id': 'bodybuilding',
              'label': 'بدنسازی',
              'description': 'توضیحات بدنسازی',
              'isAvailable': true,
            }
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
            }
          ],
          'goals': [
            {
              'id': 'muscle_gain',
              'label': 'حجم',
              'compatibleDisciplines': ['bodybuilding'],
              'isAvailable': true,
            }
          ],
          'levels': [
            {'id': 'beginner', 'label': 'مبتدی'}
          ],
          'sessionMinutes': [30, 60],
          'locations': [
            {'id': 'gym', 'label': 'باشگاه'}
          ],
          'equipment': [
            {'id': 'dumbbell', 'label': 'دمبل'}
          ],
          'injuries': [
            {
              'id': 'knee',
              'label': 'زانو',
              'description': 'درد زانو',
              'requiresReferral': false,
            }
          ],
          'maxDisciplines': '2',
          'minDaysPerWeek': '2',
          'maxDaysPerWeek': '6',
        }
      };

      final envelope = WorkoutOptionsEnvelope.fromJson(json);
      expect(envelope.success, isTrue);
      expect(envelope.data.disciplines.length, equals(1));
      expect(envelope.data.styles.first.minDays, equals(2));
      expect(envelope.data.styles.first.maxDays, equals(3));
      expect(envelope.data.maxDisciplines, equals(2));
    });

    test('WorkoutProfileEnvelope should parse response with nested profile', () {
      final json = {
        'success': true,
        'data': {
          'profile': {
            'id': 'prof_1',
            'userId': 'user_1',
            'disciplines': ['bodybuilding'],
            'styles': {'bodybuilding': 'full_body'},
            'goal': 'muscle_gain',
            'level': 'beginner',
            'daysPerWeek': '3',
            'sessionMinutes': '60',
            'location': 'gym',
            'equipment': ['dumbbell'],
            'injuries': [],
            'painLevel': '0',
          },
          'shouldRegeneratePlan': true,
        }
      };

      final envelope = WorkoutProfileEnvelope.fromJson(json);
      expect(envelope.success, isTrue);
      expect(envelope.profile.id, equals('prof_1'));
      expect(envelope.profile.daysPerWeek, equals(3));
      expect(envelope.shouldRegeneratePlan, isTrue);
    });

    test('WorkoutPlanModel should parse string numbers and quota keys', () {
      final json = {
        'id': 'plan_1',
        'userId': 'user_1',
        'status': 'active',
        'summary': 'خلاصه تمرین',
        'notes': {
          'progression': 'پیشرفت',
          'safety': ['ایمنی'],
        },
        'days': [
          {
            'day': 'saturday',
            'isRest': false,
            'title': 'شنبه',
            'focus': ['chest'],
            'durationMin': '60',
            'warmup': [],
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
              }
            ],
            'cooldown': [],
          }
        ],
        'createdAt': '2026-03-30T10:00:00.000Z',
        'remaining_full_generations': '2',
        'remaining_exercise_swaps': '4',
      };

      final plan = WorkoutPlanModel.fromJson(json);
      expect(plan.id, equals('plan_1'));
      expect(plan.remainingFullGenerations, equals(2));
      expect(plan.remainingExerciseSwaps, equals(4));

      final item = plan.days.first.main.first;
      expect(item.sets, equals(3));
      expect(item.restSec, equals(90));
      expect(item.rpe, equals(8.5));
    });

    test('WorkoutPlanHistoryEnvelope should parse items array and pagination', () {
      final json = {
        'success': true,
        'data': {
          'items': [
            {
              'id': 'plan_1',
              'userId': 'user_1',
              'status': 'archived',
              'summary': 'برنامه قدیمی',
              'notes': {'progression': 'پیشرفت', 'safety': []},
              'days': [],
              'createdAt': '2026-03-01T10:00:00.000Z',
            }
          ],
          'pagination': {
            'total': '1',
            'page': '1',
            'limit': '10',
          }
        }
      };

      final envelope = WorkoutPlanHistoryEnvelope.fromJson(json);
      expect(envelope.success, isTrue);
      expect(envelope.items.length, equals(1));
      expect(envelope.items.first.id, equals('plan_1'));
      expect(envelope.total, equals(1));
      expect(envelope.page, equals(1));
    });

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
        }
      };

      final envelope = SwapExerciseEnvelope.fromJson(json);
      expect(envelope.success, isTrue);
      expect(envelope.item.exerciseId, equals('push_up'));
      expect(envelope.remainingExerciseSwaps, equals(3));
    });
  });
}
