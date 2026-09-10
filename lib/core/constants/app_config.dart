/// Runtime configuration driven by `--dart-define` flags.
///
/// Example:
/// ```bash
/// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
/// flutter run --dart-define=ENV=prod --dart-define=API_BASE_URL=https://api.example.com
/// ```
class AppConfig {
  AppConfig._();

  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
    // defaultValue: 'prod',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3000/api/v1/',
    // defaultValue: 'https://fitsho.liara.run/api/v1/',
    // defaultValue: 'https://api.fitsho-ai.ir/api/v1/',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  static bool get isDev => env == 'dev';
  static bool get isProd => env == 'prod';
}
