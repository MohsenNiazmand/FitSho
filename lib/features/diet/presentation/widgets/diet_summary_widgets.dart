import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class BmiStatusCard extends StatelessWidget {
  const BmiStatusCard({
    required this.bmi,
    super.key,
  });

  final double bmi;

  String get _statusLabel {
    if (bmi < 18.5) return 'کمبود وزن';
    if (bmi < 25) return 'وزن نرمال';
    if (bmi < 30) return 'اضافه وزن';
    return 'چاقی';
  }

  Color get _statusColor {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return cSuccess;
    if (bmi < 30) return cWarning;
    return cError;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cSurface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: cBorder.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'وضعیت سلامت (BMI)',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: cTextSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _statusLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          Gap.v12(),
          Row(
            children: [
              Text(
                PersianDigits.toPersian(bmi.toStringAsFixed(1)),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cTextPrimary,
                    ),
              ),
              Gap.h12(),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (bmi - 15) / 25, // Assuming range 15-40
                    backgroundColor: cBorder.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation(_statusColor),
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
        color: cPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        border: Border.all(color: cPrimary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: cPrimary.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation(cPrimary),
                  strokeCap: StrokeCap.round,
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
    final bgColor = isHigh ? Colors.amber.shade50 : cSurfaceElevated;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isHigh ? Colors.amber.shade200 : cBorder.withValues(alpha: 0.8),
        ),
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
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: Colors.amber.shade200),
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
