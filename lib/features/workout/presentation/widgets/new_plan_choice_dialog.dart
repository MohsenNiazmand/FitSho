import 'package:flutter/material.dart';

import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

enum NewPlanChoiceAction { generateCurrent, editDetails }

class NewPlanChoiceDialog extends StatelessWidget {
  const NewPlanChoiceDialog({super.key});

  static Future<NewPlanChoiceAction?> show(BuildContext context) {
    return showModalBottomSheet<NewPlanChoiceAction>(
      context: context,
      backgroundColor: cSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const NewPlanChoiceDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Gap.v16(),
            Text(
              context.tr.workoutNewPlanChoiceTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap.custom(height: 20),
            AppPrimaryButton(
              label: context.tr.workoutNewPlanChoiceUseCurrent,
              onPressed: () => Navigator.of(
                context,
              ).pop(NewPlanChoiceAction.generateCurrent),
            ),
            Gap.v12(),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: const BorderSide(color: cPrimary),
              ),
              onPressed: () =>
                  Navigator.of(context).pop(NewPlanChoiceAction.editDetails),
              child: Text(
                context.tr.workoutNewPlanChoiceEdit,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: cPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
