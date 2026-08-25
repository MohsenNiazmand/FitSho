import 'package:json_annotation/json_annotation.dart';

part 'preference_model.g.dart';

@JsonSerializable()
class PreferenceModel {
  const PreferenceModel({
    required this.id,
    required this.dietaryRestrictions,
    required this.preferredCuisines,
    required this.updatedAt,
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$PreferenceModelFromJson(json);

  final String id;
  final List<String> dietaryRestrictions;
  final List<String> preferredCuisines;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$PreferenceModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PreferenceEnvelope {
  const PreferenceEnvelope({
    required this.success,
    required this.data,
  });

  factory PreferenceEnvelope.fromJson(Map<String, dynamic> json) =>
      _$PreferenceEnvelopeFromJson(json);

  final bool success;
  final PreferenceModel data;

  Map<String, dynamic> toJson() => _$PreferenceEnvelopeToJson(this);
}

@JsonSerializable()
class UpsertPreferenceRequest {
  const UpsertPreferenceRequest({
    required this.dietaryRestrictions,
    required this.preferredCuisines,
  });

  factory UpsertPreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpsertPreferenceRequestFromJson(json);

  final List<String> dietaryRestrictions;
  final List<String> preferredCuisines;

  Map<String, dynamic> toJson() => _$UpsertPreferenceRequestToJson(this);
}
