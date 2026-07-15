import 'package:flutter/material.dart';
import 'package:fixit/shared/widgets/inputs/app_text_field.dart';

class FigmaAuthTextField extends StatelessWidget {
  const FigmaAuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.label,
    this.isPassword = false,
    this.obscure = false,
    this.onToggleVisibility,
    this.validator,
    this.darkTheme = false,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    this.autofillHints,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? label;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;
  final bool darkTheme;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      icon: icon,
      label: label,
      isPassword: isPassword,
      obscure: obscure,
      onToggleVisibility: onToggleVisibility,
      validator: validator,
      darkTheme: darkTheme,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
    );
  }
}
