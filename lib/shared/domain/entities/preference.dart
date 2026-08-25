class Preference {
  const Preference({
    required this.id,
    required this.dietaryRestrictions,
    required this.preferredCuisines,
    required this.updatedAt,
  });

  final String id;
  final List<String> dietaryRestrictions;
  final List<String> preferredCuisines;
  final DateTime updatedAt;
}
