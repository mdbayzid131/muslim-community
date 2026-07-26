import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';

class FemaleVerificationCompleteUI extends StatelessWidget {
  const FemaleVerificationCompleteUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFFD18E8E);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(true, themeColor),
            _buildDot(true, themeColor),
            _buildDot(true, themeColor),
          ],
        ),
        centerTitle: true,
        actions: [const SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon Circle
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: themeColor.withValues(alpha: 0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeColor.withValues(alpha: 0.1),
                      ),
                      child: Icon(Icons.check, size: 40, color: themeColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Text(
                'Verification Complete',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Alhamdulillah! Your profile has been submitted for review. Welcome to the Sisters community.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFFA6864D).withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ),
              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.femaleLogin),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : color.withValues(alpha: 0.2),
      ),
    );
  }
}
