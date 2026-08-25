import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/preferences/domain/repositories/preference_repository.dart';
import 'package:fitsho/shared/domain/entities/preference.dart';

class SavePreferencesParams {
  const SavePreferencesParams({
    required this.dietaryRestrictions,
    required this.preferredCuisines,
  });

  final List<String> dietaryRestrictions;
  final List<String> preferredCuisines;
}

class SavePreferencesUseCase
    implements UseCase<Preference, SavePreferencesParams> {
  SavePreferencesUseCase(this._repository);

  final PreferenceRepository _repository;

  @override
  ResultFuture<Preference> call(SavePreferencesParams params) {
    return _repository.upsertPreferences(
      dietaryRestrictions: params.dietaryRestrictions,
      preferredCuisines: params.preferredCuisines,
    );
  }
}
