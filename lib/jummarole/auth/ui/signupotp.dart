import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/jummarole/auth/controller/jumma_otp_controller.dart';

class JummaSignUpOTPUI extends StatelessWidget {
  const JummaSignUpOTPUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF436E50);
    final controller = Get.put(JummaOtpController());

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/verifycomplite.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Text(
                'Verify Your Email',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'We have sent a 6-digit code to your email.\nPlease enter it below to continue.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF636E72),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Email Badge
              Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: themeColor.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Obx(
                        () => Text(
                          controller.email.value,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF2D3436),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.circle, size: 4, color: Color(0xFFF1C40F)),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 6-digit OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildOTPBox(index, themeColor, controller),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'ENTER 6-DIGIT CODE',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Code expires in ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.timerText.value,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.verifyOtp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.help_outline,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Verify & Continue',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.resendOtp();
                    },
                    child: Obx(
                      () => Text(
                        'Resend',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: controller.secondsRemaining.value > 0
                              ? Colors.grey
                              : themeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPBox(
    int index,
    Color themeColor,
    JummaOtpController controller,
  ) {
    return Container(
      width: 45,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            fontSize: 22,
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
