import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({required this.updateUrl, super.key});

  final String updateUrl;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(context.tr.forceUpdateTitle),
        content: Text(context.tr.forceUpdateMessage),
        actions: [
          FilledButton(
            onPressed: () async {
              final uri = Uri.parse(updateUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text(context.tr.updateNow),
          ),
        ],
      ),
    );
  }
}

class OptionalUpdateDialog extends StatelessWidget {
  const OptionalUpdateDialog({required this.updateUrl, super.key});

  final String updateUrl;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.optionalUpdateTitle),
      content: Text(context.tr.optionalUpdateMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.tr.later),
        ),
        FilledButton(
          onPressed: () async {
            final uri = Uri.parse(updateUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text(context.tr.updateNow),
        ),
      ],
    );
  }
}
