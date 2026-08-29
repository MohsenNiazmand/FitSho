import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  Future<bool> requestPermissionAndRegisterToken() async {
    if (kIsWeb) {
      return false;
    }

    if (_tokenRegisteredThisSession) {
      return true;
    }

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
  }

  Future<void> registerTokenIfPossible() async {
    if (kIsWeb) {
      return;
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    final deviceId = await getIt<DeviceIdService>().getDeviceId();
    final platform = Platform.isIOS ? 'ios' : 'android';

    await getIt<DietRepository>().registerFcmToken(
      FcmTokenRegistration(
        token: token,
        deviceId: deviceId,
        platform: platform,
      ),
    );
  }

  Future<void> unregisterToken() async {
    if (kIsWeb) {
      return;
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    await getIt<DietRepository>().unregisterFcmToken(token);
    _tokenRegisteredThisSession = false;
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
      }
      return;
    }

    if (type == 'supplement_reminder') {
      _ref.read(dietNavigationNotifierProvider.notifier).openSupplements();
    }
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
            title: title ?? 'یادآوری رژیم',
            body: body ?? 'زمان وعده غذایی شما نزدیک است.',
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
    required this.title,
    required this.body,
    required this.onTap,
  });

  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Gap.h16(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(body, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Text(
                    'تیک زدن',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
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
