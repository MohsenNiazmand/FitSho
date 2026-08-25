import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/app.dart';
import 'package:fitsho/core/injection_container.dart';

void main() {
  setUpAll(() async {
    await initializeDependencies();
  });

  testWidgets('Splash screen shows localized app name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FitShoApp(),
      ),
    );

    expect(find.text('فیت‌شو'), findsOneWidget);
    expect(find.text('FitSho'), findsOneWidget);
  });
}
