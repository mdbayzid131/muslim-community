import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/group/model/group_model.dart';
import 'package:muslim_community/approut.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onJoinToggle;

  const GroupCard({super.key, required this.group, required this.onJoinToggle});

  static const Color _roleColor = AppColors.maleColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (group.isJoined) {
          Get.toNamed(AppRoutes.maleGroupDetails, arguments: group);
        } else {
          Get.snackbar(
            "Access Denied",
            "Please join the group first to see its posts and members.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Row(
              children: [
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF1F7), // Soft blue-grey background
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Icon(group.icon, color: _roleColor, size: 20.sp),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${group.category} • ${group.memberCount} members',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.h),

            // --- DESCRIPTION ---
            Text(
              group.description,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: AppColors.titleColor.withValues(alpha: 0.8),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 20.h),

            // --- BUTTONS ---
            Row(
              children: [
                if (!group.isJoined)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onJoinToggle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _roleColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        'Join Group',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                if (group.isJoined)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onJoinToggle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        'Leave Group',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
