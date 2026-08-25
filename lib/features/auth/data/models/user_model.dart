import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.mobileNumber,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  final String mobileNumber;
  final String? name;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserEnvelope {
  const UserEnvelope({
    required this.success,
    required this.data,
  });

  factory UserEnvelope.fromJson(Map<String, dynamic> json) =>
      _$UserEnvelopeFromJson(json);

  final bool success;
  final UserModel data;

  Map<String, dynamic> toJson() => _$UserEnvelopeToJson(this);
}
