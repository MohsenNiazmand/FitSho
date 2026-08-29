import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/core/constants/app_assets.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/core/utils/persian_input.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.dietSupplementsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
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
                      message: context.tr.dietSupplementsEmpty,
                      subtitle: context.tr.dietSupplementsEmptySubtitle,
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
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    [
                      if (item.dosageNote != null) item.dosageNote!,
                      if (item.times.isNotEmpty) item.times.join(' • '),
                      if (item.linkedMealSlot != null)
                        dietMealSlotLabel(context, item.linkedMealSlot!),
                    ].join('\n'),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await _openForm(context, ref, supplement: item);
                      } else if (value == 'delete') {
                        final failure = await ref
                            .read(supplementsNotifierProvider.notifier)
                            .delete(item.id);
                        if (failure != null && context.mounted) {
                          showFailureToast(context, failure);
                        }
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
                ),
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

class _SupplementFormSheet extends HookWidget {
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
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: supplement?.name);
    final dosageController =
        useTextEditingController(text: supplement?.dosageNote);
    final times = useState<List<String>>(
      List<String>.from(supplement?.times ?? const []),
    );
    final linkedSlot = useState<String?>(supplement?.linkedMealSlot);
    final isSaving = useState(false);

    Future<void> addTime() async {
      final picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked == null) return;
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (!times.value.contains(formatted)) {
        times.value = [...times.value, formatted]..sort();
      }
    }

    Future<void> submit() async {
      final name = nameController.text.trim();
      if (name.isEmpty) return;
      isSaving.value = true;
      final success = await onSubmit(
        name,
        dosageController.text.trim().isEmpty
            ? null
            : dosageController.text.trim(),
        times.value,
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
          Text(
            context.tr.dietSupplementTimesLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cTextSecondary,
            ),
          ),
          Gap.v8(),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final time in times.value)
                Chip(
                  label: Text(PersianDigits.toPersian(time)),
                  onDeleted: () => times.value = times.value
                      .where((item) => item != time)
                      .toList(),
                ),
              ActionChip(
                avatar: const Icon(Icons.add_rounded, size: 18),
                label: Text(context.tr.dietAddTime),
                onPressed: addTime,
              ),
            ],
          ),
          Gap.v12(),
          DropdownButtonFormField<String?>(
            value: linkedSlot.value,
            decoration: InputDecoration(
              labelText: context.tr.dietSupplementLinkedMealLabel,
            ),
            items: [
              DropdownMenuItem<String?>(
                child: Text(context.tr.dietNone),
              ),
              ...orderedMealSlotKeys().map(
                (slot) => DropdownMenuItem<String?>(
                  value: slot,
                  child: Text(dietMealSlotLabel(context, slot)),
                ),
              ),
            ],
            onChanged: (value) => linkedSlot.value = value,
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
