import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/autostart_helper.dart';
import 'package:flutter/material.dart';

class AutoStartPromptDialog extends StatelessWidget {
  const AutoStartPromptDialog({super.key});

  /// Displays the dialog if the context is mounted.
  static Future<void> show(BuildContext context) async {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AutoStartPromptDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Dialog(
      backgroundColor: cSurface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.card,
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon header with soft primary container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: cPrimary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.alarm_on_rounded,
                size: 34,
                color: cPrimary,
              ),
            ),
            const SizedBox(height: 18),
            // Title
            Text(
              tr.autostartPromptTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: cTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            // Body description
            Text(
              tr.autostartPromptBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: cTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            // Primary Button: Enable
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () async {
                  await AutoStartHelper.markPromptAsShown();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  await AutoStartHelper.openAutoStartSettings();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: cPrimary,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.button,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  tr.autostartPromptEnable,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Secondary Button: Later
            SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                onPressed: () async {
                  await AutoStartHelper.markPromptAsShown();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: cTextHint,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.button,
                  ),
                ),
                child: Text(
                  tr.autostartPromptLater,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
