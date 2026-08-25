// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequestBody _$OtpRequestBodyFromJson(Map<String, dynamic> json) =>
    OtpRequestBody(
      mobileNumber: json['mobileNumber'] as String,
      deviceId: json['deviceId'] as String,
    );

Map<String, dynamic> _$OtpRequestBodyToJson(OtpRequestBody instance) =>
    <String, dynamic>{
      'mobileNumber': instance.mobileNumber,
      'deviceId': instance.deviceId,
    };

OtpVerifyBody _$OtpVerifyBodyFromJson(Map<String, dynamic> json) =>
    OtpVerifyBody(
      mobileNumber: json['mobileNumber'] as String,
      otpCode: json['otpCode'] as String,
      deviceId: json['deviceId'] as String,
    );

Map<String, dynamic> _$OtpVerifyBodyToJson(OtpVerifyBody instance) =>
    <String, dynamic>{
      'mobileNumber': instance.mobileNumber,
      'otpCode': instance.otpCode,
      'deviceId': instance.deviceId,
    };

RefreshTokenBody _$RefreshTokenBodyFromJson(Map<String, dynamic> json) =>
    RefreshTokenBody(
      refreshToken: json['refreshToken'] as String,
      deviceId: json['deviceId'] as String,
    );

Map<String, dynamic> _$RefreshTokenBodyToJson(RefreshTokenBody instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'deviceId': instance.deviceId,
    };

UpdateProfileBody _$UpdateProfileBodyFromJson(Map<String, dynamic> json) =>
    UpdateProfileBody(name: json['name'] as String);

Map<String, dynamic> _$UpdateProfileBodyToJson(UpdateProfileBody instance) =>
    <String, dynamic>{'name': instance.name};

AuthTokenResponse _$AuthTokenResponseFromJson(Map<String, dynamic> json) =>
    AuthTokenResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthTokenResponseToJson(AuthTokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user.toJson(),
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => RefreshTokenResponse(accessToken: json['accessToken'] as String);

Map<String, dynamic> _$RefreshTokenResponseToJson(
  RefreshTokenResponse instance,
) => <String, dynamic>{'accessToken': instance.accessToken};
