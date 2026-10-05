// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dietOptionsNotifierHash() =>
    r'ade7e640ac2f114ea145f57f573b71cd46fe468d';

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
    r'56771b5e627967829c8b1f2ed1453ad961afa3e8';

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
String _$dietPlanNotifierHash() => r'72d95bcf3f14a3e4829cd1451ea80a8dba39de01';

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
    r'e7febc825234145b11623d73f3ea805911da6b61';

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
    r'53def9d009aef4a75fa3ccacaaf992c4531cf509';

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
    r'3511af2b644acbb7c532ec52bcdd2d4efb2f3d56';

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
String _$logMealNotifierHash() => r'3b6af0adc6a7f909bdb95398e6bfd51b7d65cae1';

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
String _$mealSlotsNotifierHash() => r'281c98ee896634a6c07697b81ddbf19df5c53243';

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
    r'727a1af819618fa19c509fb27637a0d570e1471d';

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
