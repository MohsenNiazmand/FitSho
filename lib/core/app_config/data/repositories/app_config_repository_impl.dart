import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/app_config/data/models/app_config_model.dart';
import 'package:fitsho/core/app_config/data/services/app_config_api.dart';
import 'package:fitsho/core/app_config/domain/repositories/app_config_repository.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/utils/repository_guard.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  const AppConfigRepositoryImpl(this._api);

  final AppConfigApi _api;

  @override
  Future<Either<Failure, AppConfigModel>> getAppConfig() {
    return guard(() async {
      final response = await _api.getAppConfig();
      return response.data;
    });
  }
}
