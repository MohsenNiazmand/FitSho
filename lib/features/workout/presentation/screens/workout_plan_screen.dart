import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/core/constants/app_assets.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/widgets/ai_loading_dialog.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/providers/workout_providers.dart';
import 'package:fitsho/features/workout/presentation/widgets/empty_exercise_pool_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/medical_referral_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/new_plan_choice_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_session_section.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_plan_header.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_profile_form.dart';
import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/empty_state_view.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WorkoutPlanScreen extends HookConsumerWidget {
  const WorkoutPlanScreen({super.key});

  Future<void> _generatePlan(BuildContext context, WidgetRef ref) async {
    unawaited(
      AiLoadingDialog.show(
        context,
        title: context.tr.workoutGeneratingPlanTitle,
        message: context.tr.workoutGeneratingPlanMessage,
      ),
    );

    final failure = await ref
        .read(workoutPlanNotifierProvider.notifier)
        .generate();

    if (context.mounted) {
      AiLoadingDialog.hide(context);

      if (failure != null) {
        if (failure is MedicalReferralFailure) {
          await MedicalReferralDialog.show(context, failure.message);
        } else if (failure is EmptyExercisePoolFailure) {
          await EmptyExercisePoolDialog.show(context, failure.message);
        } else if (failure is RateLimitFailure) {
          showMessageToast(failure.message);
        } else {
          showFailureToast(context, failure);
        }
      }
    }
  }

  Future<void> _swapExercise(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
    WorkoutExerciseItem item,
    ValueNotifier<String?> swappingItemId,
  ) async {
    if (swappingItemId.value != null) return;
    swappingItemId.value = item.itemId;

    final result = await ref
        .read(workoutPlanNotifierProvider.notifier)
        .swapExercise(sessionId: sessionId, itemId: item.itemId);

    if (context.mounted) {
      swappingItemId.value = null;
      result.fold(
        (failure) => showFailureToast(context, failure),
        (remainingSwaps) => showMessageToast(
          context.tr.workoutExerciseSwappedSuccess(remainingSwaps),
        ),
      );
    }
  }

  Future<void> _handleNewPlan(BuildContext context, WidgetRef ref) async {
    final choice = await NewPlanChoiceDialog.show(context);

    if (!context.mounted || choice == null) return;
    if (choice == NewPlanChoiceAction.generateCurrent) {
      await _generatePlan(context, ref);
    } else {
      await context.push(AppRoutes.workoutProfileEdit, extra: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietProfileAsync = ref.watch(dietProfileNotifierProvider);
    final workoutProfileAsync = ref.watch(workoutProfileNotifierProvider);
    final workoutPlanAsync = ref.watch(workoutPlanNotifierProvider);
    final isGenerating = workoutPlanAsync.isLoading;
    final swappingItemId = useState<String?>(null);

    return Scaffold(
      backgroundColor: cBackground,
      appBar: AppBar(
        title: Text(context.tr.workoutTabTitle),
        actions: [
          if (workoutProfileAsync.valueOrNull != null) ...[
            IconButton(
              icon: const Icon(Icons.history_rounded),
              tooltip: context.tr.workoutHistoryTitle,
              onPressed: () => context.push(AppRoutes.workoutHistory),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: context.tr.workoutEditProfile,
              onPressed: () => context.push(AppRoutes.workoutProfileEdit),
            ),
          ],
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: dietProfileAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (error, _) => ErrorRetryView(
            message: errorDisplayMessage(context, error),
            onRetry: () => ref.invalidate(dietProfileNotifierProvider),
          ),
          data: (dietProfile) {
            // Scenario §2.1: No DietProfile -> message + diet onboarding
            if (dietProfile == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EmptyStateView(
                        imagePath: AppAssets.emptyState,
                        message: context.tr.workoutNeedDietFirst,
                      ),
                      Gap.v24(),
                      AppPrimaryButton(
                        label: context.tr.workoutGoToDietOnboarding,
                        onPressed: () => context.push(AppRoutes.dietOnboarding),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Check WorkoutProfile
            return workoutProfileAsync.when(
              loading: () => const AppLoadingIndicator(),
              error: (error, _) => ErrorRetryView(
                message: errorDisplayMessage(context, error),
                onRetry: () => ref.invalidate(workoutProfileNotifierProvider),
              ),
              data: (workoutProfile) {
                // Scenario §2.2: No WorkoutProfile (GET 404) -> wizard
                if (workoutProfile == null) {
                  return const WorkoutProfileForm();
                }

                // Scenario §2.3 & §2.4: Profile exists -> plan / empty
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(workoutPlanNotifierProvider.notifier)
                        .refreshPlan();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      workoutPlanAsync.when(
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
                                    ref.invalidate(workoutPlanNotifierProvider),
                              ),
                            ),
                          ),
                        ),
                        data: (plan) {
                          // Scenario §2.3: Profile but no plan -> empty state
                          if (plan == null) {
                            return SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    EmptyStateView(
                                      imagePath: AppAssets.emptyState,
                                      message: context.tr.workoutNoPlanYet,
                                      subtitle:
                                          context.tr.workoutNoPlanYetSubtitle,
                                    ),
                                    Gap.v24(),
                                    AppPrimaryButton(
                                      label: context.tr.workoutGeneratePlan,
                                      isLoading: isGenerating,
                                      onPressed: isGenerating
                                          ? null
                                          : () => _generatePlan(context, ref),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Scenario §2.4: Active plan -> header + day section
                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  WorkoutPlanHeader(
                                    plan: plan,
                                    isGenerating: isGenerating,
                                    onGenerateNewPlan: () =>
                                        _handleNewPlan(context, ref),
                                  ),
                                  WorkoutSessionSection(
                                    plan: plan,
                                    swappingItemId: swappingItemId.value,
                                    onSwapExercise: (sessionId, item) =>
                                        _swapExercise(
                                          context,
                                          ref,
                                          sessionId,
                                          item,
                                          swappingItemId,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
