import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fitsho/features/auth/data/models/auth_requests.dart';
import 'package:fitsho/features/auth/data/models/user_model.dart';
import 'package:fitsho/shared/data/models/message_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/api/auth/otp/request')
  Future<MessageResponse> requestOtp(@Body() OtpRequestBody body);

  @POST('/api/auth/otp/verify')
  Future<AuthTokenResponse> verifyOtp(@Body() OtpVerifyBody body);

  @POST('/api/auth/refresh')
  Future<RefreshTokenResponse> refreshToken(@Body() RefreshTokenBody body);

  @POST('/api/auth/logout')
  Future<MessageResponse> logout();

  @GET('/api/auth/me')
  Future<UserEnvelope> getMe();

  @PATCH('/api/auth/me')
  Future<UserEnvelope> updateProfile(@Body() UpdateProfileBody body);

  @DELETE('/api/auth/me')
  Future<MessageResponse> deleteAccount();
}
