import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/auth/controller/forgot_password_controller.dart';

class ForgotPasswordOtpView extends GetView<ForgotPasswordController> {
  const ForgotPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
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
                // Logo/Icon
                Center(
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mark_email_read_outlined,
                          color: themeColor,
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
                Text(
                  'Verify Your Email',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),

                SizedBox(height: 20.h),
                Text(
                  'We have sent a 6-digit code to your email.\nPlease enter it below to continue.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: const Color(0xFF636E72),
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 30.h),

                // Email Badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.email_outlined,
                          size: 16.sp, color: Colors.grey),
                      SizedBox(width: 8.w),
                      Text(
                        controller.email.value.isNotEmpty
                            ? controller.email.value
                            : 'your-email@example.com',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                // OTP Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => _buildOTPField(index, themeColor, controller),
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

                SizedBox(height: 30.h),

                // Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 18.sp, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Text(
                      'Code expires in ',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      controller.timerText.value,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40.h),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            final nextRoute = controller.currentRole.value ==
                                    'female'
                                ? AppRoutes.femaleResetPassword
                                : controller.currentRole.value == 'jumma'
                                    ? AppRoutes.jummaResetPassword
                                    : AppRoutes.maleResetPassword;
                            controller.verifyOtp(nextRoute);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Verify & Continue',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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
                      'Didn\'t receive the code? ',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.secondsRemaining.value == 0
                          ? () {
                              final otpRoute = controller.currentRole.value ==
                                      'female'
                                  ? AppRoutes.femaleForgetPasswordOTP
                                  : controller.currentRole.value == 'jumma'
                                      ? AppRoutes.jummaForgetPasswordOTP
                                      : AppRoutes.maleForgetPasswordOTP;
                              controller.sendOtp(otpRoute);
                            }
                          : null,
                      child: Text(
                        'Resend',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: controller.secondsRemaining.value == 0
                              ? themeColor
                              : Colors.grey,
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
    });
  }

  Widget _buildOTPField(
    int index,
    Color themeColor,
    ForgotPasswordController controller,
  ) {
    return Container(
      width: 45.w,
      height: 55.w,
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
            fontSize: 22.sp,
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
