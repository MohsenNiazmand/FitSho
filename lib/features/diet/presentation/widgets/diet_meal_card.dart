import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class DietMealCard extends StatelessWidget {
  const DietMealCard({
    required this.slot,
    required this.meal,
    required this.day,
    required this.isHighlighted,
    required this.isLogging,
    this.isLogged = false,
    required this.onLogMeal,
    super.key,
  });

  final String slot;
  final String day;
  final DietMeal meal;
  final bool isHighlighted;
  final bool isLogging;
  final bool isLogged;
  final VoidCallback? onLogMeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: isLogged ? cSuccess.withValues(alpha: 0.05) : cSurface,
        border: Border.all(
          color: isHighlighted
              ? cPrimary
              : isLogged
                  ? cSuccess.withValues(alpha: 0.5)
                  : cBorder.withValues(alpha: 0.85),
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isLogged
                ? cSuccess.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: isLogged ? 24 : 18,
            spreadRadius: isLogged ? 1 : 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              meal.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cTextPrimary,
              ),
            ),
            if (meal.description != null && meal.description!.isNotEmpty) ...[
              Gap.v8(),
              Text(
                meal.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cTextSecondary,
                  height: 1.5,
                ),
              ),
            ],
            if (meal.ingredients.isNotEmpty) ...[
              Gap.v12(),
              Text(
                context.tr.dietIngredientsTitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap.v6(),
              ...meal.ingredients.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${item.name} — ${PersianDigits.toPersian(item.amount)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cTextSecondary,
                    ),
                  ),
                ),
              ),
            ],
            Gap.v12(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MacroChip(
                  label: context.tr.dietCaloriesShort(
                    PersianDigits.toPersian(meal.calories.toString()),
                  ),
                ),
                _MacroChip(
                  label: context.tr.dietProteinShort(
                    PersianDigits.toPersian(meal.proteinG.toStringAsFixed(0)),
                  ),
                ),
                _MacroChip(
                  label: context.tr.dietCarbsShort(
                    PersianDigits.toPersian(meal.carbsG.toStringAsFixed(0)),
                  ),
                ),
                _MacroChip(
                  label: context.tr.dietFatShort(
                    PersianDigits.toPersian(meal.fatG.toStringAsFixed(0)),
                  ),
                ),
              ],
            ),
            Gap.v12(),
            FilledButton(
              onPressed: (isLogging || isLogged)
                  ? null
                  : () {
                      HapticFeedback.mediumImpact();
                      onLogMeal?.call();
                    },
              style: isLogged
                  ? FilledButton.styleFrom(
                      backgroundColor: cSuccess.withValues(alpha: 0.1),
                      foregroundColor: cSuccess,
                    )
                  : null,
              child: isLogging
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isLogged ? 'خورده شد ✓' : context.tr.dietIAteThis),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cSurfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cBorder.withValues(alpha: 0.75)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: cTextSecondary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
