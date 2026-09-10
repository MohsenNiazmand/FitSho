import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitsho/app.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/notifications/notification_service.dart';
import 'package:fitsho/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart' as tz;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Persian date formatting
  await initializeDateFormatting('fa_IR');

  // 2. Initialize timezone database before any scheduling occurs
  tz.initializeTimeZones();

  // 3. Initialize dependency injection
  await initializeDependencies();

  // 4. Initialize NotificationService (plugin, channel & device timezone)
  final notificationService = getIt<NotificationService>();
  await notificationService.initialize();

  // 5. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    const ProviderScope(
      child: FitShoApp(),
    ),
  );
}
