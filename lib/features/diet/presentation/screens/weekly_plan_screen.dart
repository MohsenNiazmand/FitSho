import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_navigation_provider.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/widgets/diet_plan_section.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WeeklyPlanScreen extends ConsumerStatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  ConsumerState<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends ConsumerState<WeeklyPlanScreen> {
  String? _loggingSlotKey;

  Future<void> _generatePlan() async {
    final failure = await ref
        .read(dietPlanNotifierProvider.notifier)
        .generate();
    if (failure != null && mounted) {
      showFailureToast(context, failure);
    }
  }

  Future<void> _logMeal(String day, String slot) async {
    setState(() => _loggingSlotKey = '$day|$slot');
    final failure = await ref
        .read(logMealNotifierProvider.notifier)
        .logMeal(slot: slot, day: day);
    if (mounted) {
      setState(() => _loggingSlotKey = null);
      if (failure != null) {
        showFailureToast(context, failure);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(dietProfileNotifierProvider);
    final planAsync = ref.watch(dietPlanNotifierProvider);
    final navigationTarget = ref.watch(dietNavigationNotifierProvider);
    final isGenerating = planAsync.isLoading;

    return Scaffold(
      backgroundColor: cBackground,
      body: SafeArea(
        bottom: false,
        child: profileAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (error, _) => ErrorRetryView(
            message: error.toString(),
            onRetry: () => ref.invalidate(dietProfileNotifierProvider),
          ),
          data: (profile) {
            if (profile == null) {
              return Center(
                child: Text(
                  context.tr.dietNoPlanYet,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: cTextSecondary),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(dietPlanNotifierProvider);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr.navWeeklyPlan,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cTextPrimary,
                            ),
                      ),
                    ],
                  ),
                  Gap.v16(),
                  AppPrimaryButton(
                    label: context.tr.dietGeneratePlan,
                    isLoading: isGenerating,
                    onPressed: isGenerating ? null : _generatePlan,
                  ),
                  Gap.v24(),
                  planAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, _) => ErrorRetryView(
                      message: error.toString(),
                      onRetry: () => ref.invalidate(dietPlanNotifierProvider),
                    ),
                    data: (plan) {
                      if (plan == null) {
                        return Text(
                          context.tr.dietNoPlanYet,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: cTextSecondary),
                        );
                      }

                      return DietPlanSection(
                        plan: plan,
                        highlightDay: navigationTarget?.highlightDay,
                        highlightSlot: navigationTarget?.highlightSlot,
                        loggingSlotKey: _loggingSlotKey,
                        onLogMeal: _logMeal,
                        onHighlightHandled: () {
                          ref
                              .read(dietNavigationNotifierProvider.notifier)
                              .clear();
                        },
                      );
                    },
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
