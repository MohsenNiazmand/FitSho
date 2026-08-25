import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/utils/repository_guard.dart';
import 'package:fitsho/features/preferences/data/models/preference_model.dart';
import 'package:fitsho/features/preferences/data/services/preference_api.dart';
import 'package:fitsho/features/preferences/domain/repositories/preference_repository.dart';
import 'package:fitsho/shared/data/mappers/entity_mappers.dart';
import 'package:fitsho/shared/domain/entities/preference.dart';

class PreferenceRepositoryImpl implements PreferenceRepository {
  PreferenceRepositoryImpl(this._preferenceApi);

  final PreferenceApi _preferenceApi;

  @override
  Future<Either<Failure, Preference>> getPreferences() {
    return guard(() async {
      final response = await _preferenceApi.getPreferences();
      return response.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, Preference>> upsertPreferences({
    required List<String> dietaryRestrictions,
    required List<String> preferredCuisines,
  }) {
    return guard(() async {
      final response = await _preferenceApi.upsertPreferences(
        UpsertPreferenceRequest(
          dietaryRestrictions: dietaryRestrictions,
          preferredCuisines: preferredCuisines,
        ),
      );
      return response.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deletePreferences() {
    return guard(() async {
      await _preferenceApi.deletePreferences();
    });
  }
}
