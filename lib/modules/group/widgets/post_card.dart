import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/utils/date_formatter.dart';
import 'package:muslim_community/data/models/group_post_model.dart';

class PostCard extends StatelessWidget {
  final GroupPostModel post;
  final Color themeColor;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback? onDeleteTap;
  final bool isMyPost;

  const PostCard({
    super.key,
    required this.post,
    required this.themeColor,
    required this.onTap,
    required this.onLikeTap,
    required this.onCommentTap,
    this.onDeleteTap,
    this.isMyPost = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: themeColor.withValues(alpha: 0.15),
                  backgroundImage: (post.userImage.isNotEmpty &&
                          post.userImage.startsWith('http') &&
                          !post.userImage.endsWith('.svg'))
                      ? NetworkImage(post.userImage)
                      : null,
                  onBackgroundImageError: (post.userImage.isNotEmpty &&
                          post.userImage.startsWith('http') &&
                          !post.userImage.endsWith('.svg'))
                      ? (e, s) {}
                      : null,
                  child: (post.userImage.isEmpty ||
                          !post.userImage.startsWith('http') ||
                          post.userImage.endsWith('.svg'))
                      ? Icon(Icons.person, size: 18.sp, color: themeColor)
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.userName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      Text(
                        DateFormatter.timeAgo(post.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMyPost && onDeleteTap != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.bodyColor,
                      size: 20.sp,
                    ),
                    onSelected: (value) {
                      if (value == 'delete') {
                        onDeleteTap!();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                color: Colors.red, size: 20),
                            SizedBox(width: 10),
                            Text("Delete", style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Icon(
                    Icons.more_vert,
                    color: AppColors.bodyColor.withValues(alpha: 0.3),
                    size: 20.sp,
                  ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              post.content,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.titleColor.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            if (post.attachments.isNotEmpty) ...[
              SizedBox(height: 15.h),
              SizedBox(
                height: 150.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.attachments.length,
                  separatorBuilder: (context, index) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final att = post.attachments[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: att.startsWith('http')
                          ? Image.network(
                              att,
                              width: 200.w,
                              height: 150.h,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              att,
                              width: 200.w,
                              height: 150.h,
                              fit: BoxFit.cover,
                            ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 20.h),
            Row(
              children: [
                GestureDetector(
                  onTap: onLikeTap,
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        size: 20.sp,
                        color: post.isLiked ? Colors.red : AppColors.bodyColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${post.likeCount}',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.bodyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25.w),
                GestureDetector(
                  onTap: onCommentTap,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 18.sp,
                        color: AppColors.bodyColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${post.commentCount}',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.bodyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
