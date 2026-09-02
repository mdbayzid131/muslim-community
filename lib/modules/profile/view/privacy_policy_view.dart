import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/api_client.dart';
import 'package:muslim_community/modules/profile/controller/privacy_terms_controller.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PrivacyAndTermsController>()
        ? Get.find<PrivacyAndTermsController>()
        : Get.put(
            PrivacyAndTermsController(
              apiClient: Get.find<ApiClient>(),
            ),
          );

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
            "PRIVACY POLICY",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
              letterSpacing: 2,
            ),
          ),
        ),
        body: controller.isDetailLoading.value
            ? Center(
                child: CircularProgressIndicator(color: themeColor),
              )
            : RefreshIndicator(
                onRefresh: () => controller.fetchLegalContent(
                  'privacy-policy',
                  isPrivacy: true,
                ),
                color: themeColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      controller.privacyPolicyContent.value.isNotEmpty
                          ? controller.privacyPolicyContent.value
                          : "No content available. Admin has not set this information yet.",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.bodyColor,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
      );
    });
  }
}
