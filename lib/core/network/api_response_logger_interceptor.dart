import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiResponseLoggerInterceptor extends Interceptor {
  ApiResponseLoggerInterceptor(this._logger);

  final Logger _logger;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response != null) {
      _logResponse(response);
    } else {
      final request = err.requestOptions;
      _logger.e(
        '[API] ${request.method} ${request.uri}\n'
        'Status: (no response)\n'
        'Error: ${err.type.name} — ${err.message}',
      );
    }
    handler.next(err);
  }

  void _logResponse(Response<dynamic> response) {
    final request = response.requestOptions;
    final statusCode = response.statusCode;
    final level =
        statusCode != null && statusCode >= 400 ? Level.warning : Level.info;

    _logger.log(
      level,
      '[API] ${request.method} ${request.uri}\n'
      'Status: $statusCode\n'
      'Body: ${_formatBody(response.data)}',
    );
  }

  String _formatBody(dynamic body) {
    if (body == null) return '(empty)';
    if (body is Map || body is List) {
      try {
        return const JsonEncoder.withIndent('  ').convert(body);
      } on Object {
        return body.toString();
      }
    }
    return body.toString();
  }
}
