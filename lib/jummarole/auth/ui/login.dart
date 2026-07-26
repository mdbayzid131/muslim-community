import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/jummarole/auth/controller/jumma_login_controller.dart';

class JummaLoginUI extends StatelessWidget {
  const JummaLoginUI({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeColor = Color(0xFF436E50); // Jumma color
    final controller = Get.put(JummaLoginController());

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // Top Logo
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA6864D).withValues(alpha: 0.15),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/image/splashscreenlogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Titles
              Text(
                'Welcome Back',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Continue your journey with the community.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF636E72).withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 50),

              // Form Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('EMAIL ADDRESS', themeColor),
                  const SizedBox(height: 8),
                  _buildTextField(
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                    controller: controller.emailController,
                  ),
                  const SizedBox(height: 25),
                  _buildLabel('PASSWORD', themeColor),
                  const SizedBox(height: 8),
                  Obx(
                    () => _buildTextField(
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: !controller.isPasswordVisible.value,
                      controller: controller.passwordController,
                      onToggleVisibility: () =>
                          controller.togglePasswordVisibility(),
                    ),
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.jummaForgetPasswordEmail),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeColor.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.login(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Sign Up Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to SYA? ',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.jummaSignUp),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF436E50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color themeColor) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: themeColor.withValues(alpha: 0.8),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    TextEditingController? controller,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 15),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFEDF4F1).withValues(alpha: 0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }
}
