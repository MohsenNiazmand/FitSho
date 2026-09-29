import 'package:flutter/material.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:fitsho/config/theme/app_radius.dart';

class MedicalSafetyWarningCard extends StatelessWidget {
  const MedicalSafetyWarningCard({
    super.key,
    this.customMessage,
  });

  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.08),
        border: Border.all(
          color: errorColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
        borderRadius: AppRadius.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              color: errorColor,
              size: 24,
            ),
          ),
          Gap.h12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.workoutMedicalReferralTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: errorColor,
                  ),
                ),
                Gap.v4(),
                Text(
                  customMessage ?? context.tr.workoutMedicalReferralWarning,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    height: 1.5,
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
