import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
    final isOnline = args['isOnline'] == true;
    final participantId = args['participantId']?.toString();

    if (chatId.isNotEmpty) {
      controller.fetchMessages(chatId, participantId: participantId);
      controller.setupSocket(chatId, initialOnline: isOnline);
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (chatId.isNotEmpty) {
                      await controller.fetchMessages(chatId);
                    }
                  },
                  color: roleColor,
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.messages.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 150.h),
                          Center(
                            child:
                                CircularProgressIndicator(color: roleColor),
                          ),
                        ],
                      );
                    }

                    if (controller.messages.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 150.h),
                          Center(
                            child: Text(
                              'No messages yet. Start a conversation!',
                              style:
                                  GoogleFonts.inter(color: AppColors.bodyColor),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
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
              ),

              // Image sending indicator
              Obx(() => controller.isSendingImage.value
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                      color: roleColor.withValues(alpha: 0.08),
                      child: Row(
                        children: [
                          SizedBox(width: 12.w, height: 12.h,
                            child: CircularProgressIndicator(strokeWidth: 2, color: roleColor)),
                          SizedBox(width: 10.w),
                          Text('Sending image...', style: GoogleFonts.inter(fontSize: 12.sp, color: roleColor)),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),

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
                        ? (userImage.startsWith('http') && !userImage.endsWith('.svg')
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
                            : (userImage.startsWith('assets/')
                                ? Image.asset(
                                    userImage,
                                    fit: BoxFit.cover,
                                    width: 40.h,
                                    height: 40.h,
                                  )
                                : Center(
                                    child: Text(
                                      userName.isNotEmpty ? userName[0] : '',
                                      style: TextStyle(
                                        color: roleColor,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  )))
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
    final hasImage = message.imageUrl != null && message.imageUrl!.isNotEmpty;

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
                  child: hasImage
                      ? ClipRRect(
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
                          child: _buildImageContent(message.imageUrl!, isMe),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
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

  Widget _buildImageContent(String imageUrl, bool isMe) {
    // If starts with 'http' → network image
    // If it's a valid local path AND file exists → local file
    // Otherwise → treat as network (ApiConstants.getImageUrl handles relative paths in model)
    final isLocalPath = !imageUrl.startsWith('http');
    final localFileExists = isLocalPath && File(imageUrl).existsSync();

    if (isLocalPath && localFileExists) {
      return Image.file(
        File(imageUrl),
        width: Get.width * 0.65,
        height: 200.h,
        fit: BoxFit.cover,
        errorBuilder: (ctx, e, st) => _imagePlaceholder(isMe),
      );
    }

    // Network image (full https:// URL or converted relative URL)
    final networkUrl = isLocalPath
        ? 'https://nayem5002.binarybards.online$imageUrl'
        : imageUrl;

    return Image.network(
      networkUrl,
      width: Get.width * 0.65,
      height: 200.h,
      fit: BoxFit.cover,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: Get.width * 0.65,
          height: 200.h,
          child: Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : null,
              color: isMe ? Colors.white : AppColors.goldColor,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (ctx, e, st) => _imagePlaceholder(isMe),
    );
  }

  Widget _imagePlaceholder(bool isMe) {
    return Container(
      width: Get.width * 0.65,
      height: 120.h,
      color: isMe
          ? Colors.white.withValues(alpha: 0.15)
          : Colors.grey.shade200,
      child: Icon(
        Icons.broken_image_outlined,
        color: isMe ? Colors.white54 : Colors.grey.shade400,
        size: 40.sp,
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
          // Plus / Attachment button
          GestureDetector(
            onTap: () => _showAttachmentSheet(roleColor, chatId),
            child: Icon(Icons.add, color: roleColor, size: 24.sp),
          ),
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

  void _showAttachmentSheet(Color roleColor, String chatId) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              'Send Attachment',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _attachmentOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: roleColor,
                  onTap: () {
                    Get.back();
                    controller.pickAndSendImage(chatId, ImageSource.gallery);
                  },
                ),
                _attachmentOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: roleColor,
                  onTap: () {
                    Get.back();
                    controller.pickAndSendImage(chatId, ImageSource.camera);
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _attachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Icon(icon, color: color, size: 30.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.titleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
