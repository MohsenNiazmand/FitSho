sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Session expired. Please login again',
  ]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

final class ConflictFailure extends Failure {
  const ConflictFailure([super.message = 'Resource already exists']);
}

final class AiProviderFailure extends Failure {
  const AiProviderFailure([
    super.message = 'AI service temporarily unavailable',
  ]);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
