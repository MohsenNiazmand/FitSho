import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/notifications/push_notification_service.dart';
import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:fitsho/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fitsho/features/diet/data/datasources/diet_local_data_source.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';

part 'delete_account_provider.g.dart';

@riverpod
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> deleteAccount() async {
    ref.read(authStateProvider.notifier).beginLogout();
    state = const AsyncValue.loading();

    try {
      await ref.read(pushNotificationServiceProvider).unregisterToken();
      final result = await getIt<DeleteAccountUseCase>()(const NoParams());

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
