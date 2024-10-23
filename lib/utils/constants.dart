import 'package:flutter/material.dart';

class Constants {
  // Colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF000000);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14.0,
    color: textColor,
  );

  // Padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
}
