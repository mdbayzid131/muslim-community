import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/date_formatter.dart';
import 'package:muslim_community/data/models/group_post_model.dart';
import 'package:muslim_community/modules/group/controller/group_controller.dart';

class PostDetailsView extends GetView<GroupController> {
  const PostDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupPostModel post = (Get.arguments is Map
            ? Get.arguments['post'] as GroupPostModel?
            : Get.arguments is GroupPostModel
                ? Get.arguments as GroupPostModel
                : null) ??
        GroupPostModel(
          id: '',
          groupId: '',
          userId: '',
          userName: 'Brother',
          userImage: '',
          content: '',
          attachments: const [],
          likesCount: 0,
          commentsCount: 0,
          isPinned: false,
          isLiked: false,
          createdAt: '',
        );

    final myUserId =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userId : '';

    // Fetch live comments when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (post.id.isNotEmpty) {
        controller.fetchPostComments(post.id);
      }
    });

    return Obx(() {
      final roleColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(8.w),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: roleColor,
                  size: 18.sp,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          title: Text(
            'Post Details',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- POST CARD ---
                    Container(
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
                                 backgroundColor:
                                     roleColor.withValues(alpha: 0.15),
                                 backgroundImage: (post.userImage.isNotEmpty &&
                                         post.userImage.startsWith('http') &&
                                         !post.userImage.endsWith('.svg'))
                                     ? NetworkImage(post.userImage)
                                     : null,
                                 onBackgroundImageError:
                                     (post.userImage.isNotEmpty &&
                                             post.userImage
                                                 .startsWith('http') &&
                                             !post.userImage.endsWith('.svg'))
                                         ? (e, s) {}
                                         : null,
                                 child: (post.userImage.isEmpty ||
                                         !post.userImage.startsWith('http') ||
                                         post.userImage.endsWith('.svg'))
                                     ? Icon(Icons.person,
                                         size: 18.sp, color: roleColor)
                                     : null,
                               ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            post.content,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppColors.titleColor
                                  .withValues(alpha: 0.8),
                              height: 1.5,
                            ),
                          ),
                          if (post.attachments.isNotEmpty) ...[
                            SizedBox(height: 15.h),
                            ...post.attachments.map(
                              (url) => Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.network(
                                    url,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: double.infinity,
                                      height: 200.h,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => controller.toggleLike(post.id),
                                child: Row(
                                  children: [
                                    Icon(
                                      post.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: post.isLiked
                                          ? const Color(0xFFE57373)
                                          : AppColors.bodyColor,
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      '${post.likeCount}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.bodyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Icon(
                                Icons.chat_bubble_outline,
                                color: AppColors.bodyColor,
                                size: 18.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${post.commentCount}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.bodyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // --- COMMENTS SECTION ---
                    Text(
                      'Comments',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    SizedBox(height: 15.h),

                    if (controller.isCommentsLoading.value &&
                        controller.postComments.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.h),
                          child: CircularProgressIndicator(color: roleColor),
                        ),
                      )
                    else if (controller.postComments.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(
                            'No comments yet. Write a comment below!',
                            style: GoogleFonts.inter(
                              color: AppColors.bodyColor,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.postComments.length,
                        separatorBuilder: (context, idx) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, idx) {
                          final comment = controller.postComments[idx];
                          return Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: roleColor.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor:
                                      roleColor.withValues(alpha: 0.15),
                                  backgroundImage: (comment.userImage.isNotEmpty &&
                                          comment.userImage.startsWith('http') &&
                                          !comment.userImage.endsWith('.svg'))
                                      ? NetworkImage(comment.userImage)
                                      : null,
                                  onBackgroundImageError:
                                      (comment.userImage.isNotEmpty &&
                                              comment.userImage
                                                  .startsWith('http') &&
                                              !comment.userImage.endsWith('.svg'))
                                          ? (e, s) {}
                                          : null,
                                  child: (comment.userImage.isEmpty ||
                                          !comment.userImage.startsWith('http') ||
                                          comment.userImage.endsWith('.svg'))
                                      ? Icon(Icons.person,
                                          size: 16.sp, color: roleColor)
                                      : null,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            comment.userName,
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.titleColor,
                                            ),
                                          ),
                                          if (comment.userId == myUserId)
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete_outline,
                                                size: 16.sp,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () =>
                                                  controller.deleteComment(
                                                      post.id, comment.id),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        comment.content,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          color: AppColors.bodyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // --- COMMENT INPUT BOX ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: roleColor.withValues(alpha: 0.15),
                      child: Icon(Icons.person, size: 18.sp, color: roleColor),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: roleColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: TextField(
                          controller: controller.commentContentCtrl,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.bodyColor
                                  .withValues(alpha: 0.6),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    IconButton(
                      onPressed: () => controller.addComment(post.id),
                      icon: Icon(
                        Icons.send_rounded,
                        color: roleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
