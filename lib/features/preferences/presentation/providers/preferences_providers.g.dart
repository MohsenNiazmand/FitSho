// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$preferencesLoadNotifierHash() =>
    r'59de92a493b92d5269991c0782a828bdf537330c';

/// See also [PreferencesLoadNotifier].
@ProviderFor(PreferencesLoadNotifier)
final preferencesLoadNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      PreferencesLoadNotifier,
      Preference?
    >.internal(
      PreferencesLoadNotifier.new,
      name: r'preferencesLoadNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preferencesLoadNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PreferencesLoadNotifier = AutoDisposeAsyncNotifier<Preference?>;
String _$savePreferencesNotifierHash() =>
    r'9808f7aec708b2b2135c313c8efc8a4e9595fbe2';

/// See also [SavePreferencesNotifier].
@ProviderFor(SavePreferencesNotifier)
final savePreferencesNotifierProvider =
    AutoDisposeNotifierProvider<
      SavePreferencesNotifier,
      AsyncValue<void>
    >.internal(
      SavePreferencesNotifier.new,
      name: r'savePreferencesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savePreferencesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SavePreferencesNotifier = AutoDisposeNotifier<AsyncValue<void>>;
String _$deletePreferencesNotifierHash() =>
    r'06e6451ed33313797dca4cd556ffb925a7788c3c';

/// See also [DeletePreferencesNotifier].
@ProviderFor(DeletePreferencesNotifier)
final deletePreferencesNotifierProvider =
    AutoDisposeNotifierProvider<
      DeletePreferencesNotifier,
      AsyncValue<void>
    >.internal(
      DeletePreferencesNotifier.new,
      name: r'deletePreferencesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deletePreferencesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeletePreferencesNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
