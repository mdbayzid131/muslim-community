import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/male_role/discover/controller/discover_controller.dart';
import 'package:muslim_community/male_role/discover/ui/widgets/brother_card.dart';
import 'package:muslim_community/male_role/discover/ui/learning.dart';
import 'package:muslim_community/male_role/discover/ui/mosques.dart';
import 'package:muslim_community/male_role/discover/ui/jumma.dart';
import 'package:muslim_community/male_role/discover/ui/ask_brother.dart';
import 'package:muslim_community/male_role/discover/controller/requestsendcontroller.dart';
import 'package:muslim_community/male_role/discover/controller/requestcancelcontroller.dart';
import 'package:muslim_community/male_role/discover/controller/requestacceptcontroller.dart';

import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/shared/widgets/coming_soon_dialog.dart';

/// Male Discover page — mirrors female structure, uses maleColor (0xFF5B7C99)
class MaleDiscoverUI extends StatelessWidget {
  const MaleDiscoverUI({super.key});

  // Male role primary color — from AppColors
  static const Color _roleColor = AppColors.maleColor;
  static const Color _bgColor = AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    final MaleDiscoverController controller = Get.put(MaleDiscoverController());
    Get.put(MaleRequestSendController());
    Get.put(MaleRequestCancelController());
    Get.put(MaleRequestAcceptController());

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                'Discover',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 20.h),
              _buildMainCategories(controller),
              SizedBox(height: 20.h),

              Expanded(
                child: Obx(() {
                  if (controller.selectedCategory.value == 'Brothers') {
                    return Column(
                      children: [
                        _buildSearchBar(controller),
                        SizedBox(height: 20.h),
                        _buildFilterTabs(controller),
                        SizedBox(height: 20.h),
                        _buildProfilesGrid(controller),
                      ],
                    );
                  } else if (controller.selectedCategory.value == 'Learning') {
                    return const LearningUI();
                  } else if (controller.selectedCategory.value == 'Mosques') {
                    return const MosquesUI();
                  } else if (controller.selectedCategory.value == 'Jumma') {
                    return const JummaUI();
                  } else if (controller.selectedCategory.value ==
                      'Ask Brother') {
                    return const AskBrotherUI();
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategories(MaleDiscoverController controller) {
    return Container(
      padding: EdgeInsets.all(4.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE6),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Obx(() {
        final currentSelection = controller.selectedCategory.value;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.mainCategories.map((category) {
              final isSelected = currentSelection == category;

              return GestureDetector(
                onTap: () {
                  if (category == 'Jumma') {
                    showComingSoonDialog();
                  } else {
                    controller.selectedCategory.value = category;
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                    border: isSelected
                        ? Border.all(color: AppColors.maleColor, width: 1)
                        : null,
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: isSelected
                          ? AppColors.titleColor
                          : const Color(0xFF5B7C99),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar(MaleDiscoverController controller) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        onChanged: (value) => controller.search(value),
        decoration: InputDecoration(
          hintText: 'Search Brothers...',
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.withValues(alpha: 0.5),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: _roleColor.withValues(alpha: 0.5),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(MaleDiscoverController controller) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tab(
              'Near Me',
              controller.selectedTab.value == MaleDiscoverTab.nearMe,
              () => controller.changeTab(MaleDiscoverTab.nearMe),
            ),
            SizedBox(width: 10.w),
            _tab(
              'New Reverts',
              controller.selectedTab.value == MaleDiscoverTab.newReverts,
              () => controller.changeTab(MaleDiscoverTab.newReverts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected
                ? _roleColor.withValues(alpha: 0.4)
                : const Color(0xFFA6864D).withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            // maleColor replaces femaleColor for selected tab text
            color: isSelected ? _roleColor : const Color(0xFFA6864D),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilesGrid(MaleDiscoverController controller) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.loadMore();
          }
          return false;
        },
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.filteredBrothers.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _roleColor),
            );
          }

          if (controller.filteredBrothers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 60.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Brothers Found',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Try adjusting your search or filters.',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.bodyColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchBrothers(),
            color: _roleColor,
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 20.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: controller.filteredBrothers.length,
              itemBuilder: (context, index) {
                final brother = controller.filteredBrothers[index];
                return BrotherCard(
                  brother: brother,
                  index: index,
                  onConnectPressed: () => Get.find<MaleRequestSendController>()
                      .sendRequest(brother.id),
                  onCancelPressed: () {
                    print("=== CANCEL BUTTON TAPPED ===");
                    print("  brother.id         : ${brother.id}");
                    print("  brother.connectionId: ${brother.connectionId}");
                    if (brother.connectionId != null) {
                      Get.find<MaleRequestCancelController>().cancelRequest(
                        brother.id,
                        brother.connectionId!,
                      );
                    } else {
                      print(
                        "  ⚠️ connectionId is NULL! Request cannot be cancelled.",
                      );
                      Get.snackbar(
                        "Error",
                        "Connection ID is missing. Cannot cancel.",
                      );
                    }
                  },
                  onConfirmPressed: () {
                    if (brother.connectionId != null) {
                      Get.find<MaleRequestAcceptController>().acceptRequest(
                        brother.id,
                        brother.connectionId!,
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Connection ID is missing. Cannot confirm.",
                      );
                    }
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
