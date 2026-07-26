import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/auth/service/male_create_account_service.dart';
import 'package:muslim_community/male_role/auth/controller/male_verify_controller.dart';
import 'dart:convert';

import '../../../approut.dart';

class MaleCreateAccountController extends GetxController {
  final MaleCreateAccountService _service = MaleCreateAccountService();
  final MaleVerifyController verifyController = Get.put(MaleVerifyController());

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  var role = "BROTHER".obs;
  var dateOfBirth = "".obs;
  var revertDate = "".obs;
  var agreeToTerms = false.obs;
  var consentToReligiousData = false.obs;
  var nameError = "".obs;
  var emailError = "".obs;
  var passwordError = "".obs;
  var dobError = "".obs;
  var revertError = "".obs;

  var isLoading = false.obs;

  void setRole(String selectedRole) {
    role.value = selectedRole;
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBirth.value = picked.toUtc().toIso8601String();
      dobError.value = ""; // clear dob error if a date was picked
    }
  }

  Future<void> pickRevertDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      revertDate.value = picked.toUtc().toIso8601String();
      revertError.value = ""; // clear revert error if a date was picked
    }
  }

  void validateAndNext() {
    nameError.value = "";
    emailError.value = "";
    passwordError.value = "";
    dobError.value = "";
    revertError.value = "";

    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = "Name is required";
      isValid = false;
    }

    if (emailController.text.trim().isEmpty) {
      emailError.value = "Email is required";
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = "Please enter a valid email address";
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = "Password is required";
      isValid = false;
    } else {
      String password = passwordController.text;
      bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      bool hasSpecialCharacters = password.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
      );

      if (password.length < 8 ||
          !hasUppercase ||
          !hasLowercase ||
          !hasDigits ||
          !hasSpecialCharacters) {
        passwordError.value =
            "Must be 8+ chars with A-Z, a-z, 0-9 & special char";
        isValid = false;
      }
    }

    if (revertDate.value.isEmpty) {
      revertError.value = "Revert date is required";
      isValid = false;
    }

    if (dateOfBirth.value.isEmpty) {
      dobError.value = "Birthday is required";
      isValid = false;
    } else {
      DateTime dob = DateTime.parse(dateOfBirth.value);
      DateTime now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      if (age < 16) {
        dobError.value = "You must be at least 16 years old";
        isValid = false;
      }
    }

    if (!isValid) {
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

    Get.toNamed(AppRoutes.maleIdentityVerification);
  }

  Future<void> createAccount() async {
    // Debug Logging
    print("--- Registration Data Debug ---");
    print("Name: ${nameController.text}");
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    print("Role: ${role.value}");
    print("DOB: ${dateOfBirth.value}");
    print("Revert Date: ${revertDate.value}");
    print("Image Path: ${verifyController.verificationImage.value?.path}");
    print("Video Path: ${verifyController.verificationVideo.value?.path}");
    print("-------------------------------");

    // Detailed Validation
    String missingFields = "";
    if (nameController.text.isEmpty) missingFields += "Name, ";
    if (emailController.text.isEmpty) missingFields += "Email, ";
    if (passwordController.text.isEmpty) missingFields += "Password, ";
    if (dateOfBirth.value.isEmpty) missingFields += "Date of Birth, ";

    // Require verification based on the selected method
    if (verifyController.selectedMethod.value == null) {
      missingFields += "Verification method selection, ";
    } else if (verifyController.selectedMethod.value == 'photo' &&
        verifyController.verificationImage.value == null) {
      missingFields += "Photo verification, ";
    } else if (verifyController.selectedMethod.value == 'video' &&
        verifyController.verificationVideo.value == null) {
      missingFields += "Video verification, ";
    }

    if (missingFields.isNotEmpty) {
      String errorMsg =
          "Missing: ${missingFields.substring(0, missingFields.length - 2)}";
      print("Validation Error: $errorMsg");
      Get.snackbar(
        'Validation Error',
        errorMsg,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _service.createAccount(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: role.value,
        dateOfBirth: dateOfBirth.value,
        revertDate: revertDate.value.isNotEmpty ? revertDate.value : null,
        verificationImage: verifyController.selectedMethod.value == 'photo'
            ? verifyController.verificationImage.value
            : null,
        verificationVideo: verifyController.selectedMethod.value == 'video'
            ? verifyController.verificationVideo.value
            : null,
      );

      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Account created successfully! Please verify your email.',
        );
        Get.toNamed(
          AppRoutes.maleSignUpOTP,
          arguments: {'email': emailController.text},
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

  @override
  void onClose() {
    super.onClose();
  }
}
