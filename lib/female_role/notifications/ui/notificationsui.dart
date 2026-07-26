import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/female_role/notifications/controller/notification_controller.dart';
import 'package:muslim_community/female_role/notifications/model/notification_model.dart';
import 'package:muslim_community/female_role/notifications/ui/pending_request_ui.dart';
import 'package:muslim_community/female_role/notifications/ui/sent_request_ui.dart';
import 'package:muslim_community/appcolore.dart';

class FemaleNotificationsUI extends StatelessWidget {
  const FemaleNotificationsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemaleNotificationController controller = Get.put(
      FemaleNotificationController(),
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF8F1),
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
                  color: const Color(0xFFA6864D),
                ),
              ),
            ),
            SizedBox(width: 10.w),
          ],
          bottom: TabBar(
            indicatorColor: AppColors.femaleColor,
            labelColor: AppColors.femaleColor,
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
            _buildNotificationList(controller),
            const FemalePendingRequestUI(),
            const FemaleSentRequestUI(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(FemaleNotificationController controller) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: () => controller.fetchNotifications(),
        color: AppColors.femaleColor,
        child: controller.isLoading.value && controller.notifications.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.femaleColor),
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return GestureDetector(
                    onTap: () => controller.markAsRead(notification.id),
                    child: _buildNotificationCard(notification),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
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
          if (notification.isUnread)
            Positioned(
              left: 0,
              top: 20.h,
              bottom: 20.h,
              child: Container(
                width: 4.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFA6864D),
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
                    color: notification.iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.iconColor,
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
                            notification.timeAgo,
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
