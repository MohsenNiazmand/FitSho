import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/auth/domain/enums/auth_status.dart';
import 'package:fitsho/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fitsho/features/auth/presentation/screens/login_screen.dart';
import 'package:fitsho/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:fitsho/features/diet/presentation/screens/dashboard_screen.dart';
import 'package:fitsho/features/diet/presentation/screens/diet_history_screen.dart';
import 'package:fitsho/features/diet/presentation/screens/diet_meal_slots_screen.dart';
import 'package:fitsho/features/diet/presentation/screens/supplements_screen.dart';
import 'package:fitsho/features/diet/presentation/screens/weekly_plan_screen.dart';
import 'package:fitsho/features/main/presentation/screens/main_shell_screen.dart';
import 'package:fitsho/features/profile/presentation/screens/profile_screen.dart';
import 'package:fitsho/features/splash/presentation/screens/splash_screen.dart';

part 'go_router_provider.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authListenable = ValueNotifier(ref.read(authStateProvider));

  ref
    ..listen(authStateProvider, (_, next) {
      authListenable.value = next;
    })
    ..onDispose(authListenable.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authListenable,
    redirect: (context, state) {
      final status = authListenable.value;
      final path = state.uri.path;

      if (status == AuthStatus.initial) {
        return path == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (path == AppRoutes.splash) {
        return status == AuthStatus.authenticated
            ? AppRoutes.home
            : AppRoutes.login;
      }

      final isAuthRoute =
          path == AppRoutes.login || path == AppRoutes.otpVerification;

      if (status == AuthStatus.unauthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (status == AuthStatus.authenticated && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final mobile = state.uri.queryParameters['mobile'] ?? '';
          return OtpVerificationScreen(mobileNumber: mobile);
        },
      ),
      GoRoute(
        path: AppRoutes.dietMealSlots,
        builder: (context, state) => const DietMealSlotsScreen(),
      ),
      GoRoute(
        path: AppRoutes.dietHistory,
        builder: (context, state) => const DietHistoryScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.weeklyPlan,
                builder: (context, state) => const WeeklyPlanScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dietSupplements,
                builder: (context, state) => const SupplementsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: Text(context.tr.errorTitle)),
        body: Center(
          child: Text(context.tr.routeNotFound(state.uri.toString())),
        ),
      );
    },
  );
}
