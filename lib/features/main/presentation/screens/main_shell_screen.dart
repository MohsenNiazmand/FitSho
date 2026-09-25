import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/notifications/notification_service.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainShellScreen extends HookConsumerWidget {
  const MainShellScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _handleBackPress(
    BuildContext context,
    ObjectRef<DateTime?> lastBackPress,
  ) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }

    if (navigationShell.currentIndex != 0) {
      navigationShell.goBranch(0);
      return;
    }

    final now = DateTime.now();
    final previousPress = lastBackPress.value;
    if (previousPress == null ||
        now.difference(previousPress) > const Duration(seconds: 2)) {
      lastBackPress.value = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(context.tr.pressBackAgainToExit),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastBackPress = useRef<DateTime?>(null);

    // Handle initial navigation (cold start) and subsequent updates
    useEffect(() {
      void handleNavigation(DietNavigationTarget? target) {
        if (target == null) return;

        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (target.openSupplements) {
            navigationShell.goBranch(3);
            ref.read(dietNavigationNotifierProvider.notifier).clear();
          } else if (target.openWeeklyPlan) {
            navigationShell.goBranch(1);
            if (target.highlightDay == null && target.highlightSlot == null) {
              ref.read(dietNavigationNotifierProvider.notifier).clear();
            }
          }
        });
      }

      // Check immediately on build
      handleNavigation(ref.read(dietNavigationNotifierProvider));

      // Handle cold-start notification tap
      getIt<NotificationService>().checkAndHandleInitialNotification();

      // Listen for changes
      final subscription = ref.listenManual(
        dietNavigationNotifierProvider,
        (prev, next) => handleNavigation(next),
      );

      return subscription.close;
    }, []);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackPress(context, lastBackPress);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onTap,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: context.tr.navDashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month),
              label: context.tr.navWeeklyPlan,
            ),
            NavigationDestination(
              icon: const Icon(Icons.fitness_center_outlined),
              selectedIcon: const Icon(Icons.fitness_center),
              label: context.tr.workoutTabTitle,
            ),
            NavigationDestination(
              icon: const Icon(Icons.medication_outlined),
              selectedIcon: const Icon(Icons.medication),
              label: context.tr.navSupplements,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: context.tr.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
