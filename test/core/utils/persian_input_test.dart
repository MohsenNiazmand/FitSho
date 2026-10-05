import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitsho/core/utils/persian_input.dart';

void main() {
  test('text formatter accepts Persian ک and other writing systems', () {
    final formatter = createLettersOnlyFormatter();
    final result = formatter.formatEditUpdate(
      const TextEditingValue(),
      const TextEditingValue(text: 'کیک yoga تمرین'),
    );

    expect(result.text, 'کیک yoga تمرین');
  });

  test('text formatter rejects Latin, Arabic-Indic, and Persian digits', () {
    final formatter = createLettersOnlyFormatter();
    final result = formatter.formatEditUpdate(
      const TextEditingValue(),
      const TextEditingValue(text: 'کیک 123 ١٢٣ ۱۲۳'),
    );

    expect(result.text, 'کیک   ');
  });
}
