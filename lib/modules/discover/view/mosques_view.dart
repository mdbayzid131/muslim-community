import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/home/controller/home_controller.dart';

class MosquesView extends StatelessWidget {
  const MosquesView({super.key});

  @override
  Widget build(BuildContext context) {
    String loc = 'Unknown';
    try {
      if (Get.isRegistered<HomeController>()) {
        loc = Get.find<HomeController>().currentLocation.value;
      }
    } catch (_) {}

    final dummyMosques = [
      {
        'name': 'East London Mosque',
        'address': '82-92 Whitechapel Rd, London E1 1JQ',
        'distance': '1.2 mi',
        'capacity': '7,000 worshippers',
      },
      {
        'name': 'London Central Mosque (Regent\'s Park)',
        'address': '146 Park Rd, London NW8 7RG',
        'distance': '3.5 mi',
        'capacity': '5,000 worshippers',
      },
      {
        'name': 'Baitul Futuh Mosque',
        'address': '181 London Rd, Morden SM4 5PT',
        'distance': '5.8 mi',
        'capacity': '10,000 worshippers',
      },
    ];

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
                  Text(
                    loc,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: dummyMosques.length,
            itemBuilder: (context, index) {
              final mosque = dummyMosques[index];
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
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
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF81C784).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Icon(Icons.mosque_rounded,
                          color: const Color(0xFF81C784), size: 24.sp),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mosque['name']!,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            mosque['address']!,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.bodyColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${mosque['distance']} • ${mosque['capacity']}',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: const Color(0xFF81C784),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
