import 'package:flutter/material.dart';

import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WorkoutExerciseCard extends StatelessWidget {
  const WorkoutExerciseCard({
    required this.exercise,
    this.onSwap,
    this.isSwapping = false,
    this.canSwap = true,
    this.readOnly = false,
    super.key,
  });

  final WorkoutExerciseItem exercise;
  final VoidCallback? onSwap;
  final bool isSwapping;
  final bool canSwap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String setsAndRepsText;
    if (exercise.reps != null && exercise.reps!.trim().isNotEmpty) {
      setsAndRepsText = context.tr.workoutSetsReps(
        exercise.sets,
        PersianDigits.toPersian(exercise.reps!),
      );
    } else if (exercise.durationSec != null) {
      setsAndRepsText = context.tr.workoutSetsDuration(
        exercise.sets,
        exercise.durationSec!,
      );
    } else {
      setsAndRepsText = context.tr.workoutSetsOnly(exercise.sets);
    }

    final hasNotes =
        exercise.notes != null && exercise.notes!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cBorder.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cTextPrimary,
                      ),
                    ),
                    Gap.v6(),
                    Text(
                      setsAndRepsText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!readOnly && canSwap)
                isSwapping
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.swap_horiz_rounded,
                          color: cPrimary,
                        ),
                        tooltip: context.tr.workoutSwapExercise,
                        onPressed: onSwap,
                      ),
            ],
          ),
          Gap.v12(),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildBadge(
                context,
                icon: Icons.timer_outlined,
                label: context.tr.workoutRest(exercise.restSec),
              ),
              if (exercise.rpe != null)
                _buildBadge(
                  context,
                  icon: Icons.fitness_center_outlined,
                  label: context.tr.workoutRpe(
                    PersianDigits.toPersian(
                      exercise.rpe! % 1 == 0
                          ? exercise.rpe!.toInt().toString()
                          : exercise.rpe!.toString(),
                    ),
                  ),
                ),
            ],
          ),
          if (hasNotes) ...[
            Gap.v12(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: cSecondaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: cTextSecondary,
                  ),
                  Gap.h8(),
                  Expanded(
                    child: Text(
                      exercise.notes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cTextSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cSurfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cTextSecondary),
          Gap.h4(),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
