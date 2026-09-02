import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/api_client.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/modules/profile/controller/privacy_terms_controller.dart';
import 'package:muslim_community/modules/profile/controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final legalCtrl = Get.isRegistered<PrivacyAndTermsController>()
        ? Get.find<PrivacyAndTermsController>()
        : Get.put(
            PrivacyAndTermsController(
              apiClient: Get.find<ApiClient>(),
            ),
          );

    return Obx(() {
      final roleColor = controller.roleColor;
      final user = controller.user.value;
      final role = controller.userRole;
      final roleLabel = role == 'female'
          ? 'Sister'
          : (role == 'jumma' ? 'Imam' : 'Brother');
      final roleEmoji = role == 'female' ? '🌸' : (role == 'jumma' ? '🌙' : '🕌');

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchProfile();
              await legalCtrl.fetchAllLegalPages();
            },
            color: roleColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),

                  // App Bar Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.personalInfo),
                        icon: Icon(
                          Icons.edit_note_rounded,
                          color: roleColor,
                          size: 26.sp,
                        ),
                        tooltip: "Edit Profile",
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // USER HERO CARD
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          roleColor,
                          roleColor.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: roleColor.withValues(alpha: 0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Stack(
                              children: [
                                Container(
                                  width: 72.w,
                                  height: 72.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.w,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: (user?.profileImage != null &&
                                            user!.profileImage.isNotEmpty)
                                        ? Image.network(
                                            user.profileImage,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    _buildAvatarFallback(roleColor),
                                          )
                                        : _buildAvatarFallback(roleColor),
                                  ),
                                ),
                                if (user?.isVerified == true)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.verified_rounded,
                                        color: Colors.blue,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(width: 16.w),

                            // User Info Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.name.isNotEmpty == true
                                        ? user!.name
                                        : "Muslim Community",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    user?.email.isNotEmpty == true
                                        ? user!.email
                                        : "Tap edit to update profile",
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10.h),

                                  // Chips Row
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 4.h,
                                    children: [
                                      // Role Badge Chip
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              roleEmoji,
                                              style: TextStyle(fontSize: 10.sp),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              roleLabel,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Location Chip
                                      if (_getLocationString(user).isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                color: Colors.white,
                                                size: 11.sp,
                                              ),
                                              SizedBox(width: 3.w),
                                              Text(
                                                _getLocationString(user),
                                                style: GoogleFonts.inter(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Action Button inside Hero Card
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.personalInfo),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_search_rounded,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "View & Edit Profile Details",
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // ACCOUNT SETTINGS Section
                  _buildSectionHeader("ACCOUNT SETTINGS"),
                  SizedBox(height: 12.h),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildAccountOption(
                          icon: Icons.person_outline_rounded,
                          title: "Personal Information",
                          subtitle: "Update name, bio, location & interests",
                          onTap: () => Get.toNamed(AppRoutes.personalInfo),
                          themeColor: roleColor,
                        ),
                        _buildDivider(),
                        _buildAccountOption(
                          icon: Icons.lock_outline_rounded,
                          title: "Change Password",
                          subtitle: "Update security credentials",
                          onTap: () => Get.toNamed(AppRoutes.changePassword),
                          themeColor: roleColor,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // LEGAL & SUPPORT Section
                  _buildSectionHeader("LEGAL & COMMUNITY"),
                  SizedBox(height: 12.h),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      if (legalCtrl.legalPages.isNotEmpty) {
                        return Column(
                          children:
                              List.generate(legalCtrl.legalPages.length, (index) {
                            final page = legalCtrl.legalPages[index];
                            final title =
                                page['title']?.toString() ?? "Legal Info";
                            final slug = page['slug']?.toString() ?? "";
                            final isPrivacy = slug.contains('privacy') ||
                                title.toLowerCase().contains('privacy');

                            return Column(
                              children: [
                                if (index > 0) _buildDivider(),
                                _buildAccountOption(
                                  icon: isPrivacy
                                      ? Icons.shield_outlined
                                      : Icons.description_outlined,
                                  title: title,
                                  subtitle: "Read $title guidelines",
                                  onTap: () {
                                    if (isPrivacy) {
                                      legalCtrl.fetchLegalContent(
                                        slug,
                                        isPrivacy: true,
                                      );
                                      Get.toNamed(AppRoutes.privacyPolicy);
                                    } else {
                                      legalCtrl.fetchLegalContent(
                                        slug,
                                        isTerms: true,
                                      );
                                      Get.toNamed(AppRoutes.termsConditions);
                                    }
                                  },
                                  themeColor: roleColor,
                                ),
                              ],
                            );
                          }),
                        );
                      }

                      return Column(
                        children: [
                          _buildAccountOption(
                            icon: Icons.shield_outlined,
                            title: "Privacy Policy",
                            subtitle: "Read our privacy guidelines",
                            onTap: () {
                              legalCtrl.fetchLegalContent(
                                'privacy-policy',
                                isPrivacy: true,
                              );
                              Get.toNamed(AppRoutes.privacyPolicy);
                            },
                            themeColor: roleColor,
                          ),
                          _buildDivider(),
                          _buildAccountOption(
                            icon: Icons.description_outlined,
                            title: "Terms and Conditions",
                            subtitle: "Read terms of service",
                            onTap: () {
                              legalCtrl.fetchLegalContent(
                                'terms-and-conditions',
                                isTerms: true,
                              );
                              Get.toNamed(AppRoutes.termsConditions);
                            },
                            themeColor: roleColor,
                          ),
                        ],
                      );
                    }),
                  ),

                  SizedBox(height: 28.h),

                  // SESSION & DANGER ZONE
                  _buildSectionHeader("SESSION & ACCOUNT"),
                  SizedBox(height: 12.h),

                  // Log Out Button
                  GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppColors.titleColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.logout_rounded,
                              color: AppColors.titleColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Log Out",
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Sign out from this device",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey.withValues(alpha: 0.4),
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Delete Account Button
                  GestureDetector(
                    onTap: () => _showDeleteAccountDialog(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFFCDCDC),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: const Color(0xFFDC2626),
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delete Account",
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFDC2626),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Permanently delete your profile & data",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF991B1B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: const Color(0xFFF87171),
                            size: 14.sp,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAvatarFallback(Color roleColor) {
    return Container(
      color: roleColor.withValues(alpha: 0.15),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 40.sp,
          color: roleColor,
        ),
      ),
    );
  }

  String _getLocationString(dynamic user) {
    if (user == null) return "";
    if (user.city.isNotEmpty && user.country.isNotEmpty) {
      return "${user.city}, ${user.country}";
    }
    if (user.city.isNotEmpty) return user.city;
    if (user.country.isNotEmpty) return user.country;
    if (user.location != null && user.location!.isNotEmpty) {
      return user.location!;
    }
    return "";
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.bodyColor.withValues(alpha: 0.65),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withValues(alpha: 0.1),
      indent: 68.w,
      endIndent: 20.w,
    );
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color themeColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: themeColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.withValues(alpha: 0.4),
              size: 14.sp,
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
                      await StorageService.clearAuth();
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
                      await StorageService.clearAuth();
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
