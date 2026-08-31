import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/auth/controller/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                // Logo
                Center(
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withValues(alpha: 0.1),
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

                Text(
                  'Welcome Back',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign in to continue your journey.',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF636E72).withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 40.h),

                // Form
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        label: 'EMAIL ADDRESS',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        themeColor: themeColor,
                        controller: controller.emailController,
                        errorText: controller.emailError.value,
                      ),
                      SizedBox(height: 20.h),
                      _buildInputField(
                        label: 'PASSWORD',
                        hint: 'Enter your password',
                        icon: Icons.lock_outline,
                        themeColor: themeColor,
                        isPassword: true,
                        obscureText: !controller.isPasswordVisible.value,
                        controller: controller.passwordController,
                        onToggleVisibility: () =>
                            controller.togglePasswordVisibility(),
                        errorText: controller.passwordError.value,
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            if (controller.currentRole.value == 'female') {
                              Get.toNamed(AppRoutes.femaleForgetPasswordEmail);
                            } else if (controller.currentRole.value ==
                                'jumma') {
                              Get.toNamed(AppRoutes.jummaForgetPasswordEmail);
                            } else {
                              Get.toNamed(AppRoutes.maleForgetPasswordEmail);
                            }
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: themeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.login(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                // Social Login or Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.currentRole.value == 'female') {
                          Get.toNamed(AppRoutes.femaleSignUp);
                        } else if (controller.currentRole.value == 'jumma') {
                          Get.toNamed(AppRoutes.jummaSignUp);
                        } else {
                          Get.toNamed(AppRoutes.maleSignUp);
                        }
                      },
                      child: Text(
                        'Sign Up',
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
    required IconData icon,
    required Color themeColor,
    bool isPassword = false,
    bool obscureText = false,
    TextEditingController? controller,
    VoidCallback? onToggleVisibility,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: themeColor.withValues(alpha: 0.8),
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          style: GoogleFonts.inter(fontSize: 14.sp),
          decoration: InputDecoration(
            errorText:
                errorText != null && errorText.isNotEmpty ? errorText : null,
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade400,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20.sp),
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
