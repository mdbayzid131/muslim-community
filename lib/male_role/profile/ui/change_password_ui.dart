import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';

import 'package:muslim_community/male_role/profile/controller/changepasswordcontroller.dart';

class MaleChangePasswordUI extends StatelessWidget {
  const MaleChangePasswordUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MaleChangePasswordController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.titleColor,
                size: 16.sp,
              ),
            ),
          ),
        ),
        title: Text(
          "CHANGE PASSWORD",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => _buildPasswordField(
                      label: "PREVIOUS PASSWORD",
                      hint: "Enter your current password",
                      controller: controller.currentPasswordCtrl,
                      obscureText: !controller.isCurrentPasswordVisible.value,
                      onToggle: controller.toggleCurrentPasswordVisibility,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Obx(
                    () => _buildPasswordField(
                      label: "NEW PASSWORD",
                      hint: "Enter your new password",
                      controller: controller.newPasswordCtrl,
                      obscureText: !controller.isNewPasswordVisible.value,
                      onToggle: controller.toggleNewPasswordVisibility,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Obx(
                    () => _buildPasswordField(
                      label: "CONFIRM NEW PASSWORD",
                      hint: "Re-enter your new password",
                      controller: controller.confirmPasswordCtrl,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      onToggle: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.changePassword(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.maleColor,
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
                                "Change Password",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.bodyColor.withValues(alpha: 0.7),
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.titleColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.withValues(alpha: 0.5),
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: AppColors.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.withValues(alpha: 0.5),
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
