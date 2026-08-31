import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/rakat_info.dart';
import 'package:muslim_community/modules/prayer_guide/view/prayer_recitation_view.dart';

class PrayerRakatGuideView extends StatelessWidget {
  final Color? themeColor;
  final bool? isMale;

  const PrayerRakatGuideView({
    super.key,
    this.themeColor,
    this.isMale,
  });

  @override
  Widget build(BuildContext context) {
    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final activeColor = themeColor ?? AppColors.getRoleColor(role);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.titleColor,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Prayer Rakat Guide",
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        children: [
          // Header Card
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  activeColor,
                  activeColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mosque_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prayer Rakat & Learning Guide",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Detailed breakdown of Rakat counts and recitation steps for each prayer.",
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          Text(
            "DAILY PRAYERS",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.bodyColor.withValues(alpha: 0.6),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 12.h),

          // List of 5 daily prayers
          ...RakatInfo.allPrayers.map((info) => _buildPrayerRakatCard(context, info, activeColor)),
        ],
      ),
    );
  }

  Widget _buildPrayerRakatCard(BuildContext context, RakatInfo info, Color activeColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: activeColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: () {
            Get.to(
              () => PrayerRecitationView(
                prayerName: info.waqt,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Rakat Badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: activeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${info.farzRakats}",
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: activeColor,
                        ),
                      ),
                      Text(
                        "FARZ",
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: activeColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15.w),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.waqt,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        info.rakatSummaryEn,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: activeColor,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Breakdown: ${info.rakatDetailsEn}",
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: AppColors.bodyColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: activeColor.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
