import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUseCase implements UseCase<void, NoParams> {
  RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(NoParams params) {
    return _repository.refreshToken();
  }
}
