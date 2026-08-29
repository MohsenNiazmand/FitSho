import 'package:hive_ce/hive.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 0)
class Ingredient {
  const Ingredient({
    required this.name,
    required this.amount,
  });

  @HiveField(0)
  final String name;

  @HiveField(1)
  final String amount;
}
