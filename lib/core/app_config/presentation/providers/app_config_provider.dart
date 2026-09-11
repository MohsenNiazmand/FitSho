import 'package:fitsho/core/app_config/domain/repositories/app_config_repository.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_provider.g.dart';

enum VersionStatus {
  latest,
  updateAvailable,
  forceUpdate,
}

class AppVersionInfo {
  const AppVersionInfo({
    required this.status,
    this.updateUrl,
  });

  final VersionStatus status;
  final String? updateUrl;
}

@riverpod
class AppVersionCheck extends _$AppVersionCheck {
  @override
  FutureOr<AppVersionInfo> build() async {
    final repository = getIt<AppConfigRepository>();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = Version.parse(packageInfo.version);

    final result = await repository.getAppConfig();

    return result.fold(
      (failure) => const AppVersionInfo(status: VersionStatus.latest),
      (config) {
        final latestVersion = Version.parse(config.latestVersion);
        final minSupportedVersion = Version.parse(config.minSupportedVersion);

        if (config.forceUpdate || currentVersion < minSupportedVersion) {
          return AppVersionInfo(
            status: VersionStatus.forceUpdate,
            updateUrl: config.updateUrl,
          );
        }

        if (currentVersion < latestVersion) {
          return AppVersionInfo(
            status: VersionStatus.updateAvailable,
            updateUrl: config.updateUrl,
          );
        }

        return const AppVersionInfo(status: VersionStatus.latest);
      },
    );
  }
}

/// Provides the current app version string (e.g., '1.0.0').
final appVersionProvider = FutureProvider<String>((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
});
