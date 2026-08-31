import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/modules/profile/controller/personal_info_controller.dart';

class PersonalInfoView extends GetView<PersonalInfoController> {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final role =
        Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
    final isSister = role == 'female';

    return Obx(() {
      final themeColor = controller.roleColor;

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.titleColor,
                  size: 16.sp,
                ),
              ),
            ),
          ),
          title: Text(
            "PROFILE",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
              letterSpacing: 2,
            ),
          ),
          actions: [
            if (controller.isAnyEditing)
              Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Center(
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.saveProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Save All",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
        body: controller.isFetchingProfile.value
            ? Center(
                child: CircularProgressIndicator(color: themeColor),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    // Profile Image & Info
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeColor.withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: controller.selectedProfileImage.value !=
                                          null
                                      ? DecorationImage(
                                          image: FileImage(
                                            controller
                                                .selectedProfileImage.value!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : (controller.profileImageUrl.isNotEmpty &&
                                              controller.profileImageUrl.value.startsWith('http') &&
                                              !controller.profileImageUrl.value.endsWith('.svg'))
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                controller
                                                    .profileImageUrl.value,
                                              ),
                                              onError: (exception, stackTrace) {},
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: (controller.selectedProfileImage.value ==
                                            null &&
                                        (controller.profileImageUrl.isEmpty ||
                                            !controller.profileImageUrl.value
                                                .startsWith('http') ||
                                            controller.profileImageUrl.value
                                                .endsWith('.svg')))
                                    ? Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 50.sp,
                                          color: themeColor,
                                        ),
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: themeColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 10.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          controller.isEditingPersonalDetails.value
                              ? SizedBox(
                                  width: 200.w,
                                  child: TextField(
                                    controller: controller.nameCtrl,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter Name",
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 4.h,
                                      ),
                                      isDense: true,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  "${isSister ? 'Sister' : 'Brother'} ${controller.nameCtrl.text.split(' ').first}",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                          SizedBox(height: 5.h),
                          Text(
                            controller.joinedAgo.value,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: AppColors.bodyColor,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          GestureDetector(
                            onTap: () => controller.pickProfileImage(),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: themeColor,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    controller.selectedProfileImage.value !=
                                            null
                                        ? "Change Photo"
                                        : "Edit Photo",
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.titleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (controller.selectedProfileImage.value != null)
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: GestureDetector(
                                onTap: () => controller.saveProfile(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    "Save Photo",
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Verified Revert Banner
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: const Color(0xFFA6864D).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA6864D).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shield_outlined,
                              color: const Color(0xFFA6864D),
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Verified Revert",
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleColor,
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                ],
                              ),
                              Text(
                                "Community Member",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: AppColors.bodyColor
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Personal Details Card
                    _buildPersonalDetailsSection(controller, themeColor),
                    SizedBox(height: 20.h),

                    // About Me Card
                    _buildExpandableTextSection(
                      title: "About Me",
                      controller: controller.aboutCtrl,
                      isEditing: controller.isEditingAboutMe.value,
                      onToggleEdit: () => controller.isEditingAboutMe.value =
                          !controller.isEditingAboutMe.value,
                      themeColor: themeColor,
                    ),
                    SizedBox(height: 20.h),

                    // My Revert Story Card
                    _buildExpandableTextSection(
                      title: "My Revert Story",
                      controller: controller.storyCtrl,
                      isEditing: controller.isEditingStory.value,
                      onToggleEdit: () => controller.isEditingStory.value =
                          !controller.isEditingStory.value,
                      themeColor: themeColor,
                    ),
                    SizedBox(height: 20.h),

                    // Interests Section
                    _buildInterestsSection(controller, themeColor),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildPersonalDetailsSection(
    PersonalInfoController controller,
    Color themeColor,
  ) {
    bool isEditing = controller.isEditingPersonalDetails.value;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Personal Details",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              if (isEditing)
                GestureDetector(
                  onTap: () => controller.isEditingPersonalDetails.value = false,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => controller.isEditingPersonalDetails.value = true,
                  child: Icon(
                    Icons.edit_square,
                    color: themeColor.withValues(alpha: 0.5),
                    size: 18.sp,
                  ),
                ),
            ],
          ),
          SizedBox(height: 15.h),
          _buildDetailRow("Age", controller.ageCtrl, isEditing, themeColor),
          Divider(
            color: Colors.grey.withValues(alpha: 0.1),
            height: 20.h,
          ),
          _buildDetailRow(
            "Location",
            controller.locationCtrl,
            isEditing,
            themeColor,
          ),
          Divider(
            color: Colors.grey.withValues(alpha: 0.1),
            height: 20.h,
          ),
          _buildDetailRow(
            "Revert Duration",
            controller.durationCtrl,
            false,
            themeColor,
          ),
          Divider(
            color: Colors.grey.withValues(alpha: 0.1),
            height: 20.h,
          ),
          _buildDetailRow(
            "Email Address",
            controller.emailCtrl,
            false,
            themeColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    TextEditingController controller,
    bool isEditing,
    Color themeColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 13.sp, color: AppColors.bodyColor),
        ),
        isEditing
            ? SizedBox(
                width: 150.w,
                height: 35.h,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: themeColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              )
            : Text(
                controller.text.isNotEmpty ? controller.text : "Not specified",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleColor,
                ),
              ),
      ],
    );
  }

  Widget _buildExpandableTextSection({
    required String title,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onToggleEdit,
    required Color themeColor,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              if (isEditing)
                GestureDetector(
                  onTap: onToggleEdit,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: onToggleEdit,
                  child: Icon(
                    Icons.edit_square,
                    color: themeColor.withValues(alpha: 0.5),
                    size: 18.sp,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          isEditing
              ? TextField(
                  controller: controller,
                  maxLines: 4,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.bodyColor,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: "Write your $title here...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                        color: themeColor.withValues(alpha: 0.5),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10.w),
                  ),
                )
              : Text(
                  controller.text.isNotEmpty
                      ? controller.text
                      : "No details added yet.",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppColors.bodyColor,
                    height: 1.5,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection(
    PersonalInfoController controller,
    Color themeColor,
  ) {
    bool isEditing = controller.isEditingInterests.value;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Interests",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titleColor,
                    ),
                  ),
                  if (isEditing) ...[
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => controller.isEditingInterests.value = false,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "Save",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => controller.isEditingInterests.value = true,
                      child: Icon(
                        Icons.edit_square,
                        color: themeColor.withValues(alpha: 0.5),
                        size: 18.sp,
                      ),
                    ),
                  ],
                ],
              ),
              if (isEditing)
                Text(
                  "Add up to 10",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppColors.bodyColor,
                  ),
                ),
            ],
          ),
          SizedBox(height: 15.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              ...controller.interestsList.map(
                (t) => _buildInterestTag(t, isEditing, controller, themeColor),
              ),
              if (isEditing && controller.interestsList.length < 10)
                GestureDetector(
                  onTap: () => _showAddInterestDialog(controller, themeColor),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.bodyColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.bodyColor,
                          size: 14.sp,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Add Interest",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.bodyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestTag(
    String text,
    bool isEditing,
    PersonalInfoController controller,
    Color themeColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: themeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: themeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isEditing) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => controller.removeInterest(text),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: themeColor,
                  size: 10.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddInterestDialog(
    PersonalInfoController controller,
    Color themeColor,
  ) {
    TextEditingController newInterestCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          "Add Interest",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: newInterestCtrl,
          decoration: InputDecoration(
            hintText: "e.g. Dhikr",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: themeColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              if (newInterestCtrl.text.trim().isNotEmpty) {
                controller.addInterest(newInterestCtrl.text.trim());
              }
              Get.back();
            },
            child: Text(
              "Add",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
