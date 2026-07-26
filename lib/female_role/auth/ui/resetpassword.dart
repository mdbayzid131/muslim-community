import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/shared/auth/controller/forget_password_controller.dart';

class FemaleResetPasswordUI extends StatelessWidget {
  const FemaleResetPasswordUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF436E50);
    final controller = Get.find<ForgetPasswordController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: themeColor, size: 20.sp),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Icon
              Center(
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_outlined,
                        color: themeColor,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
              Text(
                'Reset Password',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),

              SizedBox(height: 12.h),
              Text(
                'Create a strong password to secure your account.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFF636E72),
                ),
              ),

              SizedBox(height: 40.h),

              // Password Fields
              _buildPasswordField(
                label: 'NEW PASSWORD',
                hint: 'Enter new password',
                controller: controller.passwordController,
                isVisible: controller.isPasswordVisible,
                toggleVisibility: controller.togglePasswordVisibility,
                themeColor: themeColor,
              ),

              SizedBox(height: 20.h),

              _buildPasswordField(
                label: 'CONFIRM PASSWORD',
                hint: 'Confirm new password',
                controller: controller.confirmPasswordController,
                isVisible: controller.isConfirmPasswordVisible,
                toggleVisibility: controller.toggleConfirmPasswordVisibility,
                themeColor: themeColor,
              ),

              SizedBox(height: 40.h),

              // Reset Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.resetPassword(AppRoutes.femaleLogin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Reset Password',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required RxBool isVisible,
    required VoidCallback toggleVisibility,
    required Color themeColor,
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
        Obx(
          () => TextField(
            controller: controller,
            obscureText: !isVisible.value,
            style: GoogleFonts.inter(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey.shade400,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.grey.shade400,
                size: 20.sp,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: toggleVisibility,
              ),
              filled: true,
              fillColor: const Color(0xFFEDF4F1).withValues(alpha: 0.6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
