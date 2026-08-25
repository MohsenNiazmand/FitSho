import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:fitsho/features/auth/presentation/providers/current_user_provider.dart';

part 'profile_providers.g.dart';

@riverpod
class UpdateProfileNotifier extends _$UpdateProfileNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> updateProfile(String name) async {
    state = const AsyncValue.loading();

    final result = await getIt<UpdateProfileUseCase>()(
      UpdateProfileParams(name: name),
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (user) {
        ref.read(currentUserProvider.notifier).updateUser(user);
        state = const AsyncValue.data(null);
        return null;
      },
    );
  }
}

@riverpod
class ProfileRefreshNotifier extends _$ProfileRefreshNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> refreshUser() async {
    state = const AsyncValue.loading();

    final result = await getIt<GetCurrentUserUseCase>()(const NoParams());

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (user) {
        ref.read(currentUserProvider.notifier).updateUser(user);
        state = const AsyncValue.data(null);
      },
    );
  }
}
