import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/core/constants/app_assets.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/core/utils/persian_input.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_text_field.dart';
import 'package:fitsho/shared/presentation/widgets/empty_state_view.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplementsScreen extends ConsumerWidget {
  const SupplementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplementsAsync = ref.watch(supplementsNotifierProvider);
    final planAsync = ref.watch(dietPlanNotifierProvider);
    final hasActivePlan = planAsync.value != null;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.dietSupplementsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: hasActivePlan ? () => _openForm(context, ref) : null,
        backgroundColor: hasActivePlan ? null : Theme.of(context).disabledColor,
        icon: const Icon(Icons.add_rounded),
        label: Text(context.tr.dietAddSupplement),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: supplementsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => ErrorRetryView(
          message: errorDisplayMessage(context, error),
          onRetry: () => ref.invalidate(supplementsNotifierProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EmptyStateView(
                      imagePath: AppAssets.emptyState,
                      message: hasActivePlan
                          ? context.tr.dietSupplementsEmpty
                          : context.tr.dietNoPlanYet,
                      subtitle: hasActivePlan
                          ? context.tr.dietSupplementsEmptySubtitle
                          : context.tr.dietSupplementsRequirementHint,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, __) => Gap.v12(),
            itemBuilder: (context, index) {
              final item = items[index];
              return _SupplementListItem(
                item: item,
                onEdit: () => _openForm(context, ref, supplement: item),
                onDelete: () async {
                  final failure = await ref
                      .read(supplementsNotifierProvider.notifier)
                      .delete(item.id);
                  if (failure != null && context.mounted) {
                    showFailureToast(context, failure);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Supplement? supplement,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: _SupplementFormSheet(
            supplement: supplement,
            onSubmit: (name, dosage, times, linkedSlot) async {
              final failure = supplement == null
                  ? await ref.read(supplementsNotifierProvider.notifier).create(
                        name: name,
                        dosageNote: dosage,
                        times: times,
                        linkedMealSlot: linkedSlot,
                      )
                  : await ref
                      .read(supplementsNotifierProvider.notifier)
                      .updateSupplement(
                        id: supplement.id,
                        name: name,
                        dosageNote: dosage,
                        times: times,
                        linkedMealSlot: linkedSlot,
                      );
              if (failure != null && sheetContext.mounted) {
                showFailureToast(sheetContext, failure);
                return false;
              }
              return true;
            },
          ),
        );
      },
    );
  }
}

class _SupplementListItem extends HookWidget {
  const _SupplementListItem({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final Supplement item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isConsumed = useState(false);
    final theme = Theme.of(context);

    // Formatted subtitle string: "Dosage" (times removed as per requirement)
    final subtitleText = item.dosageNote ?? '';

    Future<void> toggleConsumed() async {
      final previous = isConsumed.value;
      isConsumed.value = !previous;

      // Hypothetical API call
      try {
        // await ref.read(supplementsNotifierProvider.notifier).toggleLog(item.id);
        await Future.delayed(const Duration(milliseconds: 600));
      } catch (e) {
        if (context.mounted) {
          isConsumed.value = previous;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr.dietSupplementUpdateError)),
          );
        }
      }
    }

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cPrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.medication_outlined, color: cPrimary),
        ),
        title: Text(
          item.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitleText.isNotEmpty)
                Text(
                  subtitleText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              if (item.linkedMealSlot != null) ...[
                const SizedBox(height: 4),
                Text(
                  dietMealSlotLabel(context, item.linkedMealSlot!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: toggleConsumed,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: Icon(
                    isConsumed.value
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    key: ValueKey(isConsumed.value),
                    color: isConsumed.value ? cSuccess : theme.disabledColor,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text(context.tr.edit),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(context.tr.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SupplementFormSheet extends HookConsumerWidget {
  const _SupplementFormSheet({
    required this.onSubmit,
    this.supplement,
  });

  final Supplement? supplement;
  final Future<bool> Function(
    String name,
    String? dosage,
    List<String> times,
    String? linkedSlot,
  ) onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(dietPlanNotifierProvider);
    final nameController = useTextEditingController(text: supplement?.name);
    final dosageController =
        useTextEditingController(text: supplement?.dosageNote);
    final linkedSlot = useState<String?>(supplement?.linkedMealSlot);
    final isSaving = useState(false);

    // Filter slots based on active plan
    final activeSlots = useMemoized(() {
      final plan = planAsync.value;
      if (plan != null && plan.days.isNotEmpty) {
        final slots = <String>{};
        for (final day in plan.days) {
          for (final entry in day.meals.entries) {
            if (entry.value != null) {
              slots.add(entry.key);
            }
          }
        }
        if (slots.isNotEmpty) {
          return DietConstants.mealSlotKeys
              .where((key) => slots.contains(key))
              .toList();
        }
      }
      return orderedMealSlotKeys(); // Fallback if no plan
    }, [planAsync.value]);

    Future<void> submit() async {
      final name = nameController.text.trim();
      if (name.isEmpty) return;

      if (linkedSlot.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr.dietSupplementLinkedMealRequired)),
        );
        return;
      }

      isSaving.value = true;
      final success = await onSubmit(
        name,
        dosageController.text.trim().isEmpty
            ? null
            : dosageController.text.trim(),
        const [], // Empty times as per requirement
        linkedSlot.value,
      );
      isSaving.value = false;
      if (success && context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            supplement == null
                ? context.tr.dietAddSupplement
                : context.tr.dietEditSupplement,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap.v16(),
          AppTextField(
            controller: nameController,
            labelText: context.tr.dietSupplementNameLabel,
            inputFormatters: [createPersianTextFormatter()],
          ),
          Gap.v12(),
          AppTextField(
            controller: dosageController,
            labelText: context.tr.dietSupplementDosageLabel,
            maxLines: 2,
            inputFormatters: [createPersianTextFormatter()],
          ),
          Gap.v12(),
          DropdownButtonFormField<String?>(
            value: linkedSlot.value,
            decoration: InputDecoration(
              labelText: context.tr.dietSupplementLinkedMealLabel,
            ),
            items: [
              ...activeSlots.map(
                (slot) => DropdownMenuItem<String?>(
                  value: slot,
                  child: Text(dietMealSlotLabel(context, slot)),
                ),
              ),
            ],
            onChanged: (value) => linkedSlot.value = value,
            validator: (value) =>
                value == null ? context.tr.dietSupplementLinkedMealRequired : null,
          ),
          Gap.v16(),
          FilledButton(
            onPressed: isSaving.value ? null : submit,
            child: isSaving.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(context.tr.save),
          ),
        ],
      ),
    );
  }
}
