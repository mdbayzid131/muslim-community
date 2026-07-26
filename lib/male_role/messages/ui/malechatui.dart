import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/male_role/messages/controller/chat_controller.dart';
import 'package:muslim_community/shared/model/chat_message_model.dart';

class MaleChatUI extends StatelessWidget {
  final String chatId;
  final String userName;
  final String? userImage;

  const MaleChatUI({
    super.key,
    required this.chatId,
    required this.userName,
    this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    // Get the controller (creates if not exists, otherwise returns existing)
    final MaleChatController controller = Get.put(MaleChatController());

    // Fetch messages when UI opens or when chatId changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentChatId != chatId) {
        controller.fetchMessages(chatId);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(controller),
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
                if (controller.isLoading.value && controller.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
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
                  reverse: true, // Newest messages at bottom (index 0)
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];

                    // With reverse: true, the last item in the list is the oldest (top of screen)
                    if (index == controller.messages.length - 1) {
                      return Column(
                        children: [
                          _buildTodayPill(),
                          SizedBox(height: 20.h),
                          _buildChatBubble(msg),
                        ],
                      );
                    }

                    return _buildChatBubble(msg);
                  },
                );
              }),
            ),

            // --- MESSAGE INPUT ---
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(MaleChatController controller) {
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
                    child: userImage != null
                        ? (userImage!.startsWith('assets/')
                              ? Image.asset(
                                  userImage!,
                                  fit: BoxFit.cover,
                                  width: 40.h,
                                  height: 40.h,
                                )
                              : Image.network(
                                  userImage!,
                                  fit: BoxFit.cover,
                                  width: 40.h,
                                  height: 40.h,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                        child: Text(
                                          userName.isNotEmpty
                                              ? userName[0]
                                              : '',
                                          style: TextStyle(
                                            color: AppColors.maleColor,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                ))
                        : Center(
                            child: Text(
                              userName.isNotEmpty ? userName[0] : '',
                              style: TextStyle(
                                color: AppColors.maleColor,
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
                        : AppColors.maleColor,
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
            color: const Color(0xFFA6864D), // Gold color
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessageModel message) {
    bool isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.maleColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: isMe
                          ? Radius.circular(20.r)
                          : Radius.circular(0),
                      bottomRight: isMe
                          ? Radius.circular(0)
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
                        _buildStatusIndicator(message.status),
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

  Widget _buildStatusIndicator(MessageStatus status) {
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
        color = AppColors.maleColor; // Or a specific "read" color like blue
        break;
    }

    return Icon(icon, size: 14.sp, color: color);
  }

  Widget _buildMessageInput() {
    final MaleChatController controller = Get.find<MaleChatController>();
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
          Icon(Icons.add, color: AppColors.maleColor, size: 24.sp),
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
              decoration: const BoxDecoration(
                color: AppColors.maleColor,
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
