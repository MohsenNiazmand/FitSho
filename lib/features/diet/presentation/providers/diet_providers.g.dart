// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dietOptionsNotifierHash() =>
    r'96b2413a38e9ce1a67235f488419786065c0477a';

/// See also [DietOptionsNotifier].
@ProviderFor(DietOptionsNotifier)
final dietOptionsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      DietOptionsNotifier,
      DietProfileOptions
    >.internal(
      DietOptionsNotifier.new,
      name: r'dietOptionsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dietOptionsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DietOptionsNotifier = AutoDisposeAsyncNotifier<DietProfileOptions>;
String _$dietProfileNotifierHash() =>
    r'616094e469c70d71bc1011d752c21851f98c56bf';

/// See also [DietProfileNotifier].
@ProviderFor(DietProfileNotifier)
final dietProfileNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      DietProfileNotifier,
      DietProfile?
    >.internal(
      DietProfileNotifier.new,
      name: r'dietProfileNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dietProfileNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DietProfileNotifier = AutoDisposeAsyncNotifier<DietProfile?>;
String _$dietPlanNotifierHash() => r'04d4c08d9bf0fab834a134610a25b66be66b59ec';

/// See also [DietPlanNotifier].
@ProviderFor(DietPlanNotifier)
final dietPlanNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DietPlanNotifier, DietPlan?>.internal(
      DietPlanNotifier.new,
      name: r'dietPlanNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dietPlanNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DietPlanNotifier = AutoDisposeAsyncNotifier<DietPlan?>;
String _$dietPlanHistoryNotifierHash() =>
    r'd47f429f552d650a81a78b7773444a5998b34cc6';

/// See also [DietPlanHistoryNotifier].
@ProviderFor(DietPlanHistoryNotifier)
final dietPlanHistoryNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      DietPlanHistoryNotifier,
      List<DietPlan>
    >.internal(
      DietPlanHistoryNotifier.new,
      name: r'dietPlanHistoryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dietPlanHistoryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DietPlanHistoryNotifier = AutoDisposeAsyncNotifier<List<DietPlan>>;
String _$lastMealLogNotifierHash() =>
    r'f8e49fd3c21636696b0c54e3fc1edb6647670c61';

/// See also [LastMealLogNotifier].
@ProviderFor(LastMealLogNotifier)
final lastMealLogNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LastMealLogNotifier, MealLog?>.internal(
      LastMealLogNotifier.new,
      name: r'lastMealLogNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lastMealLogNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LastMealLogNotifier = AutoDisposeAsyncNotifier<MealLog?>;
String _$todayMealLogsNotifierHash() =>
    r'd09093e6fd8f0374013f9e0249f3ed54c4ee9cf4';

/// See also [TodayMealLogsNotifier].
@ProviderFor(TodayMealLogsNotifier)
final todayMealLogsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      TodayMealLogsNotifier,
      List<MealLog>
    >.internal(
      TodayMealLogsNotifier.new,
      name: r'todayMealLogsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayMealLogsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodayMealLogsNotifier = AutoDisposeAsyncNotifier<List<MealLog>>;
String _$complianceStatsNotifierHash() =>
    r'47f98f23f0f7d6c6be62af05e1d66e8419ca71d5';

/// See also [ComplianceStatsNotifier].
@ProviderFor(ComplianceStatsNotifier)
final complianceStatsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      ComplianceStatsNotifier,
      ComplianceStats?
    >.internal(
      ComplianceStatsNotifier.new,
      name: r'complianceStatsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$complianceStatsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ComplianceStatsNotifier = AutoDisposeAsyncNotifier<ComplianceStats?>;
String _$logMealNotifierHash() => r'aa7c821407734ca36b57a749a4a4e3378644235c';

/// See also [LogMealNotifier].
@ProviderFor(LogMealNotifier)
final logMealNotifierProvider =
    AutoDisposeNotifierProvider<LogMealNotifier, AsyncValue<void>>.internal(
      LogMealNotifier.new,
      name: r'logMealNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$logMealNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LogMealNotifier = AutoDisposeNotifier<AsyncValue<void>>;
String _$mealSlotsNotifierHash() => r'f0f1d67b3da2a8f4696743c7bd0e539d197ef3fe';

/// See also [MealSlotsNotifier].
@ProviderFor(MealSlotsNotifier)
final mealSlotsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      MealSlotsNotifier,
      Map<String, MealSlotConfig>
    >.internal(
      MealSlotsNotifier.new,
      name: r'mealSlotsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mealSlotsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MealSlotsNotifier =
    AutoDisposeAsyncNotifier<Map<String, MealSlotConfig>>;
String _$supplementsNotifierHash() =>
    r'4517cba607423ae5c9f54e85ce174075b2f9bf7b';

/// See also [SupplementsNotifier].
@ProviderFor(SupplementsNotifier)
final supplementsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      SupplementsNotifier,
      List<Supplement>
    >.internal(
      SupplementsNotifier.new,
      name: r'supplementsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supplementsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SupplementsNotifier = AutoDisposeAsyncNotifier<List<Supplement>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
