import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/widgets/custom_app_bar.dart';
import 'package:muslim_community/core/widgets/custom_loader.dart';
import 'package:muslim_community/modules/notifications/controller/sent_request_controller.dart';

class SentRequestView extends GetView<SentRequestController> {
  const SentRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const CustomAppBar(title: "Sent Requests"),
        body: RefreshIndicator(
          onRefresh: () => controller.fetchSentRequests(),
          color: roleColor,
          child: controller.isLoading.value && controller.sentRequests.isEmpty
              ? CustomLoader(color: roleColor)
              : controller.sentRequests.isEmpty
                  ? Center(
                      child: Text(
                        "No sent requests",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(20.w),
                      itemCount: controller.sentRequests.length,
                      itemBuilder: (context, idx) {
                        final user = controller.sentRequests[idx];

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
                              OutlinedButton(
                                onPressed: () =>
                                    controller.cancelRequest(user.id),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(
                                      color: AppColors.error),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
