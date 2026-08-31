import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/data/models/conversation_model.dart';

class MessageTile extends StatelessWidget {
  final ConversationModel message;
  final Color themeColor;

  const MessageTile({
    super.key,
    required this.message,
    this.themeColor = AppColors.maleColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnread = message.unreadCount > 0;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.chat,
          arguments: {
            'chatId': message.id,
            'userName': message.name,
            'userImage': message.imageUrl,
            'isOnline': message.isOnline,
            'participantId': message.participantId,
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- AVATAR ---
            SizedBox(
              width: 60.h,
              height: 60.h,
              child: Stack(
                children: [
                  _buildAvatar(),
                  if (message.isVerified) _buildVerifiedBadge(),
                ],
              ),
            ),

            SizedBox(width: 15.w),

            // --- MESSAGE INFO ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      Text(
                        message.time,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: isUnread ? themeColor : AppColors.bodyColor,
                          fontWeight:
                              isUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.lastMessage,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: isUnread
                                ? AppColors.titleColor
                                : AppColors.bodyColor,
                            fontWeight:
                                isUnread ? FontWeight.w700 : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread) ...[
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            message.unreadCount.toString(),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (message.imageUrl.isNotEmpty &&
        (message.imageUrl.startsWith('http') ||
            message.imageUrl.startsWith('assets/')) &&
        !message.imageUrl.endsWith('.svg')) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: message.imageUrl.startsWith('http')
              ? Image.network(
                  message.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child:
                        Icon(Icons.person, color: Colors.grey, size: 30.sp),
                  ),
                )
              : Image.asset(
                  message.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
        ),
      );
    } else {
      // Initials Avatar
      String initial = message.name.isNotEmpty
          ? message.name[0].toUpperCase()
          : '';
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE0EAF4),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          initial,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24.sp,
            color: themeColor,
          ),
        ),
      );
    }
  }

  Widget _buildVerifiedBadge() {
    return Positioned(
      bottom: -2,
      right: -2,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: themeColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(Icons.check, color: Colors.white, size: 10.sp),
      ),
    );
  }
}
