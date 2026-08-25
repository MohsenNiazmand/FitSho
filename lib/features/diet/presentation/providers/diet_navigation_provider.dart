import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diet_navigation_provider.g.dart';

class DietNavigationTarget {
  const DietNavigationTarget({
    this.highlightDay,
    this.highlightSlot,
    this.openSupplements = false,
  });

  final String? highlightDay;
  final String? highlightSlot;
  final bool openSupplements;
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
    );
  }

  void openSupplements() {
    state = const DietNavigationTarget(openSupplements: true);
  }

  void clear() {
    state = null;
  }
}
