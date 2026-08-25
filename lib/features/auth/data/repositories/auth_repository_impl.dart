import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/constants/constants.dart';
import 'package:fitsho/core/error/exceptions.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/storage/device_id_service.dart';
import 'package:fitsho/core/storage/token_storage.dart';
import 'package:fitsho/core/utils/repository_guard.dart';
import 'package:fitsho/features/auth/data/models/auth_requests.dart';
import 'package:fitsho/features/auth/data/services/auth_api.dart';
import 'package:fitsho/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitsho/shared/data/mappers/entity_mappers.dart';
import 'package:fitsho/shared/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._authApi,
    required this._tokenStorage,
    required this._deviceIdService,
  });

  final AuthApi _authApi;
  final TokenStorage _tokenStorage;
  final DeviceIdService _deviceIdService;

  @override
  Future<Either<Failure, void>> requestOtp(String mobileNumber) {
    return guard(() async {
      if (!Constants.mobileNumberPattern.hasMatch(mobileNumber)) {
        throw const ValidationException('Invalid mobile number format');
      }

      final deviceId = await _deviceIdService.getDeviceId();
      await _authApi.requestOtp(
        OtpRequestBody(mobileNumber: mobileNumber, deviceId: deviceId),
      );
    });
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String mobileNumber,
    required String otpCode,
  }) {
    return guard(() async {
      if (!Constants.mobileNumberPattern.hasMatch(mobileNumber)) {
        throw const ValidationException('Invalid mobile number format');
      }

      final deviceId = await _deviceIdService.getDeviceId();
      final response = await _authApi.verifyOtp(
        OtpVerifyBody(
          mobileNumber: mobileNumber,
          otpCode: otpCode,
          deviceId: deviceId,
        ),
      );

      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return response.user.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> refreshToken() {
    return guard(() async {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const UnauthorizedException();
      }

      final deviceId = await _deviceIdService.getDeviceId();
      final response = await _authApi.refreshToken(
        RefreshTokenBody(refreshToken: refreshToken, deviceId: deviceId),
      );

      await _tokenStorage.saveAccessToken(response.accessToken);
    });
  }

  @override
  Future<Either<Failure, void>> logout() {
    return guard(() async {
      try {
        await _authApi.logout();
      } finally {
        await _tokenStorage.clearTokens();
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount() {
    return guard(() async {
      await _authApi.deleteAccount();
      await _tokenStorage.clearTokens();
    });
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() {
    return guard(() async {
      final response = await _authApi.getMe();
      return response.data.toEntity();
    });
  }

  @override
  Future<Either<Failure, User>> updateProfile(String name) {
    return guard(() async {
      if (name.trim().isEmpty) {
        throw const ValidationException('Name cannot be empty');
      }

      final response = await _authApi.updateProfile(
        UpdateProfileBody(name: name.trim()),
      );
      return response.data.toEntity();
    });
  }

  @override
  Future<bool> isLoggedIn() {
    return _tokenStorage.hasSession();
  }
}
