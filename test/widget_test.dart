import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitsho/app.dart';
import 'package:fitsho/core/injection_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return Directory.systemTemp.path;
    });

    SharedPreferences.setMockInitialValues({});
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
