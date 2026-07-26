import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/profile/controller/female_personal_info_controller.dart';

import 'package:muslim_community/female_role/home/controller/userdatacontroller.dart';

class FemalePersonalInfoUI extends StatelessWidget {
  const FemalePersonalInfoUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FemalePersonalInfoController());
    final userCtrl = Get.find<FemaleUserDataController>();

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
      ),
      body: Obx(() {
        if (controller.isFetchingProfile.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.femaleColor),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Profile Image & Info
              Center(
                child: Column(
                  children: [
                    Obx(
                      () => Stack(
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              image:
                                  controller.selectedProfileImage.value != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        controller.selectedProfileImage.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : userCtrl.userProfileImage.value.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        userCtrl.userProfileImage.value,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                        'assets/image/female.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
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
                                decoration: const BoxDecoration(
                                  color: AppColors.femaleColor,
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
                    ),
                    SizedBox(height: 15.h),
                    Obx(
                      () => controller.isEditingPersonalDetails.value
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
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            )
                          : Text(
                              "Sister ${controller.nameCtrl.text.split(' ').first}",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                    ),
                    SizedBox(height: 5.h),
                    Obx(
                      () => Text(
                        controller.joinedAgo.value,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: AppColors.bodyColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () => controller.pickImage(),
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
                              color: AppColors.femaleColor,
                              size: 14.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              controller.selectedProfileImage.value != null
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
                    Obx(
                      () => controller.selectedProfileImage.value != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: GestureDetector(
                                onTap: () => controller.saveAll(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.femaleColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          width: 14.sp,
                                          height: 14.sp,
                                          child:
                                              const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                        )
                                      : Text(
                                          "Save Photo",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // Verified Revert Banner
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: AppColors.femaleColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.goldColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: AppColors.goldColor,
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
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 14.sp,
                            ),
                          ],
                        ),
                        Text(
                          "Verified on Oct 12, 2023",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: AppColors.bodyColor.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Personal Details Card
              Obx(
                () => _buildSectionCard(
                  title: "Personal Details",
                  isEditingSection: controller.isEditingPersonalDetails.value,
                  onEditTap: () =>
                      controller.isEditingPersonalDetails.value = true,
                  onSaveTap: () => controller.saveAll(),
                  themeColor: AppColors.femaleColor,
                  children: [
                    _buildDetailRow(
                      "Full Name",
                      controller.nameCtrl,
                      controller.isEditingPersonalDetails.value,
                      AppColors.femaleColor,
                    ),
                    _buildStaticRow(
                      "Age",
                      controller.ageCtrl.text,
                      icon: Icons.lock_outline,
                    ),
                    _buildStaticRow(
                      "Gender",
                      "Sister",
                      icon: Icons.lock_outline,
                    ),
                    _buildStaticRow(
                      "Location",
                      controller.locationCtrl.text,
                      icon: Icons.lock_outline,
                    ),
                    _buildStaticRow(
                      "How long Muslim?",
                      controller.durationCtrl.text,
                      icon: Icons.lock_outline,
                    ),
                    _buildStaticRow(
                      "Email",
                      controller.emailCtrl.text,
                      icon: Icons.lock_outline,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // About Me Card
              Obx(
                () => _buildSectionCard(
                  title: "About Me",
                  isEditingSection: controller.isEditingAboutMe.value,
                  onEditTap: () => controller.isEditingAboutMe.value = true,
                  onSaveTap: () => controller.saveAll(),
                  themeColor: AppColors.femaleColor,
                  children: [
                    _buildEditableTextArea(
                      controller.aboutCtrl,
                      controller.isEditingAboutMe.value,
                      AppColors.femaleColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // My Revert Story Card
              Obx(
                () => _buildSectionCard(
                  title: "My Revert Story",
                  isEditingSection: controller.isEditingStory.value,
                  onEditTap: () => controller.isEditingStory.value = true,
                  onSaveTap: () => controller.saveAll(),
                  themeColor: AppColors.femaleColor,
                  children: [
                    _buildEditableTextArea(
                      controller.storyCtrl,
                      controller.isEditingStory.value,
                      AppColors.femaleColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Interests Card
              Obx(() => _buildInterestsSection(controller)),
              SizedBox(height: 30.h),

              // Global Save Button removed as requested
              const SizedBox.shrink(),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required bool isEditingSection,
    required VoidCallback onEditTap,
    required VoidCallback onSaveTap,
    required Color themeColor,
    required List<Widget> children,
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
              if (isEditingSection)
                GestureDetector(
                  onTap: onSaveTap,
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
                  onTap: onEditTap,
                  child: Icon(
                    Icons.edit_square,
                    color: themeColor.withValues(alpha: 0.5),
                    size: 18.sp,
                  ),
                ),
            ],
          ),
          SizedBox(height: 15.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    TextEditingController controller,
    bool isEditingSection,
    Color themeColor,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.bodyColor.withValues(alpha: 0.8),
            ),
          ),
          isEditingSection
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.titleColor,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: themeColor.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: themeColor),
                        ),
                      ),
                    ),
                  ),
                )
              : Text(
                  controller.text,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleColor,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildStaticRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.bodyColor.withValues(alpha: 0.8),
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleColor,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 5.w),
                Icon(icon, color: AppColors.bodyColor, size: 14.sp),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTextArea(
    TextEditingController controller,
    bool isEditingSection,
    Color themeColor,
  ) {
    return isEditingSection
        ? TextField(
            controller: controller,
            maxLines: null,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.bodyColor,
              height: 1.5,
            ),
            decoration: InputDecoration(
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
            controller.text,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppColors.bodyColor,
              height: 1.5,
            ),
          );
  }

  Widget _buildInterestsSection(FemalePersonalInfoController controller) {
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
                          color: AppColors.femaleColor,
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
                        color: AppColors.femaleColor.withValues(alpha: 0.5),
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
                (t) => _buildInterestTag(t, isEditing, controller),
              ),
              if (isEditing && controller.interestsList.length < 10)
                GestureDetector(
                  onTap: () => _showAddInterestDialog(controller),
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
    FemalePersonalInfoController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.femaleColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.femaleColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.femaleColor,
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
                  color: AppColors.femaleColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.femaleColor,
                  size: 10.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddInterestDialog(FemalePersonalInfoController controller) {
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
              borderSide: const BorderSide(color: AppColors.femaleColor),
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
              backgroundColor: AppColors.femaleColor,
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
