import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/injection_container.dart';
import 'package:fitsho/core/usecase/usecase.dart';
import 'package:fitsho/features/preferences/domain/usecases/delete_preferences_usecase.dart';
import 'package:fitsho/features/preferences/domain/usecases/get_preferences_usecase.dart';
import 'package:fitsho/features/preferences/domain/usecases/save_preferences_usecase.dart';
import 'package:fitsho/shared/domain/entities/preference.dart';

part 'preferences_providers.g.dart';

@riverpod
class PreferencesLoadNotifier extends _$PreferencesLoadNotifier {
  @override
  Future<Preference?> build() async {
    final result = await getIt<GetPreferencesUseCase>()(const NoParams());

    return result.fold(
      (failure) => throw StateError(failure.message),
      (preference) => preference,
    );
  }

  Future<void> reload() async {
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
class SavePreferencesNotifier extends _$SavePreferencesNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> save({
    required List<String> dietaryRestrictions,
    required List<String> preferredCuisines,
  }) async {
    state = const AsyncValue.loading();

    final result = await getIt<SavePreferencesUseCase>()(
      SavePreferencesParams(
        dietaryRestrictions: dietaryRestrictions,
        preferredCuisines: preferredCuisines,
      ),
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) {
        ref.invalidate(preferencesLoadNotifierProvider);
        state = const AsyncValue.data(null);
        return null;
      },
    );
  }
}

@riverpod
class DeletePreferencesNotifier extends _$DeletePreferencesNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<Failure?> delete() async {
    state = const AsyncValue.loading();

    final result =
        await getIt<DeletePreferencesUseCase>()(const NoParams());

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return failure;
      },
      (_) {
        ref.invalidate(preferencesLoadNotifierProvider);
        state = const AsyncValue.data(null);
        return null;
      },
    );
  }
}
