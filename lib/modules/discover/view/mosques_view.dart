import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/data/models/mosque_model.dart';
import 'package:muslim_community/data/repositories/mosque_repository.dart';
import 'package:muslim_community/modules/discover/controller/mosque_controller.dart';
import 'package:muslim_community/modules/discover/view/mosque_details_view.dart';
import 'package:muslim_community/modules/home/controller/home_controller.dart';

class MosquesView extends StatelessWidget {
  const MosquesView({super.key});

  @override
  Widget build(BuildContext context) {
    final MosqueController controller = Get.isRegistered<MosqueController>()
        ? Get.find<MosqueController>()
        : Get.put(MosqueController(mosqueRepository: Get.find<MosqueRepository>()));

    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final roleColor = AppColors.getRoleColor(role);

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
                      if (Get.isRegistered<HomeController>()) {
                        loc = Get.find<HomeController>()
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
                        onChanged: controller.searchMosques,
                        decoration: InputDecoration(
                          hintText: 'Search nearby mosques or city...',
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
              return Center(
                child: CircularProgressIndicator(color: roleColor),
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
              color: roleColor,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.mosques.length,
                itemBuilder: (context, index) {
                  final mosque = controller.mosques[index];
                  return _buildMosqueCard(
                    context,
                    mosque,
                    roleColor,
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
    BuildContext context,
    MosqueModel mosque,
    Color roleColor,
  ) {
    return GestureDetector(
      onTap: () => Get.to(
        () => MosqueDetailsView(mosque: mosque),
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
              child: mosque.image.startsWith('assets/')
                  ? Image.asset(
                      mosque.image,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      mosque.image,
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
                    mosque.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    mosque.address,
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
                          mosque.nextPrayer,
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
                        mosque.distance,
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
