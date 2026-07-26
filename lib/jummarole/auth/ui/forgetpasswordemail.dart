import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';

import 'package:muslim_community/shared/auth/controller/forget_password_controller.dart';

class JummaForgetPasswordEmailUI extends StatelessWidget {
  const JummaForgetPasswordEmailUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF436E50);
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: themeColor, size: 20.sp),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Logo
              Center(
                child: Image.asset(
                  'assets/icons/forgetpasswordlogo.png',
                  width: 150.w,
                  height: 150.w,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 40.h),
              Text(
                'Forget Password',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Enter your email address and we\'ll send you a code to reset your password.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: const Color(0xFF636E72),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),

              // Email Input
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'EMAIL ADDRESS',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: themeColor.withValues(alpha: 0.8),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: controller.emailController,
                style: GoogleFonts.inter(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEDF4F1).withValues(alpha: 0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFFA6864D),
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'We\'ll send a 6-digit verification code to this address',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),

              // Send OTP Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.sendOtp(
                            AppRoutes.jummaForgetPasswordOTP,
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Send OTP',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Icon(
                      Icons.nights_stay_outlined,
                      color: Colors.grey.shade300,
                      size: 16.sp,
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              SizedBox(height: 30.h),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember your password? ',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Login',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
