import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/jummarole/auth/service/jumma_signup_service.dart';
import 'package:muslim_community/approut.dart';
import 'dart:convert';

class JummaSignupController extends GetxController {
  final JummaSignupService _service = JummaSignupService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var dateOfBirth = "".obs;
  var role = "JUMMAH".obs;
  var agreeToTerms = false.obs;
  var consentToReligiousData = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBirth.value = picked.toUtc().toIso8601String();
    }
  }

  Future<void> signup() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        dateOfBirth.value.isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Please fill all fields',
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (!agreeToTerms.value || !consentToReligiousData.value) {
      Get.snackbar(
        'Consent Required',
        'You must agree to the Terms of Service & Privacy Policy and consent to religious data processing to create an account.',
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.createAccount(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: role.value,
        dateOfBirth: dateOfBirth.value,
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Account created successfully! Please verify your email.',
        );
        Get.toNamed(
          AppRoutes.jummaSignUpOTP,
          arguments: {'email': emailController.text.trim()},
        );
      } else {
        Get.snackbar('Error', decodedData['message'] ?? "Registration failed");
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
