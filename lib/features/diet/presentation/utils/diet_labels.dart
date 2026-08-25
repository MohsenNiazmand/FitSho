import 'package:flutter/material.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/features/diet/domain/constants/diet_constants.dart';

String dietDayLabel(BuildContext context, String dayKey) {
  final tr = context.tr;
  return switch (dayKey) {
    'saturday' => tr.dietDaySaturday,
    'sunday' => tr.dietDaySunday,
    'monday' => tr.dietDayMonday,
    'tuesday' => tr.dietDayTuesday,
    'wednesday' => tr.dietDayWednesday,
    'thursday' => tr.dietDayThursday,
    'friday' => tr.dietDayFriday,
    _ => dayKey,
  };
}

String dietMealSlotLabel(BuildContext context, String slotKey) {
  final tr = context.tr;
  return switch (slotKey) {
    'breakfast' => tr.dietSlotBreakfast,
    'morning_snack' => tr.dietSlotMorningSnack,
    'lunch' => tr.dietSlotLunch,
    'afternoon_snack' => tr.dietSlotAfternoonSnack,
    'dinner' => tr.dietSlotDinner,
    _ => slotKey,
  };
}

String dietGenderLabel(BuildContext context, String gender) {
  final tr = context.tr;
  return switch (gender) {
    'male' => tr.dietGenderMale,
    'female' => tr.dietGenderFemale,
    _ => gender,
  };
}

String dietOptionLabel(BuildContext context, String value) {
  final normalized = value.trim().toLowerCase().replaceAll(' ', '_');
  final tr = context.tr;
  return switch (normalized) {
    'lose_weight' || 'weight_loss' => tr.dietGoalLoseWeight,
    'maintain_weight' || 'maintenance' => tr.dietGoalMaintainWeight,
    'gain_weight' || 'muscle_gain' => tr.dietGoalGainWeight,
    'sedentary' => tr.dietActivitySedentary,
    'lightly_active' || 'light' => tr.dietActivityLight,
    'moderately_active' || 'moderate' => tr.dietActivityModerate,
    'very_active' || 'active' => tr.dietActivityVeryActive,
    'extra_active' || 'extreme' => tr.dietActivityExtraActive,
    'vegan' => tr.dietaryVegan,
    'vegetarian' => tr.dietaryVegetarian,
    'gluten_free' => tr.dietaryGlutenFree,
    'dairy_free' => tr.dietaryDairyFree,
    'halal' => tr.dietaryHalal,
    'low_carb' => tr.dietaryLowCarb,
    'nut_free' => tr.dietaryNutFree,
    _ => value,
  };
}

List<String> orderedDayKeys() => DietConstants.dayKeys;

List<String> orderedMealSlotKeys() => DietConstants.mealSlotKeys;
