import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get theme => lightTheme();

  static ThemeData lightTheme({Color primaryColor = AppColors.maleColor}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: AppColors.goldColor,
        surface: AppColors.surfaceColor,
        error: AppColors.error,
      ),
      fontFamily: GoogleFonts.outfit().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.titleColor),
        titleTextStyle: TextStyle(
          color: AppColors.titleColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderGrey, width: 1),
        ),
      ),
    );
  }
}
