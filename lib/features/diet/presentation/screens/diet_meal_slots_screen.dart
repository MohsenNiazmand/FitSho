import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';

class DietMealSlotsScreen extends HookConsumerWidget {
  const DietMealSlotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slotsAsync = ref.watch(mealSlotsNotifierProvider);
    final localSlots = useState<Map<String, MealSlotConfig>>({});
    final isSaving = useState(false);

    useEffect(() {
      slotsAsync.whenData((slots) {
        if (slots.isEmpty) {
          localSlots.value = DietConstants.defaultMealSlots();
        } else {
          localSlots.value = Map<String, MealSlotConfig>.from(slots);
        }
      });
      return null;
    }, [slotsAsync]);

    Future<void> pickTime(String slotKey) async {
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
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      localSlots.value = {
        ...localSlots.value,
        slotKey: MealSlotConfig(
          enabled: current.enabled,
          time: formatted,
          notificationsEnabled: current.notificationsEnabled,
        ),
      };
    }

    Future<void> save() async {
      isSaving.value = true;
      final payload = {
        for (final key in DietConstants.mealSlotKeys)
          key: localSlots.value[key] ?? DietConstants.defaultMealSlots()[key]!,
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

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.dietMealTimesSettings)),
      body: slotsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => ErrorRetryView(
          message: error.toString(),
          onRetry: () => ref.invalidate(mealSlotsNotifierProvider),
        ),
        data: (_) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    for (final slotKey in DietConstants.mealSlotKeys)
                      _MealSlotTile(
                        title: dietMealSlotLabel(context, slotKey),
                        config:
                            localSlots.value[slotKey] ??
                            DietConstants.defaultMealSlots()[slotKey]!,
                        onToggle: (enabled) {
                          final current =
                              localSlots.value[slotKey] ??
                              DietConstants.defaultMealSlots()[slotKey]!;
                          localSlots.value = {
                            ...localSlots.value,
                            slotKey: MealSlotConfig(
                              enabled: enabled,
                              time: current.time,
                              notificationsEnabled:
                                  current.notificationsEnabled,
                            ),
                          };
                        },
                        onToggleNotifications: (enabled) {
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
                  onPressed: isSaving.value ? null : save,
                ),
              ),
            ],
          );
        },
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
  });

  final String title;
  final MealSlotConfig config;
  final ValueChanged<bool> onToggle;
  final ValueChanged<bool> onToggleNotifications;
  final VoidCallback onPickTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(title),
            subtitle: Text(config.time),
            value: config.enabled,
            onChanged: onToggle,
            secondary: IconButton(
              icon: const Icon(Icons.schedule_rounded),
              onPressed: config.enabled ? onPickTime : null,
            ),
          ),
          if (config.enabled)
            SwitchListTile(
              title: Text(context.tr.dietSlotNotificationLabel),
              value: config.notificationsEnabled,
              onChanged: onToggleNotifications,
              dense: true,
            ),
        ],
      ),
    );
  }
}
