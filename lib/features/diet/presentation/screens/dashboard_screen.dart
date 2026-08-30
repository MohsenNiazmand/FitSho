import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/notifications/push_notification_service.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_navigation_provider.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/widgets/diet_onboarding_form.dart';
import 'package:fitsho/features/diet/presentation/widgets/diet_summary_widgets.dart';
import 'package:fitsho/features/diet/presentation/widgets/last_meal_card.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_outlined_button.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _generatePlan(BuildContext context, WidgetRef ref) async {
    final failure = await ref
        .read(dietPlanNotifierProvider.notifier)
        .generate();
    if (failure != null && context.mounted) {
      showFailureToast(context, failure);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future(() async {
        await ref.read(pushNotificationServiceProvider).initialize();
        await ref
            .read(pushNotificationServiceProvider)
            .requestPermissionAndRegisterToken();
      });
      return null;
    }, const []);

    ref.listen(dietNavigationNotifierProvider, (_, next) {
      if (next != null && next.openSupplements) {
        context.push(AppRoutes.dietSupplements);
        ref.read(dietNavigationNotifierProvider.notifier).clear();
      }
    });

    final profileAsync = ref.watch(dietProfileNotifierProvider);
    final planAsync = ref.watch(dietPlanNotifierProvider);
    final lastMealAsync = ref.watch(lastMealLogNotifierProvider);
    final todayLogsAsync = ref.watch(todayMealLogsNotifierProvider);
    final statsAsync = ref.watch(complianceStatsNotifierProvider);
    final isGenerating = planAsync.isLoading;

    final plan = planAsync.value;
    final now = DateTime.now();
    final lastGeneratedAt = plan?.createdAt;
    final bool cooldownActive = lastGeneratedAt != null &&
        now.difference(lastGeneratedAt).inHours < 24;

    String getGenerateLabel() {
      final baseLabel = context.tr.dietGeneratePlan;
      if (!cooldownActive) return baseLabel;
      final remainingHours = 24 - now.difference(lastGeneratedAt!).inHours;
      return '$baseLabel (${PersianDigits.toPersian(remainingHours.toString())} ساعت دیگر)';
    }

    return Scaffold(
      backgroundColor: cBackground,
      body: SafeArea(
        bottom: false,
        child: profileAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (error, _) => ErrorRetryView(
            message: errorDisplayMessage(context, error),
            onRetry: () => ref.invalidate(dietProfileNotifierProvider),
          ),
          data: (profile) {
            if (profile == null) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go(AppRoutes.dietOnboarding);
              });
              return const AppLoadingIndicator();
            }

            final waterGoalLiters = (profile.weightKg * 0.033).clamp(1.5, 4.5);

            return RefreshIndicator(
              onRefresh: () async {
                ref
                  ..invalidate(dietProfileNotifierProvider)
                  ..invalidate(dietPlanNotifierProvider)
                  ..invalidate(lastMealLogNotifierProvider)
                  ..invalidate(todayMealLogsNotifierProvider)
                  ..invalidate(complianceStatsNotifierProvider);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr.navDashboard,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cTextPrimary,
                            ),
                      ),
                      Row(
                        children: [
                          if (profile.dailyCalorieTarget != null)
                            Text(
                              'TDEE: ${PersianDigits.toPersian(profile.dailyCalorieTarget.toString())}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: cPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Gap.v24(),
                  if (planAsync.value?.shouldRegeneratePlan == true) ...[
                    RegenerationBanner(
                      onGenerate: () => _generatePlan(context, ref),
                      isLoading: isGenerating,
                    ),
                  ],
                  Text(
                    'پیشرفت روزانه',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cTextPrimary,
                    ),
                  ),
                  Gap.v12(),
                  if (planAsync.value != null)
                    Builder(
                      builder: (context) {
                        final plan = planAsync.value!;
                        final todayLogs = todayLogsAsync.value ?? [];
                        final todayKey = DietConstants.todayKey();
                        final todayPlan = plan.days.firstWhere(
                          (d) => d.day == todayKey,
                          orElse: () => plan.days.first,
                        );

                        int consumed = 0;
                        for (final log in todayLogs) {
                          final meal = todayPlan.meals[log.slot];
                          if (meal != null) {
                            consumed += meal.calories;
                          }
                        }

                        return CalorieProgressRing(
                          target:
                              profile.dailyCalorieTarget ??
                              plan.dailyCalorieTarget,
                          consumed: consumed,
                        );
                      },
                    )
                  else
                    Text(
                      context.tr.dietNoPlanYet,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: cTextSecondary),
                    ),
                  Gap.v24(),
                  Text(
                    'آمار سلامت',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cTextPrimary,
                    ),
                  ),
                  Gap.v12(),
                  Row(
                    children: [
                      if (profile.bmi != null)
                        Expanded(
                          child: HealthStatCard(
                            icon: Icons.monitor_weight_outlined,
                            label: 'BMI (${bmiStatusLabel(profile.bmi!)})',
                            value: PersianDigits.toPersian(
                              profile.bmi!.toStringAsFixed(1),
                            ),
                            accentColor: bmiStatusColor(profile.bmi!),
                          ),
                        ),
                      if (profile.bmi != null) Gap.h12(),
                      Expanded(
                        child: HealthStatCard(
                          icon: Icons.water_drop_outlined,
                          label: 'هدف آب روزانه',
                          value:
                              '${PersianDigits.toPersian(waterGoalLiters.toStringAsFixed(1))} لیتر',
                          accentColor: cPrimary,
                        ),
                      ),
                    ],
                  ),
                  Gap.v24(),
                  if (statsAsync.value != null) ...[
                    ComplianceRing(rate: statsAsync.value!.complianceRate),
                    Gap.v16(),
                  ],
                  lastMealAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (log) {
                      if (log == null) return const SizedBox.shrink();
                      return LastMealCard(mealLog: log);
                    },
                  ),
                  Gap.v24(),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.tune,
                          label: context.tr.dietProfileEditTitle,
                          onTap: () => context.push(AppRoutes.dietProfileEdit),
                        ),
                      ),
                      Gap.h12(),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.access_time,
                          label: context.tr.dietMealTimesSettings,
                          onTap: () => context.push(AppRoutes.dietMealSlots),
                        ),
                      ),
                      Gap.h12(),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.history,
                          label: context.tr.dietHistoryTitle,
                          onTap: () => context.push(AppRoutes.dietHistory),
                        ),
                      ),
                    ],
                  ),
                  Gap.v24(),
                  AppPrimaryButton(
                    label: getGenerateLabel(),
                    isLoading: isGenerating,
                    onPressed: (isGenerating || cooldownActive)
                        ? null
                        : () => _generatePlan(context, ref),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: cPrimary, size: 28),
              Gap.v8(),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: cTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
