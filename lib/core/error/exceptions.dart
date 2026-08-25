class ServerException implements Exception {
  const ServerException([this.message = 'Server error occurred']);

  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Unauthorized']);

  final String message;
}

class ValidationException implements Exception {
  const ValidationException([this.message = 'Validation failed']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache error']);

  final String message;
}
