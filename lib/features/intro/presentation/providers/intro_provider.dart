import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitsho/core/constants/storage_keys.dart';
import 'package:fitsho/core/injection_container.dart';

part 'intro_provider.g.dart';

@Riverpod(keepAlive: true)
class IntroState extends _$IntroState {
  @override
  bool build() {
    return getIt<SharedPreferences>().getBool(StorageKeys.onboardingCompleted) ?? false;
  }

  Future<void> completeIntro() async {
    await getIt<SharedPreferences>().setBool(StorageKeys.onboardingCompleted, true);
    state = true;
  }
}
