import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:get/get.dart';
import 'package:muslim_community/jummarole/profile/controller/jumma_personal_info_controller.dart';

class JummaPersonalInfoUI extends StatelessWidget {
  const JummaPersonalInfoUI({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JummaPersonalInfoController());

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
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Profile Image & Info
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Obx(() {
                          final hasLocalImage =
                              controller.selectedProfileImage.value != null;
                          final hasNetworkImage =
                              controller.profileImageUrl.value.isNotEmpty;

                          return Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              image: hasLocalImage
                                  ? DecorationImage(
                                      image: FileImage(
                                        controller.selectedProfileImage.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : hasNetworkImage
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        controller.profileImageUrl.value,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: AssetImage(
                                        'assets/image/male.png',
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
                          );
                        }),
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
                                color: AppColors.jummaColor,
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
                              controller.nameCtrl.text,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
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
                              color: AppColors.jummaColor,
                              size: 14.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Edit Photo",
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
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              // Verified Banner
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: AppColors.jummaColor.withValues(alpha: 0.3),
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
                              "Verified Imam",
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
                          "Official Muslim Community Imam",
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
                  isLoading: controller.isLoading.value,
                  onEditTap: () =>
                      controller.isEditingPersonalDetails.value = true,
                  onSaveTap: () => controller.saveAll(),
                  themeColor: AppColors.jummaColor,
                  children: [
                    _buildDetailRow(
                      "Full Name",
                      controller.nameCtrl,
                      controller.isEditingPersonalDetails.value,
                      AppColors.jummaColor,
                    ),
                    _buildDetailRow(
                      "Age",
                      controller.ageCtrl,
                      false, // Age not editable
                      AppColors.jummaColor,
                    ),
                    _buildDetailRow(
                      "Email",
                      controller.emailCtrl,
                      false, // Email not editable
                      AppColors.jummaColor,
                      isLocked: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required bool isEditingSection,
    required bool isLoading,
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
                  onTap: isLoading ? null : onSaveTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 12.w,
                            height: 12.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
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
    Color themeColor, {
    bool isLocked = false,
  }) {
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
              : Row(
                  children: [
                    Text(
                      controller.text,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.titleColor,
                      ),
                    ),
                    if (isLocked) ...[
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.lock_outline,
                        size: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ],
                ),
        ],
      ),
    );
  }
}
