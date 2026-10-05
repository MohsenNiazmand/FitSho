import 'package:json_annotation/json_annotation.dart';

part 'app_config_model.g.dart';

@JsonSerializable(createToJson: false)
class AppConfigResponse {
  const AppConfigResponse({
    required this.success,
    required this.data,
  });

  factory AppConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$AppConfigResponseFromJson(json);

  final bool success;
  final AppConfigModel data;
}

@JsonSerializable(createToJson: false)
class AppConfigModel {
  const AppConfigModel({
    required this.latestVersion,
    required this.minSupportedVersion,
    required this.forceUpdate,
    required this.updateUrl,
    this.releaseNotes = const [],
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);

  final String latestVersion;
  final String minSupportedVersion;
  final bool forceUpdate;
  final String updateUrl;
  final List<String> releaseNotes;
}
