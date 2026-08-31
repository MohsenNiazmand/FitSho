import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_input.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/features/diet/presentation/widgets/ai_loading_dialog.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/app_text_field.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

const _stepCount = 4;

class DietOnboardingForm extends HookConsumerWidget {
  const DietOnboardingForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(dietOptionsNotifierProvider);
    final profileAsync = ref.watch(dietProfileNotifierProvider);
    final ageController = useTextEditingController();
    final heightController = useTextEditingController();
    final weightController = useTextEditingController();
    final jobController = useTextEditingController();
    final goalNotesController = useTextEditingController();
    final exerciseTypeController = useTextEditingController();
    final allergiesController = useTextEditingController();
    final exerciseDaysController = useTextEditingController();
    final gender = useState<String?>(null);
    final goal = useState<String?>(null);
    final activityLevel = useState<String?>(null);
    final doesExercise = useState(false);
    final dietaryPreferences = useState<Set<String>>({});
    final mealSlots = useState<Map<String, MealSlotConfig>>({
      'breakfast': const MealSlotConfig(enabled: true, time: '08:30'),
      'morning_snack': const MealSlotConfig(enabled: false, time: '10:30'),
      'lunch': const MealSlotConfig(enabled: true, time: '13:30'),
      'afternoon_snack': const MealSlotConfig(enabled: false, time: '16:30'),
      'dinner': const MealSlotConfig(enabled: true, time: '20:30'),
    });
    final isSaving = useState(false);
    final isMounted = useIsMounted();
    final pageController = usePageController();
    final currentStep = useState(0);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    Widget requiredLabel(String text) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: text),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    String? validateAge(String? value) {
      final val = int.tryParse(value ?? '');
      if (val == null) return context.tr.dietFormValidationError;
      if (val < 8 || val > 140) return context.tr.dietAgeValidation;
      return null;
    }

    String? validateHeight(String? value) {
      final val = int.tryParse(value ?? '');
      if (val == null) return context.tr.dietFormValidationError;
      if (val < 60 || val > 250) return context.tr.dietHeightValidation;
      return null;
    }

    String? validateWeight(String? value) {
      final val = double.tryParse(value ?? '');
      if (val == null) return context.tr.dietFormValidationError;
      if (val < 30 || val > 250) return context.tr.dietWeightValidation;
      return null;
    }

    String? validateExerciseDays(String? value) {
      if (!doesExercise.value) return null;
      final val = int.tryParse(value ?? '');
      if (val == null) return context.tr.dietFormValidationError;
      if (val < 1 || val > 7) return context.tr.dietExerciseDaysValidation;
      return null;
    }

    useEffect(
      () {
        profileAsync.whenData((profile) {
          if (profile == null) return;
          ageController.text = profile.age.toString();
          heightController.text = profile.heightCm.toString();
          weightController.text = profile.weightKg.toString();
          jobController.text = profile.job ?? '';
          goalNotesController.text = profile.goalNotes ?? '';
          exerciseTypeController.text = profile.exerciseType ?? '';
          allergiesController.text = profile.allergiesNotes ?? '';
          exerciseDaysController.text =
              profile.exerciseDaysPerWeek?.toString() ?? '';
          gender.value = profile.gender;
          goal.value = profile.goal;
          activityLevel.value = profile.activityLevel;
          doesExercise.value = profile.doesExercise;
          dietaryPreferences.value = profile.dietaryPreferences.toSet();

          // Fetch existing meal slots if available
          ref.read(mealSlotsNotifierProvider).whenData((slots) {
            if (slots.isNotEmpty) {
              mealSlots.value = Map<String, MealSlotConfig>.from(slots);
            }
          });
        });
        return null;
      },
      [profileAsync],
    );

    Future<void> submit(DietProfileOptions options) async {
      final age = int.tryParse(ageController.text.trim());
      final height = int.tryParse(heightController.text.trim());
      final weight = double.tryParse(weightController.text.trim());
      if (age == null ||
          height == null ||
          weight == null ||
          gender.value == null ||
          goal.value == null ||
          activityLevel.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr.dietFormValidationError)),
        );
        return;
      }

      isSaving.value = true;
      try {
        final profileResult =
            await ref.read(dietProfileNotifierProvider.notifier).save(
                  DietProfile(
                    age: age,
                    heightCm: height,
                    weightKg: weight,
                    gender: gender.value!,
                    goal: goal.value!,
                    activityLevel: activityLevel.value!,
                    doesExercise: doesExercise.value,
                    job: jobController.text.trim().isEmpty
                        ? null
                        : jobController.text.trim(),
                    goalNotes: goalNotesController.text.trim().isEmpty
                        ? null
                        : goalNotesController.text.trim(),
                    exerciseType: doesExercise.value &&
                            exerciseTypeController.text.trim().isNotEmpty
                        ? exerciseTypeController.text.trim()
                        : null,
                    exerciseDaysPerWeek: doesExercise.value
                        ? int.tryParse(exerciseDaysController.text.trim())
                        : null,
                    dietaryPreferences: dietaryPreferences.value.toList(),
                    allergiesNotes: allergiesController.text.trim().isEmpty
                        ? null
                        : allergiesController.text.trim(),
                  ),
                );

        if (profileResult == null) {
          // Profile saved successfully, now save meal slots
          await ref
              .read(mealSlotsNotifierProvider.notifier)
              .save(mealSlots.value);
          showSuccessToast(context.tr.profileUpdatedSuccess);
        }

        if (isMounted()) {
          isSaving.value = false;

          if (profileResult != null) {
            if (context.mounted) {
              showFailureToast(context, profileResult);
            }
            return;
          }
        }

        if (context.mounted) {
          await _maybePromptRegenerate(context, ref);
        }

        if (context.mounted) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            context.go(AppRoutes.home);
          }
        }
      } finally {
        if (isMounted()) {
          isSaving.value = false;
        }
      }
    }

    Future<void> pickTime(String slotKey) async {
      final current = mealSlots.value[slotKey]!;
      final parts = current.time.split(':');
      final initial = TimeOfDay(
        hour: int.tryParse(parts.first) ?? 8,
        minute: int.tryParse(parts.last) ?? 0,
      );
      final picked =
          await showTimePicker(context: context, initialTime: initial);
      if (picked == null) return;

      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      mealSlots.value = {
        ...mealSlots.value,
        slotKey: MealSlotConfig(
          enabled: current.enabled,
          time: formatted,
          notificationsEnabled: current.notificationsEnabled,
        ),
      };
    }

    void goToStep(int step) {
      currentStep.value = step;
      pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }

    void handleNext(DietProfileOptions options) {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      if (currentStep.value == _stepCount - 1) {
        submit(options);
        return;
      }
      goToStep(currentStep.value + 1);
    }

    return optionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(errorDisplayMessage(context, error))),
      data: (options) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.dietOnboardingTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Gap.v8(),
                  Text(
                    context.tr.dietOnboardingSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Gap.v16(),
                  _ProgressLine(
                    currentStep: currentStep.value,
                    stepCount: _stepCount,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => currentStep.value = index,
                  children: [
                    _StepScaffold(
                      children: [
                        AppTextField(
                          controller: ageController,
                          label: requiredLabel(context.tr.dietAgeLabel),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          validator: validateAge,
                        ),
                        Gap.v12(),
                        AppTextField(
                          controller: heightController,
                          label: requiredLabel(context.tr.dietHeightLabel),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          validator: validateHeight,
                        ),
                        Gap.v12(),
                        AppTextField(
                          controller: weightController,
                          label: requiredLabel(context.tr.dietWeightLabel),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,3}(\.\d{0,1})?'),
                            ),
                          ],
                          validator: validateWeight,
                        ),
                        Gap.v12(),
                        _DropdownField(
                          label: requiredLabel(context.tr.dietGenderLabel),
                          value: gender.value,
                          items: options.genders,
                          onChanged: (value) => gender.value = value,
                          validator: (v) => v == null
                              ? context.tr.dietFormValidationError
                              : null,
                        ),
                      ],
                    ),
                    _StepScaffold(
                      children: [
                        AppTextField(
                          controller: jobController,
                          labelText: context.tr.dietJobLabel,
                          inputFormatters: [createPersianTextFormatter()],
                        ),
                        Gap.v12(),
                        _DropdownField(
                          label: requiredLabel(context.tr.dietGoalLabel),
                          value: goal.value,
                          items: options.goals,
                          onChanged: (value) => goal.value = value,
                          validator: (v) => v == null
                              ? context.tr.dietFormValidationError
                              : null,
                        ),
                        Gap.v12(),
                        AppTextField(
                          controller: goalNotesController,
                          labelText: context.tr.dietGoalNotesLabel,
                          maxLines: 2,
                          inputFormatters: [createPersianTextFormatter()],
                        ),
                        Gap.v12(),
                        _DropdownField(
                          label: requiredLabel(context.tr.dietActivityLevelLabel),
                          value: activityLevel.value,
                          items: options.activityLevels,
                          onChanged: (value) => activityLevel.value = value,
                          validator: (v) => v == null
                              ? context.tr.dietFormValidationError
                              : null,
                        ),
                      ],
                    ),
                    _StepScaffold(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(context.tr.dietDoesExerciseLabel),
                          value: doesExercise.value,
                          onChanged: (value) => doesExercise.value = value,
                        ),
                        if (doesExercise.value) ...[
                          Gap.v8(),
                          AppTextField(
                            controller: exerciseTypeController,
                            label: requiredLabel(context.tr.dietExerciseTypeLabel),
                            inputFormatters: [createPersianTextFormatter()],
                            validator: (v) => v?.trim().isEmpty == true
                                ? context.tr.dietFormValidationError
                                : null,
                          ),
                          Gap.v12(),
                          AppTextField(
                            controller: exerciseDaysController,
                            label: requiredLabel(context.tr.dietExerciseDaysLabel),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            validator: validateExerciseDays,
                          ),
                        ],
                        Gap.v16(),
                        Text(
                          context.tr.dietDietaryPreferencesLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Gap.v12(),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final option in options.dietaryPreferences)
                              if (option.isAvailable)
                                FilterChip(
                                  label: Text(option.label),
                                  selected: dietaryPreferences.value
                                      .contains(option.id),
                                  onSelected: (selected) {
                                    final updated = Set<String>.from(
                                      dietaryPreferences.value,
                                    );
                                    if (selected) {
                                      updated.add(option.id);
                                    } else {
                                      updated.remove(option.id);
                                    }
                                    dietaryPreferences.value = updated;
                                  },
                                ),
                          ],
                        ),
                        Gap.v12(),
                        AppTextField(
                          controller: allergiesController,
                          labelText: context.tr.dietAllergiesLabel,
                          maxLines: 2,
                          inputFormatters: [createPersianTextFormatter()],
                        ),
                      ],
                    ),
                    _StepScaffold(
                      children: [
                        Text(
                          context.tr.dietDailyMealSlots,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Gap.v12(),
                        ...mealSlots.value.entries.map((entry) {
                          final slotKey = entry.key;
                          final config = entry.value;
                          final icon = dietSlotIcon(slotKey);

                          return _MealSlotInput(
                            title: dietMealSlotLabel(context, slotKey),
                            icon: icon,
                            config: config,
                            onToggle: (enabled) {
                              mealSlots.value = {
                                ...mealSlots.value,
                                slotKey: MealSlotConfig(
                                  enabled: enabled,
                                  time: config.time,
                                  notificationsEnabled:
                                      config.notificationsEnabled,
                                ),
                              };
                            },
                            onPickTime: () => pickTime(slotKey),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppPrimaryButton(
                    label: currentStep.value == _stepCount - 1
                        ? context.tr.dietSaveProfile
                        : context.tr.next,
                    isLoading: isSaving.value,
                    // RTL layout: forward points left.
                    icon: currentStep.value == _stepCount - 1
                        ? null
                        : Icons.arrow_back_rounded,
                    onPressed: isSaving.value
                        ? null
                        : () => handleNext(options),
                  ),
                  if (currentStep.value > 0) ...[
                    Gap.v8(),
                    OutlinedButton.icon(
                      onPressed: isSaving.value
                          ? null
                          : () => goToStep(currentStep.value - 1),
                      // RTL layout: back points right.
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(context.tr.back),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _maybePromptRegenerate(BuildContext context, WidgetRef ref) async {
  final profile = ref.read(dietProfileNotifierProvider).valueOrNull;
  if (profile == null || !profile.shouldRegeneratePlan) return;

  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => const _RegeneratePlanSheet(),
  );

  if (confirmed != true || !context.mounted) return;
  await _generatePlanAfterProfileSave(context, ref);
}

Future<void> _generatePlanAfterProfileSave(
  BuildContext context,
  WidgetRef ref,
) async {
  AiLoadingDialog.show(context);
  final failure = await ref.read(dietPlanNotifierProvider.notifier).generate();
  if (!context.mounted) return;
  AiLoadingDialog.hide(context);

  if (failure != null) {
    if (failure is AiProviderFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr.aiProviderFailure),
          action: SnackBarAction(
            label: context.tr.retry,
            onPressed: () => _generatePlanAfterProfileSave(context, ref),
          ),
        ),
      );
    } else {
      showFailureToast(context, failure);
    }
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(context.tr.dietPlanRegenerated)),
  );
}

class _RegeneratePlanSheet extends StatelessWidget {
  const _RegeneratePlanSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr.dietRegeneratePromptTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          Gap.v8(),
          Text(
            context.tr.dietRegeneratePromptBody,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cTextSecondary),
          ),
          Gap.v24(),
          AppPrimaryButton(
            label: context.tr.dietRegenerateConfirm,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          Gap.v8(),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.tr.dietRegenerateDismiss),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.currentStep,
    required this.stepCount,
  });

  final int currentStep;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    final fraction = (currentStep + 1) / stepCount;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        height: 6,
        color: cBorder.withValues(alpha: 0.4),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fraction),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: value,
            child: child,
          ),
          child: const DecoratedBox(
            decoration: BoxDecoration(color: cPrimary),
          ),
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.validator,
  });

  final Widget label;
  final String? labelText;
  final String? value;
  final List<DietOptionItem> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        label: label,
        labelText: labelText,
      ),
      validator: validator,
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item.id,
              child: Text(item.label),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _MealSlotInput extends StatelessWidget {
  const _MealSlotInput({
    required this.title,
    required this.icon,
    required this.config,
    required this.onToggle,
    required this.onPickTime,
  });

  final String title;
  final IconData icon;
  final MealSlotConfig config;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          Gap.h12(),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: config.enabled ? FontWeight.bold : null,
              ),
            ),
          ),
          if (config.enabled)
            InkWell(
              onTap: onPickTime,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      config.time,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Gap.h8(),
          Switch(
            value: config.enabled,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
