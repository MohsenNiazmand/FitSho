import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.foregroundColor,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final color = foregroundColor ?? Theme.of(context).colorScheme.onSurface;

    final style = OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color),
    );

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: style,
        icon: _buildIcon(color),
        label: Text(label),
      );
    }

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: _buildChild(color),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }
    return Text(label);
  }

  Widget _buildIcon(Color color) {
    if (isLoading) {
      return SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      );
    }
    return Icon(icon);
  }
}
