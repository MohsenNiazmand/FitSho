import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class DietHistoryScreen extends ConsumerWidget {
  const DietHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(dietPlanHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: cBackground,
      appBar: AppBar(title: Text(context.tr.dietHistoryTitle)),
      body: historyAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => Center(child: Text(errorDisplayMessage(context, error))),
        data: (plans) {
          if (plans.isEmpty) {
            return Center(
              child: Text(
                context.tr.dietHistoryEmpty,
                style: const TextStyle(color: cTextSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: plans.length,
            separatorBuilder: (context, index) => Gap.v12(),
            itemBuilder: (context, index) {
              final plan = plans[index];
              final date = intl.DateFormat.yMMMMd(
                'fa_IR',
              ).format(plan.createdAt);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cSurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: cBorder.withValues(alpha: 0.8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            PersianDigits.toPersian(date),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Gap.v4(),
                          Text(
                            context.tr.dietDailyCalories(
                            PersianDigits.toPersian(
                              plan.dailyCalorieTarget.toString(),
                            ),
                          ),
                            style: const TextStyle(
                              color: cTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: cError),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              context.tr.dietHistoryDeleteConfirmTitle,
                            ),
                            content: Text(
                              context.tr.dietHistoryDeleteConfirmBody,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  context.tr.dietHistoryDeleteConfirmCancel,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  context.tr.dietHistoryDeleteConfirmConfirm,
                                  style: const TextStyle(color: cError),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final failure = await ref
                              .read(dietPlanNotifierProvider.notifier)
                              .delete(plan.id);
                          if (context.mounted) {
                            if (failure != null) {
                              showFailureToast(context, failure);
                            } else {
                              showMessageToast(
                                context.tr.dietHistoryDeleteSuccess,
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
