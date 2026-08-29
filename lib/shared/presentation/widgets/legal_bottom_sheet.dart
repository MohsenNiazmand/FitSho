import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';

class LegalBottomSheet extends StatelessWidget {
  const LegalBottomSheet({
    required this.title,
    required this.content,
    super.key,
  });

  final String title;
  final String content;

  static void show(BuildContext context, {required String title, required String content}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LegalBottomSheet(title: title, content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Gap.v24(),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.start,
          ),
          Gap.v16(),
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                content,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Gap.v24(),
          AppPrimaryButton(
            label: context.tr.gotIt,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
