import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class AskSuccessUI extends StatelessWidget {
  final String role; // 'brother' or 'sister'

  const AskSuccessUI({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final bool isBrother = role.toLowerCase() == 'brother';
    final Color roleColor = isBrother
        ? AppColors.maleColor
        : AppColors.femaleColor;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premium Styled Circle Checkmark Icon
                Container(
                  width: 130.w,
                  height: 130.w,
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: roleColor, width: 2.5),
                      ),
                      child: Icon(Icons.check, color: roleColor, size: 32.sp),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),

                // Title
                Text(
                  'Question Submitted',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: roleColor,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 30.h),

                // Tailored Description Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    isBrother
                        ? 'May Allah reward you for seeking knowledge. Your question has been received and will be answered by a qualified brother.'
                        : 'May Allah reward you for seeking knowledge. Your question has been received and will be answered by a qualified sister.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: AppColors.bodyColor,
                      height: 1.6,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // Subtitle / Timing info
                Text(
                  'You will receive a thoughtful response soon, insha’Allah.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(
                      0xFFA6864D,
                    ), // AppColors.goldColor equivalent
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 80.h),

                // Minimalist Button Action
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: roleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Back to Discover',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
