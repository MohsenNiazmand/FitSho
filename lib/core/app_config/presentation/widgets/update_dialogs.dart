import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';

class ForceUpdateDialog extends StatelessWidget {
  const ForceUpdateDialog({
    required this.updateUrl,
    this.releaseNotes = const [],
    super.key,
  });

  final String updateUrl;
  final List<String> releaseNotes;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(context.tr.forceUpdateTitle),
        content: _UpdateContent(
          message: context.tr.forceUpdateMessage,
          releaseNotes: releaseNotes,
        ),
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
  const OptionalUpdateDialog({
    required this.updateUrl,
    this.releaseNotes = const [],
    super.key,
  });

  final String updateUrl;
  final List<String> releaseNotes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr.optionalUpdateTitle),
      content: _UpdateContent(
        message: context.tr.optionalUpdateMessage,
        releaseNotes: releaseNotes,
      ),
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

class _UpdateContent extends StatelessWidget {
  const _UpdateContent({required this.message, required this.releaseNotes});

  final String message;
  final List<String> releaseNotes;

  @override
  Widget build(BuildContext context) {
    if (releaseNotes.isEmpty) return Text(message);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          const SizedBox(height: 12),
          Text(
            context.tr.updateWhatsNew,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          for (final note in releaseNotes)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('• $note'),
            ),
        ],
      ),
    );
  }
}
