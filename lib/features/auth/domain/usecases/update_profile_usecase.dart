import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitsho/shared/domain/entities/user.dart';

class UpdateProfileParams {
  const UpdateProfileParams({required this.name});

  final String name;
}

class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  UpdateProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<User> call(UpdateProfileParams params) {
    return _repository.updateProfile(params.name);
  }
}
