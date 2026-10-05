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
    EmptyExercisePoolFailure() => failure.message,
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
  if (error is Failure) {
    return failureMessage(context, error);
  }
  if (error is StateError) {
    return error.message.isNotEmpty ? error.message : error.toString();
  }
  try {
    final msg = (error as dynamic).message;
    if (msg is String && msg.isNotEmpty) {
      return msg;
    }
  } catch (_) {}

  final str = error.toString();
  if (str.contains('NotFoundFailure')) return 'Resource not found';
  if (str.contains('NetworkFailure')) return context.tr.networkError;
  if (str.contains('UnauthorizedFailure')) return context.tr.sessionExpired;
  if (str.startsWith("Instance of '")) {
    return context.tr.genericError;
  }
  return str;
}
