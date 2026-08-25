import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/features/auth/domain/usecases/request_otp_usecase.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> requestOtp(String mobileNumber) async {
    state = const AsyncValue.loading();

    final result = await getIt<RequestOtpUseCase>()(
      RequestOtpParams(mobileNumber: mobileNumber),
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) {
        state = const AsyncValue.data(null);
        return null;
      },
    );
  }
}
