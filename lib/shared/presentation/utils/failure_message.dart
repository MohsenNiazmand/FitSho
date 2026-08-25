import 'package:flutter/material.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';

String failureMessage(BuildContext context, Failure failure) {
  return switch (failure) {
    NetworkFailure() => context.tr.networkError,
    UnauthorizedFailure() => context.tr.sessionExpired,
    AiProviderFailure() => context.tr.aiProviderFailure,
    ValidationFailure() => failure.message,
    ConflictFailure() => failure.message,
    NotFoundFailure() => failure.message,
    ServerFailure() => failure.message.isNotEmpty
        ? failure.message
        : context.tr.genericError,
    CacheFailure() => context.tr.genericError,
    UnknownFailure() => context.tr.genericError,
  };
}
