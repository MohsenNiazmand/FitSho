import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/presentation/widgets/ai_loading_dialog.dart';
import 'package:fitsho/features/workout/presentation/providers/workout_providers.dart';
import 'package:fitsho/features/workout/presentation/widgets/empty_exercise_pool_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/medical_referral_dialog.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_profile_form.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';

class WorkoutProfileEditScreen extends ConsumerWidget {
  const WorkoutProfileEditScreen({
    this.skipRegeneratePrompt = false,
    super.key,
  });

  final bool skipRegeneratePrompt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> generateAfterSave() async {
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
      if (!context.mounted) return;
      AiLoadingDialog.hide(context);
      if (failure is MedicalReferralFailure) {
        await MedicalReferralDialog.show(context, failure.message);
      } else if (failure is EmptyExercisePoolFailure) {
        await EmptyExercisePoolDialog.show(context, failure.message);
      } else if (failure is RateLimitFailure) {
        showMessageToast(failure.message);
      } else if (failure != null) {
        showFailureToast(context, failure);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.workoutOnboardingTitle)),
      body: SafeArea(
        child: WorkoutProfileForm(
          isEditing: true,
          skipRegeneratePrompt: skipRegeneratePrompt,
          onProfileSaved: skipRegeneratePrompt ? generateAfterSave : null,
        ),
      ),
    );
  }
}
