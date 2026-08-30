import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/app_config/data/models/app_config_model.dart';

abstract class AppConfigRepository {
  Future<Either<Failure, AppConfigModel>> getAppConfig();
}
