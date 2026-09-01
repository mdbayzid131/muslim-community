import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/messages/controller/messages_controller.dart';
import 'package:muslim_community/modules/messages/widgets/message_tile.dart';

class MessagesView extends GetView<MessagesController> {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),

                // --- TITLE ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    Obx(() {
                      final unreadTotal = controller.conversations
                          .fold<int>(0, (sum, item) => sum + item.unreadCount);
                      if (unreadTotal > 0) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: roleColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '$unreadTotal new',
                            style: GoogleFonts.inter(
                              color: roleColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),

                SizedBox(height: 16.h),

                // --- SEARCH BAR ---
                _buildSearchBar(roleColor),

                SizedBox(height: 16.h),

                // --- MESSAGES LIST ---
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.fetchChatList(),
                    color: roleColor,
                    child: Obx(() {
                      if (controller.isLoading.value &&
                          controller.conversations.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 100.h),
                            Center(
                              child:
                                  CircularProgressIndicator(color: roleColor),
                            ),
                          ],
                        );
                      }

                      if (controller.filteredConversations.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 80.h),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(18.w),
                                    decoration: BoxDecoration(
                                      color: roleColor.withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 40.sp,
                                      color: roleColor.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  Text(
                                    controller.searchQuery.value.isEmpty
                                        ? 'No conversations yet'
                                        : 'No matching chats found',
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.titleColor,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    controller.searchQuery.value.isEmpty
                                        ? 'Connect with members to start messaging'
                                        : 'Try searching with a different name',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: AppColors.bodyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 4.h, bottom: 20.h),
                        itemCount: controller.filteredConversations.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            message: controller.filteredConversations[index],
                            themeColor: roleColor,
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSearchBar(Color roleColor) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.searchMessages,
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          color: AppColors.titleColor,
        ),
        decoration: InputDecoration(
          hintText: 'Search messages or people...',
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.withValues(alpha: 0.6),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: roleColor.withValues(alpha: 0.7),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}
