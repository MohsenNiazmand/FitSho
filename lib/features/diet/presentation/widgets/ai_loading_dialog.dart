import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fitsho/core/constants/app_assets.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class AiLoadingDialog extends StatelessWidget {
  const AiLoadingDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AiLoadingDialog(),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AppAssets.aiLoading,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              Gap.v24(),
              Text(
                context.tr.aiGeneratingPlanTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap.v12(),
              Text(
                context.tr.aiGeneratingPlanMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
