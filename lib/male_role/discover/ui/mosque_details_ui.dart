import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:url_launcher/url_launcher.dart';

class MaleMosqueDetailsUI extends StatelessWidget {
  const MaleMosqueDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        Get.arguments ??
        {
          'name': 'London Central Mosque',
          'address': '146 Park Rd, London NW8 7RG',
          'imagePath': 'assets/image/mosque01.png',
          'fajr': '04:15',
          'dhuhr': '13:05',
          'asr': '15:30',
          'maghrib': '20:15',
          'isha': '21:45',
          'jummah': '13:15',
        };
    final String name = args['name'] ?? 'London Central Mosque';
    final String address = args['address'] ?? '146 Park Rd, London NW8 7RG';
    final String description =
        args['description'] ??
        'A beautiful and serene mosque serving the local and wider community with daily prayers, educational classes, and community events.';
    final String imagePath = args['imagePath'] ?? 'assets/image/mosque01.png';
    final String fajr = args['fajr'] ?? '04:15';
    final String dhuhr = args['dhuhr'] ?? '13:05';
    final String asr = args['asr'] ?? '15:30';
    final String maghrib = args['maghrib'] ?? '20:15';
    final String isha = args['isha'] ?? '21:45';
    final String jummah = args['jummah'] ?? '13:15';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER IMAGE ---
            Stack(
              children: [
                imagePath.startsWith('assets/')
                    ? Image.asset(
                        imagePath,
                        width: double.infinity,
                        height: 300.h,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imagePath,
                        width: double.infinity,
                        height: 300.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              'assets/image/mosque01.png',
                              width: double.infinity,
                              height: 300.h,
                              fit: BoxFit.cover,
                            ),
                      ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40.h,
                  left: 20.w,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.8),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.maleColor,
                        size: 18.sp,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              address,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DIRECTIONS BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final String mapUrl = args['mapLink'] ?? '';
                        if (mapUrl.isNotEmpty) {
                          final uri = Uri.parse(mapUrl);
                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            Get.snackbar('Error', 'Could not open map: $e');
                          }
                        } else {
                          Get.snackbar('Info', 'Map location not available');
                        }
                      },
                      icon: Icon(Icons.near_me, size: 18.sp),
                      label: Text(
                        'Get Directions',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFE5A69E,
                        ).withValues(alpha: 0.8), // Soft coral from image
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),
                  ),

                  if (args['website'] != null &&
                      args['website'].toString().isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final String url = args['website'];
                          final uri = Uri.parse(
                            url.startsWith('http') ? url : 'https://$url',
                          );
                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            Get.snackbar('Error', 'Could not open website');
                          }
                        },
                        icon: Icon(Icons.language, size: 18.sp),
                        label: Text(
                          'Visit Website',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.maleColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            side: BorderSide(
                              color: AppColors.maleColor.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 30.h),

                  // --- ABOUT ---
                  Text(
                    'About',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.bodyColor,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // --- PRAYER TIMES CARD ---
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: const Color(0xFFE5A69E),
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Prayer Times',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        _buildPrayerRow('Fajr', fajr),
                        _buildPrayerRow('Dhuhr', dhuhr),
                        _buildPrayerRow('Asr', asr),
                        _buildPrayerRow('Maghrib', maghrib),
                        _buildPrayerRow('Isha', isha),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF0F0),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Jummah',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE57373),
                                ),
                              ),
                              Text(
                                jummah,
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE57373),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildPrayerRow(String label, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.bodyColor,
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
