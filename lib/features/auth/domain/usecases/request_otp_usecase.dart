import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/repositories/auth_repository.dart';

class RequestOtpParams {
  const RequestOtpParams({required this.mobileNumber});

  final String mobileNumber;
}

class RequestOtpUseCase implements UseCase<void, RequestOtpParams> {
  RequestOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(RequestOtpParams params) {
    return _repository.requestOtp(params.mobileNumber);
  }
}
