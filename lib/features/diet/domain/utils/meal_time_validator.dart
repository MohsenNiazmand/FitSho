import 'package:fitsho/features/diet/domain/entities/diet_entities.dart';
import 'package:fitsho/features/diet/domain/utils/meal_time_utils.dart';
import 'package:fitsho/features/diet/presentation/utils/diet_labels.dart';
import 'package:fitsho/l10n/app_localizations.dart';

/// Outcome of [MealTimeValidator.validate].
///
/// Modelled as a tiny result type (rather than throwing) so callers can
/// decide how to surface the failure — a toast, an inline form error, etc.
sealed class MealTimeValidationResult {
  const MealTimeValidationResult();

  const factory MealTimeValidationResult.valid() = MealTimesValid;

  const factory MealTimeValidationResult.invalid(String message) =
      MealTimesInvalid;
}

class MealTimesValid extends MealTimeValidationResult {
  const MealTimesValid();
}

class MealTimesInvalid extends MealTimeValidationResult {
  const MealTimesInvalid(this.message);

  final String message;
}

/// Validates the chronological ordering and spacing of a user's meal time
/// settings before they're persisted.
abstract final class MealTimeValidator {
  /// The minimum gap required between any two consecutive active meals.
  static const Duration minimumGap = Duration(hours: 1);

  /// Checks that every *enabled* slot in [slots] — visited in [orderedKeys]
  /// order (i.e. `DietConstants.mealSlotKeys`) — is:
  ///   1. Strictly later than the previous enabled slot, and
  ///   2. At least [minimumGap] after the previous enabled slot.
  ///
  /// Disabled slots are skipped entirely — they don't participate in the
  /// ordering/gap checks and don't need a reminder scheduled.
  ///
  /// [tr] provides localized user-facing error messages.
  /// [labelOf] optionally customizes how slot keys are converted to labels.
  static MealTimeValidationResult validate({
    required Map<String, MealSlotConfig> slots,
    required List<String> orderedKeys,
    required AppLocalizations tr,
    String Function(String slotKey)? labelOf,
  }) {
    final activeSlots = orderedKeys
        .where((key) => slots[key]?.enabled ?? false)
        .map(
          (key) => (
            key: key,
            time: MealTimeUtils.parseTimeOfDay(slots[key]!.time),
          ),
        )
        .toList();

    for (var i = 1; i < activeSlots.length; i++) {
      final previous = activeSlots[i - 1];
      final current = activeSlots[i];

      final previousMinutes = MealTimeUtils.minutesSinceMidnight(
        previous.time,
      );
      final currentMinutes = MealTimeUtils.minutesSinceMidnight(current.time);

      final prevLabel = labelOf != null
          ? labelOf(previous.key)
          : dietMealSlotLabelTr(tr, previous.key);
      final currLabel = labelOf != null
          ? labelOf(current.key)
          : dietMealSlotLabelTr(tr, current.key);

      if (currentMinutes == previousMinutes) {
        return MealTimeValidationResult.invalid(
          tr.dietMealTimeSameError(prevLabel, currLabel),
        );
      }

      if (currentMinutes < previousMinutes) {
        return MealTimeValidationResult.invalid(
          tr.dietMealTimeOrderError(currLabel, prevLabel),
        );
      }

      if (currentMinutes - previousMinutes < minimumGap.inMinutes) {
        return MealTimeValidationResult.invalid(
          tr.dietMealTimeGapError(prevLabel, currLabel),
        );
      }
    }

    return const MealTimeValidationResult.valid();
  }
}
