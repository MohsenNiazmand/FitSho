import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/app_text_field.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

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
      }

      if (isMounted()) {
        isSaving.value = false;

        if (profileResult != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(profileResult.message)),
          );
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

    return optionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
      data: (options) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Gap.v24(),
              AppTextField(
                controller: ageController,
                labelText: context.tr.dietAgeLabel,
                keyboardType: TextInputType.number,
              ),
              Gap.v12(),
              AppTextField(
                controller: heightController,
                labelText: context.tr.dietHeightLabel,
                keyboardType: TextInputType.number,
              ),
              Gap.v12(),
              AppTextField(
                controller: weightController,
                labelText: context.tr.dietWeightLabel,
                keyboardType: TextInputType.number,
              ),
              Gap.v12(),
              _DropdownField(
                label: context.tr.dietGenderLabel,
                value: gender.value,
                items: options.genders,
                onChanged: (value) => gender.value = value,
              ),
              Gap.v12(),
              AppTextField(
                controller: jobController,
                labelText: context.tr.dietJobLabel,
              ),
              Gap.v12(),
              _DropdownField(
                label: context.tr.dietGoalLabel,
                value: goal.value,
                items: options.goals,
                onChanged: (value) => goal.value = value,
              ),
              Gap.v12(),
              AppTextField(
                controller: goalNotesController,
                labelText: context.tr.dietGoalNotesLabel,
                maxLines: 2,
              ),
              Gap.v12(),
              _DropdownField(
                label: context.tr.dietActivityLevelLabel,
                value: activityLevel.value,
                items: options.activityLevels,
                onChanged: (value) => activityLevel.value = value,
              ),
              Gap.v12(),
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
                  labelText: context.tr.dietExerciseTypeLabel,
                ),
                Gap.v12(),
                AppTextField(
                  controller: exerciseDaysController,
                  labelText: context.tr.dietExerciseDaysLabel,
                  keyboardType: TextInputType.number,
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
                        selected: dietaryPreferences.value.contains(option.id),
                        onSelected: (selected) {
                          final updated =
                              Set<String>.from(dietaryPreferences.value);
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
              ),
              Gap.v24(),
              Text(
                'وعده‌های روزانه',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Gap.v12(),
              ...mealSlots.value.entries.map((entry) {
                final slotKey = entry.key;
                final config = entry.value;
                final icon = switch (slotKey) {
                  'breakfast' => Icons.coffee_rounded,
                  'lunch' => Icons.wb_sunny_rounded,
                  'dinner' => Icons.nightlight_round,
                  'morning_snack' => Icons.apple_rounded,
                  'afternoon_snack' => Icons.cookie_rounded,
                  _ => Icons.restaurant_rounded,
                };

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
                        notificationsEnabled: config.notificationsEnabled,
                      ),
                    };
                  },
                  onPickTime: () => pickTime(slotKey),
                );
              }),
              Gap.v24(),
              AppPrimaryButton(
                label: context.tr.dietSaveProfile,
                isLoading: isSaving.value,
                onPressed: isSaving.value ? null : () => submit(options),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<DietOptionItem> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
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
            TextButton(
              onPressed: onPickTime,
              child: Text(
                config.time,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          Switch(
            value: config.enabled,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
