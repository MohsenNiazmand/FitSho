import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/config/router/go_router_provider.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/core/notifications/push_notification_service.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_navigation_provider.dart';

class DietNotificationListener extends HookConsumerWidget {
  const DietNotificationListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        ref.read(pushNotificationServiceProvider).initialize();
        return null;
      },
      const [],
    );

    ref.listen(dietNavigationNotifierProvider, (previous, next) {
      if (next == null) return;

      final router = ref.read(goRouterProvider);
      if (next.openSupplements) {
        router.push(AppRoutes.dietSupplements);
        ref.read(dietNavigationNotifierProvider.notifier).clear();
        return;
      }

      if (next.highlightDay != null && next.highlightSlot != null) {
        router.go(AppRoutes.weeklyPlan);
      }
    });

    return child;
  }
}
