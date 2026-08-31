import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/widgets/custom_app_bar.dart';
import 'package:muslim_community/modules/home/controller/prayer_settings_controller.dart';

class PrayerSettingsView extends GetView<PrayerSettingsController> {
  const PrayerSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Get.find<AuthService>().userRole;
    final themeColor = AppColors.getRoleColor(role);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: "Prayer Settings"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location Settings",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Row(
                children: [
                  Icon(Icons.my_location, color: themeColor, size: 24.sp),
                  SizedBox(width: 14.w),
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
                    () => Switch.adaptive(
                      value: controller.isAutoDetectLocation.value,
                      onChanged: (val) =>
                          controller.toggleAutoDetectLocation(),
                      activeTrackColor: themeColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            Text(
              "Adhan & Notifications",
              style: GoogleFonts.playfairDisplay(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 12.h),

            _buildPrayerItem(
              "Fajr",
              controller.fajrNotification,
              StorageConstants.fajrAzan,
              themeColor,
            ),
            _buildPrayerItem(
              "Dhuhr",
              controller.dhuhrNotification,
              StorageConstants.dhuhrAzan,
              themeColor,
            ),
            _buildPrayerItem(
              "Asr",
              controller.asrNotification,
              StorageConstants.asrAzan,
              themeColor,
            ),
            _buildPrayerItem(
              "Maghrib",
              controller.maghribNotification,
              StorageConstants.maghribAzan,
              themeColor,
            ),
            _buildPrayerItem(
              "Isha",
              controller.ishaNotification,
              StorageConstants.ishaAzan,
              themeColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerItem(
    String name,
    RxString notification,
    String key,
    Color themeColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.titleColor,
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: () => controller.toggleNotification(notification, key),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: notification.value == "Adhan"
                      ? themeColor.withValues(alpha: 0.12)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      notification.value == "Adhan"
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      size: 16.sp,
                      color: notification.value == "Adhan"
                          ? themeColor
                          : Colors.grey,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      notification.value,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: notification.value == "Adhan"
                            ? themeColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
