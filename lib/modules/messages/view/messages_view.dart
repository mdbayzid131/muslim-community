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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                // --- TITLE ---
                Text(
                  'Messages',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titleColor,
                  ),
                ),

                SizedBox(height: 20.h),

                // --- SEARCH BAR ---
                _buildSearchBar(roleColor),

                SizedBox(height: 20.h),

                // --- DIVIDER ---
                Divider(
                  color: AppColors.goldColor.withValues(alpha: 0.15),
                  thickness: 1,
                  height: 1,
                ),

                SizedBox(height: 20.h),

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
                            SizedBox(height: 100.h),
                            Center(
                              child: Text(
                                controller.searchQuery.value.isEmpty
                                    ? 'No chats found'
                                    : 'No matches found',
                                style: GoogleFonts.inter(
                                    color: AppColors.bodyColor),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
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
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r), // Pill shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.searchMessages,
        decoration: InputDecoration(
          hintText: 'Search messages...',
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.withValues(alpha: 0.5),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: roleColor.withValues(alpha: 0.5),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}
