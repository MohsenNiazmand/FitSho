import 'package:fitsho/core/app_config/presentation/providers/app_config_provider.dart';
import 'package:fitsho/core/app_config/presentation/widgets/update_dialogs.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fitsho/shared/presentation/widgets/app_icon_badge.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionCheck = ref.watch(appVersionCheckProvider);
    final versionAsync = ref.watch(appVersionProvider);

    useEffect(
      () {
        if (versionCheck is AsyncData) {
          final info = versionCheck.value!;
          if (info.status == VersionStatus.forceUpdate) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) => ForceUpdateDialog(
                  updateUrl: info.updateUrl!,
                  releaseNotes: info.releaseNotes,
                ),
              );
            });
          } else if (info.status == VersionStatus.updateAvailable) {
            SchedulerBinding.instance.addPostFrameCallback((_) async {
              await showDialog<void>(
                context: context,
                builder: (_) =>
                    OptionalUpdateDialog(
                  updateUrl: info.updateUrl!,
                  releaseNotes: info.releaseNotes,
                ),
              );
              if (context.mounted) {
                await ref.read(authStateProvider.notifier).checkSession();
              }
            });
          } else {
            // Latest version or error (already handled by provider)
            SchedulerBinding.instance.addPostFrameCallback((_) async {
              await ref.read(authStateProvider.notifier).checkSession();
            });
          }
        } else if (versionCheck is AsyncError) {
          // If error (offline, server down), continue to app
          SchedulerBinding.instance.addPostFrameCallback((_) async {
            await ref.read(authStateProvider.notifier).checkSession();
          });
        }
        return null;
      },
      [versionCheck],
    );

    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppIconBadge(
                  icon: Icons.restaurant_menu_rounded,
                  size: 96,
                ),
                Gap.v24(),
                Text(
                  context.tr.appNamePersian,
                  style: theme.textTheme.headlineMedium,
                ),
                Gap.v8(),
                Text(
                  context.tr.appName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Gap.v32(),
                const AppLoadingIndicator(),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: versionAsync.when(
                  data: (version) => Text(
                    context.tr.appVersion(
                      PersianDigits.toPersian(version),
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
