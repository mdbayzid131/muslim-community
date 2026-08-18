import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/home/controller/home_controller.dart';
import 'package:muslim_community/female_role/home/controller/userdatacontroller.dart';
import 'package:muslim_community/female_role/navbar/navbarcontroller.dart';
import 'package:muslim_community/female_role/home/ui/prayer_settings_ui.dart';
import 'package:muslim_community/female_role/notifications/ui/notificationsui.dart';
import 'package:muslim_community/female_role/discover/controller/discover_controller.dart';
import 'dart:math' as math;
import 'package:muslim_community/shared/ui/prayer_recitation_page.dart';
import 'package:muslim_community/shared/widgets/qibla_compass_widget.dart';
import 'package:muslim_community/shared/widgets/coming_soon_dialog.dart';
import 'package:muslim_community/shared/ui/sunrise_details_ui.dart';
import 'package:muslim_community/shared/utils/rakat_info.dart';

class FemaleHomeUI extends StatelessWidget {
  const FemaleHomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final FemaleUserDataController userDataController = Get.put(
      FemaleUserDataController(),
    );
    final FemaleNavbarController navbarController =
        Get.find<FemaleNavbarController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                // --- HEADER ---
                _buildHeader(userDataController),
                SizedBox(height: 30.h),

                // --- PRAYER & QIBLA SECTION ---
                _buildSectionHeader(
                  "Prayer & Qibla",
                  "Settings >",
                  onActionTap: () =>
                      Get.to(() => const FemalePrayerSettingsUI()),
                ),
                SizedBox(height: 20.h),

                // --- PRAYER TIMES ---
                _buildPrayerTimes(controller),
                SizedBox(height: 30.h),

                // --- QIBLA DIRECTION ---
                _buildQiblaCompass(controller),
                SizedBox(height: 30.h),

