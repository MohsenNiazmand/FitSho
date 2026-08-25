import 'package:flutter/material.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class LastMealCard extends StatelessWidget {
  const LastMealCard({
    required this.mealLog,
    super.key,
  });

  final MealLog mealLog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: cSurface,
        border: Border.all(color: cBorder.withValues(alpha: 0.85)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.dietLastMealTitle,
            style: theme.textTheme.labelLarge?.copyWith(
              color: cPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap.v8(),
          Text(
            mealLog.mealTitle ?? context.tr.dietUnknownMeal,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap.v4(),
          Text(
            '${dietDayLabel(context, mealLog.day)} • ${dietMealSlotLabel(context, mealLog.slot)}',
            style: theme.textTheme.bodySmall?.copyWith(color: cTextHint),
          ),
        ],
      ),
    );
  }
}
