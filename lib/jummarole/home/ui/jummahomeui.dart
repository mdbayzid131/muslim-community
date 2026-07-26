import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/approut.dart';

import 'package:muslim_community/jummarole/home/controller/jumma_home_controller.dart';
import 'package:muslim_community/shared/model/khutbah_model.dart';
import 'package:intl/intl.dart';

class JummaHomeUI extends StatelessWidget {
  const JummaHomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JummaHomeController());

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
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 30.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.jummaColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Jumu'ah Mubarak",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Image.asset(
                              'assets/icons/mosque.png',
                              width: 30.w,
                              height: 30.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'BLESSED FRIDAY',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.khutbahs.isEmpty) {
                      return SizedBox(
                        height: 400.h,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.khutbahs.isEmpty) {
                      return SizedBox(
                        height: 400.h,
                        child: const Center(
                          child: Text("No Khutbahs available"),
                        ),
                      );
                    }

                    final featuredKhutbah = controller.khutbahs.first;
                    final otherKhutbahs = controller.khutbahs.skip(1).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),
                        Center(
                          child: Text(
                            "This Week's Khutbahs",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),

                        // Featured Khutbah Card
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.jummaNowPlaying,
                            arguments: {'khutbahId': featuredKhutbah.id},
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardColor,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight: Radius.circular(20.r),
                                      ),
                                      child:
                                          featuredKhutbah
                                              .thumbnailUrl
                                              .isNotEmpty
                                          ? Image.network(
                                              featuredKhutbah.thumbnailUrl,
                                              width: double.infinity,
                                              height: 200.h,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Image.asset(
                                                    'assets/icons/video.png',
                                                    width: double.infinity,
                                                    height: 200.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                            )
                                          : Image.asset(
                                              'assets/icons/video.png',
                                              width: double.infinity,
                                              height: 200.h,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.r),
                                            topRight: Radius.circular(20.r),
                                          ),
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 40.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'FEATURED',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.goldColor,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        featuredKhutbah.title,
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titleColor,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/location.png',
                                            width: 14.w,
                                            height: 14.w,
                                            color: AppColors.bodyColor,
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            featuredKhutbah.mosqueName,
                                            style: GoogleFonts.inter(
                                              fontSize: 12.sp,
                                              color: AppColors.bodyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // List of Other Khutbahs
                        ...otherKhutbahs.map(
                          (khutbah) => _buildKhutbahListItem(khutbah),
                        ),
                        SizedBox(height: 20.h),
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

  Widget _buildKhutbahListItem(KhutbahModel khutbah) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.jummaNowPlaying,
        arguments: {'khutbahId': khutbah.id},
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(15.r),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                children: [
                  khutbah.thumbnailUrl.isNotEmpty
                      ? Image.network(
                          khutbah.thumbnailUrl,
                          width: 65.w,
                          height: 65.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/icons/video.png',
                                width: 65.w,
                                height: 65.w,
                                fit: BoxFit.cover,
                              ),
                        )
                      : Image.asset(
                          'assets/icons/video.png',
                          width: 65.w,
                          height: 65.w,
                          fit: BoxFit.cover,
                        ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    khutbah.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/location.png',
                        width: 12.w,
                        height: 12.w,
                        color: AppColors.bodyColor,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          khutbah.mosqueName,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.bodyColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          khutbah.imam,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.circle,
                        size: 4.sp,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        DateFormat('MMM dd').format(khutbah.date),
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
