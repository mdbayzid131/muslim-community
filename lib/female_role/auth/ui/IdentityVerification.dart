import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/female_role/auth/controller/female_create_account_controller.dart';
import 'package:muslim_community/female_role/auth/controller/female_verify_controller.dart';

class FemaleIdentityVerificationUI extends StatelessWidget {
  const FemaleIdentityVerificationUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFFD18E8E);
    final accountController = Get.put(FemaleCreateAccountController());
    final verifyController = accountController.verifyController;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF2D3436),
            size: 24.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(true, themeColor),
            _buildDot(true, themeColor),
            _buildDot(false, themeColor),
          ],
        ),
        centerTitle: true,
        actions: [SizedBox(width: 48.w)],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Identity Verification',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'To keep SYA a safe, exclusive space, we require a quick verification.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFFA6864D).withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 30.h),

              // Verification Section
              Obx(() {
                final method = verifyController.selectedMethod.value;
                if (method == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Verification Method',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildMethodSelectionCard(
                        title: 'Photo Verification',
                        subtitle: 'Take a photo holding today\'s date on paper',
                        icon: Icons.camera_alt_outlined,
                        onTap: () => verifyController.selectedMethod.value = 'photo',
                        themeColor: themeColor,
                      ),
                      SizedBox(height: 16.h),
                      _buildMethodSelectionCard(
                        title: 'Video Verification',
                        subtitle: 'Record a short 5-second video reading your name',
                        icon: Icons.videocam_outlined,
                        onTap: () => verifyController.selectedMethod.value = 'video',
                        themeColor: themeColor,
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          method == 'photo' ? 'Photo Verification' : 'Video Verification',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            verifyController.selectedMethod.value = null;
                          },
                          icon: Icon(Icons.edit, size: 14.sp, color: themeColor),
                          label: Text(
                            'Change',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: themeColor,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    if (method == 'photo')
                      _buildVerificationCard(
                        icon: Icons.shield_outlined,
                        title: 'Photo Verification',
                        description:
                            'Please take a clear photo holding a piece of paper with today\'s date. This is for manual review only and will never be shared.',
                        buttonText: 'Take Verification Photo',
                        buttonIcon: Icons.camera_alt_outlined,
                        onTap: verifyController.takePhoto,
                        isCompleted: verifyController.verificationImage.value != null,
                        themeColor: themeColor,
                      )
                    else
                      _buildVerificationCard(
                        icon: Icons.shield_outlined,
                        title: 'Record Video Verification',
                        description: '5-second video reading your name ',
                        buttonText: 'Start recording',
                        buttonIcon: Icons.videocam_outlined,
                        onTap: verifyController.recordVideo,
                        isCompleted: verifyController.verificationVideo.value != null,
                        themeColor: themeColor,
                      ),
                  ],
                );
              }),
              SizedBox(height: 40.h),

              // Continue Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: accountController.isLoading.value
                        ? null
                        : () => accountController.createAccount(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: accountController.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : color.withOpacity(0.2),
      ),
    );
  }

  Widget _buildMethodSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color themeColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E9).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 24.sp,
                    color: themeColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFFA6864D),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: const Color(0xFF2D3436).withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onTap,
    required bool isCompleted,
    required Color themeColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E9).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24.r),
        border: isCompleted
            ? Border.all(color: Colors.green, width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : icon,
            size: 40.sp,
            color: isCompleted ? Colors.green : themeColor.withOpacity(0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFFA6864D),
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(buttonIcon, size: 20.sp, color: const Color(0xFF2D3436)),
                  SizedBox(width: 10.w),
                  Text(
                    isCompleted ? 'Recapture' : buttonText,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
