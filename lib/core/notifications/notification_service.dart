import 'dart:convert';
import 'dart:io';
import 'package:fitsho/config/router/go_router_provider.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/utils/meal_time_utils.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

typedef WeeklyPlan = DietPlan;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const String mealChannelId = 'meal_reminders';

  /// Cached payload if the app was launched by tapping a notification from
  /// a terminated state.
  String? _initialPayload;

  /// Optional external listener for notification taps.
  void Function(String day, String meal)? onNotificationTapped;

  /// Initializes the local notifications plugin with the custom icon,
  /// configures the channel, timezone data, and tap handlers.
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
        debugPrint(
          'NotificationService: tapped with payload: ${details.payload}',
        );
        handleNotificationPayload(details.payload);
      },
    );

    // 3. Create Android Notification Channel upfront with MAX importance
    if (Platform.isAndroid) {
      final tr = currentAppLocalizations();
      final androidChannel = AndroidNotificationChannel(
        mealChannelId,
        tr.notificationMealChannelName,
        description: tr.notificationMealChannelDesc,
        importance: Importance.max,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }

    // 4. Capture cold-start launch notification if tapped when terminated
    final launchDetails =
        await _notifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _initialPayload = launchDetails?.notificationResponse?.payload;
      debugPrint(
        'NotificationService: app launched from notification with payload: '
        '$_initialPayload',
      );
    }
  }

  /// Checks and navigates to the cold-start notification target once
  /// the router / main shell is ready.
  void checkAndHandleInitialNotification() {
    if (_initialPayload != null) {
      final payload = _initialPayload;
      _initialPayload = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNotificationPayload(payload);
      });
    }
  }

  /// Parses the notification payload and navigates to the Weekly Plan screen
  /// with the target day and meal slot.
  void handleNotificationPayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) return;

    try {
      final Map<String, dynamic> data;
      if (payload.trim().startsWith('{')) {
        data = jsonDecode(payload) as Map<String, dynamic>;
      } else {
        // Fallback for legacy pipe-separated format: 'slot|day'
        final parts = payload.split('|');
        data = {
          'slot': parts[0],
          'day': parts.length > 1 ? parts[1] : '',
        };
      }

      final day = data['day'] as String?;
      final meal = (data['meal'] ?? data['slot']) as String?;

      if (day != null && meal != null) {
        onNotificationTapped?.call(day, meal);

        final context = rootNavigatorKey.currentContext;
        if (context != null && context.mounted) {
          context.go('${AppRoutes.weeklyPlan}?day=$day&meal=$meal');
        }
      }
    } on Object catch (e) {
      debugPrint('NotificationService: Error handling payload: $e');
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

  /// Requests notification permissions for Android 13+ and iOS.
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Checks and requests permission for exact alarms on Android 12+.
  Future<bool> checkAndRequestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.scheduleExactAlarm.status;
    debugPrint('NotificationService: Exact alarm permission status: $status');
    if (!status.isGranted) {
      final result = await Permission.scheduleExactAlarm.request();
      debugPrint(
        'NotificationService: Exact alarm permission requested result: $result',
      );
      return result.isGranted;
    }
    return true;
  }

  /// Checks whether exact alarms can currently be scheduled.
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    return Permission.scheduleExactAlarm.isGranted;
  }

  /// Requests both notifications and exact alarm permissions.
  Future<bool> requestAllPermissions() async {
    final notificationGranted = await requestNotificationPermission();
    final exactAlarmGranted = await checkAndRequestExactAlarmPermission();
    debugPrint(
      'NotificationService: requestAllPermissions: '
      'notif=$notificationGranted, exactAlarm=$exactAlarmGranted',
    );
    return notificationGranted && exactAlarmGranted;
  }

  /// Schedules specific, dynamic notifications for each day of the current
  /// weekly plan and each enabled meal slot.
  ///
  /// - All texts, channel names, summaries and titles are fully
  ///   localized via l10n.
  /// - Includes JSON payload with target day and meal slot for tap navigation.
  /// - Includes dynamic food names and linked supplements with dosage.
  /// - Skips slots whose scheduled time has already passed.
  /// - Generates unique integer IDs per (day, slot) to prevent collisions.
  Future<void> scheduleWeeklyDietNotifications({
    required WeeklyPlan weeklyPlan,
    required List<Supplement> supplements,
    required Map<String, MealSlotConfig> mealTimes,
  }) async {
    // 0. Cancel previously scheduled weekly diet notifications to
    // prevent stale alarms
    await cancelWeeklyDietNotifications();

    final now = tz.TZDateTime.now(tz.local);
    final tr = currentAppLocalizations();

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

        // 2. Construct localized Title
        final slotLabel = dietMealSlotLabelTr(tr, slotKey);
        final title = tr.notificationMealReminderTitle(slotLabel);

        // 3. Construct localized Body with dynamic food and linked supplements
        final meal = dayPlan.meals[slotKey];
        final foodName = meal?.title.trim() ?? '';

        // Filter supplements where linkedMeal matches current meal slot
        final linkedSupplements = supplements.where((s) {
          final rawSlot = (s.linkedMeal ?? s.linkedMealSlot)
              ?.trim()
              .toLowerCase()
              .replaceAll('-', '_')
              .replaceAll(' ', '_');
          if (rawSlot == null || rawSlot.isEmpty) return false;

          final normalizedKey = slotKey.trim().toLowerCase();
          final localizedLabel = slotLabel.trim().toLowerCase();

          return rawSlot == normalizedKey || rawSlot == localizedLabel;
        }).toList();

        final bodyBuffer = StringBuffer();
        if (foodName.isNotEmpty) {
          bodyBuffer.write(foodName);
        } else {
          bodyBuffer.write(tr.notificationMealTimeForSlot(slotLabel));
        }

        if (linkedSupplements.isNotEmpty) {
          final supplementParts = linkedSupplements.map((s) {
            final dosage = s.dosageNote?.trim();
            if (dosage != null && dosage.isNotEmpty) {
              return '${s.name} ($dosage)';
            }
            return s.name;
          }).join('، ');

          if (bodyBuffer.isNotEmpty) {
            bodyBuffer.write('\n - $supplementParts');
          } else {
            bodyBuffer.write(supplementParts);
          }
        }

        final body = bodyBuffer.toString();

        // 4. Unique ID: 1000 + (dayIndex * 10) + slotIndex
        final slotIndex = DietConstants.mealSlotKeys.indexOf(slotKey);
        final notificationId = 1000 + (dayIndex * 10) + slotIndex;

        // 5. Build JSON payload containing target day and meal slot
        final payload = jsonEncode({
          'type': 'meal_reminder',
          'day': dayKey,
          'meal': slotKey,
          'slot': slotKey,
        });

        // 6. Multi-line expanded style for Android with localized summary
        final bigTextStyle = BigTextStyleInformation(
          body,
          contentTitle: title,
          summaryText: tr.notificationDietPlanSummary,
        );

        // 7. Schedule via zonedSchedule with localized channel & ticker
        final androidDetails = AndroidNotificationDetails(
          mealChannelId,
          tr.notificationMealChannelName,
          channelDescription: tr.notificationMealChannelDesc,
          importance: Importance.max,
          priority: Priority.high,
          ticker: tr.notificationMealTicker,
          icon: 'ic_stat_notification',
          styleInformation: bigTextStyle,
        );

        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        final details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await _notifications.zonedSchedule(
          notificationId,
          title,
          body,
          scheduledDateTime,
          details,
          payload: payload,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );

        debugPrint(
          'Scheduled [$title] for $scheduledDateTime with body:\n$body',
        );
      }
    }

    // ── Diagnostic: verify pending notifications & permissions ──
    final pending = await _notifications.pendingNotificationRequests();
    debugPrint('📋 Pending notifications after scheduling: ${pending.length}');
    for (final p in pending) {
      debugPrint('  → id=${p.id}  title=${p.title}');
    }

    if (Platform.isAndroid) {
      final notifPerm = await Permission.notification.status;
      final alarmPerm = await Permission.scheduleExactAlarm.status;
      debugPrint('🔔 Notification permission: $notifPerm');
      debugPrint('⏰ Exact alarm permission: $alarmPerm');
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
