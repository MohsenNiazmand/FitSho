import 'package:json_annotation/json_annotation.dart';
import 'package:fitsho/features/auth/data/models/user_model.dart';

part 'auth_requests.g.dart';

@JsonSerializable()
class OtpRequestBody {
  const OtpRequestBody({
    required this.mobileNumber,
    required this.deviceId,
  });

  factory OtpRequestBody.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestBodyFromJson(json);

  final String mobileNumber;
  final String deviceId;

  Map<String, dynamic> toJson() => _$OtpRequestBodyToJson(this);
}

@JsonSerializable()
class OtpVerifyBody {
  const OtpVerifyBody({
    required this.mobileNumber,
    required this.otpCode,
    required this.deviceId,
  });

  factory OtpVerifyBody.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyBodyFromJson(json);

  final String mobileNumber;
  final String otpCode;
  final String deviceId;

  Map<String, dynamic> toJson() => _$OtpVerifyBodyToJson(this);
}

@JsonSerializable()
class RefreshTokenBody {
  const RefreshTokenBody({
    required this.refreshToken,
    required this.deviceId,
  });

  factory RefreshTokenBody.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenBodyFromJson(json);

  final String refreshToken;
  final String deviceId;

  Map<String, dynamic> toJson() => _$RefreshTokenBodyToJson(this);
}

@JsonSerializable()
class UpdateProfileBody {
  const UpdateProfileBody({required this.name});

  factory UpdateProfileBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileBodyFromJson(json);

  final String name;

  Map<String, dynamic> toJson() => _$UpdateProfileBodyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AuthTokenResponse {
  const AuthTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResponseFromJson(json);

  final String accessToken;
  final String refreshToken;
  final UserModel user;

  Map<String, dynamic> toJson() => _$AuthTokenResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenResponse {
  const RefreshTokenResponse({required this.accessToken});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  final String accessToken;

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}
