import 'package:dio/dio.dart';
import 'package:fitsho/core/error/exceptions.dart';
import 'package:fitsho/core/error/failures.dart';

class ExceptionMapper {
  ExceptionMapper._();

  static Failure mapException(Object error) {
    if (error is Failure) return error;

    if (error is DioException) {
      return _mapDioException(error);
    }

    if (error is ServerException) {
      return ServerFailure(error.message);
    }
    if (error is NetworkException) {
      return NetworkFailure(error.message);
    }
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message);
    }
    if (error is ValidationException) {
      return ValidationFailure(error.message);
    }
    if (error is CacheException) {
      return CacheFailure(error.message);
    }

    return UnknownFailure(error.toString());
  }

  static Failure _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode, error.response?.data);
      case DioExceptionType.cancel:
        return const UnknownFailure('Request cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return UnknownFailure(error.message ?? 'Network error');
    }
  }

  static Failure _mapStatusCode(int? statusCode, dynamic data) {
    final message = _extractMessage(data);

    if (statusCode == 400) {
      return ValidationFailure(message ?? 'Invalid request');
    }
    if (statusCode == 401) {
      return UnauthorizedFailure(message ?? 'Unauthorized');
    }
    if (statusCode == 404) {
      return NotFoundFailure(message ?? 'Not found');
    }
    if (statusCode == 409) {
      return ConflictFailure(message ?? 'Resource already exists');
    }
    if (statusCode == 429) {
      return RateLimitFailure(message ?? 'Rate limit exceeded');
    }
    if (statusCode == 422) {
      return ValidationFailure(message ?? 'Invalid input');
    }
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return ServerFailure(message ?? 'Server error');
    }
    return ServerFailure(message ?? 'Request failed');
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) return message;
    }
    return null;
  }

}
