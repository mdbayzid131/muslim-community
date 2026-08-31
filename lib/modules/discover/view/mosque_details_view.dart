import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/mosque_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MosqueDetailsView extends StatelessWidget {
  final MosqueModel? mosque;

  const MosqueDetailsView({super.key, this.mosque});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments is Map
        ? Get.arguments as Map<String, dynamic>
        : {};

    final String name = mosque?.name ?? args['name'] ?? 'Mosque Details';
    final String address =
        mosque?.address ?? args['address'] ?? 'No address provided';
    final String description = mosque?.description ??
        args['description'] ??
        'A beautiful and serene mosque serving the local and wider community with daily prayers, educational classes, and community events.';
    final String imagePath =
        mosque?.image ?? args['imagePath'] ?? 'assets/image/mosque01.png';
    final String fajr = mosque?.fajr ?? args['fajr'] ?? '04:15';
    final String dhuhr = mosque?.dhuhr ?? args['dhuhr'] ?? '13:05';
    final String asr = mosque?.asr ?? args['asr'] ?? '15:30';
    final String maghrib = mosque?.maghrib ?? args['maghrib'] ?? '20:15';
    final String isha = mosque?.isha ?? args['isha'] ?? '21:45';
    final String jummah = mosque?.jummah ?? args['jummah'] ?? '13:15';
    final String mapLink = mosque?.mapLink ?? args['mapLink'] ?? '';
    final String website = mosque?.website ?? args['website'] ?? '';

    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final roleColor = AppColors.getRoleColor(role);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER IMAGE WITH BACK BUTTON ---
            Stack(
              children: [
                imagePath.startsWith('assets/')
                    ? Image.asset(
                        imagePath,
                        width: double.infinity,
                        height: 250.h,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imagePath,
                        width: double.infinity,
                        height: 250.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/image/mosque01.png',
                          width: double.infinity,
                          height: 250.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: roleColor,
                          size: 18.sp,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TITLE & ADDRESS ---
                  Text(
                    name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: const Color(0xFFE57373),
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          address,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.bodyColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // --- BUTTONS ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (mapLink.isNotEmpty) {
                          final uri = Uri.parse(mapLink);
                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            Helpers.showError('Could not open map');
                          }
                        } else {
                          Helpers.showError('Map location not available');
                        }
                      },
                      icon: Icon(Icons.near_me, size: 18.sp),
                      label: Text(
                        'Get Directions',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5A69E).withValues(alpha: 0.8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                    ),
                  ),

                  if (website.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(
                            website.startsWith('http')
                                ? website
                                : 'https://$website',
                          );
                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            Helpers.showError('Could not open website');
                          }
                        },
                        icon: Icon(Icons.language, size: 18.sp),
                        label: Text(
                          'Visit Website',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: roleColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            side: BorderSide(
                              color: roleColor.withValues(alpha: 0.3),
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
