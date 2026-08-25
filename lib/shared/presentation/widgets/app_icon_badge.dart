import 'package:flutter/material.dart';

class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    required this.icon,
    this.size = 88,
    this.iconSize = 40,
    this.backgroundColor,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? colorScheme.primary,
      ),
    );
  }
}
