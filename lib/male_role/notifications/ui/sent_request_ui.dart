import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/male_role/notifications/controller/sent_request_controller.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/male_role/discover/ui/male_profile_details_ui.dart';

class MaleSentRequestUI extends StatelessWidget {
  const MaleSentRequestUI({super.key});

  @override
  Widget build(BuildContext context) {
    final MaleSentRequestController controller = Get.put(
      MaleSentRequestController(),
    );

    return Obx(() {
      if (controller.isLoading.value && controller.sentRequests.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.maleColor),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchSentRequests(isRefresh: true),
        color: AppColors.maleColor,
        child: controller.sentRequests.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: 200.h),
                  Center(
                    child: Text(
                      'No sent requests',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    controller.fetchSentRequests();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  itemCount:
                      controller.sentRequests.length +
                      (controller.isFetchingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.sentRequests.length) {
                      final brother = controller.sentRequests[index];
                      return _buildRequestCard(brother, controller);
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: AppColors.maleColor,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
      );
    });
  }

  Widget _buildRequestCard(
    BrotherModel brother,
    MaleSentRequestController controller,
  ) {
    return GestureDetector(
      onTap: () => Get.to(() => MaleProfileDetailsUI(brother: brother)),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundImage: brother.imageUrl.isNotEmpty
                  ? NetworkImage(brother.imageUrl)
                  : null,
              child: brother.imageUrl.isEmpty
                  ? Icon(Icons.person, size: 30.sp, color: Colors.grey)
                  : null,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brother.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  Text(
                    "${brother.age} years • ${brother.distance} km away",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (brother.connectionId != null) {
                          print(
                            "UI: Cancel button clicked for connectionId: ${brother.connectionId}",
                          );
                          controller.cancelRequest(
                            brother.connectionId!,
                            brother.id,
                          );
                        } else {
                          print(
                            "UI: Cancel button clicked but connectionId is NULL",
                          );
                          Get.snackbar("Error", "Connection ID missing");
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.maleColor),
                        foregroundColor: AppColors.maleColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      child: Text(
                        "Cancel Request",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
