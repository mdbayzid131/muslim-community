import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';
import 'package:muslim_community/modules/notifications/controller/sent_request_controller.dart';
import 'package:muslim_community/modules/profile/view/profile_details_view.dart';

class SentRequestsView extends StatelessWidget {
  const SentRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SentRequestController controller =
        Get.isRegistered<SentRequestController>()
            ? Get.find<SentRequestController>()
            : Get.put(SentRequestController(
                connectionRepository: Get.find<ConnectionRepository>()));

    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final roleColor = AppColors.getRoleColor(role);

    return Obx(() {
      if (controller.isLoading.value && controller.sentRequests.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: roleColor),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchSentRequests(),
        color: roleColor,
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
            : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 20.h,
                ),
                itemCount: controller.sentRequests.length,
                itemBuilder: (context, index) {
                  final user = controller.sentRequests[index];
                  return _buildRequestCard(user, roleColor, controller);
                },
              ),
      );
    });
  }

  Widget _buildRequestCard(
      UserModel user, Color roleColor, SentRequestController controller) {
    final displayName = user.fullName.isNotEmpty ? user.fullName : user.name;
    final distanceText =
        user.distance.isNotEmpty ? "${user.distance} mi away" : "1.0 mi away";

    return GestureDetector(
      onTap: () => Get.to(() => ProfileDetailsView(user: user)),
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
              backgroundColor: roleColor.withValues(alpha: 0.15),
              backgroundImage: user.profileImage.isNotEmpty
                  ? NetworkImage(user.profileImage)
                  : null,
              child: user.profileImage.isEmpty
                  ? Icon(Icons.person, size: 30.sp, color: roleColor)
                  : null,
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  Text(
                    "${user.age} years • $distanceText",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => controller.cancelRequest(user.id),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: roleColor),
                        foregroundColor: roleColor,
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
