import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/male_role/discover/controller/maleprofileservicecontroller.dart';

class MaleProfileDetailsUI extends StatelessWidget {
  final BrotherModel brother;

  const MaleProfileDetailsUI({super.key, required this.brother});

  @override
  Widget build(BuildContext context) {
    final MaleProfileDetailsController controller = Get.put(
      MaleProfileDetailsController(),
    );

    // Fetch live profile details when UI opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile(brother.id);
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.maleColor),
          );
        }

        final liveBrother = controller.brother.value ?? brother;

        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(liveBrother),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderInfo(liveBrother),
                    SizedBox(height: 30.h),
                    _buildSectionTitle("About Me"),
                    SizedBox(height: 10.h),
                    _buildSectionContent(liveBrother.about),
                    SizedBox(height: 25.h),
                    _buildSectionTitle("My Revert Story / Journey"),
                    SizedBox(height: 10.h),
                    _buildSectionContent(liveBrother.revertHistory),
                    SizedBox(height: 25.h),
                    _buildSectionTitle("Interests"),
                    SizedBox(height: 10.h),
                    _buildInterests(liveBrother),
                    SizedBox(height: 40.h),
                    _buildActionButtons(liveBrother),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSliverAppBar(BrotherModel displayBrother) {
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
            displayBrother.imageUrl.isNotEmpty &&
                    displayBrother.imageUrl.startsWith('http')
                ? Image.network(
                    displayBrother.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/image/male.png', fit: BoxFit.cover),
                  )
                : Image.asset('assets/image/male.png', fit: BoxFit.cover),
            // Gradient to make text readable
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
            if (displayBrother.isOnline)
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

  Widget _buildHeaderInfo(BrotherModel displayBrother) {
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
                          "${displayBrother.name}, ${displayBrother.age}",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (displayBrother.isVerified) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.verified,
                          color: AppColors.maleColor,
                          size: 22.sp,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    displayBrother.joinedAgo.isNotEmpty
                        ? "Joined ${displayBrother.joinedAgo}"
                        : "Member",
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
                color: AppColors.maleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.maleColor,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "${displayBrother.distance} mi",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.maleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (displayBrother.isNewRevert) ...[
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

  Widget _buildInterests(BrotherModel displayBrother) {
    if (displayBrother.interests.isEmpty) {
      return _buildSectionContent("No interests provided yet.");
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: displayBrother.interests.map((interest) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.maleColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.maleColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            interest,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.maleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BrotherModel displayBrother) {
    final bool isConnected = displayBrother.status == 'Connected';
    final bool isRequested = displayBrother.status == 'Requested';
    final bool isConnect = displayBrother.status == 'Connect';

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isConnected || isRequested
              ? Colors.white
              : AppColors.maleColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: isConnected || isRequested
                ? BorderSide(color: AppColors.maleColor, width: 1.5)
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
              displayBrother.status,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isConnected || isRequested
                    ? AppColors.maleColor
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
