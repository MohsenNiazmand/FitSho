import 'package:flutter/material.dart';

import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WorkoutPlanHeader extends StatelessWidget {
  const WorkoutPlanHeader({
    required this.plan,
    this.onGenerateNewPlan,
    this.isGenerating = false,
    this.readOnly = false,
    super.key,
  });

  final WorkoutPlan plan;
  final VoidCallback? onGenerateNewPlan;
  final bool isGenerating;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSummary = plan.summary != null && plan.summary!.trim().isNotEmpty;
    final hasProgression = plan.notes.progression.trim().isNotEmpty;
    final hasSafety = plan.notes.safety.isNotEmpty;
    final canGenerate = plan.remainingFullGenerations > 0 && !isGenerating;

    return Material(
      color: cSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasSummary) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cPrimary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          color: cPrimary,
                          size: 20,
                        ),
                      ),
                      Gap.h12(),
                      Expanded(
                        child: Text(
                          plan.summary!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cTextPrimary,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap.v16(),
                ],
                Row(
                  children: [
                    Expanded(
                      child: _buildQuotaCard(
                        context,
                        icon: Icons.auto_awesome_outlined,
                        title: context.tr.workoutWeeklyGenerationsTitle,
                        value: context.tr.workoutRemainingGenerations(
                          plan.remainingFullGenerations,
                        ),
                      ),
                    ),
                    Gap.h8(),
                    Expanded(
                      child: _buildQuotaCard(
                        context,
                        icon: Icons.swap_horiz_rounded,
                        title: context.tr.workoutDailySwapsTitle,
                        value: context.tr.workoutRemainingSwaps(
                          plan.remainingExerciseSwaps,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!readOnly) ...[
                  Gap.v16(),
                  AppPrimaryButton(
                    label: context.tr.workoutNewPlan,
                    isLoading: isGenerating,
                    onPressed: canGenerate ? onGenerateNewPlan : null,
                  ),
                ],
              ],
            ),
          ),
          if (hasProgression || hasSafety) ...[
            const Divider(height: 1, color: cDivider),
            if (hasProgression)
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const Icon(
                    Icons.trending_up_rounded,
                    color: cPrimary,
                    size: 20,
                  ),
                  title: Text(
                    context.tr.workoutProgressionNotes,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cTextPrimary,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      plan.notes.progression,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cTextSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            if (hasSafety)
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const Icon(
                    Icons.health_and_safety_outlined,
                    color: cWarning,
                    size: 20,
                  ),
                  title: Text(
                    context.tr.workoutSafetyNotes,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cTextPrimary,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                  children: plan.notes.safety.map((safetyItem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(
                              Icons.fiber_manual_record,
                              size: 8,
                              color: cWarning,
                            ),
                          ),
                          Gap.h8(),
                          Expanded(
                            child: Text(
                              safetyItem,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cTextSecondary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuotaCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cSurfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: cTextSecondary),
              Gap.h8(),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Gap.v4(),
          Text(
            PersianDigits.toPersian(value),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cTextPrimary,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
