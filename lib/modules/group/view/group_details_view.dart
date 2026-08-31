import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/data/models/group_model.dart';
import 'package:muslim_community/modules/group/controller/group_controller.dart';
import 'package:muslim_community/modules/group/widgets/post_card.dart';

class GroupDetailsView extends GetView<GroupController> {
  const GroupDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupModel initialGroup = (Get.arguments is Map
            ? Get.arguments['group'] as GroupModel?
            : Get.arguments is GroupModel
                ? Get.arguments as GroupModel
                : null) ??
        controller.currentGroup.value ??
        GroupModel(
          id: '',
          name: 'Group',
          category: 'Community',
          memberCount: 0,
          description: '',
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialGroup.id.isNotEmpty &&
          controller.currentGroup.value?.id != initialGroup.id) {
        controller.updateInitialGroup(initialGroup);
      }
    });

    final myProfileImage = Get.isRegistered<AuthService>()
        ? Get.find<AuthService>().currentUser.value?.profileImage ?? ''
        : '';
    final myUserId =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userId : '';

    return Obx(() {
      final roleColor = controller.roleColor;
      final group = controller.currentGroup.value ?? initialGroup;

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              Text(
                '${group.totalMembers} members',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.bodyColor,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- GROUP INFO CARD ---
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Icon(
                        Icons.groups_rounded,
                        color: roleColor,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${group.category.isNotEmpty ? group.category : "Community"} Group',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titleColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            group.description,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.bodyColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // --- CREATE POST SECTION (MEMBERS ONLY) ---
              if (group.isJoined) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: roleColor.withValues(alpha: 0.15),
                      backgroundImage: (myProfileImage.isNotEmpty &&
                              myProfileImage.startsWith('http') &&
                              !myProfileImage.endsWith('.svg'))
                          ? NetworkImage(myProfileImage)
                          : null,
                      onBackgroundImageError: (myProfileImage.isNotEmpty &&
                              myProfileImage.startsWith('http') &&
                              !myProfileImage.endsWith('.svg'))
                          ? (e, s) {}
                          : null,
                      child: (myProfileImage.isEmpty ||
                              !myProfileImage.startsWith('http') ||
                              myProfileImage.endsWith('.svg'))
                          ? Icon(Icons.person, size: 20.sp, color: roleColor)
                          : null,
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: roleColor.withValues(alpha: 0.15),
                              ),
                            ),
                            child: TextField(
                              controller: controller.postContentCtrl,
                              maxLines: null,
                              minLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Share something with the group...',
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
                          if (controller.selectedImages.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: SizedBox(
                                height: 80.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      controller.selectedImages.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 10.w),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Image.file(
                                            controller.selectedImages[index],
                                            width: 80.w,
                                            height: 80.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5.h,
                                          right: 5.w,
                                          child: GestureDetector(
                                            onTap: () => controller
                                                .removeImage(index),
                                            child: Container(
                                              padding: EdgeInsets.all(4.w),
                                              decoration:
                                                  const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => controller.pickPostImages(),
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: roleColor,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              ElevatedButton(
                                onPressed: () =>
                                    controller.createPost(group.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD9E2ED),
                                  foregroundColor: roleColor,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25.w,
                                    vertical: 8.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: controller.isSubmitting.value
                                    ? SizedBox(
                                        width: 15.w,
                                        height: 15.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: roleColor,
                                        ),
                                      )
                                    : Text(
                                        'Post',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
              ],

              // --- RECENT POSTS TITLE ---
              Text(
                'Recent Posts',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              SizedBox(height: 20.h),

              // --- POSTS LIST ---
              if (controller.isPostsLoading.value &&
                  controller.groupPosts.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.h),
                    child: CircularProgressIndicator(color: roleColor),
                  ),
                )
              else if (controller.groupPosts.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      'No posts yet. Be the first to share!',
                      style: GoogleFonts.inter(color: AppColors.bodyColor),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.groupPosts.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 15.h),
                  itemBuilder: (context, index) {
                    final post = controller.groupPosts[index];
                    return PostCard(
                      post: post,
                      themeColor: roleColor,
                      isMyPost: post.userId == myUserId,
                      onTap: () {
                        Get.toNamed(AppRoutes.postDetails,
                            arguments: post);
                      },
                      onLikeTap: () => controller.toggleLike(post.id),
                      onCommentTap: () {
                        Get.toNamed(AppRoutes.postDetails,
                            arguments: post);
                      },
                      onDeleteTap: () =>
                          controller.deletePost(group.id, post.id),
                    );
                  },
                ),
            ],
          ),
        ),
      );
    });
  }
}
