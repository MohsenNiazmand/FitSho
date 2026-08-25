// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  mobileNumber: json['mobileNumber'] as String,
  name: json['name'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'mobileNumber': instance.mobileNumber,
  'name': instance.name,
};

UserEnvelope _$UserEnvelopeFromJson(Map<String, dynamic> json) => UserEnvelope(
  success: json['success'] as bool,
  data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserEnvelopeToJson(UserEnvelope instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data.toJson(),
    };
