import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/data/models/chat_message_model.dart';
import 'package:muslim_community/modules/messages/controller/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map? ?? {};
    final chatId = args['chatId']?.toString() ?? '';
    final userName = args['userName']?.toString() ?? 'Brother';
    final userImage = args['userImage']?.toString() ?? '';

    if (chatId.isNotEmpty) {
      controller.fetchMessages(chatId);
      controller.setupSocket(chatId);
    }

    return Obx(() {
      final roleColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: _buildAppBar(roleColor, userName, userImage),
        body: SafeArea(
          child: Column(
            children: [
              // --- DIVIDER ---
              Divider(
                color: AppColors.goldColor.withValues(alpha: 0.15),
                thickness: 1,
                height: 1,
              ),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.messages.isEmpty) {
                    return Center(
                        child: CircularProgressIndicator(color: roleColor));
                  }

                  if (controller.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet. Start a conversation!',
                        style: GoogleFonts.inter(color: AppColors.bodyColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    reverse: true, // Newest messages at bottom
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];

                      if (index == controller.messages.length - 1) {
                        return Column(
                          children: [
                            _buildTodayPill(),
                            SizedBox(height: 20.h),
                            _buildChatBubble(msg, roleColor),
                          ],
                        );
                      }

                      return _buildChatBubble(msg, roleColor);
                    },
                  );
                }),
              ),

              // --- MESSAGE INPUT ---
              _buildMessageInput(roleColor, chatId),
            ],
          ),
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar(
      Color roleColor, String userName, String userImage) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.titleColor,
          size: 20.sp,
        ),
        onPressed: () => Get.back(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          // Avatar
          SizedBox(
            width: 40.h,
            height: 40.h,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xFFF5EFE6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: userImage.isNotEmpty
                        ? (userImage.startsWith('http')
                            ? Image.network(
                                userImage,
                                fit: BoxFit.cover,
                                width: 40.h,
                                height: 40.h,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                  child: Text(
                                    userName.isNotEmpty ? userName[0] : '',
                                    style: TextStyle(
                                      color: roleColor,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              )
                            : Image.asset(
                                userImage,
                                fit: BoxFit.cover,
                                width: 40.h,
                                height: 40.h,
                              ))
                        : Center(
                            child: Text(
                              userName.isNotEmpty ? userName[0] : '',
                              style: TextStyle(
                                color: roleColor,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                  ),
                ),
                Obx(
                  () => controller.isOtherUserOnline.value
                      ? Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.backgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Name and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              Obx(
                () => Text(
                  controller.isOtherUserOnline.value ? 'Online' : 'Offline',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: controller.isOtherUserOnline.value
                        ? Colors.green
                        : roleColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayPill() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.goldColor.withValues(alpha: 0.15),
          ),
        ),
        child: Text(
          'TODAY',
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFA6864D),
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessageModel message, Color roleColor) {
    bool isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                  decoration: BoxDecoration(
                    color: isMe ? roleColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: isMe
                          ? Radius.circular(20.r)
                          : const Radius.circular(0),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : Radius.circular(20.r),
                    ),
                    border: isMe
                        ? null
                        : Border.all(
                            color: AppColors.goldColor.withValues(alpha: 0.15),
                          ),
                    boxShadow: [
                      if (!isMe)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: isMe ? Colors.white : AppColors.titleColor,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          color: AppColors.bodyColor.withValues(alpha: 0.7),
                        ),
                      ),
                      if (isMe) ...[
                        SizedBox(width: 4.w),
                        _buildStatusIndicator(message.status, roleColor),
                      ],
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

  Widget _buildStatusIndicator(MessageStatus status, Color roleColor) {
    IconData icon;
    Color color;

    switch (status) {
      case MessageStatus.sent:
        icon = Icons.done;
        color = AppColors.bodyColor.withValues(alpha: 0.5);
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = AppColors.bodyColor.withValues(alpha: 0.5);
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = roleColor;
        break;
    }

    return Icon(icon, size: 14.sp, color: color);
  }

  Widget _buildMessageInput(Color roleColor, String chatId) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.goldColor.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.add, color: roleColor, size: 24.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: AppColors.goldColor.withValues(alpha: 0.2),
                ),
              ),
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.withValues(alpha: 0.5),
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15.w,
                    vertical: 12.h,
                  ),
                ),
                onSubmitted: (_) => controller.sendMessage(chatId),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          GestureDetector(
            onTap: () => controller.sendMessage(chatId),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: roleColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
