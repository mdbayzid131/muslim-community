import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/services/location_service.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  final ImagePicker _picker = ImagePicker();

  // State
  final currentRole = 'male'.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Multi-step signup form state
  final dateOfBirth = "".obs;
  final revertDate = "".obs;
  final agreeToTerms = false.obs;
  final consentToReligiousData = false.obs;

  // Errors
  final nameError = "".obs;
  final emailError = "".obs;
  final passwordError = "".obs;
  final dobError = "".obs;
  final revertError = "".obs;

  // Identity Verification
  final selectedMethod = Rxn<String>(); // 'photo' or 'video'
  final verificationImage = Rxn<File>();
  final verificationVideo = Rxn<File>();

  // OTP & Timer
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
  final secondsRemaining = 180.obs;
  final timerText = "03:00".obs;
  dynamic _timerSubscription;

  Color get roleColor => AppColors.getRoleColor(currentRole.value);

  String get otp => otpControllers.map((c) => c.text).join();

  void startTimer() {
    secondsRemaining.value = 180;
    _timerSubscription?.cancel();
    _timerSubscription = Stream.periodic(const Duration(seconds: 1), (i) => i)
        .listen((_) {
          if (secondsRemaining.value > 0) {
            secondsRemaining.value--;
            int minutes = secondsRemaining.value ~/ 60;
            int seconds = secondsRemaining.value % 60;
            timerText.value =
                "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
          } else {
            _timerSubscription?.cancel();
          }
        });
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      if (args['role'] != null) {
        currentRole.value = args['role'].toString().toLowerCase();
      }
      if (args['email'] != null && args['email'].toString().isNotEmpty) {
        emailController.text = args['email'].toString();
      }
    } else {
      StorageService.getString(StorageConstants.userRole).then((savedRole) {
        if (savedRole.isNotEmpty) {
          currentRole.value = savedRole.toLowerCase();
        }
      });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void setRole(String role) {
    currentRole.value = role.toLowerCase();
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
      dobError.value = "";
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
      revertError.value = "";
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        verificationImage.value = File(picked.path);
      }
    } catch (e) {
      Helpers.error('Pick image error: $e');
    }
  }

  Future<void> pickVideo(ImageSource source) async {
    try {
      final picked = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(seconds: 15),
      );
      if (picked != null) {
        verificationVideo.value = File(picked.path);
      }
    } catch (e) {
      Helpers.error('Pick video error: $e');
    }
  }

  Future<void> fetchAndSaveCurrentLocation() async {
    isLoading.value = true;
    try {
      final pos = await LocationService.getCurrentLocation();
      if (pos != null) {
        final address =
            await LocationService.getAddressFromCoordinates(pos.latitude, pos.longitude);
        await StorageService.setString(
            StorageConstants.userCity, address['city'] ?? '');
        await StorageService.setString(
            StorageConstants.userCountry, address['country'] ?? '');
        await StorageService.setDouble(
            StorageConstants.latitude, pos.latitude);
        await StorageService.setDouble(
            StorageConstants.longitude, pos.longitude);
      }
      Get.offAllNamed(AppRoutes.navbar);
    } catch (e) {
      Helpers.error("Save location error: $e");
      Get.offAllNamed(AppRoutes.navbar);
    } finally {
      isLoading.value = false;
    }
  }

  // ──────────────────────── LOGIN ────────────────────────

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Helpers.showError('Please enter email and password');
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepository.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        final accessToken = data['accessToken'] ?? data['token'];
        final refreshToken = data['refreshToken'] ?? '';

        if (accessToken != null) {
          final authService = Get.find<AuthService>();
          await authService.saveAuthData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            fallbackRole: currentRole.value,
          );

          Helpers.showSuccess('Login successful');

          final role = authService.userRole.isNotEmpty
              ? authService.userRole
              : currentRole.value;

          if (role == 'male') {
            Get.offAllNamed(AppRoutes.maleNavbar);
          } else if (role == 'female') {
            Get.offAllNamed(AppRoutes.femaleNavbar);
          } else if (role == 'jumma') {
            Get.offAllNamed(AppRoutes.jummaNavbar);
          } else {
            Get.offAllNamed(AppRoutes.navbar);
          }
        } else {
          Helpers.showError('Invalid token received');
        }
      } else {
        final msg = response.data?['message'] ?? 'Login failed';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error('Login error: $e');
      Helpers.showError('An error occurred during login');
    } finally {
      isLoading.value = false;
    }
  }

  // ──────────────────────── SIGN UP VALIDATION & PROCEED ────────────────────────

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
      String pwd = passwordController.text;
      if (pwd.length < 6) {
        passwordError.value = "Password must be at least 6 characters";
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
    }

    if (!isValid) return;

    if (!agreeToTerms.value || !consentToReligiousData.value) {
      Helpers.showWarning(
        'You must agree to the Terms & Privacy and consent to continue.',
        title: 'Consent Required',
      );
      return;
    }

    if (currentRole.value == 'female') {
      Get.toNamed(AppRoutes.femaleIdentityVerification);
    } else {
      Get.toNamed(AppRoutes.maleIdentityVerification);
    }
  }

  Future<void> completeSignUp() async {
    if (selectedMethod.value == null) {
      Helpers.showError('Please choose a verification method');
      return;
    }

    if (selectedMethod.value == 'photo' && verificationImage.value == null) {
      Helpers.showError('Please take/upload your verification photo');
      return;
    }

    if (selectedMethod.value == 'video' && verificationVideo.value == null) {
      Helpers.showError('Please record/upload your verification video');
      return;
    }

    isLoading.value = true;
    try {
      final body = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'role': currentRole.value == 'female'
            ? 'SISTER'
            : currentRole.value == 'jumma'
                ? 'JUMMAH'
                : 'BROTHER',
        'dateOfBirth': dateOfBirth.value,
      };

      if (revertDate.value.isNotEmpty) {
        body['revertDate'] = revertDate.value;
      }

      final response = await authRepository.signUp(
        body: body,
        verificationImage: selectedMethod.value == 'photo'
            ? verificationImage.value
            : null,
        verificationVideo: selectedMethod.value == 'video'
            ? verificationVideo.value
            : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showSuccess('Verification code sent to your email');
        startTimer();
        final nextRoute = currentRole.value == 'female'
            ? AppRoutes.femaleSignUpOTP
            : currentRole.value == 'jumma'
                ? AppRoutes.jummaSignUpOTP
                : AppRoutes.maleSignUpOTP;

        Get.toNamed(nextRoute, arguments: {
          'email': emailController.text.trim(),
          'role': currentRole.value,
        });
      } else {
        final msg = response.data?['message'] ?? 'Sign up failed';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error('Sign up error: $e');
      Helpers.showError('An error occurred during sign up');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String? inputOtp) async {
    final code = (inputOtp != null && inputOtp.isNotEmpty) ? inputOtp : otp;
    if (code.length < 6) {
      Helpers.showError('Please enter a 6-digit OTP');
      return;
    }

    isLoading.value = true;
    try {
      final response = await authRepository.verifyOtp(
        email: emailController.text.trim(),
        otp: code,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final nextRoute = currentRole.value == 'female'
            ? AppRoutes.femaleVerificationComplete
            : AppRoutes.maleVerificationComplete;
        Get.offAllNamed(nextRoute);
      } else {
        final msg = response.data?['message'] ?? 'OTP verification failed';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error('OTP verify error: $e');
      Helpers.showError('An error occurred during verification');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (secondsRemaining.value > 0) return;
    isLoading.value = true;
    try {
      final response = await authRepository.resendOtp(
        email: emailController.text.trim(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Helpers.showSuccess('OTP resent successfully');
        startTimer();
      } else {
        final msg = response.data?['message'] ?? 'Failed to resend OTP';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error('Resend OTP error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timerSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
