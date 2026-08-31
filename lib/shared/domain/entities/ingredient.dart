import 'package:hive_ce/hive.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 0)
class Ingredient {
  const Ingredient({
    required this.name,
    required this.amount,
    this.unit,
  });

  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String? unit;

  String get displayAmount {
    final formattedAmount = amount % 1 == 0 ? amount.toInt().toString() : amount.toString();
    return unit != null ? '$formattedAmount $unit' : formattedAmount;
  }
}
