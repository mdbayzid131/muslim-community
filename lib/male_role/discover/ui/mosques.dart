import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/male_role/discover/controller/mosquecontroller.dart';
import 'package:muslim_community/male_role/discover/model/mosque_model.dart';
import 'package:muslim_community/male_role/home/controller/home_controller.dart';

class MosquesUI extends StatelessWidget {
  const MosquesUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MosqueController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- SEARCH & LOCATION ---
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: const Color(0xFFE57373),
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Obx(() {
                    String loc = 'Unknown';
                    try {
                      if (Get.isRegistered<MaleHomeController>()) {
                        loc = Get.find<MaleHomeController>()
                            .currentLocation
                            .value;
                      }
                    } catch (_) {}
                    return Text(
                      loc,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: const Color(0xFFF5EFE6)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.bodyColor.withValues(alpha: 0.5),
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search nearby mosques...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.bodyColor.withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 25.h),

        // --- MOSQUE LIST ---
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value && controller.mosques.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.maleColor),
              );
            }

            if (controller.mosques.isEmpty) {
              return Center(
                child: Text(
                  'No nearby mosques found.',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await controller.fetchMosques();
              },
              color: AppColors.maleColor,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.mosques.length,
                itemBuilder: (context, index) {
                  final mosque = controller.mosques[index];
                  return _buildMosqueCard(
                    mosque.name,
                    mosque.address,
                    mosque.nextPrayer,
                    mosque.distance,
                    mosque.image,
                    AppRoutes.maleMosqueDetails,
                    mosque,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMosqueCard(
    String name,
    String address,
    String prayerTime,
    String distance,
    String imagePath,
    String route,
    MosqueModel mosque,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        route,
        arguments: {
          'name': mosque.name,
          'address': mosque.address,
          'description': mosque.description,
          'imagePath': mosque.image,
          'fajr': mosque.fajr,
          'dhuhr': mosque.dhuhr,
          'asr': mosque.asr,
          'maghrib': mosque.maghrib,
          'isha': mosque.isha,
          'jummah': mosque.jummah,
          'mapLink': mosque.mapLink,
          'website': mosque.website,
        },
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
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
              borderRadius: BorderRadius.circular(15.r),
              child: imagePath.startsWith('assets/')
                  ? Image.asset(
                      imagePath,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imagePath,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/image/mosque01.png',
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.bodyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBF0F0),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          prayerTime,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: const Color(0xFFE57373),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.near_me_outlined,
                        size: 12.sp,
                        color: AppColors.bodyColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        distance,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
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
    );
  }
}
