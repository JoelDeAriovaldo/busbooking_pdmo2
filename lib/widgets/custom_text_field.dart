import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: Constants.bodyTextStyle,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Constants.subheadingStyle,
        filled: true,
        fillColor: Constants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide:
              BorderSide(color: Constants.textSecondaryColor.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          borderSide: BorderSide(color: Constants.primaryColor),
        ),
        prefixIcon: prefixIcon,
      ),
    );
  }
}
