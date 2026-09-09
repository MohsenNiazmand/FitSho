import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/utils/meal_time_utils.dart';
import 'package:fitsho/features/diet/domain/utils/meal_time_validator.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';

class DietMealSlotsScreen extends HookConsumerWidget {
  const DietMealSlotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(mealSlotsNotifierProvider);
    final planAsync = ref.watch(dietPlanNotifierProvider);
    final localSlots = useState<Map<String, MealSlotConfig>>({});
    final isSaving = useState(false);

    useEffect(() {
      // mealSlotsNotifierProvider derives from the diet profile response
      // (there's no dedicated GET endpoint for meal slots on the backend),
      // so this already reflects the latest saved profile data.
      slotsAsync.whenData((slots) {
        if (slots.isEmpty) {
          localSlots.value = DietConstants.defaultMealSlots();
        } else {
          localSlots.value = Map<String, MealSlotConfig>.from(slots);
        }
      });
      return null;
    }, [slotsAsync]);

    // Determine which slots to show based on the active plan or profile selection
    final displaySlotKeys = useMemoized(() {
      final plan = planAsync.value;
      if (plan != null && plan.days.isNotEmpty) {
        // Collect all slots that have at least one meal in the plan
        final activeSlots = <String>{};
        for (final day in plan.days) {
          for (final entry in day.meals.entries) {
            if (entry.value != null) {
              activeSlots.add(entry.key);
            }
          }
        }
        if (activeSlots.isNotEmpty) {
          return DietConstants.mealSlotKeys
              .where((key) => activeSlots.contains(key))
              .toList();
        }
      }

      // Fallback to localSlots enabled status if no plan or empty plan
      return DietConstants.mealSlotKeys.where((key) {
        return localSlots.value[key]?.enabled ?? false;
      }).toList();
    }, [planAsync.value, localSlots.value]);

    final bool hasActivePlan = planAsync.value != null;

    Future<void> pickTime(String slotKey) async {
      if (!hasActivePlan) return;
      final current =
          localSlots.value[slotKey] ??
          DietConstants.defaultMealSlots()[slotKey]!;
      final parts = current.time.split(':');
      final initial = TimeOfDay(
        hour: int.tryParse(parts.first) ?? 8,
        minute: int.tryParse(parts.last) ?? 0,
      );
      final picked = await showTimePicker(
        context: context,
        initialTime: initial,
      );
      if (picked == null) return;
      if (!context.mounted) return;
      final formatted = MealTimeUtils.formatTimeOfDay(picked);

      final updatedCandidate = {
        ...localSlots.value,
        slotKey: MealSlotConfig(
          enabled: current.enabled,
          time: formatted,
          notificationsEnabled: current.notificationsEnabled,
        ),
      };

      final validation = MealTimeValidator.validate(
        slots: updatedCandidate,
        orderedKeys: DietConstants.mealSlotKeys,
        tr: context.tr,
      );

      if (validation case MealTimesInvalid(:final message)) {
        BotToast.showText(text: message);
        return;
      }

      localSlots.value = updatedCandidate;
    }

    Future<void> save() async {
      isSaving.value = true;
      final currentSlots = slotsAsync.value ?? {};
      
      // Merge: priority to local changes, then current server state,
      // and finally defaults ONLY for keys that MUST exist.
      final payload = {
        for (final key in DietConstants.mealSlotKeys)
          key: localSlots.value[key] ??
              currentSlots[key] ??
              DietConstants.defaultMealSlots()[key]!.copyWith(enabled: false),
      };
      
      final failure = await ref
          .read(mealSlotsNotifierProvider.notifier)
          .save(payload);
      isSaving.value = false;
      if (failure != null && context.mounted) {
        showFailureToast(context, failure);
        return;
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(context.tr.dietMealTimesSettings)),
        body: slotsAsync.when(
          loading: () => const AppLoadingIndicator(),
          error: (error, _) => ErrorRetryView(
            message: errorDisplayMessage(context, error),
            onRetry: () => ref.invalidate(mealSlotsNotifierProvider),
          ),
          data: (_) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      for (final slotKey in displaySlotKeys)
                        _MealSlotTile(
                          title: dietMealSlotLabel(context, slotKey),
                          isEnabled: hasActivePlan,
                          config:
                              localSlots.value[slotKey] ??
                              DietConstants.defaultMealSlots()[slotKey]!,
                          onToggle: (enabled) {
                            if (!hasActivePlan) return;
                            final current =
                                localSlots.value[slotKey] ??
                                DietConstants.defaultMealSlots()[slotKey]!;
                            final updatedCandidate = {
                              ...localSlots.value,
                              slotKey: MealSlotConfig(
                                enabled: enabled,
                                time: current.time,
                                notificationsEnabled:
                                    current.notificationsEnabled,
                              ),
                            };

                            if (enabled) {
                              final validation = MealTimeValidator.validate(
                                slots: updatedCandidate,
                                orderedKeys: DietConstants.mealSlotKeys,
                                tr: context.tr,
                              );

                              if (validation
                                  case MealTimesInvalid(:final message)) {
                                BotToast.showText(text: message);
                                return;
                              }
                            }

                            localSlots.value = updatedCandidate;
                          },
                          onToggleNotifications: (enabled) {
                            if (!hasActivePlan) return;
                            final current =
                                localSlots.value[slotKey] ??
                                DietConstants.defaultMealSlots()[slotKey]!;
                            localSlots.value = {
                              ...localSlots.value,
                              slotKey: MealSlotConfig(
                                enabled: current.enabled,
                                time: current.time,
                                notificationsEnabled: enabled,
                              ),
                            };
                          },
                          onPickTime: () => pickTime(slotKey),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AppPrimaryButton(
                    label: context.tr.save,
                    isLoading: isSaving.value,
                    onPressed: (isSaving.value || !hasActivePlan) ? null : save,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MealSlotTile extends StatelessWidget {
  const _MealSlotTile({
    required this.title,
    required this.config,
    required this.onToggle,
    required this.onToggleNotifications,
    required this.onPickTime,
    this.isEnabled = true,
  });

  final String title;
  final MealSlotConfig config;
  final ValueChanged<bool> onToggle;
  final ValueChanged<bool> onToggleNotifications;
  final VoidCallback onPickTime;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canInteract = isEnabled && config.enabled;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(
              title,
              style: TextStyle(
                color: isEnabled ? null : theme.disabledColor,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: InkWell(
                onTap: canInteract ? onPickTime : null,
                borderRadius: BorderRadius.circular(8),
                child: UnconstrainedBox(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? Colors.grey.shade200
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isEnabled ? null : theme.disabledColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          config.time,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isEnabled ? null : theme.disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            value: config.enabled,
            onChanged: isEnabled ? onToggle : null,
          ),
          if (config.enabled)
            SwitchListTile(
              title: Text(
                context.tr.dietSlotNotificationLabel,
                style: TextStyle(
                  color: isEnabled ? null : theme.disabledColor,
                ),
              ),
              value: config.notificationsEnabled,
              onChanged: isEnabled ? onToggleNotifications : null,
              dense: true,
            ),
        ],
      ),
    );
  }
}
