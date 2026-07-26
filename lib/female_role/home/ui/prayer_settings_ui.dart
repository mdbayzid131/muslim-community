import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/home/controller/prayer_settings_controller.dart';

import 'package:muslim_community/services/azan_service.dart';

class FemalePrayerSettingsUI extends StatelessWidget {
  const FemalePrayerSettingsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemalePrayerSettingsController controller = Get.put(
      FemalePrayerSettingsController(),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            _buildAppBar(),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LOCATION & QIBLA SECTION
                      Text(
                        "LOCATION & QIBLA",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bodyColor.withValues(alpha: 0.6),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildLocationCard(controller),

                      SizedBox(height: 30.h),

                      // NOTIFICATIONS SECTION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "NOTIFICATIONS",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodyColor.withValues(alpha: 0.6),
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            "Tap to cycle alerts",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: AppColors.bodyColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      _buildNotificationsCard(controller),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.titleColor,
              size: 20.sp,
            ),
          ),
          Text(
            "Prayer Settings",
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.femaleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.femaleColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(FemalePrayerSettingsController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.femaleColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.femaleColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.near_me_outlined,
              color: AppColors.femaleColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Auto-Detect Location",
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleColor,
                  ),
                ),
                Text(
                  "Use GPS for accurate prayer times",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => CupertinoSwitch(
              value: controller.isAutoDetectLocation.value,
              activeColor: AppColors.femaleColor,
              onChanged: (value) => controller.toggleAutoDetectLocation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard(FemalePrayerSettingsController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.femaleColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildNotificationItem(
            "Fajr",
            controller.fajrNotification,
            controller,
            AzanService.fajrKey,
          ),
          _buildDivider(),
          _buildNotificationItem(
            "Sunrise",
            controller.sunriseNotification,
            controller,
            "sunrise_azan",
          ),
          _buildDivider(),
          _buildNotificationItem(
            "Dhuhr",
            controller.dhuhrNotification,
            controller,
            AzanService.dhuhrKey,
          ),
          _buildDivider(),
          _buildNotificationItem(
            "Asr",
            controller.asrNotification,
            controller,
            AzanService.asrKey,
          ),
          _buildDivider(),
          _buildNotificationItem(
            "Maghrib",
            controller.maghribNotification,
            controller,
            AzanService.maghribKey,
          ),
          _buildDivider(),
          _buildNotificationItem(
            "Isha",
            controller.ishaNotification,
            controller,
            AzanService.ishaKey,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String name,
    RxString status,
    FemalePrayerSettingsController controller,
    String key, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.titleColor,
            ),
          ),
          GestureDetector(
            onTap: () => controller.toggleNotification(status, key),
            child: Obx(() {
              bool isOff = status.value == "Off" || status.value == "Silent";
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isOff
                      ? Colors.grey.withValues(alpha: 0.1)
                      : AppColors.femaleColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isOff
                        ? Colors.grey.withValues(alpha: 0.3)
                        : AppColors.femaleColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status.value == "Off" || status.value == "Silent"
                          ? "Off"
                          : "On",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isOff ? Colors.grey[600] : AppColors.femaleColor,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      isOff
                          ? Icons.volume_off_outlined
                          : Icons.volume_up_outlined,
                      color: isOff ? Colors.grey[600] : AppColors.femaleColor,
                      size: 16.sp,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withValues(alpha: 0.1),
      indent: 20.w,
      endIndent: 20.w,
    );
  }
}
