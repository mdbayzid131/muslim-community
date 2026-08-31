import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';

enum SnackBarType { success, error, info, warning }

/// ===================== HELPERS =====================
/// Common utility functions used across the app.

class Helpers {
  Helpers._();

  // ──────────────────── LOGGING ────────────────────

  static void debug(String message) {
    if (!kDebugMode) return;
    debugPrint('🔍 DEBUG: $message');
  }

  static void info(String message) {
    if (!kDebugMode) return;
    debugPrint('ℹ️ INFO: $message');
  }

  static void warning(String message) {
    if (!kDebugMode) return;
    debugPrint('⚠️ WARNING: $message');
  }

  static void error(String message) {
    if (!kDebugMode) return;
    debugPrint('❌ ERROR: $message');
  }

  // ──────────────────── SNACKBARS & TOASTS ────────────────────

  static void showSuccess(String message, {String title = 'Success'}) {
    _showCustomSnackbar(
      title: title,
      message: message,
      type: SnackBarType.success,
    );
  }

  static void showError(String message, {String title = 'Error'}) {
    _showCustomSnackbar(
      title: title,
      message: message,
      type: SnackBarType.error,
    );
  }

  static void showInfo(String message, {String title = 'Info'}) {
    _showCustomSnackbar(
      title: title,
      message: message,
      type: SnackBarType.info,
    );
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    _showCustomSnackbar(
      title: title,
      message: message,
      type: SnackBarType.warning,
    );
  }

  static void _showCustomSnackbar({
    required String title,
    required String message,
    required SnackBarType type,
  }) {
    Color bgColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        bgColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        bgColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case SnackBarType.warning:
        bgColor = AppColors.warning;
        icon = Icons.warning_amber_rounded;
        break;
      case SnackBarType.info:
        bgColor = AppColors.info;
        icon = Icons.info_outline;
        break;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderRadius: 12.r,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  // ──────────────────── TIME FORMATTING ────────────────────

  static String timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays >= 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
