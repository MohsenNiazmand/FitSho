import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

String failureMessage(BuildContext context, Failure failure) {
  return switch (failure) {
    NetworkFailure() => context.tr.networkError,
    UnauthorizedFailure() => context.tr.sessionExpired,
    AiProviderFailure() => context.tr.aiProviderFailure,
    ValidationFailure() => failure.message,
    ConflictFailure() => failure.message,
    NotFoundFailure() => failure.message,
    RateLimitFailure() => failure.message,
    MedicalReferralFailure() => failure.message,
    ServerFailure() => failure.message.isNotEmpty
        ? failure.message
        : context.tr.genericError,
    CacheFailure() => context.tr.genericError,
    UnknownFailure() => context.tr.genericError,
  };
}

/// Formats any caught error for display, resolving [Failure]s to their
/// localized message instead of falling back to `error.toString()` (which
/// just prints `Instance of 'XFailure'`).
String errorDisplayMessage(BuildContext context, Object error) {
  return error is Failure ? failureMessage(context, error) : error.toString();
}
