import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';
import 'package:muslim_community/modules/home/controller/jumma_home_controller.dart';

class JummaHomeView extends StatelessWidget {
  const JummaHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      JummaHomeController(
        learningRepository: Get.find<LearningRepository>(),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchKhutbahs(),
          color: AppColors.jummaColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                  decoration: BoxDecoration(
                    color: AppColors.jummaColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Jumu'ah Mubarak",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Image.asset(
                            ImagePaths.mosqueIcon,
                            width: 28.w,
                            height: 28.w,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.mosque, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'BLESSED FRIDAY REFLECTION',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.khutbahs.isEmpty) {
                      return SizedBox(
                        height: 350.h,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.jummaColor,
                          ),
                        ),
                      );
                    }

                    if (controller.khutbahs.isEmpty) {
                      return SizedBox(
                        height: 350.h,
                        child: Center(
                          child: Text(
                            "No Khutbahs available currently.",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppColors.bodyColor,
                            ),
                          ),
                        ),
                      );
                    }

                    final featured = controller.khutbahs.first;
                    final others = controller.khutbahs.skip(1).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        Center(
                          child: Text(
                            "This Week's Khutbah",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Featured Card
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.jummaNowPlaying,
                            arguments: {'khutbah': featured},
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.r),
                                  ),
                                  child: Image.network(
                                    featured.thumbnailUrl,
                                    height: 180.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      height: 180.h,
                                      color: AppColors.jummaColor
                                          .withValues(alpha: 0.1),
                                      child: const Center(
                                        child: Icon(
                                          Icons.play_circle_fill,
                                          color: AppColors.jummaColor,
                                          size: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        featured.title,
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titleColor,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        featured.speaker,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          color: AppColors.jummaColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        if (others.isNotEmpty) ...[
                          Text(
                            "Past Khutbahs",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleColor,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ...others.map((k) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  k.thumbnailUrl,
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 60.w,
                                    height: 60.w,
                                    color: AppColors.jummaColor
                                        .withValues(alpha: 0.1),
                                    child: const Icon(
                                      Icons.audiotrack,
                                      color: AppColors.jummaColor,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                k.title,
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.titleColor,
                                ),
                              ),
                              subtitle: Text(
                                k.speaker,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.bodyColor,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.jummaColor,
                              ),
                              onTap: () => Get.toNamed(
                                AppRoutes.jummaNowPlaying,
                                arguments: {'khutbah': k},
                              ),
                            );
                          }),
                          SizedBox(height: 30.h),
                        ],
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
