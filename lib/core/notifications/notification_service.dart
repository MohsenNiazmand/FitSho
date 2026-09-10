import 'dart:io';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/utils/meal_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

typedef WeeklyPlan = DietPlan;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String mealChannelId = 'meal_reminders';
  static const String mealChannelName = 'Meal Reminders';
  static const String mealChannelDescription =
      'Notifications for scheduled meal times';

  /// Standard Persian labels for each canonical meal slot.
  static const Map<String, String> _slotLabelsFa = {
    'breakfast': 'صبحانه',
    'morning_snack': 'میان‌وعده صبح',
    'lunch': 'ناهار',
    'afternoon_snack': 'میان‌وعده عصر',
    'dinner': 'شام',
  };

  /// Initializes the local notifications plugin, sets up channels,
  /// and configures the local device timezone.
  Future<void> initialize() async {
    // 1. Configure device local timezone location
    await configureLocalTimeZone();

    // 2. Android Initialization Settings with custom transparent icon
    const androidSettings =
        AndroidInitializationSettings('ic_stat_notification');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint('Notification clicked with payload: ${details.payload}');
      },
    );

    // 3. Create Android Notification Channel upfront with MAX importance
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        mealChannelId,
        mealChannelName,
        description: mealChannelDescription,
        importance: Importance.max,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  /// Configures [tz.local] to match the actual device timezone.
  Future<void> configureLocalTimeZone() async {
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
    } on Object catch (e) {
      debugPrint('NotificationService: Failed to get local timezone: $e');
    }
  }

  /// Requests notification permissions for Android 13+ (POST_NOTIFICATIONS)
  /// and iOS.
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Checks and requests permission for exact alarms on Android 12+
  /// (SCHEDULE_EXACT_ALARM).
  Future<bool> checkAndRequestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      final result = await Permission.scheduleExactAlarm.request();
      return result.isGranted;
    }
    return true;
  }

  /// Checks whether exact alarms can currently be scheduled.
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    return Permission.scheduleExactAlarm.isGranted;
  }

  /// Comprehensive permission request helper for both notifications
  /// and exact alarms.
  Future<bool> requestAllPermissions() async {
    final notificationGranted = await requestNotificationPermission();
    final exactAlarmGranted = await checkAndRequestExactAlarmPermission();
    return notificationGranted && exactAlarmGranted;
  }

  /// Schedules specific, dynamic notifications for each day of the current
  /// weekly plan and each enabled meal slot.
  ///
  /// - Includes dynamic Persian food names and linked supplements.
  /// - Skips slots whose scheduled time has already passed.
  /// - Generates unique integer IDs per (day, slot) to prevent collisions.
  Future<void> scheduleWeeklyDietNotifications({
    required WeeklyPlan weeklyPlan,
    required List<Supplement> supplements,
    required Map<String, MealSlotConfig> mealTimes,
  }) async {
    // 0. Cancel any previously scheduled weekly diet notifications
    await cancelWeeklyDietNotifications();

    final now = tz.TZDateTime.now(tz.local);

    // Calculate Saturday (start of current week in the Persian calendar)
    // DateTime.weekday: Monday=1 ... Saturday=6, Sunday=7
    // DayKeys index: Saturday=0, Sunday=1, Monday=2 ... Friday=6
    final todayWeekIndex = (now.weekday + 1) % 7;
    final weekStartSaturday = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: todayWeekIndex));

    for (final dayPlan in weeklyPlan.days) {
      final dayKey = dayPlan.day.toLowerCase().trim();
      final dayIndex = DietConstants.dayKeys.indexOf(dayKey);
      if (dayIndex == -1) continue;

      final targetDate = weekStartSaturday.add(Duration(days: dayIndex));

      for (final slotKey in DietConstants.mealSlotKeys) {
        final config = mealTimes[slotKey];
        if (config == null || !config.enabled || !config.notificationsEnabled) {
          continue;
        }

        final time = MealTimeUtils.parseTimeOfDay(config.time);

        // 1. Calculate the exact tz.TZDateTime for that specific day and time
        final scheduledDateTime = tz.TZDateTime(
          tz.local,
          targetDate.year,
          targetDate.month,
          targetDate.day,
          time.hour,
          time.minute,
        );

        // Skip if the time has already passed
        if (scheduledDateTime.isBefore(now)) {
          continue;
        }

        // 2. Construct the Title (Persian)
        final slotLabel = _slotLabelsFa[slotKey] ?? slotKey;
        final title = 'یادآوری $slotLabel';

        // 3. Construct the Body with dynamic food name and linked supplements
        final meal = dayPlan.meals[slotKey];
        final foodName = meal?.title.trim() ?? '';

        // Check if any supplements are linked to this specific meal slot
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

        final body = bodyBuffer.isNotEmpty
            ? bodyBuffer.toString()
            : 'زمان صرف $slotLabel است.';

        // 4. Unique ID: 1000 + (dayIndex * 10) + slotIndex
        final slotIndex = DietConstants.mealSlotKeys.indexOf(slotKey);
        final notificationId = 1000 + (dayIndex * 10) + slotIndex;

        // 5. Schedule via zonedSchedule
        const androidDetails = AndroidNotificationDetails(
          mealChannelId,
          mealChannelName,
          channelDescription: mealChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'یادآور وعده غذایی',
          icon: 'ic_stat_notification',
        );

        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await _notifications.zonedSchedule(
          notificationId,
          title,
          body,
          scheduledDateTime,
          details,
          payload: '$slotKey|$dayKey',
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );

        debugPrint(
          'Scheduled [$title] for $scheduledDateTime (#$notificationId)',
        );
      }
    }
  }

  /// Cancels all scheduled weekly diet notifications (IDs 1000..1069).
  Future<void> cancelWeeklyDietNotifications() async {
    for (int day = 0; day < 7; day++) {
      for (int slot = 0; slot < 10; slot++) {
        await _notifications.cancel(1000 + (day * 10) + slot);
      }
    }
  }

  /// Cancels a specific notification by [id].
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancels all scheduled and active notifications.
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Retrieves a list of all currently scheduled pending notifications.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }
}
