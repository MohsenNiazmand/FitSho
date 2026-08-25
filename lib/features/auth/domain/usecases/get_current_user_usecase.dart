import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitsho/shared/domain/entities/user.dart';

class GetCurrentUserUseCase implements UseCase<User, NoParams> {
  GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<User> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
