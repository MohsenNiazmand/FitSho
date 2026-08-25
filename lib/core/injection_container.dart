import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:fitsho/core/network/dio_client.dart';
import 'package:fitsho/core/storage/device_id_service.dart';
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
import 'package:fitsho/features/diet/data/repositories/diet_repository_impl.dart';
import 'package:fitsho/features/diet/data/services/diet_api.dart';
import 'package:fitsho/features/diet/domain/repositories/diet_repository.dart';
import 'package:fitsho/features/preferences/data/repositories/preference_repository_impl.dart';
import 'package:fitsho/features/preferences/data/services/preference_api.dart';
import 'package:fitsho/features/preferences/domain/repositories/preference_repository.dart';
import 'package:fitsho/features/preferences/domain/usecases/delete_preferences_usecase.dart';
import 'package:fitsho/features/preferences/domain/usecases/get_preferences_usecase.dart';
import 'package:fitsho/features/preferences/domain/usecases/save_preferences_usecase.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  getIt
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
    ..registerLazySingleton<Dio>(
      () => createDio(
        tokenStorage: getIt(),
        deviceIdService: getIt(),
        logger: getIt(),
      ),
    )
    ..registerLazySingleton<AuthApi>(() => AuthApi(getIt()))
    ..registerLazySingleton<PreferenceApi>(() => PreferenceApi(getIt()))
    ..registerLazySingleton<DietApi>(() => DietApi(getIt()))
    ..registerLazySingleton<DietRepository>(
      () => DietRepositoryImpl(getIt()),
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
