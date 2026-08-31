import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/modules/discover/view/wudu_ghusl_flashcard_view.dart';
import 'package:muslim_community/modules/home/view/three_quls_view.dart';
import 'package:muslim_community/modules/prayer_guide/view/prayer_rakat_guide_view.dart';

class LearningView extends StatelessWidget {
  const LearningView({super.key});

  @override
  Widget build(BuildContext context) {
    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final themeColor = AppColors.getRoleColor(role);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      children: [
        SizedBox(height: 15.h),

        // Card 0: Prayer & Rakat Guide
        _buildLearningSectionCard(
          title: "Prayer Rakat & Learning Guide",
          subtitle:
              "Complete Rakat count & recitation guide (Fajr 2, Dhuhr 4 Rakats...)",
          icon: Icons.mosque_rounded,
          themeColor: themeColor,
          onTap: () {
            Get.to(
              () => PrayerRakatGuideView(
                themeColor: themeColor,
                isMale: role != 'female',
              ),
            );
          },
        ),

        SizedBox(height: 16.h),

        // Card 1: How to Perform Ghusl
        _buildLearningSectionCard(
          title: "How to Perform Ghusl",
          subtitle: "Step-by-step ritual purification bath guide.",
          icon: Icons.shower_rounded,
          themeColor: themeColor,
          onTap: () {
            Get.to(
              () => const WuduGhuslFlashcardView(title: "How to Perform Ghusl"),
            );
          },
        ),

        SizedBox(height: 16.h),

        // Card 2: How to Make Wudu
        _buildLearningSectionCard(
          title: "How to Make Wudu",
          subtitle: "Step-by-step ritual purification guide for prayer.",
          icon: Icons.clean_hands_rounded,
          themeColor: themeColor,
          onTap: () {
            Get.to(
              () => const WuduGhuslFlashcardView(title: "How to Make Wudu"),
            );
          },
        ),

        SizedBox(height: 16.h),

        // Card 3: 3 Quls
        _buildLearningSectionCard(
          title: "3 Quls",
          subtitle: "Listen, read and learn the three protective Surahs.",
          icon: Icons.menu_book_rounded,
          themeColor: themeColor,
          onTap: () {
            Get.to(() => ThreeQulsView(themeColor: themeColor));
          },
        ),
      ],
    );
  }

  Widget _buildLearningSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color themeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: themeColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            // Text Container
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.bodyColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: themeColor.withValues(alpha: 0.4),
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
