/// Utilities for Persian (Eastern Arabic) digit display.
///
/// Design rationale: Even with Vazirmatn UI-FD, explicit conversion keeps
/// ingredient amounts and phone numbers correct when strings mix scripts.
abstract final class PersianDigits {
  static const _latin = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static const _persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  /// Converts Latin digits in [input] to Persian digits.
  static String toPersian(String input) {
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      final char = String.fromCharCode(codeUnit);
      final index = _latin.indexOf(char);
      buffer.write(index >= 0 ? _persian[index] : char);
    }
    return buffer.toString();
  }

  /// Formats an integer with Persian digits.
  static String formatInt(int value) => toPersian('$value');

  /// Converts Persian/Arabic-Indic digits back to Latin for parsers.
  static String toLatin(String input) {
    const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final buffer = StringBuffer();
    for (final codeUnit in input.codeUnits) {
      final char = String.fromCharCode(codeUnit);
      var index = _persian.indexOf(char);
      if (index < 0) index = arabicIndic.indexOf(char);
      buffer.write(index >= 0 ? _latin[index] : char);
    }
    return buffer.toString();
  }
}
