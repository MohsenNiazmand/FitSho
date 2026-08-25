// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferenceModel _$PreferenceModelFromJson(Map<String, dynamic> json) =>
    PreferenceModel(
      id: json['id'] as String,
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      preferredCuisines: (json['preferredCuisines'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PreferenceModelToJson(PreferenceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'preferredCuisines': instance.preferredCuisines,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

PreferenceEnvelope _$PreferenceEnvelopeFromJson(Map<String, dynamic> json) =>
    PreferenceEnvelope(
      success: json['success'] as bool,
      data: PreferenceModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreferenceEnvelopeToJson(PreferenceEnvelope instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
    };

UpsertPreferenceRequest _$UpsertPreferenceRequestFromJson(
  Map<String, dynamic> json,
) => UpsertPreferenceRequest(
  dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  preferredCuisines: (json['preferredCuisines'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpsertPreferenceRequestToJson(
  UpsertPreferenceRequest instance,
) => <String, dynamic>{
  'dietaryRestrictions': instance.dietaryRestrictions,
  'preferredCuisines': instance.preferredCuisines,
};
