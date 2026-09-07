import 'dart:math';

import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/config/theme/app_shadows.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';

class HealthStatCard extends StatelessWidget {
  const HealthStatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.accentColor,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? cPrimary;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          Gap.v12(),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: cTextPrimary,
            ),
          ),
          Gap.v4(),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: cTextSecondary),
          ),
        ],
      ),
    );
  }
}

String bmiStatusLabel(BuildContext context, double bmi) {
  if (bmi < 18.5) return context.tr.dietBmiUnderweight;
  if (bmi < 25) return context.tr.dietBmiNormal;
  if (bmi < 30) return context.tr.dietBmiOverweight;
  return context.tr.dietBmiObesity;
}

Color bmiStatusColor(double bmi) {
  if (bmi < 18.5) return Colors.blue;
  if (bmi < 25) return cSuccess;
  if (bmi < 30) return cWarning;
  return cError;
}

class CalorieProgressRing extends StatelessWidget {
  const CalorieProgressRing({
    required this.target,
    required this.consumed,
    super.key,
  });

  final int target;
  final int consumed;

  @override
  Widget build(BuildContext context) {
    final remaining = target - consumed;
    final progress = min(1.0, consumed / target);
    final theme = Theme.of(context);
    final isCompleted = consumed >= (target - 10);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cSurface,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 92,
                height: 92,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value,
                    strokeWidth: 9,
                    backgroundColor: cPrimary.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation(cPrimary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap.h20(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.dietDailyCalorieTargetLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: cTextSecondary,
                  ),
                ),
                Gap.v4(),
                Text(
                  '${PersianDigits.toPersian(target.toString())} کیلوکالری',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cTextPrimary,
                  ),
                ),
                Gap.v8(),
                Text(
                  isCompleted
                      ? context.tr.dietCalorieGoalCompleted
                      : context.tr.dietCaloriesRemaining(
                          PersianDigits.toPersian(remaining.toString()),
                        ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cSuccess,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ComplianceRing extends StatelessWidget {
  const ComplianceRing({
    required this.rate,
    super.key,
  });

  final double rate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeRate = rate.isFinite ? rate : 0.0;
    final percentage = safeRate.toInt();
    final isHigh = percentage >= 80;
    final mainColor = isHigh ? Colors.amber.shade700 : cWarning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: safeRate / 100),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutBack,
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value.clamp(0.0, 1.0),
                    strokeWidth: 6,
                    backgroundColor: mainColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(mainColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percentage.toDouble()),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, _) => Text(
                  '${PersianDigits.toPersian(value.toInt().toString())}٪',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ),
            ],
          ),
          Gap.h16(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.dietComplianceLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cTextPrimary,
                  ),
                ),
                Gap.v4(),
                Text(
                  isHigh
                      ? context.tr.dietComplianceHigh
                      : context.tr.dietComplianceLow,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RegenerationBanner extends StatelessWidget {
  const RegenerationBanner({
    required this.onGenerate,
    required this.isLoading,
    super.key,
  });

  final VoidCallback onGenerate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cSurface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.amber),
          Gap.h12(),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.dietWeightChangedTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  context.tr.dietWeightChangedSubtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Gap.h8(),
          TextButton(
            onPressed: isLoading ? null : onGenerate,
            style: TextButton.styleFrom(
              backgroundColor: Colors.amber.shade200,
              foregroundColor: Colors.amber.shade900,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.amber),
                    ),
                  )
                : Text(context.tr.dietRegenerateButton),
          ),
        ],
      ),
    );
  }
}
