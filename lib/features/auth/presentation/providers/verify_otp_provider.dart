import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fitsho/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fitsho/features/auth/presentation/providers/current_user_provider.dart';
import 'package:fitsho/shared/domain/entities/user.dart';

part 'verify_otp_provider.g.dart';

@riverpod
class VerifyOtpNotifier extends _$VerifyOtpNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<({Failure? failure, User? user})> verifyOtp({
    required String mobileNumber,
    required String otpCode,
  }) async {
    state = const AsyncValue.loading();

    final result = await getIt<VerifyOtpUseCase>()(
      VerifyOtpParams(mobileNumber: mobileNumber, otpCode: otpCode),
    );

    return await result.fold(
      (failure) async {
        state = AsyncValue.error(failure, StackTrace.current);
        return (failure: failure, user: null);
      },
      (user) async {
        ref.read(authStateProvider.notifier).setAuthenticated();

        final meResult =
            await getIt<GetCurrentUserUseCase>()(const NoParams());
        final hydratedUser =
            meResult.fold((_) => user, (fullUser) => fullUser);

        ref.read(currentUserProvider.notifier).updateUser(hydratedUser);
        state = const AsyncValue.data(null);
        return (failure: null, user: hydratedUser);
      },
    );
  }
}
