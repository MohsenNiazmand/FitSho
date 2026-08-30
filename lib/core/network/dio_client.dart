import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:fitsho/core/constants/app_config.dart';
import 'package:fitsho/core/network/api_response_logger_interceptor.dart';
import 'package:fitsho/core/network/auth_interceptor.dart';
import 'package:fitsho/core/storage/device_id_service.dart';
import 'package:fitsho/core/storage/token_storage.dart';
import 'package:logger/logger.dart';

Dio createDio({
  required TokenStorage tokenStorage,
  required DeviceIdService deviceIdService,
  Logger? logger,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      deviceIdService: deviceIdService,
      dio: dio,
    ),
  );

  if (AppConfig.isDev) {
    dio.interceptors.add(
      CurlLoggerDioInterceptor(printOnSuccess: true),
    );
    if (logger != null) {
      dio.interceptors.add(ApiResponseLoggerInterceptor(logger));
    }
  }

  return dio;
}
