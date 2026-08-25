import 'package:json_annotation/json_annotation.dart';

part 'ingredient_model.g.dart';

@JsonSerializable()
class IngredientModel {
  const IngredientModel({
    required this.name,
    required this.amount,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);

  final String name;
  final String amount;

  Map<String, dynamic> toJson() => _$IngredientModelToJson(this);
}
