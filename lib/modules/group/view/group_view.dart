import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/group/controller/group_controller.dart';
import 'package:muslim_community/modules/group/widgets/group_card.dart';

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // --- TITLE ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Groups',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // --- GROUP LIST ---
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.groups.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: roleColor),
                    );
                  }

                  if (controller.groups.isEmpty) {
                    return Center(
                      child: Text(
                        "No groups found",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.fetchGroups(),
                    color: roleColor,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      itemCount: controller.groups.length,
                      itemBuilder: (context, index) {
                        final group = controller.groups[index];
                        return GroupCard(
                          group: group,
                          themeColor: roleColor,
                          onTap: () {
                            if (group.isJoined) {
                              controller.selectGroup(group);
                              Get.toNamed(AppRoutes.groupDetails,
                                  arguments: {'group': group});
                            } else {
                              Get.snackbar(
                                "Access Denied",
                                "Please join the group first to see its posts and members.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    Colors.redAccent.withValues(alpha: 0.8),
                                colorText: Colors.white,
                              );
                            }
                          },
                          onJoinTap: () {
                            if (group.isJoined) {
                              controller.leaveGroup(group.id);
                            } else {
                              controller.joinGroup(group.id);
                            }
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}
