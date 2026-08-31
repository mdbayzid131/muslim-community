import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/select_role/controller/select_role_controller.dart';

class SelectRoleView extends GetView<SelectRoleController> {
  const SelectRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Please choose your community space to enter.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.goldColor,
                  ),
                ),
                SizedBox(height: 40.h),

                // Brother Card
                _buildRoleCard(
                  titleBadge: 'COMMUNITY',
                  title: 'SYA BROTHER',
                  description:
                      'A space of brotherhood, strength, and spiritual growth.',
                  color: AppColors.maleColor,
                  cardBgColor: const Color(0xFFF4F8F9),
                  iconPath: ImagePaths.brotherLogo,
                  onTap: () => controller.selectRole('male'),
                ),
                SizedBox(height: 20.h),

                // Sister Card
                _buildRoleCard(
                  titleBadge: 'COMMUNITY',
                  title: 'SYA SISTER',
                  description:
                      'A supportive space for sisters to learn, connect, and thrive.',
                  color: AppColors.femaleColor,
                  cardBgColor: const Color(0xFFFDF4F4),
                  iconPath: ImagePaths.sisterLogo,
                  onTap: () => controller.selectRole('female'),
                ),
                SizedBox(height: 20.h),

                // Jummah Card
                _buildRoleCard(
                  titleBadge: 'WEEKLY SACRED HOUR',
                  title: 'JUMMAH PRAYER',
                  description:
                      'Experience unity with live khutbahs, timings, and reflections.',
                  color: AppColors.jummaColor,
                  cardBgColor: const Color(0xFFF4F9F5),
                  iconPath: ImagePaths.jummaLogo,
                  onTap: () => controller.selectRole('jumma'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String titleBadge,
    required String title,
    required String description,
    required Color color,
    required Color cardBgColor,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 180.h),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Row(
            children: [
              Container(
                width: 85.w,
                height: 85.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 16.r,
                      spreadRadius: 2.r,
                      offset: Offset(0, 6.h),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.w),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titleBadge,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: color.withValues(alpha: 0.5),
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      description,
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
                decoration: BoxDecoration(
                  color: color,
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
    );
  }
}
