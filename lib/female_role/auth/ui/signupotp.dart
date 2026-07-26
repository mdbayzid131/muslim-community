import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/female_role/auth/controller/female_otp_controller.dart';
import 'package:muslim_community/female_role/auth/controller/resendotpcontroller.dart';

class FemaleSignUpOTPUI extends StatelessWidget {
  const FemaleSignUpOTPUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFFD18E8E);
    final controller = Get.put(FemaleOtpController());
    final resendController = Get.put(FemaleResendOtpController());

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.15),
                        blurRadius: 30.r,
                        spreadRadius: 5.r,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/verifycomplite.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Text(
                'Verify Your Email',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'We have sent a 6-digit code to your email.\nPlease enter it below to continue.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: const Color(0xFF636E72),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),

              // Email Badge
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14.sp,
                        color: themeColor.withValues(alpha: 0.6),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        controller.email.value.isNotEmpty
                            ? controller.email.value
                            : '... @gmail.com',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25.h),

              // Workable OTP Fields (6 boxes)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildOTPBox(index, themeColor, controller),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                'ENTER 6-DIGIT CODE',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 25.h),

              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Code expires in ',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.timerText.value,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),

              // Button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.verifyOtp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Verify & Continue',
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap:
                          (resendController.isLoading.value ||
                              controller.secondsRemaining.value > 0)
                          ? null
                          : () => resendController.resendOtp(
                              controller.email.value,
                              () => controller.startTimer(),
                            ),
                      child: Text(
                        'Resend',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color:
                              (resendController.isLoading.value ||
                                  controller.secondsRemaining.value > 0)
                              ? Colors.grey
                              : themeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildOTPBox(
    int index,
    Color themeColor,
    FemaleOtpController controller,
  ) {
    return Container(
      width: 50.w,
      height: 65.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeColor,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              controller.focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              controller.focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}
