import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/selecterole/selectedcontroller.dart';
import 'package:muslim_community/male_role/auth/controller/male_create_account_controller.dart';
import 'package:muslim_community/female_role/auth/controller/female_create_account_controller.dart';
import 'package:muslim_community/shared/widgets/coming_soon_dialog.dart';

class SelecteRoleUI extends StatelessWidget {
  const SelecteRoleUI({super.key});

  @override
  Widget build(BuildContext context) {
    final roleController = Get.put(SelectedRoleController());

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Assalamu Alaikum',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Please choose your community space to enter.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFFA6864D),
                  ),
                ),
                SizedBox(height: 40.h),

                // Brother Card
                GestureDetector(
                  onTap: () {
                    roleController.setRole("BROTHER");
                    Get.put(MaleCreateAccountController()).setRole("BROTHER");
                    Get.toNamed(AppRoutes.maleLogin);
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 180.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8F9),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: const Color(0xFF5B7C99).withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        children: [
                          // Just the Image as requested (no container border)
                          Image.asset(
                            'assets/icons/brotherlogo.png',
                            width: 100.w, // Large icon
                            height: 100.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'COMMUNITY',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    color: const Color(
                                      0xFF5B7C99,
                                    ).withValues(alpha: 0.5),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  'SYA BROTHER',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF5B7C99),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'A space of brotherhood, strength, and spiritual growth.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5B7C99),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Sister Card
                GestureDetector(
                  onTap: () {
                    roleController.setRole("SISTER");
                    Get.put(FemaleCreateAccountController()).setRole("SISTER");
                    Get.toNamed(AppRoutes.femaleLogin);
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 180.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF9F6),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: const Color(0xFFD18E8E).withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/sisterlogo.png',
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'COMMUNITY',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    color: const Color(
                                      0xFFD18E8E,
                                    ).withValues(alpha: 0.5),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  'SYA SISTER',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFD18E8E),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'A space of sisterhood, grace, and spiritual nurture.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD18E8E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Jumma Card
                GestureDetector(
                  onTap: () {
                    showComingSoonDialog();
                  },
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 180.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F7F4),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: const Color(0xFF436E50).withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/jummalogo.png',
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SYA Jumma',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF436E50),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  'Finding Peace in Prayer',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF436E50),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
