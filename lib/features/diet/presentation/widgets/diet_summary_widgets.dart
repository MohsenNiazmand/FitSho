import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/config/theme/app_shadows.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

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

String bmiStatusLabel(double bmi) {
  if (bmi < 18.5) return 'کمبود وزن';
  if (bmi < 25) return 'نرمال';
  if (bmi < 30) return 'اضافه وزن';
  return 'چاقی';
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
                  'هدف کالری روزانه',
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
                  remaining > 0
                      ? '${PersianDigits.toPersian(remaining.toString())} کالری باقی‌مانده'
                      : 'بیش از حد مصرف شده!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: remaining > 0 ? cSuccess : cError,
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
    final percentage = (rate * 100).toInt();
    final isHigh = rate >= 0.8;
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
                child: CircularProgressIndicator(
                  value: rate,
                  strokeWidth: 6,
                  backgroundColor: mainColor.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation(mainColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Text(
                '${PersianDigits.toPersian(percentage.toString())}٪',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: mainColor,
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
                  'پایبندی به رژیم',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cTextPrimary,
                  ),
                ),
                Gap.v4(),
                Text(
                  isHigh
                      ? 'عالیه! همینجوری ادامه بده 🏆'
                      : 'کمی بیشتر تلاش کن، تو می‌تونی! 💪',
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
                const Text(
                  'وزن شما تغییر کرده است!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'مایلید برنامه جدیدی بر اساس مشخصات جدیدتان تولید شود؟',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
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
                : const Text('تولید برنامه جدید'),
          ),
        ],
      ),
    );
  }
}
