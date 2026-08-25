import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:fitsho/shared/presentation/widgets/app_icon_badge.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          await ref.read(authStateProvider.notifier).checkSession();
        });
        return null;
      },
      const [],
    );

    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIconBadge(icon: Icons.restaurant_menu_rounded, size: 96),
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
    );
  }
}
