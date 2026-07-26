import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';

class SunriseDetailsUI extends StatelessWidget {
  final Color themeColor;
  final bool isMale;

  const SunriseDetailsUI({
    super.key,
    required this.themeColor,
    required this.isMale,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
          "Sunrise Details",
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER GRADIENT CARD ---
            _buildSunriseHeaderCard(),
            SizedBox(height: 25.h),

            // --- PROHIBITED TIMES SECTION ---
            Text(
              "Prohibited Times for Namaz",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "In Islam, it is strictly forbidden (Haraam/Makruh Tahrimi) to perform any kind of prayer (Namaz/Salat) during three specific times of the day.",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.bodyColor,
              ),
            ),
            SizedBox(height: 20.h),

            // 1. Sunrise Card
            _buildTimeDetailCard(
              title: "1. During Sunrise",
              description:
                  "From the moment the sun begins to rise until it has fully risen and cleared the horizon (approx. 15-20 minutes after sunrise). Praying any kind of Salat (Fard, Wajib, Sunnah, or Nafl) is forbidden during this period.",
              icon: Icons.wb_sunny_rounded,
              iconColor: const Color(0xFFFF9800),
              bgColor: const Color(0xFFFFF8E1),
            ),
            SizedBox(height: 15.h),

            // 2. Noon Card
            _buildTimeDetailCard(
              title: "2. At Zawal (Zenith/Midday)",
              description:
                  "When the sun is at its highest point (midday/zenith) until it begins to decline towards the west. As soon as the sun starts to decline, Dhuhr time begins, and prayer becomes permissible.",
              icon: Icons.access_time_filled_rounded,
              iconColor: const Color(0xFFE91E63),
              bgColor: const Color(0xFFFCE4EC),
            ),
            SizedBox(height: 15.h),

            // 3. Sunset Card
            _buildTimeDetailCard(
              title: "3. During Sunset",
              description:
                  "From the time the sun begins to turn pale/yellowish/red until it has completely set (approx. 15-20 minutes before Maghrib starts).\n\n*Note: If you have not yet prayed the Fard of the current day's Asr prayer, it can still be prayed during this time before the sun sets, though delaying it this long intentionally is highly disliked (Makruh Tahrimi).",
              icon: Icons.wb_twilight_rounded,
              iconColor: const Color(0xFFF44336),
              bgColor: const Color(0xFFFFEBEE),
            ),
            SizedBox(height: 25.h),

            // --- HADITH REFERENCE CARD ---
            _buildHadithCard(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSunriseHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFF57C00), Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF57C00).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wb_sunny_outlined,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Transition Time",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Sunrise (Prohibited Period)",
              style: GoogleFonts.playfairDisplay(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "No prayer is allowed during sunrise. You may perform Ishraq (sunrise prayer) after the sun has fully risen and cleared the horizon (approximately 15-20 minutes after sunrise).",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.95),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDetailCard({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
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
                  SizedBox(height: 8.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppColors.bodyColor,
                      height: 1.5,
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

  Widget _buildHadithCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.15),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: themeColor,
                  size: 28.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Hadith Reference",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "Uqbah ibn Amir (R.A.) said:\n\"The Messenger of Allah (S.A.W.) forbade us to pray or to bury our dead at three times:\n1. When the sun begins to rise until it has fully risen.\n2. When the sun is at its zenith (midday) until it begins to decline.\n3. When the sun begins to set until it has completely set.\"",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.titleColor,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 6.h),
            Text(
              "— Sahih Muslim, Hadith No. 1373",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.bodyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
