import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/metadata/domain/entities/metadata_catalog.dart';
import 'package:fitsho/core/metadata/presentation/providers/metadata_provider.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/core/utils/persian_input.dart';
import 'package:fitsho/features/diet/presentation/widgets/ai_loading_dialog.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/providers/workout_providers.dart';
import 'package:fitsho/features/workout/presentation/utils/workout_profile_validation.dart';
import 'package:fitsho/features/workout/presentation/widgets/medical_referral_dialog.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/app_text_field.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

const _stepCount = 5;

class WorkoutProfileForm extends HookConsumerWidget {
  const WorkoutProfileForm({
    super.key,
    this.isEditing = false,
    this.skipRegeneratePrompt = false,
    this.onProfileSaved,
  });

  final bool isEditing;
  final bool skipRegeneratePrompt;
  final Future<void> Function()? onProfileSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(workoutOptionsNotifierProvider);
    final profileAsync = ref.watch(workoutProfileNotifierProvider);
    final metadataCatalog = ref.watch(metadataCatalogProvider);

    final selectedDisciplines = useState<List<String>>([]);
    final selectedStyles = useState<Map<String, String>>({});
    final primaryGoal = useState<String?>(null);
    final secondaryGoal = useState<String?>(null);
    final selectedLevel = useState<String>('beginner');
    final daysPerWeek = useState<int>(3);
    final sessionMinutes = useState<int>(60);
    final customDurationController = useTextEditingController(text: '60');
    final customDurationError = useState<String?>(null);
    final location = useState<String>('gym');
    final selectedEquipment = useState<List<String>>([]);
    final hasNoInjuries = useState<bool>(true);
    final selectedInjuryAreas = useState<List<String>>([]);
    final selectedMedicalConditions = useState<List<String>>([]);
    final painLevel = useState<int>(0);
    final injuryNotesController = useTextEditingController();

    final pageController = usePageController();
    final currentStep = useState(0);
    final isSaving = useState(false);

    useEffect(() {
      final profile = profileAsync.value;
      if (profile != null) {
        selectedDisciplines.value = List.from(profile.disciplines);
        selectedStyles.value = Map.from(profile.styles);
        primaryGoal.value = profile.primaryGoal;
        secondaryGoal.value = profile.secondaryGoal;
        selectedLevel.value = profile.level;
        daysPerWeek.value = profile.daysPerWeek;
        final options = optionsAsync.valueOrNull;
        if (options != null && profile.disciplines.length == 1) {
          final styleId = profile.styles[profile.disciplines.single];
          for (final style in options.styles) {
            if (style.id == styleId &&
                style.disciplineId == profile.disciplines.single) {
              daysPerWeek.value = profile.daysPerWeek.clamp(
                style.minDays,
                style.maxDays,
              );
              break;
            }
          }
        }
        sessionMinutes.value = profile.sessionMinutes;
        customDurationController.text = profile.sessionMinutes.toString();
        location.value = profile.location;
        selectedEquipment.value = List.from(profile.equipment);
        selectedInjuryAreas.value = List.from(profile.injuryAreas);
        selectedMedicalConditions.value = List.from(profile.medicalConditions);
        hasNoInjuries.value =
            profile.injuryAreas.isEmpty && profile.medicalConditions.isEmpty;
        painLevel.value = profile.painLevel;
        injuryNotesController.text = profile.injuryNotes ?? '';
      }
      return null;
    }, [profileAsync.value, optionsAsync.value]);

