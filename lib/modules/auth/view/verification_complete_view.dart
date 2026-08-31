import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/auth/controller/auth_controller.dart';

class VerificationCompleteView extends GetView<AuthController> {
  const VerificationCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
            onPressed: () => Get.back(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(true, themeColor),
              _buildDot(true, themeColor),
              _buildDot(true, themeColor),
            ],
          ),
          centerTitle: true,
          actions: [SizedBox(width: 48.w)],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withValues(alpha: 0.1),
                          blurRadius: 30.r,
                          spreadRadius: 10.r,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeColor.withValues(alpha: 0.1),
                        ),
                        child: Icon(Icons.check, size: 40.sp, color: themeColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                Text(
                  'Verification Complete',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    controller.currentRole.value == 'female'
                        ? 'Alhamdulillah! Your profile has been submitted for review. Welcome to the Sisters community.'
                        : 'Alhamdulillah! Your profile has been submitted for review. Welcome to the Brothers community.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: const Color(0xFFA6864D).withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.currentRole.value == 'female') {
                        Get.offAllNamed(AppRoutes.femaleLogin);
                      } else if (controller.currentRole.value == 'jumma') {
                        Get.offAllNamed(AppRoutes.jummaLogin);
                      } else {
                        Get.offAllNamed(AppRoutes.maleLogin);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDot(bool isActive, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : color.withValues(alpha: 0.2),
      ),
    );
  }
}
