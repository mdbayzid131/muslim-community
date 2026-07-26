import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/services/forget_password_service.dart';

class ForgetPasswordController extends GetxController {
  final ForgetPasswordService _service = ForgetPasswordService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  var isLoading = false.obs;
  var email = "".obs;
  var token = "".obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Timer logic
  var secondsRemaining = 180.obs;
  var timerText = "03:00".obs;
  Timer? _timer;

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
    if (emailController.text.isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.forgotPassword(
        emailController.text.trim(),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        email.value = emailController.text.trim();
        debugPrint("OTP Success: ${response.body}");
        Get.snackbar('Success', 'OTP sent to your email');
        startTimer();
        Get.toNamed(nextRoute, arguments: {'email': email.value});
      } else {
        debugPrint("OTP Error Status: ${response.statusCode}");
        debugPrint("OTP Error Body: ${response.body}");
        Get.snackbar('Error', data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      debugPrint("OTP Exception: $e");
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String nextRoute) async {
    if (otp.length < 6) {
      Get.snackbar('Error', 'Please enter a 6-digit OTP');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.verifyOtp(email.value, otp);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract resetToken from response based on the raw data you provided
        final receivedToken =
            data['data']?['resetToken'] ??
            data['resetToken'] ??
            data['data']?['accessToken'] ??
            data['data']?['token'] ??
            data['accessToken'] ??
            data['token'];

        if (receivedToken != null) {
          token.value = receivedToken;
          Get.snackbar('Success', 'OTP Verified');
          Get.toNamed(nextRoute);
        } else {
          Get.snackbar(
            'Error',
            'Failed to get authorization token from server',
          );
        }
      } else {
        Get.snackbar('Error', data['message'] ?? 'Invalid OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String loginRoute) async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters long');
      return;
    }

    if (token.value.isEmpty) {
      Get.snackbar('Error', 'Session expired. Please start again.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.resetPassword(
        token: token.value,
        password: passwordController.text,
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Password reset successfully. Please login.');
        Get.offAllNamed(loginRoute);
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to reset password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
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
