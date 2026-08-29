import 'package:flutter/material.dart';
import 'package:fitsho/shared/presentation/widgets/app_icon_badge.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.message,
    this.icon,
    this.imagePath,
    this.subtitle,
    super.key,
  }) : assert(
         icon != null || imagePath != null,
         'Provide either icon or imagePath',
       );

  final IconData? icon;
  final String? imagePath;
  final String message;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(imagePath!, width: 160, height: 160)
            else
              AppIconBadge(icon: icon!, size: 80),
            Gap.v16(),
            Text(
              message,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              Gap.v8(),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
