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

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isUnread
            ? themeColor.withValues(alpha: 0.03)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUnread
              ? themeColor.withValues(alpha: 0.3)
              : const Color(0xFFEEEEEE),
          width: isUnread ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isUnread
                ? themeColor.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
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
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- AVATAR ---
                SizedBox(
                  width: 52.w,
                  height: 52.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildAvatar(),
                      if (message.isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 13.w,
                            height: 13.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2ECC71),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(width: 14.w),

                // --- MESSAGE INFO ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name & Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    message.name,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (message.isVerified) ...[
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.verified,
                                    color: themeColor,
                                    size: 15.sp,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            message.time,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: isUnread ? themeColor : const Color(0xFF9E9E9E),
                              fontWeight:
                                  isUnread ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      // Last Message & Unread Count Row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.lastMessage,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: isUnread
                                    ? AppColors.titleColor
                                    : const Color(0xFF757575),
                                fontWeight:
                                    isUnread ? FontWeight.w600 : FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: themeColor.withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${message.unreadCount}',
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
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: message.imageUrl.startsWith('http')
              ? Image.network(
                  message.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) => _buildFallbackInitial(),
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
      return _buildFallbackInitial();
    }
  }

  Widget _buildFallbackInitial() {
    String initial = message.name.isNotEmpty
        ? message.name[0].toUpperCase()
        : 'U';
    return Container(
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: themeColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.playfairDisplay(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: themeColor,
        ),
      ),
    );
  }
}