    return optionsAsync.when(
      data: (options) {
        bool canProceed() {
          return isWorkoutProfileStepValid(
            step: currentStep.value,
            options: options,
            selectedDisciplines: selectedDisciplines.value,
            selectedStyles: selectedStyles.value,
            selectedLevel: selectedLevel.value,
            primaryGoal: primaryGoal.value,
            secondaryGoal: secondaryGoal.value,
            daysPerWeek: daysPerWeek.value,
            sessionMinutes: sessionMinutes.value,
            injuryAreas: selectedInjuryAreas.value,
            medicalConditions: selectedMedicalConditions.value,
          );
        }

        void nextStep() {
          if (!canProceed()) {
            showMessageToast(context.tr.dietFormValidationError);
            return;
          }
          if (currentStep.value < _stepCount - 1) {
            currentStep.value++;
            pageController.animateToPage(
              currentStep.value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }

        void prevStep() {
          if (currentStep.value > 0) {
            currentStep.value--;
            pageController.animateToPage(
              currentStep.value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }

        Future<void> saveProfile() async {
          final isFormValid = List.generate(
            _stepCount,
            (step) => isWorkoutProfileStepValid(
              step: step,
              options: options,
              selectedDisciplines: selectedDisciplines.value,
              selectedStyles: selectedStyles.value,
              selectedLevel: selectedLevel.value,
              primaryGoal: primaryGoal.value,
              secondaryGoal: secondaryGoal.value,
              daysPerWeek: daysPerWeek.value,
              sessionMinutes: sessionMinutes.value,
              injuryAreas: selectedInjuryAreas.value,
              medicalConditions: selectedMedicalConditions.value,
            ),
          ).every((valid) => valid);
          if (!isFormValid) {
            showMessageToast(context.tr.dietFormValidationError);
            return;
          }

          isSaving.value = true;
          final (failure, saved) = await ref
              .read(workoutProfileNotifierProvider.notifier)
              .save(
                disciplines: selectedDisciplines.value,
                styles: selectedStyles.value,
                primaryGoal: primaryGoal.value!,
                secondaryGoal: secondaryGoal.value,
                level: selectedLevel.value,
                daysPerWeek: daysPerWeek.value,
                sessionMinutes: sessionMinutes.value,
                location: location.value,
                equipment: location.value == 'gym'
                    ? []
                    : selectedEquipment.value,
                injuryAreas: hasNoInjuries.value
                    ? []
                    : selectedInjuryAreas.value,
                medicalConditions: hasNoInjuries.value
                    ? []
                    : selectedMedicalConditions.value,
                injuryNotes: injuryNotesController.text.trim().isEmpty
                    ? null
                    : injuryNotesController.text.trim(),
                painLevel: hasNoInjuries.value ? 0 : painLevel.value,
              );
          isSaving.value = false;

          if (!context.mounted) return;

          if (failure != null) {
            showFailureToast(context, failure);
          } else {
            showSuccessToast(context.tr.workoutProfileSaved);
            await onProfileSaved?.call();
            if (!skipRegeneratePrompt && saved?.shouldRegeneratePlan == true) {
              await _maybePromptRegenerate(context, ref);
            }
            if (context.canPop()) {
              context.pop(true);
            }
          }
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: List.generate(_stepCount, (index) {
                  const activeColor = Color(0xFF6366F1);
                  final isPassed = index <= currentStep.value;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isPassed ? activeColor : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDisciplinesStep(
                    context,
                    options,
                    selectedDisciplines,
                    selectedStyles,
                  ),
                  _buildLevelStylesStep(
                    context,
                    options,
                    selectedDisciplines,
                    selectedLevel,
                    selectedStyles,
                    metadataCatalog,
                  ),
                  _buildGoalStep(
                    context,
                    options,
                    selectedDisciplines,
                    primaryGoal,
                    secondaryGoal,
                    metadataCatalog,
                  ),
                  _buildConditionsStep(
                    context,
                    options,
                    selectedDisciplines,
                    selectedStyles,
                    daysPerWeek,
                    sessionMinutes,
                    customDurationController,
                    customDurationError,
                    location,
                    selectedEquipment,
                    metadataCatalog,
                  ),
                  _buildInjuriesStep(
                    context,
                    options,
                    hasNoInjuries,
                    selectedInjuryAreas,
                    selectedMedicalConditions,
                    painLevel,
                    injuryNotesController,
                    metadataCatalog,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (currentStep.value > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: prevStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.button,
                          ),
                        ),
                        child: Text(context.tr.back),
                      ),
                    ),
                  if (currentStep.value > 0) Gap.h12(),
                  Expanded(
                    flex: 2,
                    child: AppPrimaryButton(
                      label: currentStep.value == _stepCount - 1
                          ? context.tr.workoutSaveProfile
                          : context.tr.next,
                      isLoading: isSaving.value,
                      onPressed: currentStep.value == _stepCount - 1
                          ? saveProfile
                          : nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => ErrorRetryView(
        message: err.toString(),
        onRetry: () => ref.invalidate(workoutOptionsNotifierProvider),
      ),
    );
  }

  Widget _buildDisciplinesStep(
    BuildContext context,
    WorkoutOptions options,
    ValueNotifier<List<String>> selectedDisciplines,
    ValueNotifier<Map<String, String>> selectedStyles,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepDisciplines,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v8(),
        Text(
          context.tr.workoutSelectDisciplinesHint,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        Gap.v16(),
        ...options.disciplines.map((d) {
          final isSelected = selectedDisciplines.value.contains(d.id);
          return GestureDetector(
            onTap: () {
              final list = List<String>.from(selectedDisciplines.value);
              if (isSelected) {
                final selection = removeWorkoutDisciplineSelection(
                  disciplines: list,
                  styles: selectedStyles.value,
                  disciplineId: d.id,
                );
                selectedDisciplines.value = selection.disciplines;
                selectedStyles.value = selection.styles;
              } else {
                if (list.length >= options.maxDisciplines) {
                  BotToast.showText(
                    text: context.tr.workoutMaxDisciplinesWarning,
                  );
                  return;
                }
                list.add(d.id);
                selectedDisciplines.value = list;
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: AppRadius.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        d.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? const Color(0xFF4338CA)
                              : Colors.black87,
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF6366F1),
                        ),
                    ],
                  ),
                  Gap.v6(),
                  Text(
                    d.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLevelStylesStep(
    BuildContext context,
    WorkoutOptions options,
    ValueNotifier<List<String>> selectedDisciplines,
    ValueNotifier<String> selectedLevel,
    ValueNotifier<Map<String, String>> selectedStyles,
    MetadataCatalog metadataCatalog,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepStyleLevel,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v12(),
        Text(
          context.tr.workoutFitnessLevelLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Gap.v8(),
        // F11: Accessible equal-width selectable tiles with short title on line 1 and description on line 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.levels.map((lvl) {
            final meta = metadataCatalog.findByKey('difficulty_level', lvl.id);
            final levelLabel = meta?.labelFa ?? lvl.label;
            final isSelected = selectedLevel.value == lvl.id;
            return Expanded(
              child: GestureDetector(
                onTap: () => selectedLevel.value = lvl.id,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.grey.shade100,
                    borderRadius: AppRadius.button,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4338CA)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        levelLabel,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (lvl.description != null &&
                          lvl.description!.isNotEmpty) ...[
                        Gap.v4(),
                        Text(
                          lvl.description!,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white70
                                : Colors.grey.shade600,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Gap.v24(),
        ...selectedDisciplines.value.map((dId) {
          final discipline = options.disciplines.firstWhere((d) => d.id == dId);
          final availableStyles = options.styles
              .where(
                (s) =>
                    s.disciplineId == dId &&
                    s.levels.contains(selectedLevel.value),
              )
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.workoutDisciplineStyleLabel(discipline.label),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap.v8(),
              ...availableStyles.map((style) {
                final isSelectedStyle = selectedStyles.value[dId] == style.id;
                return RadioListTile<String>(
                  title: Text(
                    style.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(style.description),
                  value: style.id,
                  groupValue: selectedStyles.value[dId],
                  onChanged: (_) {
                    final map = Map<String, String>.from(selectedStyles.value);
                    if (isSelectedStyle) {
                      // F10: Tapping currently selected style clears it
                      map.remove(dId);
                    } else {
                      map[dId] = style.id;
                    }
                    selectedStyles.value = map;
                  },
                );
              }),
              Gap.v16(),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildGoalStep(
    BuildContext context,
    WorkoutOptions options,
    ValueNotifier<List<String>> selectedDisciplines,
    ValueNotifier<String?> primaryGoal,
    ValueNotifier<String?> secondaryGoal,
    MetadataCatalog metadataCatalog,
  ) {
    final compatibleGoals = options.goals.where((g) {
      return g.compatibleDisciplines.any(
        (dId) => selectedDisciplines.value.contains(dId),
      );
    }).toList();
    final selectedGoalIds = {primaryGoal.value, secondaryGoal.value}
      ..remove(null);
    final visibleGoals = [
      ...compatibleGoals,
      ...options.goals.where(
        (goal) =>
            selectedGoalIds.contains(goal.id) &&
            !compatibleGoals.any((candidate) => candidate.id == goal.id),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepGoal,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v8(),
        Text(
          context.tr.workoutSelectGoalHint,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        Gap.v16(),
        ...visibleGoals.map((goal) {
          final isPrimary = primaryGoal.value == goal.id;
          final isSecondary = secondaryGoal.value == goal.id;
          final isSelected = isPrimary || isSecondary;

          return GestureDetector(
            onTap: () {
              if (isPrimary) {
                primaryGoal.value = null;
              } else if (isSecondary) {
                if (primaryGoal.value == null) {
                  primaryGoal.value = secondaryGoal.value;
                  secondaryGoal.value = null;
                } else {
                  secondaryGoal.value = null;
                }
              } else {
                if (primaryGoal.value == null) {
                  primaryGoal.value = goal.id;
                } else if (secondaryGoal.value == null) {
                  secondaryGoal.value = goal.id;
                } else {
                  showMessageToast(context.tr.dietFormValidationError);
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: AppRadius.card,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      metadataCatalog.findByKey('goal', goal.id)?.labelFa ??
                          goal.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? const Color(0xFF4338CA)
                            : Colors.black87,
                      ),
                    ),
                  ),
                  if (isPrimary)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.tr.workoutGoalPrimaryTag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (isSecondary)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        context.tr.workoutGoalSecondaryTag,
                        style: const TextStyle(
                          color: cPrimaryDark,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildConditionsStep(
    BuildContext context,
    WorkoutOptions options,
    ValueNotifier<List<String>> selectedDisciplines,
    ValueNotifier<Map<String, String>> selectedStyles,
    ValueNotifier<int> daysPerWeek,
    ValueNotifier<int> sessionMinutes,
    TextEditingController customDurationController,
    ValueNotifier<String?> customDurationError,
    ValueNotifier<String> location,
    ValueNotifier<List<String>> selectedEquipment,
    MetadataCatalog metadataCatalog,
  ) {
    int minDays = options.minDaysPerWeek;
    int maxDays = options.maxDaysPerWeek;
    if (selectedDisciplines.value.length == 1) {
      final dId = selectedDisciplines.value.first;
      final sId = selectedStyles.value[dId];
      if (sId != null) {
        final style = options.styles.firstWhere((s) => s.id == sId);
        minDays = style.minDays;
        maxDays = style.maxDays;
      }
    }

    void updateSessionMinutes(int val) {
      if (val >= options.minSessionMinutes &&
          val <= options.maxSessionMinutes) {
        sessionMinutes.value = val;
        customDurationError.value = null;
      } else {
        sessionMinutes.value = -1;
        customDurationError.value = context.tr.workoutCustomDurationInvalid(
          options.minSessionMinutes,
          options.maxSessionMinutes,
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepConditions,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v16(),
        Text(
          context.tr.workoutDaysPerWeek,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Gap.v8(),
        Row(
          // alignment: WrapAlignment.center,
          // spacing: 8,
          // runSpacing: 8,
          children: List.generate(maxDays - minDays + 1, (i) {
            final day = minDays + i;
            final isSelected = daysPerWeek.value == day;
            return GestureDetector(
              onTap: () => daysPerWeek.value = day,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.grey.shade100,
                  borderRadius: AppRadius.button,
                ),
                child: Text(
                  context.tr.workoutDaysCount(day),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
        Gap.custom(height: 20),
        Text(
          context.tr.workoutSessionMinutes,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Gap.v8(),
        // Suggested session-minute chips
        Wrap(
          spacing: 8,
          children: options.sessionMinutes.map((min) {
            final isSelected = sessionMinutes.value == min;
            return ChoiceChip(
              label: Text(context.tr.workoutMinutesCount(min)),
              selected: isSelected,
              onSelected: (_) {
                sessionMinutes.value = min;
                customDurationController.text = min.toString();
                customDurationError.value = null;
              },
            );
          }).toList(),
        ),
        Gap.v12(),
        // F11: Custom integer duration input field accepting Persian and Latin digits
        AppTextField(
          controller: customDurationController,
          labelText: context.tr.workoutCustomDurationLabel,
          errorText: customDurationError.value,
          keyboardType: TextInputType.number,
          inputFormatters: [createPersianDigitFormatter()],
          onChanged: (text) {
            final normalized = PersianDigits.toEnglish(text).trim();
            final parsed = RegExp(r'^[0-9]+$').hasMatch(normalized)
                ? int.tryParse(normalized)
                : null;
            if (parsed != null) {
              updateSessionMinutes(parsed);
            } else if (normalized.isEmpty) {
              sessionMinutes.value = -1;
              customDurationError.value = null;
            } else {
              sessionMinutes.value = -1;
              customDurationError.value = context.tr
                  .workoutCustomDurationInvalid(
                    options.minSessionMinutes,
                    options.maxSessionMinutes,
                  );
            }
          },
        ),
        Gap.custom(height: 20),
        Text(
          context.tr.workoutLocation,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Gap.v8(),
        Row(
          children: options.locations.map((loc) {
            final isSelected = location.value == loc.id;
            return Expanded(
              child: GestureDetector(
                onTap: () => location.value = loc.id,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.grey.shade100,
                    borderRadius: AppRadius.button,
                  ),
                  child: Text(
                    loc.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (location.value == 'home') ...[
          Gap.custom(height: 20),
          Text(
            context.tr.workoutEquipment,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Gap.v8(),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: options.equipment.map((eq) {
              final meta = metadataCatalog.findByKey('equipment', eq.id);
              final eqLabel = meta?.labelFa ?? eq.label;
              final isSelected = selectedEquipment.value.contains(eq.id);
              return FilterChip(
                label: Text(eqLabel),
                selected: isSelected,
                onSelected: (selected) {
                  final list = List<String>.from(selectedEquipment.value);
                  if (selected) {
                    list.add(eq.id);
                  } else {
                    list.remove(eq.id);
                  }
                  selectedEquipment.value = list;
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildInjuriesStep(
    BuildContext context,
    WorkoutOptions options,
    ValueNotifier<bool> hasNoInjuries,
    ValueNotifier<List<String>> selectedInjuryAreas,
    ValueNotifier<List<String>> selectedMedicalConditions,
    ValueNotifier<int> painLevel,
    TextEditingController injuryNotesController,
    MetadataCatalog metadataCatalog,
  ) {
    final medicalOptions = options.medicalConditions.isNotEmpty
        ? options.medicalConditions
        : options.injuries.where((i) => i.requiresReferral).toList();
    final hasReferralCondition = selectedMedicalConditions.value.any(
      (condId) => medicalOptions.any(
        (condition) => condition.id == condId && condition.requiresReferral,
      ),
    );

    final showWarning =
        !hasNoInjuries.value && (painLevel.value >= 7 || hasReferralCondition);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepInjuries,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v16(),
        SwitchListTile(
          title: Text(
            context.tr.workoutNoInjuries,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          value: hasNoInjuries.value,
          onChanged: (val) {
            hasNoInjuries.value = val;
            if (val) {
              selectedInjuryAreas.value = [];
              selectedMedicalConditions.value = [];
              painLevel.value = 0;
              injuryNotesController.clear();
            }
          },
        ),
        if (!hasNoInjuries.value) ...[
          Gap.v16(),
          // F10: Injury areas (max 2)
          Text(
            context.tr.workoutInjuryAreasLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Gap.v8(),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                (options.injuryAreas.isNotEmpty
                        ? options.injuryAreas
                        : options.injuries.where((i) => !i.requiresReferral))
                    .map((inj) {
                      final isSelected = selectedInjuryAreas.value.contains(
                        inj.id,
                      );
                      final meta = metadataCatalog.findByKey('injury_type', inj.id);
                      final injLabel = meta?.labelFa ?? inj.label;
                      return FilterChip(
                        label: Text(injLabel),
                        selected: isSelected,
                        onSelected: (selected) {
                          final list = List<String>.from(
                            selectedInjuryAreas.value,
                          );
                          if (selected) {
                            if (list.length >= 2) {
                              BotToast.showText(
                                text: context.tr.workoutMaxInjuryAreasWarning,
                              );
                              return;
                            }
                            list.add(inj.id);
                          } else {
                            list.remove(inj.id);
                          }
                          selectedInjuryAreas.value = list;
                          hasNoInjuries.value = false;
                        },
                      );
                    })
                    .toList(),
          ),
          Gap.v16(),
          // F10: Medical conditions (unlimited)
          Text(
            context.tr.workoutMedicalConditionsLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Gap.v8(),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                (options.medicalConditions.isNotEmpty
                        ? options.medicalConditions
                        : options.injuries.where((i) => i.requiresReferral))
                    .map((inj) {
                      final isSelected = selectedMedicalConditions.value
                          .contains(inj.id);
                      return FilterChip(
                        label: Text(inj.label),
                        selected: isSelected,
                        onSelected: (selected) {
                          final list = List<String>.from(
                            selectedMedicalConditions.value,
                          );
                          if (selected) {
                            list.add(inj.id);
                          } else {
                            list.remove(inj.id);
                          }
                          selectedMedicalConditions.value = list;
                          hasNoInjuries.value = false;
                        },
                      );
                    })
                    .toList(),
          ),
          Gap.custom(height: 20),
          Text(
            '${context.tr.workoutPainLevel} ${painLevel.value}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: painLevel.value.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            label: painLevel.value.toString(),
            onChanged: (val) => painLevel.value = val.toInt(),
          ),
          Gap.v16(),
          AppTextField(
            controller: injuryNotesController,
            labelText: context.tr.workoutInjuryNotes,
            maxLines: 3,
            inputFormatters: [createPersianTextFormatter()],
          ),
        ],
        if (showWarning) ...[
          Gap.custom(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.amber.shade300),
              borderRadius: AppRadius.card,
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                Gap.h8(),
                Expanded(
                  child: Text(
                    context.tr.workoutMedicalReferralWarning,
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

Future<void> _maybePromptRegenerate(BuildContext context, WidgetRef ref) async {
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
  AiLoadingDialog.show(
    context,
    title: context.tr.workoutGeneratingPlanTitle,
    message: context.tr.workoutGeneratingPlanMessage,
  );
  final failure = await ref
      .read(workoutPlanNotifierProvider.notifier)
      .generate();
  if (!context.mounted) return;
  AiLoadingDialog.hide(context);

  if (failure != null) {
    if (failure is MedicalReferralFailure) {
      await MedicalReferralDialog.show(context, failure.message);
    } else if (failure is RateLimitFailure) {
      showMessageToast(failure.message);
    } else {
      showFailureToast(context, failure);
    }
    return;
  }

  showMessageToast(context.tr.workoutPlanRegenerated);
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
            context.tr.workoutRegeneratePromptTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          Gap.v8(),
          Text(
            context.tr.workoutRegeneratePromptBody,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: cTextSecondary),
          ),
          Gap.v24(),
          AppPrimaryButton(
            label: context.tr.workoutRegenerateConfirm,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          Gap.v8(),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.tr.workoutRegenerateDismiss),
          ),
        ],
      ),
    );
  }
}
