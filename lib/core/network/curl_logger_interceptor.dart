import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CurlLoggerInterceptor extends Interceptor {
  const CurlLoggerInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _printCurl(options);
    handler.next(options);
  }

  void _printCurl(RequestOptions options) {
    try {
      final curl = _toCurl(options);
      debugPrint(curl);
    } on Object catch (e) {
      debugPrint('[cURL error] $e');
    }
  }

  String _toCurl(RequestOptions options) {
    final components = <String>['curl -i'];

    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method.toUpperCase()}');
    }

    options.headers.forEach((key, dynamic value) {
      if (key.toLowerCase() != 'cookie') {
        components.add('-H "$key: $value"');
      }
    });

    if (options.data != null) {
      String dataStr;
      if (options.data is FormData) {
        final map = Map.fromEntries((options.data as FormData).fields);
        dataStr = jsonEncode(map);
      } else if (options.data is Map || options.data is List) {
        dataStr = jsonEncode(options.data);
      } else {
        dataStr = options.data.toString();
      }
      final escaped = dataStr.replaceAll("'", r"\'");
      components.add("-d '$escaped'");
    }

    components.add('"${options.uri}"');

    return components.join(' ');
  }
}
