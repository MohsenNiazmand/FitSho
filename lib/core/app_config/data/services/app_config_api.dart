import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fitsho/core/app_config/data/models/app_config_model.dart';

part 'app_config_api.g.dart';

@RestApi()
abstract class AppConfigApi {
  factory AppConfigApi(Dio dio, {String baseUrl}) = _AppConfigApi;

  @GET('app-config')
  Future<AppConfigResponse> getAppConfig();
}
