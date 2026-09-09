/// Where a single meal slot stands right now with respect to the
/// "I Ate This" button.
///
/// Ordering in the UI is typically: [locked] -> [ready] -> [delayed] ->
/// [eaten], with [missed] as a terminal dead-end once the meal's calendar
/// day has fully elapsed without a log.
enum MealStatus {
  /// Too early to log. The button is disabled (e.g. shows a lock icon /
  /// countdown) until [getMealStatus] reports [ready] or later.
  locked,

  /// Within the actionable window and on time — button is enabled and
  /// looks like a normal call to action.
  ready,

  /// Actionable, but more than [MealTimeWindow.delayedAfter] past the
  /// scheduled time. The button stays clickable; the UI should additionally
  /// surface a "Delayed / Forgot to log?" hint.
  delayed,

  /// A meal log already exists for this slot on this day. Terminal state.
  eaten,

  /// The meal's scheduled day has fully elapsed (it is now the next
  /// calendar day or later) and it was never logged. Terminal state — the
  /// button becomes permanently disabled for that day.
  missed,
}

/// Tunable thresholds that drive [getMealStatus].
abstract final class MealTimeWindow {
  /// The button may unlock at most this long before the scheduled meal
  /// time.
  static const Duration maxEarlyUnlock = Duration(hours: 2);

  /// How long after the scheduled meal time the meal is still considered
  /// "on time" before the UI starts flagging it as [MealStatus.delayed].
  static const Duration delayedAfter = Duration(hours: 1);
}

/// Computes the current [MealStatus] for one meal slot.
///
/// This is a pure function of its inputs so it is trivial to unit test and
/// to drive from a periodic UI timer (e.g. `Timer.periodic` ticking a
/// Riverpod provider every minute) without touching `DateTime.now()`
/// directly inside widgets.
///
/// - [currentTime]: "now" — injected rather than read internally so callers
///   (and tests) control it explicitly.
/// - [mealTime]: the scheduled date/time for this meal slot, already
///   combined with the calendar day it belongs to (see
///   `combineDayAndTime` in `meal_time_utils.dart`).
/// - [previousMealTime]: the scheduled date/time of the meal slot
///   immediately before this one on the same day, or `null` if this is the
///   first active meal of the day.
/// - [isEaten]: whether a log already exists for this slot/day pair.
MealStatus getMealStatus(
  DateTime currentTime,
  DateTime mealTime,
  DateTime? previousMealTime,
  bool isEaten,
) {
  // 1. Already logged — nothing else matters.
  if (isEaten) {
    return MealStatus.eaten;
  }

  // 5. Missed: the meal's calendar day has fully rolled over (it is now
  // midnight or later of the *next* day relative to when the meal was
  // scheduled) and it was never logged. Same-day logging is always allowed
  // no matter how late, per the "never locks same day" rule — this check
  // must run before the locked/ready/delayed window below.
  final startOfNextDay = DateTime(
    mealTime.year,
    mealTime.month,
    mealTime.day + 1,
  );
  if (!currentTime.isBefore(startOfNextDay)) {
    return MealStatus.missed;
  }

  // 2. Locked: unlock at most 2 hours before mealTime, but never earlier
  // than the midpoint between the previous meal and this one — whichever
  // of the two candidate instants is *closer* to mealTime (i.e. later)
  // wins, so a tightly-packed schedule doesn't unlock a meal while the
  // previous one is still "current".
  final unlockAt = _unlockTime(mealTime, previousMealTime);
  if (currentTime.isBefore(unlockAt)) {
    return MealStatus.locked;
  }

  // 4. Delayed: actionable, but noticeably late.
  if (currentTime.isAfter(mealTime.add(MealTimeWindow.delayedAfter))) {
    return MealStatus.delayed;
  }

  // 3. Ready: actionable and on time.
  return MealStatus.ready;
}

/// The earliest instant the "I Ate This" button may unlock for [mealTime],
/// given the previous active meal's scheduled time (if any).
DateTime _unlockTime(DateTime mealTime, DateTime? previousMealTime) {
  final earliestByFixedWindow = mealTime.subtract(
    MealTimeWindow.maxEarlyUnlock,
  );

  if (previousMealTime == null) {
    return earliestByFixedWindow;
  }

  final gap = mealTime.difference(previousMealTime);
  final midpoint = previousMealTime.add(gap ~/ 2);

  // "Whichever is closer" to mealTime among the two candidates: pick the
  // later (larger) of the two instants.
  return earliestByFixedWindow.isAfter(midpoint)
      ? earliestByFixedWindow
      : midpoint;
}
