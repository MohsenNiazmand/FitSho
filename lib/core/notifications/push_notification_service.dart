import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/storage/device_id_service.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/repositories/diet_repository.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_navigation_provider.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class PushNotificationService {
  PushNotificationService(this._ref);

  final Ref _ref;
  bool _initialized = false;
  bool _tokenRegisteredThisSession = false;

  Future<void> initialize() async {
    if (_initialized || kIsWeb) {
      return;
    }
    _initialized = true;

    try {
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage);
      }
    } on Object catch (e, stack) {
      getIt<Logger>().w(
        'Failed to initialize push notifications: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<bool> requestPermissionAndRegisterToken() async {
    if (kIsWeb) {
      return false;
    }

    if (_tokenRegisteredThisSession) {
      return true;
    }

    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      final authorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (!authorized) {
        return false;
      }

      await registerTokenIfPossible();
      _tokenRegisteredThisSession = true;
      return true;
    } on Object catch (e, stack) {
      getIt<Logger>().w(
        'Failed to request notification permission: $e',
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  Future<void> registerTokenIfPossible() async {
    if (kIsWeb) {
      return;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      getIt<Logger>().i('FCM token: $token');

      final deviceId = await getIt<DeviceIdService>().getDeviceId();
      final platform = Platform.isIOS ? 'ios' : 'android';

      await getIt<DietRepository>().registerFcmToken(
        FcmTokenRegistration(
          token: token,
          deviceId: deviceId,
          platform: platform,
        ),
      );
    } on Object catch (e, stack) {
      getIt<Logger>().w(
        'Failed to register FCM token (Play Services unavailable): $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<void> unregisterToken() async {
    if (kIsWeb) {
      return;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await getIt<DietRepository>().unregisterFcmToken(token);
      }
    } on Object catch (e, stack) {
      getIt<Logger>().w(
        'Failed to unregister FCM token (Play Services unavailable): $e',
        error: e,
        stackTrace: stack,
      );
    } finally {
      _tokenRegisteredThisSession = false;
    }
  }

  void _handleMessage(RemoteMessage message) {
    final type = message.data['type'];
    if (type == 'meal_reminder') {
      final slot = message.data['slot'];
      final day = message.data['day'];
      if (slot is String && day is String) {
        _ref
            .read(dietNavigationNotifierProvider.notifier)
            .openMealReminder(day: day, slot: slot);
      } else {
        _ref.read(dietNavigationNotifierProvider.notifier).openWeeklyPlan();
      }
      return;
    }

    if (type == 'supplement_reminder') {
      _ref.read(dietNavigationNotifierProvider.notifier).openSupplements();
      return;
    }

    // Default action for other notifications
    _ref.read(dietNavigationNotifierProvider.notifier).openWeeklyPlan();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title;
    final body = message.notification?.body;
    final type = message.data['type'];

    if (type == 'meal_reminder' || type == 'supplement_reminder') {
      BotToast.showCustomNotification(
        duration: const Duration(seconds: 5),
        toastBuilder: (cancelFunc) {
          return _InAppNotification(
            title: title,
            body: body,
            onTap: () {
              cancelFunc();
              _handleMessage(message);
            },
          );
        },
      );
    }
  }
}

class _InAppNotification extends StatelessWidget {
  const _InAppNotification({
    this.title,
    this.body,
    required this.onTap,
  });

  final String? title;
  final String? body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTitle = (title == null || title!.isEmpty)
        ? context.tr.dietReminderTitle
        : title!;
    final displayBody = (body == null || body!.isEmpty)
        ? context.tr.dietReminderBody
        : body!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      color: theme.colorScheme.primary,
                      size: 32, // آیکون بزرگ‌تر
                    ),
                  ),
                  Gap.h12(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          displayBody,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Gap.h12(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      context.tr.view,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final pushNotificationServiceProvider = Provider<PushNotificationService>(
  PushNotificationService.new,
);
