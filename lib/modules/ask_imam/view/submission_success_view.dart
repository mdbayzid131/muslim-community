import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/widgets/custom_button.dart';

class SubmissionSuccessView extends StatelessWidget {
  const SubmissionSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Get.find<AuthService>().userRole;
    final themeColor = AppColors.getRoleColor(role);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 64.sp,
                  ),
                ),
              ),
              SizedBox(height: 28.h),

              Text(
                'Question Submitted!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'JazakAllah Khair for your question. An experienced imam will review it and provide a detailed answer in your questions tab.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.bodyColor,
                  height: 1.4,
                ),
              ),
              const Spacer(),

              CustomButton(
                text: 'Back to Ask Imam',
                backgroundColor: themeColor,
                onPressed: () => Get.back(),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
