import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/auth/controller/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                // Top Logo
                Center(
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldColor.withValues(alpha: 0.1),
                          blurRadius: 20.r,
                          spreadRadius: 5.r,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      ImagePaths.splashScreenLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                // Titles
                FittedBox(
                  child: Text(
                    'Join the Community',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start your spiritual journey with us.',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF636E72).withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 30.h),

                // Form Container
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        label: 'FULL NAME',
                        hint: 'Enter your full name',
                        icon: Icons.person_outline,
                        themeColor: themeColor,
                        controller: controller.nameController,
                        keyboardType: TextInputType.name,
                        errorText: controller.nameError.value,
                      ),
                      SizedBox(height: 16.h),
                      _buildInputField(
                        label: 'EMAIL ADDRESS',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        themeColor: themeColor,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: controller.emailError.value,
                      ),
                      SizedBox(height: 16.h),
                      _buildInputField(
                        label: 'PASSWORD',
                        hint: 'Create a password',
                        icon: Icons.lock_outline,
                        themeColor: themeColor,
                        isPassword: true,
                        obscureText: !controller.isPasswordVisible.value,
                        controller: controller.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        onToggleVisibility: () =>
                            controller.togglePasswordVisibility(),
                        errorText: controller.passwordError.value,
                      ),
                      SizedBox(height: 16.h),
                      _buildInputField(
                        label: 'HOW LONG HAVE YOU BEEN A REVERT?',
                        hint: controller.revertDate.value.isEmpty
                            ? 'Select date'
                            : controller.revertDate.value.split('T').first,
                        themeColor: themeColor,
                        icon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: () => controller.pickRevertDate(context),
                        errorText: controller.revertError.value,
                      ),
                      SizedBox(height: 16.h),
                      _buildInputField(
                        label: 'BIRTHDAY',
                        hint: controller.dateOfBirth.value.isEmpty
                            ? 'Select your birthday'
                            : controller.dateOfBirth.value.split('T').first,
                        themeColor: themeColor,
                        icon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: () => controller.pickDateOfBirth(context),
                        errorText: controller.dobError.value,
                      ),
                      SizedBox(height: 16.h),

                      // Consent Checkbox 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: Checkbox(
                              value: controller.agreeToTerms.value,
                              onChanged: (bool? value) {
                                controller.agreeToTerms.value = value ?? false;
                              },
                              activeColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF636E72),
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'I agree to the ',
                                  ),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () => _launchURL(
                                        'https://muslim-community.org/terms',
                                      ),
                                      child: Text(
                                        'Terms of Service',
                                        style: TextStyle(
                                          color: themeColor,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () => _launchURL(
                                        'https://muslim-community.org/privacy',
                                      ),
                                      child: Text(
                                        'Privacy Policy',
                                        style: TextStyle(
                                          color: themeColor,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(
                                    text:
                                        ', and understand how my data will be used to support my journey.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Consent Checkbox 2
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: Checkbox(
                              value: controller.consentToReligiousData.value,
                              onChanged: (bool? value) {
                                controller.consentToReligiousData.value =
                                    value ?? false;
                              },
                              activeColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'I explicitly consent to the processing of my religious data to personalise my community experience.',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: const Color(0xFF636E72),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () => controller.validateAndNext(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/creataccout.png',
                                width: 20.w,
                                height: 20.w,
                                color: Colors.white,
                                errorBuilder: (c, e, s) => const SizedBox(),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Create Account',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Moon Divider
                Row(
                  children: [
                    const Expanded(child: Divider(indent: 40, endIndent: 10)),
                    Image.asset(
                      'assets/icons/selecteduration.png',
                      width: 16.w,
                      height: 16.w,
                      color: themeColor.withValues(alpha: 0.5),
                      errorBuilder: (c, e, s) => Icon(
                        Icons.nights_stay_outlined,
                        size: 16.sp,
                        color: themeColor.withValues(alpha: 0.5),
                      ),
                    ),
                    const Expanded(child: Divider(indent: 10, endIndent: 40)),
                  ],
                ),
                SizedBox(height: 20.h),

                // Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.currentRole.value == 'female') {
                          Get.toNamed(AppRoutes.femaleLogin);
                        } else if (controller.currentRole.value == 'jumma') {
                          Get.toNamed(AppRoutes.jummaLogin);
                        } else {
                          Get.toNamed(AppRoutes.maleLogin);
                        }
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? icon,
    required Color themeColor,
    bool isPassword = false,
    bool obscureText = false,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    VoidCallback? onToggleVisibility,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14.sp, color: themeColor),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: themeColor.withValues(alpha: 0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 14.sp),
          decoration: InputDecoration(
            errorText:
                errorText != null && errorText.isNotEmpty ? errorText : null,
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey.shade400, size: 20.sp)
                : null,
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onToggleVisibility,
                    child: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey.shade400,
                      size: 20.sp,
                    ),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFEDF4F1).withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }
}
