import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/repositories/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository authRepository;

  ForgotPasswordController({required this.authRepository});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;
  final email = "".obs;
  final token = "".obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final currentRole = 'male'.obs;

  Color get roleColor => AppColors.getRoleColor(currentRole.value);

  var secondsRemaining = 180.obs;
  var timerText = "03:00".obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      if (args['role'] != null) {
        currentRole.value = args['role'].toString();
      }
      if (args['email'] != null && args['email'].toString().isNotEmpty) {
        email.value = args['email'].toString();
        emailController.text = args['email'].toString();
      }
    }
  }

  void startTimer() {
    secondsRemaining.value = 180;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
        int minutes = secondsRemaining.value ~/ 60;
        int seconds = secondsRemaining.value % 60;
        timerText.value =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      } else {
        _timer?.cancel();
      }
    });
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  String get otp => otpControllers.map((c) => c.text).join();

  Future<void> sendOtp(String nextRoute) async {
    final emailText = emailController.text.trim();
    if (emailText.isEmpty || !GetUtils.isEmail(emailText)) {
      Helpers.showError('Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepository.forgotPassword(email: emailText);

      if (response.statusCode == 200 || response.statusCode == 201) {
        email.value = emailText;
        Helpers.showSuccess('OTP sent to your email');
        startTimer();
        Get.toNamed(nextRoute, arguments: {
          'email': email.value,
          'role': currentRole.value,
        });
      } else {
        final msg = response.data?['message'] ?? 'Failed to send OTP';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error('Forgot password error: $e');
      Helpers.showError('An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String nextRoute) async {
    if (otp.length < 6) {
      Helpers.showError('Please enter a 6-digit OTP');
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepository.verifyForgotPasswordOtp(
        email: email.value,
        otp: otp,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        final receivedToken = data['resetToken'] ?? data['accessToken'] ?? data['token'];

        if (receivedToken != null) {
          token.value = receivedToken.toString();
          Helpers.showSuccess('OTP Verified');
          Get.toNamed(nextRoute, arguments: {
            'email': email.value,
            'role': currentRole.value,
          });
        } else {
          Helpers.showError('Failed to get authorization token from server');
        }
      } else {
        final msg = response.data?['message'] ?? 'Invalid OTP';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error('Verify OTP error: $e');
      Helpers.showError('An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String loginRoute) async {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      Helpers.showError('Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      Helpers.showError('Passwords do not match');
      return;
    }

    if (password.length < 6) {
      Helpers.showError('Password must be at least 6 characters');
      return;
    }

    if (token.value.isEmpty) {
      Helpers.showError('Session expired. Please start again.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepository.resetPassword(
        token: token.value,
        newPassword: password,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showSuccess('Password reset successfully. Please log in.');
        Get.offAllNamed(loginRoute);
      } else {
        final msg = response.data?['message'] ?? 'Failed to reset password';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error('Reset password error: $e');
      Helpers.showError('An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
