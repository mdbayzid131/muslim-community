import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/date_formatter.dart';
import 'package:muslim_community/data/models/notification_model.dart';
import 'package:muslim_community/modules/notifications/controller/notifications_controller.dart';
import 'package:muslim_community/modules/notifications/view/pending_requests_view.dart';
import 'package:muslim_community/modules/notifications/view/sent_requests_view.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final roleColor = AppColors.getRoleColor(role);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Notifications',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => controller.markAllAsRead(),
              child: Text(
                'Mark all read',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: roleColor,
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
          bottom: TabBar(
            indicatorColor: roleColor,
            labelColor: roleColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: "Notifications"),
              Tab(text: "Pending"),
              Tab(text: "Sent"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationList(roleColor),
            const PendingRequestsView(),
            const SentRequestsView(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(Color roleColor) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: () => controller.fetchNotifications(),
        color: roleColor,
        child: controller.isLoading.value && controller.notifications.isEmpty
            ? Center(
                child: CircularProgressIndicator(color: roleColor),
              )
            : controller.notifications.isEmpty
                ? ListView(
                    children: [
                      SizedBox(height: 200.h),
                      Center(
                        child: Text(
                          'No notifications',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return GestureDetector(
                        onTap: () => controller.markAsRead(notification.id),
                        child: _buildNotificationCard(notification, roleColor),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildNotificationCard(
      NotificationModel notification, Color roleColor) {
    final isUnread = !notification.isRead;

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
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
      child: Stack(
        children: [
          // Unread indicator bar
          if (isUnread)
            Positioned(
              left: 0,
              top: 20.h,
              bottom: 20.h,
              child: Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: roleColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.r),
                    bottomRight: Radius.circular(5.r),
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon in Circle
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: roleColor,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 15.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.title,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3436),
                            ),
                          ),
                          Text(
                            DateFormatter.timeAgo(notification.createdAt),
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        notification.body,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF636E72),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
