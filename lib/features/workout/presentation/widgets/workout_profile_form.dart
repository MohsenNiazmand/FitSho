import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_input.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/providers/workout_providers.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/app_text_field.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

const _stepCount = 5;

class WorkoutProfileForm extends HookConsumerWidget {
  const WorkoutProfileForm({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(workoutOptionsNotifierProvider);
    final profileAsync = ref.watch(workoutProfileNotifierProvider);

    final selectedDisciplines = useState<List<String>>([]);
    final selectedStyles = useState<Map<String, String>>({});
    final selectedGoal = useState<String?>(null);
    final selectedLevel = useState<String>('beginner');
    final daysPerWeek = useState<int>(3);
    final sessionMinutes = useState<int>(60);
    final location = useState<String>('gym');
    final selectedEquipment = useState<List<String>>([]);
    final hasNoInjuries = useState<bool>(true);
    final selectedInjuries = useState<List<String>>([]);
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
        selectedGoal.value = profile.goal;
        selectedLevel.value = profile.level;
        daysPerWeek.value = profile.daysPerWeek;
        sessionMinutes.value = profile.sessionMinutes;
        location.value = profile.location;
        selectedEquipment.value = List.from(profile.equipment);
        selectedInjuries.value = List.from(profile.injuries);
        hasNoInjuries.value = profile.injuries.isEmpty;
        painLevel.value = profile.painLevel;
        injuryNotesController.text = profile.injuryNotes ?? '';
      }
      return null;
    }, [profileAsync.value]);

    return optionsAsync.when(
      data: (options) {
        bool canProceed() {
          switch (currentStep.value) {
            case 0:
              return selectedDisciplines.value.isNotEmpty;
            case 1:
              return selectedDisciplines.value.every(
                (dId) => selectedStyles.value.containsKey(dId),
              );
            case 2:
              return selectedGoal.value != null;
            case 3:
              return true;
            case 4:
              return true;
            default:
              return false;
          }
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
          isSaving.value = true;
          final failure = await ref.read(workoutProfileNotifierProvider.notifier).save(
                disciplines: selectedDisciplines.value,
                styles: selectedStyles.value,
                goal: selectedGoal.value ?? options.goals.first.id,
                level: selectedLevel.value,
                daysPerWeek: daysPerWeek.value,
                sessionMinutes: sessionMinutes.value,
                location: location.value,
                equipment: location.value == 'gym' ? [] : selectedEquipment.value,
                injuries: hasNoInjuries.value ? [] : selectedInjuries.value,
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
                  _buildDisciplinesStep(context, options, selectedDisciplines),
                  _buildLevelStylesStep(context, options, selectedDisciplines, selectedLevel, selectedStyles),
                  _buildGoalStep(context, options, selectedDisciplines, selectedGoal),
                  _buildConditionsStep(context, options, selectedDisciplines, selectedStyles, daysPerWeek, sessionMinutes, location, selectedEquipment),
                  _buildInjuriesStep(context, options, hasNoInjuries, selectedInjuries, painLevel, injuryNotesController),
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
                list.remove(d.id);
              } else {
                if (list.length >= options.maxDisciplines) {
                  BotToast.showText(text: context.tr.workoutMaxDisciplinesWarning);
                  return;
                }
                list.add(d.id);
              }
              selectedDisciplines.value = list;
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
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
                          color: isSelected ? const Color(0xFF4338CA) : Colors.black87,
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Color(0xFF6366F1)),
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
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepStyleLevel,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v12(),
        Text(context.tr.workoutFitnessLevelLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
        Gap.v8(),
        Row(
          children: options.levels.map((lvl) {
            final isSelected = selectedLevel.value == lvl.id;
            return Expanded(
              child: GestureDetector(
                onTap: () => selectedLevel.value = lvl.id,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade100,
                    borderRadius: AppRadius.button,
                  ),
                  child: Text(
                    lvl.label,
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
        Gap.v24(),
        ...selectedDisciplines.value.map((dId) {
          final discipline = options.disciplines.firstWhere((d) => d.id == dId);
          final availableStyles = options.styles
              .where((s) => s.disciplineId == dId && s.levels.contains(selectedLevel.value))
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.workoutDisciplineStyleLabel(discipline.label),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap.v8(),
              ...availableStyles.map((style) {
                return RadioListTile<String>(
                  title: Text(style.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(style.description),
                  value: style.id,
                  groupValue: selectedStyles.value[dId],
                  onChanged: (val) {
                    if (val != null) {
                      final map = Map<String, String>.from(selectedStyles.value);
                      map[dId] = val;
                      selectedStyles.value = map;
                    }
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
    ValueNotifier<String?> selectedGoal,
  ) {
    final compatibleGoals = options.goals.where((g) {
      return g.compatibleDisciplines.any((dId) => selectedDisciplines.value.contains(dId));
    }).toList();

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
        ...compatibleGoals.map((goal) {
          final isSelected = selectedGoal.value == goal.id;
          return GestureDetector(
            onTap: () => selectedGoal.value = goal.id,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: AppRadius.card,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFF4338CA) : Colors.black87,
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Color(0xFF6366F1)),
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
    ValueNotifier<String> location,
    ValueNotifier<List<String>> selectedEquipment,
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepConditions,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v16(),
        Text(context.tr.workoutDaysPerWeek, style: const TextStyle(fontWeight: FontWeight.w600)),
        Gap.v8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(maxDays - minDays + 1, (i) {
            final day = minDays + i;
            final isSelected = daysPerWeek.value == day;
            return GestureDetector(
              onTap: () => daysPerWeek.value = day,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade100,
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
        Text(context.tr.workoutSessionMinutes, style: const TextStyle(fontWeight: FontWeight.w600)),
        Gap.v8(),
        Wrap(
          spacing: 8,
          children: options.sessionMinutes.map((min) {
            final isSelected = sessionMinutes.value == min;
            return ChoiceChip(
              label: Text(context.tr.workoutMinutesCount(min)),
              selected: isSelected,
              onSelected: (_) => sessionMinutes.value = min,
            );
          }).toList(),
        ),
        Gap.custom(height: 20),
        Text(context.tr.workoutLocation, style: const TextStyle(fontWeight: FontWeight.w600)),
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
                    color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade100,
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
          Text(context.tr.workoutEquipment, style: const TextStyle(fontWeight: FontWeight.w600)),
          Gap.v8(),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: options.equipment.map((eq) {
              final isSelected = selectedEquipment.value.contains(eq.id);
              return FilterChip(
                label: Text(eq.label),
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
    ValueNotifier<List<String>> selectedInjuries,
    ValueNotifier<int> painLevel,
    TextEditingController injuryNotesController,
  ) {
    final hasReferralInjury = selectedInjuries.value.any((injId) {
      final inj = options.injuries.firstWhere((i) => i.id == injId, orElse: () => options.injuries.first);
      return inj.requiresReferral;
    });

    final showWarning = !hasNoInjuries.value && (painLevel.value >= 7 || hasReferralInjury);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.tr.workoutStepInjuries,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Gap.v16(),
        SwitchListTile(
          title: Text(context.tr.workoutNoInjuries, style: const TextStyle(fontWeight: FontWeight.w600)),
          value: hasNoInjuries.value,
          onChanged: (val) {
            hasNoInjuries.value = val;
            if (val) {
              selectedInjuries.value = [];
              painLevel.value = 0;
            }
          },
        ),
        if (!hasNoInjuries.value) ...[
          Gap.v16(),
          Text(context.tr.workoutInjuriesLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
          Gap.v8(),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: options.injuries.map((inj) {
              final isSelected = selectedInjuries.value.contains(inj.id);
              return FilterChip(
                label: Text(inj.label),
                selected: isSelected,
                onSelected: (selected) {
                  final list = List<String>.from(selectedInjuries.value);
                  if (selected) {
                    list.add(inj.id);
                  } else {
                    list.remove(inj.id);
                  }
                  selectedInjuries.value = list;
                },
              );
            }).toList(),
          ),
          Gap.custom(height: 20),
          Text('${context.tr.workoutPainLevel} ${painLevel.value}', style: const TextStyle(fontWeight: FontWeight.w600)),
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
                    style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
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
