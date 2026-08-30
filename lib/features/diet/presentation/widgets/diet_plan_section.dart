import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/presentation/providers/diet_providers.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/features/diet/presentation/widgets/diet_meal_card.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class DietPlanSection extends HookConsumerWidget {
  const DietPlanSection({
    required this.plan,
    required this.highlightDay,
    required this.highlightSlot,
    required this.onLogMeal,
    this.onHighlightHandled,
    super.key,
  });

  final DietPlan plan;
  final String? highlightDay;
  final String? highlightSlot;
  final void Function(String day, String slot) onLogMeal;
  final VoidCallback? onHighlightHandled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayLogs = ref.watch(todayMealLogsNotifierProvider).value ?? [];
    final dayKeys = orderedDayKeys();
    final todayKey = DietConstants.todayKey();
    final selectedDay = useState(highlightDay ?? todayKey);

    final mealCardKeys = useMemoized(
      () => {for (final slot in orderedMealSlotKeys()) slot: GlobalKey()},
    );

    useEffect(() {
      if (highlightDay != null) {
        selectedDay.value = highlightDay!;
      }
      return null;
    }, [highlightDay]);

    useEffect(() {
      if (highlightSlot != null && highlightDay == selectedDay.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final key = mealCardKeys[highlightSlot];
          if (key?.currentContext != null) {
            Scrollable.ensureVisible(
              key!.currentContext!,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              alignment: 0.1,
            );
            onHighlightHandled?.call();
          }
        });
      }
      return null;
    }, [highlightSlot, selectedDay.value]);

    // Fallback: if the highlighted day/slot has no meal at all, the meal
    // card never builds and the scroll-based handler above never fires,
    // which would leave stale highlight/navigation state around. Clear it
    // explicitly in that case instead of waiting for a card that will
    // never render.
    useEffect(() {
      if (highlightDay != null && highlightSlot != null) {
        final matchingDays = plan.days.where((day) => day.day == highlightDay);
        final targetDay = matchingDays.isEmpty ? null : matchingDays.first;
        final hasMeal = targetDay?.meals[highlightSlot] != null;
        if (!hasMeal) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onHighlightHandled?.call();
          });
        }
      }
      return null;
    }, [highlightDay, highlightSlot, plan]);

    final currentDay = plan.days.firstWhere(
      (day) => day.day == selectedDay.value,
      orElse: () => plan.days.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr.dietDailyCalorieTarget(
            PersianDigits.toPersian(plan.dailyCalorieTarget.toString()),
          ),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: cTextSecondary),
        ),
        Gap.v16(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final dayKey in dayKeys)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(dietDayLabel(context, dayKey)),
                    selected: selectedDay.value == dayKey,
                    onSelected: (_) => selectedDay.value = dayKey,
                    side: dayKey == todayKey
                        ? const BorderSide(color: cPrimary, width: 1.5)
                        : null,
                    labelStyle: dayKey == todayKey
                        ? TextStyle(
                            fontWeight: FontWeight.w700,
                            color: selectedDay.value == dayKey
                                ? null
                                : cPrimary,
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
        Gap.v16(),
        for (final slot in orderedMealSlotKeys())
          if (currentDay.meals[slot] != null)
            DietMealCard(
              key: mealCardKeys[slot],
              slot: slot,
              day: currentDay.day,
              meal: currentDay.meals[slot]!,
              isHighlighted:
                  highlightDay == currentDay.day && highlightSlot == slot,
              isLogging: false,
              isLogged: todayLogs.any(
                (log) => log.day == currentDay.day && log.slot == slot,
              ),
              canLog: currentDay.day == todayKey,
              onLogMeal: () => onLogMeal(currentDay.day, slot),
            ),
      ],
    );
  }
}
