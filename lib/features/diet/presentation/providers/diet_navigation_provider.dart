import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diet_navigation_provider.g.dart';

class DietNavigationTarget {
  const DietNavigationTarget({
    this.highlightDay,
    this.highlightSlot,
    this.openSupplements = false,
    this.openWeeklyPlan = false,
  });

  final String? highlightDay;
  final String? highlightSlot;
  final bool openSupplements;
  final bool openWeeklyPlan;
}

@Riverpod(keepAlive: true)
class DietNavigationNotifier extends _$DietNavigationNotifier {
  @override
  DietNavigationTarget? build() => null;

  void openMealReminder({
    required String day,
    required String slot,
  }) {
    state = DietNavigationTarget(
      highlightDay: day,
      highlightSlot: slot,
      openWeeklyPlan: true,
    );
  }

  void openSupplements() {
    state = const DietNavigationTarget(openSupplements: true);
  }

  void openWeeklyPlan() {
    state = const DietNavigationTarget(openWeeklyPlan: true);
  }

  void clear() {
    state = null;
  }
}
