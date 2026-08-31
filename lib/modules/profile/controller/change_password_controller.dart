import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/repositories/auth_repository.dart';

class ChangePasswordController extends GetxController {
  final AuthRepository authRepository;

  ChangePasswordController({required this.authRepository});

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  void toggleCurrentPasswordVisibility() =>
      isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> changePassword() async {
    final currentPwd = currentPasswordCtrl.text;
    final newPwd = newPasswordCtrl.text;
    final confirmPwd = confirmPasswordCtrl.text;

    if (currentPwd.isEmpty || newPwd.isEmpty || confirmPwd.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPwd != confirmPwd) {
      Get.snackbar(
        'Error',
        'New passwords do not match',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPwd.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepository.changePassword(
        currentPassword: currentPwd,
        newPassword: newPwd,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await StorageService.clearAuth();
        Get.offAllNamed(AppRoutes.selectRole);

        Get.snackbar(
          'Success',
          'Password changed successfully. Please login again.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        _clearFields();
      } else {
        final msg = response.data?['message'] ?? 'Failed to change password';
        Get.snackbar(
          'Error',
          msg.toString(),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Helpers.error("Change Password Error: $e");
      Get.snackbar(
        'Error',
        'An error occurred',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    currentPasswordCtrl.clear();
    newPasswordCtrl.clear();
    confirmPasswordCtrl.clear();
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
