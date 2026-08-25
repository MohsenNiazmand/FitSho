import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/preferences/presentation/providers/preferences_providers.dart';
import 'package:fitsho/features/preferences/presentation/widgets/preference_chip_section.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_outlined_button.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/error_retry_view.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class PreferencesScreen extends HookConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(preferencesLoadNotifierProvider);
    final saveState = ref.watch(savePreferencesNotifierProvider);
    final deleteState = ref.watch(deletePreferencesNotifierProvider);
    final selectedDietary = useState<Set<String>>({});
    final selectedCuisines = useState<Set<String>>({});
    final hasExistingPreferences = useState(false);
    final isBusy = saveState.isLoading || deleteState.isLoading;
    final theme = Theme.of(context);

    useEffect(
      () {
        preferencesAsync.whenData((preference) {
          if (preference == null) {
            hasExistingPreferences.value = false;
            selectedDietary.value = {};
            selectedCuisines.value = {};
            return;
          }

          hasExistingPreferences.value = true;
          selectedDietary.value = preference.dietaryRestrictions.toSet();
          selectedCuisines.value = preference.preferredCuisines.toSet();
        });
        return null;
      },
      [preferencesAsync],
    );

    Future<void> savePreferences() async {
      final failure = await ref
          .read(savePreferencesNotifierProvider.notifier)
          .save(
            dietaryRestrictions: selectedDietary.value.toList(),
            preferredCuisines: selectedCuisines.value.toList(),
          );

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        return;
      }

      hasExistingPreferences.value = true;
      showSuccessToast(context.tr.preferencesSavedSuccess);
    }

    Future<void> confirmDelete() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(context.tr.deletePreferencesTitle),
            content: Text(context.tr.deletePreferencesConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(context.tr.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(context.tr.confirm),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !context.mounted) return;

      final failure =
          await ref.read(deletePreferencesNotifierProvider.notifier).delete();

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        return;
      }

      selectedDietary.value = {};
      selectedCuisines.value = {};
      hasExistingPreferences.value = false;
      showSuccessToast(context.tr.preferencesDeletedSuccess);
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.preferencesTitle)),
      body: preferencesAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) {
          final message =
              error is StateError ? error.message : context.tr.genericError;

          return ErrorRetryView(
            message: message,
            onRetry: () {
              ref.invalidate(preferencesLoadNotifierProvider);
            },
          );
        },
        data: (_) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.tr.preferencesSubtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (!hasExistingPreferences.value) ...[
                          Gap.v12(),
                          Text(
                            context.tr.preferencesEmptyHint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        Gap.v24(),
                        PreferencesFormBody(
                          dietarySectionTitle:
                              context.tr.dietaryRestrictionsSection,
                          cuisineSectionTitle:
                              context.tr.preferredCuisinesSection,
                          selectedDietary: selectedDietary.value,
                          selectedCuisines: selectedCuisines.value,
                          onDietaryChanged: (value) {
                            selectedDietary.value = value;
                          },
                          onCuisinesChanged: (value) {
                            selectedCuisines.value = value;
                          },
                          enabled: !isBusy,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppPrimaryButton(
                        label: context.tr.savePreferences,
                        isLoading: saveState.isLoading,
                        onPressed: isBusy ? null : savePreferences,
                      ),
                      if (hasExistingPreferences.value) ...[
                        Gap.v12(),
                        AppOutlinedButton(
                          label: context.tr.deletePreferences,
                          isLoading: deleteState.isLoading,
                          foregroundColor: theme.colorScheme.error,
                          onPressed: isBusy ? null : confirmDelete,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
