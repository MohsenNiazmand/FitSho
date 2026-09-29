import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';

class WorkoutExerciseDetailsSheet extends StatelessWidget {
  const WorkoutExerciseDetailsSheet({
    required this.exercise,
    super.key,
  });

  final WorkoutExerciseItem exercise;

  static Future<void> show(BuildContext context, WorkoutExerciseItem exercise) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkoutExerciseDetailsSheet(exercise: exercise),
    );
  }

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
    final hasCue =
        exercise.cue != null && exercise.cue!.trim().isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: cSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          if (exercise.gifUrl != null && exercise.gifUrl!.isNotEmpty)
            Container(
              width: double.infinity,
              height: 250,
              color: cSurfaceElevated,
              child: CachedNetworkImage(
                imageUrl: exercise.gifUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.fitness_center,
                    color: cTextSecondary,
                    size: 64,
                  ),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 200,
              color: cSurfaceElevated,
              child: const Center(
                child: Icon(
                  Icons.fitness_center,
                  color: cTextSecondary,
                  size: 80,
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cTextPrimary,
                  ),
                ),
                Gap.v8(),
                Text(
                  setsAndRepsText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap.v16(),
                
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildInfoBadge(
                      context,
                      icon: Icons.timer_outlined,
                      label: context.tr.workoutRest(exercise.restSec),
                    ),
                    if (exercise.rpe != null)
                      _buildInfoBadge(
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
                if (hasCue) ...[
                  Gap.v16(),
                  Text(
                    'راهنمای تکنیکی حرکت',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cPrimary,
                    ),
                  ),
                  Gap.v8(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: cPrimary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.tips_and_updates_outlined,
                          size: 20,
                          color: cPrimary,
                        ),
                        Gap.h8(),
                        Expanded(
                          child: Text(
                            exercise.cue!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cTextPrimary,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (hasNotes) ...[
                  Gap.v16(),
                  Text(
                    'نکات اجرا', // TODO: localize
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap.v8(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cSecondaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      exercise.notes!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cTextSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
                
                Gap.v24(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'متوجه شدم', // TODO: localize
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cSurfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: cTextSecondary),
          Gap.h8(),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: cTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
