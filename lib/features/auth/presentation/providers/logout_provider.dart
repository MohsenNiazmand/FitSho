import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/notifications/push_notification_service.dart';
import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fitsho/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fitsho/features/diet/data/datasources/diet_local_data_source.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';

part 'logout_provider.g.dart';

@riverpod
class LogoutNotifier extends _$LogoutNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> logout() async {
    ref.read(authStateProvider.notifier).beginLogout();
    state = const AsyncValue.loading();

    try {
      try {
        await ref.read(pushNotificationServiceProvider).unregisterToken();
      } on Object catch (_) {
        // FCM unregistration is best-effort and must not block logout.
      }
      final result = await getIt<LogoutUseCase>()(const NoParams());

      return await result.fold(
        (failure) async {
          state = AsyncValue.error(failure, StackTrace.current);
          return failure;
        },
        (_) async {
          await getIt<DietLocalDataSource>().clearCache();
          _resetCachedProviders();
          ref.read(authStateProvider.notifier).setUnauthenticated();
          state = const AsyncValue.data(null);
          return null;
        },
      );
    } finally {
      ref.read(authStateProvider.notifier).endLogout();
    }
  }

  void _resetCachedProviders() {
    ref
      ..invalidate(dietProfileNotifierProvider)
      ..invalidate(dietPlanNotifierProvider)
      ..invalidate(dietPlanHistoryNotifierProvider)
      ..invalidate(lastMealLogNotifierProvider)
      ..invalidate(todayMealLogsNotifierProvider)
      ..invalidate(complianceStatsNotifierProvider)
      ..invalidate(mealSlotsNotifierProvider)
      ..invalidate(supplementsNotifierProvider);
  }
}
