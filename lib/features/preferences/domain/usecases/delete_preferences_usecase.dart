import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/preferences/domain/repositories/preference_repository.dart';

class DeletePreferencesUseCase implements UseCase<void, NoParams> {
  DeletePreferencesUseCase(this._repository);

  final PreferenceRepository _repository;

  @override
  ResultFuture<void> call(NoParams params) {
    return _repository.deletePreferences();
  }
}
