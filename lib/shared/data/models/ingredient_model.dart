import 'package:json_annotation/json_annotation.dart';

part 'ingredient_model.g.dart';

@JsonSerializable()
class IngredientModel {
  const IngredientModel({
    required this.name,
    required this.amount,
    this.unit,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic value) {
      if (value is num) return value;
      if (value is String) return num.tryParse(value) ?? 0;
      return 0;
    }

    return IngredientModel(
      name: json['name'] as String,
      amount: parseNum(json['amount']),
      unit: json['unit'] as String?,
    );
  }

  final String name;
  final num amount;
  final String? unit;

  Map<String, dynamic> toJson() => _$IngredientModelToJson(this);
}
