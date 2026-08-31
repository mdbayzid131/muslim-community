import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/utils/rakat_info.dart';
import 'package:muslim_community/core/widgets/qibla_compass_widget.dart';
import 'package:muslim_community/modules/discover/controller/discover_controller.dart';
import 'package:muslim_community/modules/home/controller/home_controller.dart';
import 'package:muslim_community/modules/home/view/prayer_settings_view.dart';
import 'package:muslim_community/modules/home/view/sunrise_details_view.dart';
import 'package:muslim_community/modules/navigation/controller/navigation_controller.dart';
import 'package:muslim_community/modules/prayer_guide/view/prayer_recitation_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = AppColors.getRoleColor(controller.userRole);

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

                  // 1. Header
                  _buildHeader(roleColor),
                  SizedBox(height: 30.h),

                  // 2. Prayer & Qibla Header
                  _buildSectionHeader(
                    "Prayer & Qibla",
                    "Settings >",
                    roleColor,
                    onActionTap: () => Get.to(() => const PrayerSettingsView()),
                  ),
                  SizedBox(height: 20.h),

                  // 3. Prayer Times
                  _buildPrayerTimes(roleColor),
                  SizedBox(height: 30.h),

                  // 4. Qibla Direction
                  _buildQiblaCompass(roleColor),
                  SizedBox(height: 30.h),

                  // 5. Community Resources
                  _buildCommunityResources(roleColor),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(Color roleColor) {
    return Obx(() {
      final img = controller.userProfileImage;
      final name = controller.userName;

      return Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.black,
                backgroundImage:
                    img.isNotEmpty ? NetworkImage(img) : null,
                onBackgroundImageError:
                    img.isNotEmpty ? (e, s) {} : null,
                child: img.isEmpty
                    ? Icon(Icons.person, color: Colors.white, size: 28.sp)
                    : null,
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
                  "Welcome, $name",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.notifications),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications_none_rounded,
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
    String action,
    Color roleColor, {
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            action,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: roleColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerTimes(Color roleColor) {
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
                      "Today · ${prayerCtrl.todayDate.value.isNotEmpty ? prayerCtrl.todayDate.value : 'Today'} · ${prayerCtrl.hijriDate.value}",
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
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: roleColor,
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
                          color: roleColor,
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
              child: Center(
                child: CircularProgressIndicator(color: roleColor),
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
                roleColor,
                isNext: prayerCtrl.nextPrayerName.value == "Fajr",
              ),
              _buildPrayerCard(
                "Sunrise",
                timings['Sunrise'] ?? "--:--",
                'assets/icons/sunrise.png',
                roleColor,
                isNext: false,
              ),
              _buildPrayerCard(
                "Dhuhr",
                timings['Dhuhr'] ?? "--:--",
                'assets/icons/dhuhr.png',
                roleColor,
                isNext: prayerCtrl.nextPrayerName.value == "Dhuhr",
              ),
              _buildPrayerCard(
                "Asr",
                timings['Asr'] ?? "--:--",
                'assets/icons/asr.png',
                roleColor,
                isNext: prayerCtrl.nextPrayerName.value == "Asr",
              ),
              _buildPrayerCard(
                "Maghrib",
                timings['Maghrib'] ?? "--:--",
                'assets/icons/maghrib.png',
                roleColor,
                isNext: prayerCtrl.nextPrayerName.value == "Maghrib",
              ),
              _buildPrayerCard(
                "Isha",
                timings['Isha'] ?? "--:--",
                'assets/icons/isha.png',
                roleColor,
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
    String iconPath,
    Color roleColor, {
    bool isNext = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (name == "Sunrise") {
          Get.to(
            () => SunriseDetailsView(
              themeColor: roleColor,
              isMale: roleColor == AppColors.maleColor,
            ),
          );
        } else {
          Get.to(
            () => PrayerRecitationView(prayerName: name),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isNext
              ? roleColor.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: isNext
              ? Border.all(color: roleColor.withValues(alpha: 0.3))
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
                        color: roleColor,
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

  Widget _buildQiblaCompass(Color roleColor) {
    final qc = controller.qiblaController;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: roleColor.withValues(alpha: 0.08),
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
              "Qibla: ${qc.qiblaDirection.value.toStringAsFixed(1)}° from North",
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
                dialRotation: qc.dialRotation,
                needleRotation: qc.needleRotation,
                primaryColor: roleColor,
              ),
            ],
          ),
          SizedBox(height: 35.h),
          Text(
            "Align your phone to find the Kaaba",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.bodyColor.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
            ),
          ),
          Obx(
            () => qc.accuracyStatus.value.isNotEmpty
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
                              qc.accuracyStatus.value,
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

  Widget _buildCommunityResources(Color roleColor) {
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
        'subtitle': "Check Jumu'ah times and special Friday events.",
        'icon': Icons.event_available_rounded,
        'color': const Color(0xFF64B5F6),
        'category': 'Jumma',
      },
      {
        'title': controller.userRole == 'female' ? 'Ask Sister' : 'Ask Brother',
        'subtitle': 'Connect with a member for guidance and support.',
        'icon': Icons.question_answer_rounded,
        'color': const Color(0xFFFFB74D),
        'category':
            controller.userRole == 'female' ? 'Ask Sister' : 'Ask Brother',
      },
    ];

    return Column(
      children: resources.map((resource) {
        return GestureDetector(
          onTap: () {
            if (resource['category'] == 'Jumma') {
              _showComingSoonDialog();
            } else {
              if (Get.isRegistered<DiscoverController>()) {
                Get.find<DiscoverController>().selectedCategory.value =
                    resource['category'];
              }
              if (Get.isRegistered<NavigationController>()) {
                Get.find<NavigationController>().changeIndex(1); // Discover
              }
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
                    color: (resource['color'] as Color).withValues(alpha: 0.1),
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

  void _showComingSoonDialog() {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 50.sp,
                color: AppColors.goldColor,
              ),
              SizedBox(height: 15.h),
              Text(
                "Coming Soon",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "This feature is under development and will be available in the upcoming release.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.bodyColor,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
