import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/preferences/domain/repositories/preference_repository.dart';
import 'package:fitsho/shared/domain/entities/preference.dart';

class GetPreferencesUseCase implements UseCase<Preference?, NoParams> {
  GetPreferencesUseCase(this._repository);

  final PreferenceRepository _repository;

  @override
  ResultFuture<Preference?> call(NoParams params) async {
    final result = await _repository.getPreferences();

    return result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          return const Right(null);
        }
        return Left(failure);
      },
      Right.new,
    );
  }
}