                // --- COMMUNITY RESOURCES ---
                _buildCommunityResources(navbarController),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FemaleUserDataController controller) {
    return Obx(() {
      final img = controller.userProfileImage.value;

      return Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.black,
                backgroundImage: img.isNotEmpty ? NetworkImage(img) : null,
                onBackgroundImageError: img.isNotEmpty ? (e, s) {} : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "As-salamu alaykum",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
                Text(
                  "Welcome, ${controller.userName.value}",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                  // Removed ellipsis to show full name, it will wrap to next line if needed
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => Get.to(() => const FemaleNotificationsUI()),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.femaleColor.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                Icons.notifications_none,
                color: AppColors.titleColor,
                size: 24.sp,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSectionHeader(
    String title,
    String actionText, {
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        TextButton(
          onPressed: onActionTap ?? () {},
          child: Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.femaleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes(HomeController controller) {
    final prayerCtrl = controller.prayerTimeController;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prayer Times",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "Today · ${prayerCtrl.todayDate.value.isNotEmpty ? prayerCtrl.todayDate.value : 'Loading...'} · ${prayerCtrl.hijriDate.value}",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.bodyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.femaleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.femaleColor,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Obx(
                      () => Text(
                        controller.currentLocation.value,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.femaleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        // --- Dynamic Prayer Cards from API ---
        Obx(() {
          if (prayerCtrl.isLoading.value) {
            return SizedBox(
              height: 150.h,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.femaleColor),
              ),
            );
          }

          final timings = prayerCtrl.prayerTimings;
          if (timings.isEmpty) {
            return const Center(child: Text("No timings available"));
          }

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.w,
            childAspectRatio: 0.8,
            children: [
              _buildPrayerCard(
                "Fajr",
                timings['Fajr'] ?? "--:--",
                'assets/icons/fajr.png',
                isNext: prayerCtrl.nextPrayerName.value == "Fajr",
              ),
              _buildPrayerCard(
                "Sunrise",
                timings['Sunrise'] ?? "--:--",
                'assets/icons/sunrise.png',
                isNext: false,
              ),
              _buildPrayerCard(
                "Dhuhr",
                timings['Dhuhr'] ?? "--:--",
                'assets/icons/dhuhr.png',
                isNext: prayerCtrl.nextPrayerName.value == "Dhuhr",
              ),
              _buildPrayerCard(
                "Asr",
                timings['Asr'] ?? "--:--",
                'assets/icons/asr.png',
                isNext: prayerCtrl.nextPrayerName.value == "Asr",
              ),
              _buildPrayerCard(
                "Maghrib",
                timings['Maghrib'] ?? "--:--",
                'assets/icons/maghrib.png',
                isNext: prayerCtrl.nextPrayerName.value == "Maghrib",
              ),
              _buildPrayerCard(
                "Isha",
                timings['Isha'] ?? "--:--",
                'assets/icons/isha.png',
                isNext: prayerCtrl.nextPrayerName.value == "Isha",
              ),
            ],
          );
        }),
        SizedBox(height: 20.h),
        Center(
          child: Text(
            "Tap card to view recitation",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.bodyColor.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerCard(
    String name,
    String time,
    String iconPath, {
    bool isNext = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (name == "Sunrise") {
          Get.to(
            () => const SunriseDetailsUI(
              themeColor: AppColors.femaleColor,
              isMale: false,
            ),
          );
        } else {
          Get.to(
            () => PrayerRecitationPage(
              waqt: name,
              themeColor: AppColors.femaleColor,
              isMale: false,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isNext
              ? AppColors.femaleColor.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: isNext
              ? Border.all(color: AppColors.femaleColor.withValues(alpha: 0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isNext)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.goldColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    "NEXT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconPath, width: 24.w, height: 24.w),
                  SizedBox(height: 8.h),
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleColor,
                    ),
                  ),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                  if (name != "Sunrise") ...[
                    SizedBox(height: 2.h),
                    Text(
                      "${RakatInfo.getRakatInfo(name).farzRakats} Rakat",
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.femaleColor,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: AppColors.goldColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 12.sp,
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

  Widget _buildQiblaCompass(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.femaleColor.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "QIBLA DIRECTION",
            style: GoogleFonts.playfairDisplay(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 5.h),
          Obx(
            () => Text(
              "Qibla: ${controller.qiblaController.qiblaDirection.value.toStringAsFixed(1)}° from North",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.bodyColor.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 35.h),
          Stack(
            alignment: Alignment.center,
            children: [
              QiblaCompassWidget(
                dialRotation: controller.qiblaController.dialRotation,
                needleRotation: controller.qiblaController.needleRotation,
                primaryColor: AppColors.femaleColor,
              ),
            ],
          ),
          SizedBox(height: 35.h),
          // Instruction Text
          Text(
            "Align your phone to find the Kaaba",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.bodyColor.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
          // Calibration Message
          Obx(
            () => controller.qiblaController.accuracyStatus.value.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.redAccent,
                            size: 18.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              controller.qiblaController.accuracyStatus.value,
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityResources(FemaleNavbarController navbarController) {
    final FemaleDiscoverController discoverController = Get.put(
      FemaleDiscoverController(),
    );

    final List<Map<String, dynamic>> resources = [
      {
        'title': 'Learning',
        'subtitle': 'Islamic online courses and educational content.',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFFE57373),
        'category': 'Learning',
      },
      {
        'title': 'Mosques',
        'subtitle': 'Find nearby mosques and prayer facilities.',
        'icon': Icons.mosque_rounded,
        'color': const Color(0xFF81C784),
        'category': 'Mosques',
      },
      {
        'title': 'Jumma',
        'subtitle': 'Check Jumu\'ah times and special Friday events.',
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFF64B5F6),
        'category': 'Jumma',
      },
      {
        'title': 'Ask Sister',
        'subtitle': 'Connect with a sister for guidance and support.',
        'icon': Icons.question_answer_rounded,
        'color': const Color(0xFFFFB74D),
        'category': 'Ask Sister',
      },
    ];

    return Column(
      children: resources.map((resource) {
        return GestureDetector(
          onTap: () {
            if (resource['category'] == 'Jumma') {
              showComingSoonDialog();
            } else {
              discoverController.selectedCategory.value = resource['category'];
              navbarController.changeIndex(1); // Go to Discover
            }
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 15.h),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: resource['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    resource['icon'],
                    color: resource['color'],
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource['title'],
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        resource['subtitle'],
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.bodyColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.bodyColor.withValues(alpha: 0.3),
                  size: 16.sp,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
