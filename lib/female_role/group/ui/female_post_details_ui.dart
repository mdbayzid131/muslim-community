import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/group/controller/group_controller.dart';
import 'package:muslim_community/female_role/group/model/group_post_model.dart';
import 'package:muslim_community/female_role/group/model/group_comment_model.dart';
import 'package:muslim_community/female_role/home/controller/userdatacontroller.dart';

class FemalePostDetailsUI extends StatelessWidget {
  const FemalePostDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemaleGroupController controller = Get.find<FemaleGroupController>();
    final FemaleUserDataController userDataController =
        Get.isRegistered<FemaleUserDataController>()
        ? Get.find<FemaleUserDataController>()
        : Get.put(FemaleUserDataController());

    final GroupPostModel initialPost = Get.arguments;

    // Fetch live comments when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPostComments(initialPost.id);
    });

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
                color: AppColors.femaleColor,
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
              child: Obx(() {
                final post = controller.groupPosts.firstWhere(
                  (p) => p.id == initialPost.id,
                  orElse: () => initialPost,
                );

                return Column(
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
                                backgroundImage: post.userImage.isNotEmpty
                                    ? NetworkImage(post.userImage)
                                    : const AssetImage(
                                            'assets/image/female.png',
                                          )
                                          as ImageProvider,
                                onBackgroundImageError:
                                    post.userImage.isNotEmpty
                                    ? (e, s) {}
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
                                      post.createdAt.split('T')[0],
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        color: AppColors.bodyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (post.userId ==
                                  userDataController.userId.value)
                                PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: AppColors.bodyColor,
                                    size: 20.sp,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      Get.dialog(
                                        AlertDialog(
                                          title: const Text("Delete Post"),
                                          content: const Text(
                                            "Are you sure you want to delete this post?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                                controller.deletePost(
                                                  post.groupId,
                                                  post.id,
                                                );
                                                Get.back(); // Back to group details
                                              },
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            post.content,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppColors.titleColor.withValues(
                                alpha: 0.8,
                              ),
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
                                              child: Icon(
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
                                onTap: () => controller.likePost(post.id),
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
                                      post.likesCount.toString(),
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
                                post.commentsCount.toString(),
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

                    if (controller.postComments.isEmpty)
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.postComments
                            .where((c) => c.parentCommentId == null)
                            .length,
                        itemBuilder: (context, index) {
                          final mainComments = controller.postComments
                              .where((c) => c.parentCommentId == null)
                              .toList();
                          if (index >= mainComments.length)
                            return const SizedBox.shrink();
                          final mainComment = mainComments[index];
                          final replies = controller.postComments
                              .where((c) => c.parentCommentId == mainComment.id)
                              .toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCommentItem(
                                context,
                                mainComment,
                                isReply: false,
                              ),
                              if (replies.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(left: 40.w),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: replies.length,
                                    itemBuilder: (context, rIndex) {
                                      return _buildCommentItem(
                                        context,
                                        replies[rIndex],
                                        isReply: true,
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        },
                      ),
                  ],
                );
              }),
            ),
          ),

          // --- REPLY PREVIEW ---
          Obx(() {
            if (controller.replyingToCommentId.value.isEmpty)
              return const SizedBox.shrink();
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              color: AppColors.backgroundColor.withValues(alpha: 0.8),
              child: Row(
                children: [
                  Icon(Icons.reply, size: 16.sp, color: AppColors.femaleColor),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Replying to ${controller.replyingToUserName.value}',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppColors.bodyColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.cancelReply(),
                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                ],
              ),
            );
          }),

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
                  Obx(() {
                    final img = userDataController.userProfileImage.value;
                    return CircleAvatar(
                      radius: 20.r,
                      backgroundImage: img.isNotEmpty
                          ? NetworkImage(img)
                          : const AssetImage('assets/image/female.png')
                                as ImageProvider,
                      onBackgroundImageError: img.isNotEmpty ? (e, s) {} : null,
                    );
                  }),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.femaleColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.femaleColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: TextField(
                        controller: controller.commentContentCtrl,
                        decoration: InputDecoration(
                          hintText: controller.replyingToCommentId.value.isEmpty
                              ? 'Write a comment...'
                              : 'Write a reply...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: AppColors.bodyColor.withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.femaleColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: AppColors.femaleColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        controller.addComment(initialPost.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    GroupCommentModel comment, {
    required bool isReply,
  }) {
    final controller = Get.find<FemaleGroupController>();
    final userDataController = Get.find<FemaleUserDataController>();
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15.r,
            backgroundImage: comment.userImage.isNotEmpty
                ? NetworkImage(comment.userImage)
                : const AssetImage('assets/image/female.png') as ImageProvider,
            onBackgroundImageError: comment.userImage.isNotEmpty
                ? (e, s) {}
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        comment.userName,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          comment.createdAt.contains('T')
                              ? comment.createdAt.split('T')[0]
                              : comment.createdAt,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: AppColors.bodyColor.withValues(alpha: 0.6),
                          ),
                        ),
                        if (comment.userId == userDataController.userId.value)
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              size: 16.sp,
                              color: AppColors.bodyColor,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onSelected: (value) {
                              if (value == 'delete') {
                                Get.dialog(
                                  AlertDialog(
                                    title: const Text("Delete Comment"),
                                    content: const Text(
                                      "Are you sure you want to delete this comment?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                          final postId = Get.arguments.id;
                                          controller.deleteComment(
                                            postId,
                                            comment.id,
                                          );
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  comment.content,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.titleColor.withValues(alpha: 0.8),
                  ),
                ),
                if (!isReply)
                  GestureDetector(
                    onTap: () =>
                        controller.setReply(comment.id, comment.userName),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'Reply',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.femaleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
