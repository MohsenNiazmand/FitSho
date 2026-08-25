import 'package:flutter/material.dart';
import 'package:fitsho/core/constants/colors.dart';

/// Subtle kitchen-themed pattern for OTP screen background.
class OtpBackgroundPattern extends StatelessWidget {
  const OtpBackgroundPattern({super.key});

  static const _icons = [
    Icons.restaurant_menu_outlined,
    Icons.local_dining_outlined,
    Icons.ramen_dining_outlined,
    Icons.egg_outlined,
    Icons.coffee_outlined,
    Icons.set_meal_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 36,
          crossAxisSpacing: 20,
        ),
        itemCount: 32,
        itemBuilder: (context, index) {
          return Icon(
            _icons[index % _icons.length],
            size: 30,
            color: cPrimary.withValues(alpha: 0.05),
          );
        },
      ),
    );
  }
}
