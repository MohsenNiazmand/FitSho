import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime nextInstanceOfTime(TimeOfDay time, tz.TZDateTime now) {
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  return scheduledDate;
}

int getWeeklyNotificationId(int dayIndex, int slotIndex) {
  return 1000 + (dayIndex * 10) + slotIndex;
}

String formatNotificationBody({
  required String foodName,
  required List<Supplement> supplements,
  required String slotKey,
  required String slotLabel,
}) {
  final linkedSupplements = supplements.where(
    (s) =>
        s.linkedMealSlot != null &&
        s.linkedMealSlot!.toLowerCase().trim() == slotKey,
  ).toList();

  final bodyBuffer = StringBuffer();
  if (foodName.isNotEmpty) {
    bodyBuffer.write(foodName);
  }

  if (linkedSupplements.isNotEmpty) {
    final supplementItems = linkedSupplements.map((s) {
      if (s.dosageNote != null && s.dosageNote!.trim().isNotEmpty) {
        return '${s.name} (${s.dosageNote!.trim()})';
      }
      return s.name;
    }).join('، ');

    if (bodyBuffer.isNotEmpty) {
      bodyBuffer.write('\n');
    }
    final label = linkedSupplements.length > 1 ? 'مکمل‌ها' : 'مکمل';
    bodyBuffer.write('$label: $supplementItems');
  }

  return bodyBuffer.isNotEmpty
      ? bodyBuffer.toString()
      : 'زمان صرف $slotLabel است.';
}

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
  });

  group('nextInstanceOfTime', () {
    test('schedules for today if time is in the future', () {
      final now = tz.TZDateTime.utc(2026, 9, 10, 8, 30);
      const targetTime = TimeOfDay(hour: 12, minute: 0);

      final next = nextInstanceOfTime(targetTime, now);

      expect(next.year, equals(2026));
      expect(next.month, equals(9));
      expect(next.day, equals(10));
      expect(next.hour, equals(12));
      expect(next.minute, equals(0));
    });

    test(
      'schedules for tomorrow (+1 day) if time has already passed today',
      () {
        final now = tz.TZDateTime.utc(2026, 9, 10, 14, 30);
        const targetTime = TimeOfDay(hour: 8, minute: 0);

        final next = nextInstanceOfTime(targetTime, now);

        expect(next.year, equals(2026));
        expect(next.month, equals(9));
        expect(next.day, equals(11));
        expect(next.hour, equals(8));
        expect(next.minute, equals(0));
      },
    );
  });

  group('Dynamic Notification Content & Weekly ID Tests', () {
    test('Generates unique IDs for all days and slots without collision', () {
      final ids = <int>{};
      for (int d = 0; d < 7; d++) {
        for (int s = 0; s < 5; s++) {
          final id = getWeeklyNotificationId(d, s);
          expect(ids.contains(id), isFalse, reason: 'Collision for ID $id');
          ids.add(id);
        }
      }
      expect(ids.length, equals(35)); // 7 days * 5 slots = 35 unique IDs
    });

    test(
      'Constructs dynamic body with food and single supplement with dosage',
      () {
        final supplements = [
          const Supplement(
            id: '1',
            name: 'کراتین',
            dosageNote: 'یک اسکوپ',
            linkedMealSlot: 'breakfast',
          ),
        ];

        final body = formatNotificationBody(
          foodName: 'املت',
          supplements: supplements,
          slotKey: 'breakfast',
          slotLabel: 'صبحانه',
        );

        expect(body, equals('املت\nمکمل: کراتین (یک اسکوپ)'));
      },
    );

    test('Constructs dynamic body with multiple supplements', () {
      final supplements = [
        const Supplement(
          id: '1',
          name: 'کراتین',
          dosageNote: 'یک اسکوپ',
          linkedMealSlot: 'lunch',
        ),
        const Supplement(
          id: '2',
          name: 'امگا ۳',
          dosageNote: 'یک کپسول',
          linkedMealSlot: 'lunch',
        ),
      ];

      final body = formatNotificationBody(
        foodName: 'چلو جوجه‌کباب',
        supplements: supplements,
        slotKey: 'lunch',
        slotLabel: 'ناهار',
      );

      expect(
        body,
        equals('چلو جوجه‌کباب\nمکمل‌ها: کراتین (یک اسکوپ)، امگا ۳ (یک کپسول)'),
      );
    });

    test('Constructs fallback body if meal and supplements are empty', () {
      final body = formatNotificationBody(
        foodName: '',
        supplements: [],
        slotKey: 'dinner',
        slotLabel: 'شام',
      );

      expect(body, equals('زمان صرف شام است.'));
    });
  });
}
