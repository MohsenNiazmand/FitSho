import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/config/router/go_router_provider.dart';
import 'package:fitsho/config/theme/app_theme.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/notifications/diet_notification_listener.dart';
import 'package:fitsho/l10n/app_localizations.dart';

class FitShoApp extends HookConsumerWidget {
  const FitShoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final botToastBuilder = BotToastInit();

    return DietNotificationListener(
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.tr.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        locale: const Locale('fa', 'IR'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
        builder: botToastBuilder,
      ),
    );
  }
}
