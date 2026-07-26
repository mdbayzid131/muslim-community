import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:muslim_community/approut.dart';

class MaleLocationAccessUI extends StatefulWidget {
  const MaleLocationAccessUI({super.key});

  @override
  State<MaleLocationAccessUI> createState() => _MaleLocationAccessUIState();
}

class _MaleLocationAccessUIState extends State<MaleLocationAccessUI> {
  bool _isLoading = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Get.toNamed(AppRoutes.maleIdentityVerification);
      } else if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Please enable location permissions in settings to continue.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error requesting location: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF5B7C99);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Location Icon
              Center(
                child: Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE0E0E0).withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      size: 60.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),

              Text(
                'Enable precise location',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Your location will be used to show people near you.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFFA6864D),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 50.h),

              // Enable Location Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _requestLocationPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Enable location',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16.h),

              // Remind me later Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: TextButton(
                  onPressed: () =>
                      Get.toNamed(AppRoutes.maleIdentityVerification),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Text(
                    'Remind me later',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF436E50),
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 12.sp, color: Colors.grey),
                  SizedBox(width: 6.w),
                  Text(
                    'Magical secured text to make all security concerns go away.',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
