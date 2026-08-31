import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/modules/discover/controller/discover_controller.dart';

class ProfileDetailsView extends StatelessWidget {
  final UserModel user;

  const ProfileDetailsView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final roleColor = AppColors.getRoleColor(role);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(roleColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(roleColor),
                  SizedBox(height: 30.h),
                  _buildSectionTitle("About Me"),
                  SizedBox(height: 10.h),
                  _buildSectionContent(user.bio.isNotEmpty
                      ? user.bio
                      : "Peace be upon you! I am learning and growing in faith."),
                  SizedBox(height: 25.h),
                  _buildSectionTitle("My Revert Story / Journey"),
                  SizedBox(height: 10.h),
                  _buildSectionContent(user.revertStory.isNotEmpty
                      ? user.revertStory
                      : "Alhamdulillah for the blessing of Islam. Happy to connect with brothers in faith."),
                  SizedBox(height: 25.h),
                  _buildSectionTitle("Interests"),
                  SizedBox(height: 10.h),
                  _buildInterests(roleColor),
                  SizedBox(height: 40.h),
                  _buildActionButtons(roleColor),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Color roleColor) {
    return SliverAppBar(
      expandedHeight: 350.h,
      pinned: true,
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.titleColor,
              size: 18.sp,
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            user.profileImage.isNotEmpty &&
                    user.profileImage.startsWith('http')
                ? Image.network(
                    user.profileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/image/male.png', fit: BoxFit.cover),
                  )
                : Image.asset('assets/image/male.png', fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
            if (user.isOnline)
              Positioned(
                bottom: 20.h,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Online",
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(Color roleColor) {
    final displayName =
        user.fullName.isNotEmpty ? user.fullName : user.name;
    final displayAge = user.age > 0 ? user.age : 25;
    final distanceText = user.distance.isNotEmpty ? "${user.distance} mi" : "1.0 mi";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "$displayName, $displayAge",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.isVerified) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.verified,
                          color: roleColor,
                          size: 22.sp,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Member",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: roleColor,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    distanceText,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: roleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (user.isRevert) ...[
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.goldColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.goldColor.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              "✨ New Revert",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB8860B),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.titleColor,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        content,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: AppColors.bodyColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildInterests(Color roleColor) {
    if (user.interests.isEmpty) {
      return _buildSectionContent("No interests provided yet.");
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: user.interests.map((interest) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: roleColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: roleColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            interest,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: roleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(Color roleColor) {
    final status = user.connectionStatus;
    final bool isConnected = status == 'connected' || status == 'Connected';
    final bool isRequested = status == 'pending' || status == 'Requested';
    final bool isConnect = !isConnected && !isRequested;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          if (Get.isRegistered<DiscoverController>()) {
            final dc = Get.find<DiscoverController>();
            if (isConnect) {
              dc.sendConnectionRequest(user.id);
            } else if (isRequested) {
              dc.cancelConnectionRequest(user.id);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isConnected || isRequested ? Colors.white : roleColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: isConnected || isRequested
                ? BorderSide(color: roleColor, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isConnect) ...[
              Icon(Icons.person_add_alt_1, color: Colors.white, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              isConnected
                  ? 'Connected'
                  : isRequested
                      ? 'Requested'
                      : 'Connect',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isConnected || isRequested ? roleColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
