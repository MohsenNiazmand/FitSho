import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_exercise_card.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WorkoutSessionSection extends HookWidget {
  const WorkoutSessionSection({
    required this.plan,
    this.initialSessionId,
    this.readOnly = false,
    this.swappingItemId,
    this.onSwapExercise,
    super.key,
  });

  final WorkoutPlan plan;
  final String? initialSessionId;
  final bool readOnly;
  final String? swappingItemId;
  final void Function(String sessionId, WorkoutExerciseItem item)?
  onSwapExercise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sort sessions by sessionNumber
    final sortedSessions = useMemoized(() {
      final sessions = List<WorkoutSession>.from(plan.sessions)
        ..sort((a, b) => a.sessionNumber.compareTo(b.sessionNumber));
      return sessions;
    }, [plan.sessions]);

    final selectedSessionId = useState<String>(
      initialSessionId ??
          (sortedSessions.isNotEmpty
              ? sortedSessions.first.sessionId
              : 'session_1'),
    );

    final currentSession = sortedSessions.firstWhere(
      (s) => s.sessionId.toLowerCase() == selectedSessionId.value.toLowerCase(),
      orElse: () => sortedSessions.isNotEmpty
          ? sortedSessions.first
          : const WorkoutSession(
              sessionId: 'session_1',
              sessionNumber: 1,
              title: '',
              focus: [],
              durationMin: 0,
              warmup: [],
              main: [],
              cooldown: [],
            ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Horizontally scrollable Session tabs: Session 1 ... Session N
        if (sortedSessions.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: sortedSessions.map((sessionItem) {
                final isSelected =
                    sessionItem.sessionId.toLowerCase() ==
                    selectedSessionId.value.toLowerCase();

                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _buildSessionChip(
                    context,
                    session: sessionItem,
                    isSelected: isSelected,
                    onTap: () =>
                        selectedSessionId.value = sessionItem.sessionId,
                  ),
                );
              }).toList(),
            ),
          ),
        Gap.v24(),

        // Session header details: title, duration, focus muscles
        Row(
          children: [
            Expanded(
              child: Text(
                currentSession.title.isNotEmpty
                    ? currentSession.title
                    : context.tr.workoutSessionTitle(
                        currentSession.sessionNumber,
                      ),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cTextPrimary,
                ),
              ),
            ),
            if (currentSession.durationMin > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cSurfaceElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cBorder.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 15,
                      color: cPrimary,
                    ),
                    Gap.h4(),
                    Text(
                      PersianDigits.toPersian(
                        context.tr.workoutDuration(currentSession.durationMin),
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        if (currentSession.focus.isNotEmpty) ...[
          Gap.v8(),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                context.tr.workoutFocusMuscles,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ...currentSession.focus.map((muscle) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: cPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    muscle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),
        ],

        Gap.v16(),

        // Exercise sections (warmup / main / cooldown)
        if (currentSession.warmup.isNotEmpty)
          _buildSection(
            context,
            title: context.tr.workoutWarmup,
            icon: Icons.whatshot_outlined,
            color: const Color(0xFFE67E22),
            exercises: currentSession.warmup,
            sessionId: currentSession.sessionId,
          ),
        if (currentSession.main.isNotEmpty)
          _buildSection(
            context,
            title: context.tr.workoutMain,
            icon: Icons.fitness_center_rounded,
            color: cPrimary,
            exercises: currentSession.main,
            sessionId: currentSession.sessionId,
          ),
        if (currentSession.cooldown.isNotEmpty)
          _buildSection(
            context,
            title: context.tr.workoutCooldown,
            icon: Icons.ac_unit_rounded,
            color: const Color(0xFF3498DB),
            exercises: currentSession.cooldown,
            sessionId: currentSession.sessionId,
          ),
      ],
    );
  }

  Widget _buildSessionChip(
    BuildContext context, {
    required WorkoutSession session,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final label = context.tr.workoutSessionTitle(session.sessionNumber);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? cPrimary : cSurface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: cBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : cTextPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<WorkoutExerciseItem> exercises,
    required String sessionId,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              Gap.h8(),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cTextPrimary,
                ),
              ),
              Gap.h8(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  PersianDigits.toPersian(exercises.length.toString()),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...exercises.map((exercise) {
          final isSwapping = swappingItemId == exercise.itemId;
          final canSwap = plan.remainingExerciseSwaps > 0;

          return WorkoutExerciseCard(
            exercise: exercise,
            readOnly: readOnly,
            canSwap: canSwap,
            isSwapping: isSwapping,
            onSwap: onSwapExercise != null
                ? () => onSwapExercise!(sessionId, exercise)
                : null,
          );
        }),
        Gap.v12(),
      ],
    );
  }
}

// Deprecated alias for backwards compatibility
typedef WorkoutDaySection = WorkoutSessionSection;
