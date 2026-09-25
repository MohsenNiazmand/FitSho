import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;

import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/workout/presentation/providers/workout_providers.dart';
import 'package:fitsho/shared/presentation/utils/failure_message.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryNotifierProvider);

    return Scaffold(
      backgroundColor: cBackground,
      appBar: AppBar(title: Text(context.tr.workoutHistoryTitle)),
      body: historyAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => Center(
          child: Text(errorDisplayMessage(context, error)),
        ),
        data: (history) {
          final plans = history.items;
          if (plans.isEmpty) {
            return Center(
              child: Text(
                context.tr.workoutHistoryEmpty,
                style: const TextStyle(color: cTextSecondary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(workoutHistoryNotifierProvider.notifier).refresh();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: plans.length,
              separatorBuilder: (context, index) => Gap.v12(),
              itemBuilder: (context, index) {
                final plan = plans[index];
                final date = intl.DateFormat.yMMMMd(
                  'fa_IR',
                ).format(plan.createdAt);

                return InkWell(
                  onTap: () {
                    context.push(AppRoutes.workoutPlanDetail, extra: plan);
                  },
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Container(
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
                                  color: cTextPrimary,
                                ),
                              ),
                              if (plan.summary != null &&
                                  plan.summary!.trim().isNotEmpty) ...[
                                Gap.v4(),
                                Text(
                                  plan.summary!,
                                  style: const TextStyle(
                                    color: cTextSecondary,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
                                  context.tr.workoutHistoryDeleteConfirmTitle,
                                ),
                                content: Text(
                                  context.tr.workoutHistoryDeleteConfirmBody,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(
                                      context
                                          .tr.workoutHistoryDeleteConfirmCancel,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(
                                      context
                                          .tr.workoutHistoryDeleteConfirmConfirm,
                                      style: const TextStyle(color: cError),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final failure = await ref
                                  .read(workoutPlanNotifierProvider.notifier)
                                  .delete(plan.id);
                              if (context.mounted) {
                                if (failure != null) {
                                  showFailureToast(context, failure);
                                } else {
                                  ref
                                      .read(workoutHistoryNotifierProvider
                                          .notifier)
                                      .refresh();
                                  showMessageToast(
                                    context.tr.workoutHistoryDeleteSuccess,
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
