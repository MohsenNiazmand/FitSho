import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/features/workout/domain/entities/workout_entities.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_exercise_card.dart';
import 'package:fitsho/features/workout/presentation/widgets/workout_rest_day_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class WorkoutDaySection extends HookWidget {
  const WorkoutDaySection({
    required this.plan,
    this.initialDay,
    this.readOnly = false,
    this.swappingItemId,
    this.onSwapExercise,
    super.key,
  });

  final WorkoutPlan plan;
  final String? initialDay;
  final bool readOnly;
  final String? swappingItemId;
  final void Function(String day, WorkoutExerciseItem item)? onSwapExercise;

  static const List<String> orderedDays = [
    'saturday',
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayKey = DietConstants.todayKey();

    // Sort plan days to follow Saturday-first week order
    final sortedDays = useMemoized(() {
      final days = List<WorkoutDay>.from(plan.days)
        ..sort((a, b) {
          final indexA = orderedDays.indexOf(a.day.toLowerCase());
          final indexB = orderedDays.indexOf(b.day.toLowerCase());
          final orderA = indexA == -1 ? 99 : indexA;
          final orderB = indexB == -1 ? 99 : indexB;
          return orderA.compareTo(orderB);
        });
      return days;
    }, [plan.days]);

    final initialDayKey = initialDay ??
        (sortedDays.any((d) => d.day.toLowerCase() == todayKey)
            ? todayKey
            : sortedDays.isNotEmpty
                ? sortedDays.first.day
                : 'saturday');

    final selectedDay = useState(initialDayKey);

    final currentDay = sortedDays.firstWhere(
      (d) => d.day.toLowerCase() == selectedDay.value.toLowerCase(),
      orElse: () => sortedDays.isNotEmpty
          ? sortedDays.first
          : WorkoutDay(
              day: selectedDay.value,
              isRest: true,
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
        // Day chips: Saturday-first, today highlighted, rest days styled
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: sortedDays.map((dayItem) {
              final isSelected =
                  dayItem.day.toLowerCase() == selectedDay.value.toLowerCase();
              final isToday = dayItem.day.toLowerCase() == todayKey;
              final isRest = dayItem.isRest;

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildDayChip(
                  context,
                  day: dayItem,
                  isSelected: isSelected,
                  isToday: isToday,
                  isRest: isRest,
                  onTap: () => selectedDay.value = dayItem.day,
                ),
              );
            }).toList(),
          ),
        ),
        Gap.v24(),

        // Day header details: title, duration, focus muscles
        Row(
          children: [
            Expanded(
              child: Text(
                currentDay.title.isNotEmpty
                    ? currentDay.title
                    : dietDayLabel(context, currentDay.day),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cTextPrimary,
                ),
              ),
            ),
            if (currentDay.durationMin > 0) ...[
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
                        context.tr.workoutDuration(currentDay.durationMin),
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

        if (currentDay.focus.isNotEmpty) ...[
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
              ...currentDay.focus.map((muscle) {
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

        // Rest Day or Exercise sections (warmup / main / cooldown)
        if (currentDay.isRest)
          const WorkoutRestDayView()
        else ...[
          if (currentDay.warmup.isNotEmpty)
            _buildSection(
              context,
              title: context.tr.workoutWarmup,
              icon: Icons.whatshot_outlined,
              color: const Color(0xFFE67E22),
              exercises: currentDay.warmup,
              day: currentDay.day,
            ),
          if (currentDay.main.isNotEmpty)
            _buildSection(
              context,
              title: context.tr.workoutMain,
              icon: Icons.fitness_center_rounded,
              color: cPrimary,
              exercises: currentDay.main,
              day: currentDay.day,
            ),
          if (currentDay.cooldown.isNotEmpty)
            _buildSection(
              context,
              title: context.tr.workoutCooldown,
              icon: Icons.ac_unit_rounded,
              color: const Color(0xFF3498DB),
              exercises: currentDay.cooldown,
              day: currentDay.day,
            ),
        ],
      ],
    );
  }

  Widget _buildDayChip(
    BuildContext context, {
    required WorkoutDay day,
    required bool isSelected,
    required bool isToday,
    required bool isRest,
    required VoidCallback onTap,
  }) {
    final dayTitle = dietDayLabel(context, day.day);

    Color backgroundColor;
    Color textColor;
    Border? border;

    if (isSelected) {
      backgroundColor = cPrimary;
      textColor = Colors.white;
    } else if (isRest) {
      backgroundColor = cSurfaceElevated.withValues(alpha: 0.6);
      textColor = cTextSecondary.withValues(alpha: 0.7);
      border = Border.all(color: cBorder.withValues(alpha: 0.5));
    } else {
      backgroundColor = cSurface;
      textColor = cTextPrimary;
      border = Border.all(color: cBorder);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: isToday && !isSelected
              ? Border.all(color: cPrimary, width: 1.5)
              : border,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayTitle,
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (isToday) ...[
              const SizedBox(height: 2),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : cPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
            if (isRest && !isToday) ...[
              const SizedBox(height: 2),
              Text(
                context.tr.workoutRestShort,
                style: TextStyle(
                  color: isSelected ? Colors.white70 : cTextHint,
                  fontSize: 9,
                ),
              ),
            ],
          ],
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
    required String day,
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
                ? () => onSwapExercise!(day, exercise)
                : null,
          );
        }),
        Gap.v12(),
      ],
    );
  }
}
