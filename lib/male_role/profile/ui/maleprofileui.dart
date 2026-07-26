import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/profile/ui/malepersonalinfoui.dart';
import 'package:muslim_community/male_role/profile/ui/privacy_policy_ui.dart';
import 'package:muslim_community/male_role/profile/ui/terms_conditions_ui.dart';
import 'package:muslim_community/male_role/profile/ui/change_password_ui.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/services/tokenservice.dart';

class MaleProfileUI extends StatelessWidget {
  const MaleProfileUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              // ACCOUNT Section
              Text(
                "ACCOUNT",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodyColor.withValues(alpha: 0.7),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 15.h),

              // Account Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildAccountOption(
                      icon: Icons.edit_outlined,
                      title: "Personal Information",
                      onTap: () => Get.to(() => const MalePersonalInfoUI()),
                      themeColor: AppColors.maleColor,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.withValues(alpha: 0.1),
                      indent: 20.w,
                      endIndent: 20.w,
                    ),
                    _buildAccountOption(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      onTap: () => Get.to(() => const MaleChangePasswordUI()),
                      themeColor: AppColors.maleColor,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.withValues(alpha: 0.1),
                      indent: 20.w,
                      endIndent: 20.w,
                    ),
                    _buildAccountOption(
                      icon: Icons.shield_outlined,
                      title: "Privacy Policy",
                      onTap: () => Get.to(() => const MalePrivacyPolicyUI()),
                      themeColor: AppColors.maleColor,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.withValues(alpha: 0.1),
                      indent: 20.w,
                      endIndent: 20.w,
                    ),
                    _buildAccountOption(
                      icon: Icons.description_outlined,
                      title: "Terms and Conditions",
                      onTap: () => Get.to(() => const MaleTermsConditionsUI()),
                      themeColor: AppColors.maleColor,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Log Out Button
              GestureDetector(
                onTap: () => _showLogoutDialog(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: AppColors.titleColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Log Out",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15.h),

              // Delete Account Button
              GestureDetector(
                onTap: () => _showDeleteAccountDialog(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: const Color(0xFFD18E8E).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: const Color(0xFFD18E8E),
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Delete Account",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD18E8E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color themeColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: themeColor, size: 20.sp),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.withValues(alpha: 0.5),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7EFE5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: const Color(0xFF8B6B60),
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Log out of SYA?",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "You will need to sign in again to access your groups, messages, and profile.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.bodyColor,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await TokenService().removeToken();
                      Get.offAllNamed(AppRoutes.selectRole);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD49B92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Yes, Log out",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF7EFE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5C4033),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7EFE5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: const Color(0xFF8B6B60),
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7EFE5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: const Color(0xFFD49B92),
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Delete Account?",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "This action is permanent and cannot be undone. All your posts, messages, and profile data will be permanently deleted from SYA.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.bodyColor,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await TokenService().removeToken();
                      Get.offAllNamed(AppRoutes.selectRole);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD49B92),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Permanently Delete",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF7EFE5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      "Keep Account",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5C4033),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
