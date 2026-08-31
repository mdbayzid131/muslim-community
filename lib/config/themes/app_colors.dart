import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Roles
  static const Color jummaColor = Color(0xFF436E50);
  static const Color maleColor = Color(0xFF5B7C99);
  static const Color femaleColor = Color(0xFFD18E8E);

  // Background & Surfaces
  static const Color backgroundColor = Color(0xFFFDF8F1);
  static const Color cardColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF5EFE6);
  static const Color surfaceLight = Color(0xFFFAF6EE);

  // Accents & Texts
  static const Color goldColor = Color(0xFFA6864D);
  static const Color titleColor = Color(0xFF2D3436);
  static const Color bodyColor = Color(0xFF636E72);
  static const Color greyColor = Color(0xFFB2BEC3);
  static const Color lightGrey = Color(0xFFF1F2F6);
  static const Color borderGrey = Color(0xFFE2E8F0);

  // Status Colors
  static const Color success = Color(0xFF2ED573);
  static const Color onlineGreen = Color(0xFF2ED573);
  static const Color error = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFA502);
  static const Color info = Color(0xFF1E90FF);

  /// Helper to get current role primary color
  static Color getRoleColor(String? role) {
    if (role == 'female' || role == 'sister') return femaleColor;
    if (role == 'jumma' || role == 'jummah') return jummaColor;
    return maleColor;
  }
}
