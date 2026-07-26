import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/approut.dart';
import 'package:muslim_community/female_role/group/controller/group_controller.dart';
import 'package:muslim_community/female_role/group/model/group_model.dart';
import 'package:muslim_community/female_role/group/model/group_post_model.dart';
import 'package:muslim_community/female_role/home/controller/userdatacontroller.dart';

class FemaleGroupDetailsUI extends StatelessWidget {
  const FemaleGroupDetailsUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemaleGroupController controller = Get.find<FemaleGroupController>();
    final FemaleUserDataController userDataController =
        Get.isRegistered<FemaleUserDataController>()
        ? Get.find<FemaleUserDataController>()
        : Get.put(FemaleUserDataController());

    // Get initial group data from arguments
    final GroupModel initialGroup = Get.arguments;
    controller.updateInitialGroup(initialGroup);

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
        title: Obx(() {
          final group = controller.currentGroup.value ?? initialGroup;
          return Column(
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
                '${group.memberCount} members',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppColors.bodyColor,
                ),
              ),
            ],
          );
        }),
      ),
      body: Obx(() {
        final group = controller.currentGroup.value ?? initialGroup;
        return SingleChildScrollView(
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
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF0F0),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Icon(
                            group.icon,
                            color: AppColors.femaleColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${group.category} Group',
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
                    SizedBox(height: 20.h),
                    // Removed Join/Leave buttons from here
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // --- CREATE POST SECTION (MEMBERS ONLY) ---
              Obx(() {
                final group = controller.currentGroup.value;
                if (group == null || !group.isJoined)
                  return const SizedBox.shrink();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final img = userDataController.userProfileImage.value;
                      return CircleAvatar(
                        radius: 22.r,
                        backgroundImage: img.isNotEmpty
                            ? NetworkImage(img)
                            : const AssetImage('assets/image/female.png')
                                  as ImageProvider,
                        onBackgroundImageError: img.isNotEmpty
                            ? (e, s) {}
                            : null,
                      );
                    }),
                    SizedBox(width: 12.w),
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
                                color: AppColors.femaleColor.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: controller.postContentCtrl,
                              maxLines: null,
                              minLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Share something with the group...',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: AppColors.bodyColor.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Obx(() {
                            if (controller.selectedImages.isEmpty)
                              return const SizedBox.shrink();
                            return Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: SizedBox(
                                height: 80.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.selectedImages.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 10.w),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
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
                                            onTap: () =>
                                                controller.removeImage(index),
                                            child: Container(
                                              padding: EdgeInsets.all(4.w),
                                              decoration: const BoxDecoration(
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
                            );
                          }),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => controller.pickImages(),
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: AppColors.femaleColor,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              ElevatedButton(
                                onPressed: () =>
                                    controller.createPost(group.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF0E0DF),
                                  foregroundColor: AppColors.femaleColor,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.w,
                                    vertical: 8.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  'Post',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
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
                );
              }),

              SizedBox(height: 30.h),
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
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.groupPosts.length,
                  itemBuilder: (context, index) {
                    final post = controller.groupPosts[index];
                    return _buildPostCard(context, post);
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPostCard(BuildContext context, GroupPostModel post) {
    final FemaleUserDataController userDataController =
        Get.find<FemaleUserDataController>();
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.femalePostDetails, arguments: post),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
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
                      : const AssetImage('assets/image/female.png')
                            as ImageProvider,
                  onBackgroundImageError: post.userImage.isNotEmpty
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
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      Text(
                        post.createdAt,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (post.userId == userDataController.userId.value)
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
                                  final FemaleGroupController controller =
                                      Get.find<FemaleGroupController>();
                                  controller.deletePost(post.groupId, post.id);
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
                              size: 20,
                            ),
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
                    color: AppColors.bodyColor,
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
            SizedBox(height: 20.h),
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: const Color(0xFFE57373),
                  size: 18.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  '${post.likesCount}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
                SizedBox(width: 20.w),
                Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.bodyColor,
                  size: 18.sp,
                ),
                SizedBox(width: 5.w),
                Text(
                  '${post.commentsCount}',
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
    );
  }
}
