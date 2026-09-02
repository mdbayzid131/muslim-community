import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/services/azan_service.dart';
import 'package:muslim_community/core/widgets/custom_app_bar.dart';
import 'package:muslim_community/modules/home/controller/prayer_settings_controller.dart';

class PrayerSettingsView extends StatelessWidget {
  const PrayerSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PrayerSettingsController>()
        ? Get.find<PrayerSettingsController>()
        : Get.put(PrayerSettingsController());
    final role = Get.isRegistered<AuthService>()
        ? Get.find<AuthService>().userRole
        : 'male';
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
                      onChanged: (val) => controller.toggleAutoDetectLocation(),
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
              controller,
              "Fajr",
              controller.fajrNotification,
              StorageConstants.fajrAzan,
              themeColor,
              isFajr: true,
            ),
            _buildPrayerItem(
              controller,
              "Dhuhr",
              controller.dhuhrNotification,
              StorageConstants.dhuhrAzan,
              themeColor,
            ),
            _buildPrayerItem(
              controller,
              "Asr",
              controller.asrNotification,
              StorageConstants.asrAzan,
              themeColor,
            ),
            _buildPrayerItem(
              controller,
              "Maghrib",
              controller.maghribNotification,
              StorageConstants.maghribAzan,
              themeColor,
            ),
            _buildPrayerItem(
              controller,
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
    PrayerSettingsController controller,
    String name,
    RxString notification,
    String key,
    Color themeColor, {
    bool isFajr = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
          Row(
            children: [
              // Dedicated Play / Preview / Stop Icon Button
              Obx(() {
                final azanService = Get.isRegistered<AzanService>()
                    ? Get.find<AzanService>()
                    : null;
                final isPlayingThis =
                    azanService != null &&
                    azanService.isPreviewPlaying.value &&
                    azanService.currentlyPlayingPrayer.value == name;

                return GestureDetector(
                  onTap: () =>
                      controller.toggleAzanPreview(name, isFajr: isFajr),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isPlayingThis
                          ? Colors.red.withValues(alpha: 0.12)
                          : themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPlayingThis
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                          color: isPlayingThis ? Colors.red : themeColor,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isPlayingThis ? "Stop" : "Preview",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: isPlayingThis ? Colors.red : themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(width: 12.w),

              // ON / OFF Switch Toggle
              Obx(
                () => Switch.adaptive(
                  value: notification.value == "Adhan",
                  onChanged: (isOn) {
                    controller.setNotificationState(
                      notification,
                      key,
                      isOn ? "Adhan" : "Off",
                    );
                  },
                  activeTrackColor: themeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
