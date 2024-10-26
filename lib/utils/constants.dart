import 'package:flutter/material.dart';

class Constants {
  // Colors - Dark theme
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFB3B3B3);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 0.5,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
    letterSpacing: 0.25,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14.0,
    color: textColor,
    letterSpacing: 0.15,
  );

  // Padding & Sizes
  static const EdgeInsets defaultPadding = EdgeInsets.all(24.0);
  static const double buttonHeight = 56.0;
  static const double borderRadius = 12.0;
}
