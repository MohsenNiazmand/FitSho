import 'package:flutter/services.dart';

const _persianTextPattern =
    r'[\u0600-\u06FF\u0660-\u0669\u06F0-\u06F90-9\s\u200c.,،؛:\-()]';

final _latinLetterPattern = RegExp('[a-zA-Z]');

/// Creates a formatter for user-facing Persian text fields.
/// Calls [onRejected] when the user enters disallowed characters.
TextInputFormatter createPersianTextFormatter({
  VoidCallback? onRejected,
}) {
  final filter = FilteringTextInputFormatter.allow(
    RegExp(_persianTextPattern),
  );

  return TextInputFormatter.withFunction((oldValue, newValue) {
    final result = filter.formatEditUpdate(oldValue, newValue);
    if (result.text != newValue.text) {
      onRejected?.call();
    }
    return result;
  });
}

/// Returns true when [value] has no Latin letters after trim.
bool isValidPersianText(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return false;
  return !_latinLetterPattern.hasMatch(trimmed);
}
