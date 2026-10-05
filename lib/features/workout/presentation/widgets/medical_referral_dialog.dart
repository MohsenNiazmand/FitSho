import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';

class MedicalReferralDialog extends StatelessWidget {
  const MedicalReferralDialog({required this.message, super.key});

  final String message;

  static Future<void> show(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => MedicalReferralDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            Gap.v24(),
            Text(
              context.tr.workoutMedicalReferralTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            Gap.v12(),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            Gap.v24(),
            AppPrimaryButton(
              label: context.tr.workoutMedicalReferralDialogGotIt,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
