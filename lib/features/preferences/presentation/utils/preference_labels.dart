import 'package:flutter/material.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/l10n/app_localizations.dart';

String dietaryRestrictionLabel(BuildContext context, String apiValue) {
  return _dietaryRestrictionLabel(context.tr, apiValue);
}

String cuisineLabel(BuildContext context, String apiValue) {
  return _cuisineLabel(context.tr, apiValue);
}

String _dietaryRestrictionLabel(AppLocalizations tr, String apiValue) {
  return switch (apiValue) {
    'Vegan' => tr.dietaryVegan,
    'Vegetarian' => tr.dietaryVegetarian,
    'Gluten-free' => tr.dietaryGlutenFree,
    'Dairy-free' => tr.dietaryDairyFree,
    'Halal' => tr.dietaryHalal,
    'Low-carb' => tr.dietaryLowCarb,
    'Nut-free' => tr.dietaryNutFree,
    _ => apiValue,
  };
}

String _cuisineLabel(AppLocalizations tr, String apiValue) {
  return switch (apiValue) {
    'Persian' => tr.cuisinePersian,
    'Italian' => tr.cuisineItalian,
    'Mediterranean' => tr.cuisineMediterranean,
    'Indian' => tr.cuisineIndian,
    'Chinese' => tr.cuisineChinese,
    'Mexican' => tr.cuisineMexican,
    'Turkish' => tr.cuisineTurkish,
    'French' => tr.cuisineFrench,
    _ => apiValue,
  };
}
