import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase implements UseCase<void, NoParams> {
  DeleteAccountUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(NoParams params) {
    return _repository.deleteAccount();
  }
}
