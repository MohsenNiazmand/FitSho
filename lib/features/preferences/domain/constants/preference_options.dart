class PreferenceOption {
  const PreferenceOption(this.apiValue);

  final String apiValue;
}

abstract final class DietaryRestrictionOptions {
  static const vegan = PreferenceOption('Vegan');
  static const vegetarian = PreferenceOption('Vegetarian');
  static const glutenFree = PreferenceOption('Gluten-free');
  static const dairyFree = PreferenceOption('Dairy-free');
  static const halal = PreferenceOption('Halal');
  static const lowCarb = PreferenceOption('Low-carb');
  static const nutFree = PreferenceOption('Nut-free');

  static const all = [
    vegan,
    vegetarian,
    glutenFree,
    dairyFree,
    halal,
    lowCarb,
    nutFree,
  ];
}

abstract final class CuisineOptions {
  static const persian = PreferenceOption('Persian');
  static const italian = PreferenceOption('Italian');
  static const mediterranean = PreferenceOption('Mediterranean');
  static const indian = PreferenceOption('Indian');
  static const chinese = PreferenceOption('Chinese');
  static const mexican = PreferenceOption('Mexican');
  static const turkish = PreferenceOption('Turkish');
  static const french = PreferenceOption('French');

  static const all = [
    persian,
    italian,
    mediterranean,
    indian,
    chinese,
    mexican,
    turkish,
    french,
  ];
}
