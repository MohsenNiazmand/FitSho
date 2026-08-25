import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.textDirection,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.alignLabelWithHint = false,
    super.key,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final int maxLines;
  final bool enabled;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool alignLabelWithHint;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      alignLabelWithHint: alignLabelWithHint,
    );

    if (validator != null || controller != null) {
      return TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textDirection: textDirection,
        maxLines: maxLines,
        enabled: enabled,
        autofocus: autofocus,
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        decoration: decoration,
      );
    }

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textDirection: textDirection,
      maxLines: maxLines,
      enabled: enabled,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted,
      decoration: decoration,
    );
  }
}
