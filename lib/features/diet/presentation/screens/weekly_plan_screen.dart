import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/core/constants/app_assets.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_navigation_provider.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/widgets/ai_loading_dialog.dart';
import 'package:fitsho/features/diet/presentation/widgets/diet_plan_section.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/empty_state_view.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WeeklyPlanScreen extends ConsumerStatefulWidget {
  const WeeklyPlanScreen({super.key});

  @override
  ConsumerState<WeeklyPlanScreen> createState() => _WeeklyPlanScreenState();
}

class _WeeklyPlanScreenState extends ConsumerState<WeeklyPlanScreen> {
  Future<void> _logMeal(String day, String slot) async {
    final failure = await ref
        .read(logMealNotifierProvider.notifier)
        .logMeal(slot: slot, day: day);
    if (mounted && failure != null) {
      showFailureToast(context, failure);
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
      appBar: AppBar(
        title: Text(context.tr.navWeeklyPlan),
      ),
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
              return Center(
                child: EmptyStateView(
                  imagePath: AppAssets.emptyState,
                  message: context.tr.dietNoPlanYet,
                  subtitle: context.tr.dietNoPlanYetSubtitle,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(dietPlanNotifierProvider);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  planAsync.when(
                    loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: ErrorRetryView(
                            message: errorDisplayMessage(context, error),
                            onRetry: () =>
                                ref.invalidate(dietPlanNotifierProvider),
                          ),
                        ),
                      ),
                    ),
                    data: (plan) {
                      if (plan == null) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EmptyStateView(
                                  imagePath: AppAssets.emptyState,
                                  message: context.tr.dietNoPlanYet,
                                  subtitle: context.tr.dietNoPlanYetSubtitle,
                                ),
                                Gap.v16(),
                                AppPrimaryButton(
                                  label: context.tr.dietGeneratePlan,
                                  isLoading: isGenerating,
                                  onPressed: isGenerating
                                      ? null
                                      : () async {
                                          AiLoadingDialog.show(context);
                                          final failure = await ref
                                              .read(dietPlanNotifierProvider
                                                  .notifier)
                                              .generate();
                                          if (context.mounted) {
                                            AiLoadingDialog.hide(context);
                                            if (failure != null) {
                                              showFailureToast(
                                                  context, failure);
                                            }
                                          }
                                        },
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        sliver: SliverToBoxAdapter(
                          child: DietPlanSection(
                            plan: plan,
                            highlightDay: navigationTarget?.highlightDay,
                            highlightSlot: navigationTarget?.highlightSlot,
                            onLogMeal: _logMeal,
                            onHighlightHandled: () {
                              ref
                                  .read(dietNavigationNotifierProvider.notifier)
                                  .clear();
                            },
                          ),
                        ),
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
