// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigResponse _$AppConfigResponseFromJson(Map<String, dynamic> json) =>
    AppConfigResponse(
      success: json['success'] as bool,
      data: AppConfigModel.fromJson(json['data'] as Map<String, dynamic>),
    );

AppConfigModel _$AppConfigModelFromJson(Map<String, dynamic> json) =>
    AppConfigModel(
      latestVersion: json['latestVersion'] as String,
      minSupportedVersion: json['minSupportedVersion'] as String,
      forceUpdate: json['forceUpdate'] as bool,
      updateUrl: json['updateUrl'] as String,
    );
