import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/widgets/custom_app_bar.dart';
import 'package:muslim_community/core/widgets/custom_loader.dart';
import 'package:muslim_community/modules/notifications/controller/pending_request_controller.dart';

class PendingRequestView extends GetView<PendingRequestController> {
  const PendingRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const CustomAppBar(title: "Incoming Requests"),
        body: RefreshIndicator(
          onRefresh: () => controller.fetchPendingRequests(),
          color: roleColor,
          child: controller.isLoading.value &&
                  controller.pendingRequests.isEmpty
              ? CustomLoader(color: roleColor)
              : controller.pendingRequests.isEmpty
                  ? Center(
                      child: Text(
                        "No pending connection requests",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(20.w),
                      itemCount: controller.pendingRequests.length,
                      itemBuilder: (context, idx) {
                        final user = controller.pendingRequests[idx];

                        return Container(
                          margin: EdgeInsets.only(bottom: 14.h),
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundColor:
                                    roleColor.withValues(alpha: 0.15),
                                backgroundImage: user.profileImage.isNotEmpty
                                    ? NetworkImage(user.profileImage)
                                    : null,
                                child: user.profileImage.isEmpty
                                    ? Icon(Icons.person,
                                        size: 24.sp, color: roleColor)
                                    : null,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.titleColor,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "${user.city}, ${user.country}",
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.bodyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle,
                                        color: AppColors.success),
                                    onPressed: () =>
                                        controller.acceptRequest(user.id),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel,
                                        color: AppColors.error),
                                    onPressed: () =>
                                        controller.declineRequest(user.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      );
    });
  }
}
