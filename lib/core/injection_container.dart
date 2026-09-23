import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitsho/core/app_config/data/repositories/app_config_repository_impl.dart';
import 'package:fitsho/core/app_config/data/services/app_config_api.dart';
import 'package:fitsho/core/app_config/domain/repositories/app_config_repository.dart';
import 'package:fitsho/core/network/dio_client.dart';
import 'package:fitsho/core/notifications/notification_service.dart';
import 'package:fitsho/core/storage/device_id_service.dart';
import 'package:fitsho/core/storage/hive_initializer.dart';
import 'package:fitsho/core/storage/secure_token_storage.dart';
import 'package:fitsho/core/storage/token_storage.dart';
import 'package:fitsho/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitsho/features/auth/data/services/auth_api.dart';
import 'package:fitsho/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitsho/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:fitsho/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:fitsho/features/diet/data/datasources/diet_local_data_source.dart';
import 'package:fitsho/features/diet/data/repositories/diet_repository_impl.dart';
import 'package:fitsho/features/diet/data/services/diet_api.dart';
import 'package:fitsho/features/diet/domain/repositories/diet_repository.dart';
import 'package:fitsho/features/preferences/data/repositories/preference_repository_impl.dart';
import 'package:fitsho/features/preferences/data/services/preference_api.dart';
import 'package:fitsho/features/preferences/domain/repositories/preference_repository.dart';
import 'package:fitsho/features/preferences/domain/usecases/delete_preferences_usecase.dart';
import 'package:fitsho/features/preferences/domain/usecases/get_preferences_usecase.dart';
import 'package:fitsho/features/preferences/domain/usecases/save_preferences_usecase.dart';

import 'package:fitsho/features/workout/data/datasources/workout_local_data_source.dart';
import 'package:fitsho/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:fitsho/features/workout/data/services/workout_api.dart';
import 'package:fitsho/features/workout/domain/repositories/workout_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  await HiveInitializer.init();
  final dietProfileBox = await HiveInitializer.openDietProfileBox();
  final dietPlanBox = await HiveInitializer.openDietPlanBox();
  final supplementsBox = await HiveInitializer.openSupplementsBox();
  final todayMealLogsBox = await HiveInitializer.openTodayMealLogsBox();
  final lastMealLogBox = await HiveInitializer.openLastMealLogBox();
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<DietLocalDataSource>(
      () => DietLocalDataSourceImpl(
        profileBox: dietProfileBox,
        planBox: dietPlanBox,
        supplementsBox: supplementsBox,
        todayMealLogsBox: todayMealLogsBox,
        lastMealLogBox: lastMealLogBox,
        prefs: sharedPreferences,
      ),
    )
    ..registerLazySingleton<WorkoutLocalDataSource>(
      () => WorkoutLocalDataSourceImpl(sharedPreferences),
    )
    ..registerLazySingleton<Logger>(
      () => Logger(
        printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5),
      ),
    )
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<TokenStorage>(
      () => SecureTokenStorage(getIt()),
    )
    ..registerLazySingleton<DeviceIdService>(
      () => DeviceIdService(getIt()),
    )
    ..registerLazySingleton<NotificationService>(
      () => NotificationService(),
    )
    ..registerLazySingleton<Dio>(
      () => createDio(
        tokenStorage: getIt(),
        deviceIdService: getIt(),
        logger: getIt(),
      ),
    )
    ..registerLazySingleton<AuthApi>(() => AuthApi(getIt()))
    ..registerLazySingleton<AppConfigApi>(() => AppConfigApi(getIt()))
    ..registerLazySingleton<PreferenceApi>(() => PreferenceApi(getIt()))
    ..registerLazySingleton<DietApi>(() => DietApi(getIt()))
    ..registerLazySingleton<WorkoutApi>(() => WorkoutApi(getIt()))
    ..registerLazySingleton<AppConfigRepository>(
      () => AppConfigRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<DietRepository>(
      () => DietRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton<WorkoutRepository>(
      () => WorkoutRepositoryImpl(
        api: getIt(),
        localDataSource: getIt(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authApi: getIt(),
        tokenStorage: getIt(),
        deviceIdService: getIt(),
      ),
    )
    ..registerLazySingleton<PreferenceRepository>(
      () => PreferenceRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<RequestOtpUseCase>(
      () => RequestOtpUseCase(getIt()),
    )
    ..registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(getIt()),
    )
    ..registerLazySingleton<RefreshTokenUseCase>(
      () => RefreshTokenUseCase(getIt()),
    )
    ..registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt()),
    )
    ..registerLazySingleton<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(getIt()),
    )
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt()),
    )
    ..registerLazySingleton<IsLoggedInUseCase>(
      () => IsLoggedInUseCase(getIt()),
    )
    ..registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(getIt()),
    )
    ..registerLazySingleton<GetPreferencesUseCase>(
      () => GetPreferencesUseCase(getIt()),
    )
    ..registerLazySingleton<SavePreferencesUseCase>(
      () => SavePreferencesUseCase(getIt()),
    )
    ..registerLazySingleton<DeletePreferencesUseCase>(
      () => DeletePreferencesUseCase(getIt()),
    );
}
