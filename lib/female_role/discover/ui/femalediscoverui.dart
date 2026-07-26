import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/discover/controller/discover_controller.dart';
import 'package:muslim_community/female_role/discover/ui/widgets/sister_card.dart';
import 'package:muslim_community/female_role/discover/ui/learning.dart';
import 'package:muslim_community/female_role/discover/ui/mosques.dart';
import 'package:muslim_community/female_role/discover/ui/jumma.dart';
import 'package:muslim_community/female_role/discover/ui/ask_sister.dart';
import 'package:muslim_community/female_role/discover/controller/requestsendcontroller.dart';
import 'package:muslim_community/female_role/discover/controller/requestcancelcontroller.dart';
import 'package:muslim_community/female_role/discover/controller/requestacceptcontroller.dart';
import 'package:muslim_community/shared/widgets/coming_soon_dialog.dart';

/// Female Discover page — uses femaleColor (0xFFD18E8E)
class FemaleDiscoverUI extends StatelessWidget {
  const FemaleDiscoverUI({super.key});

  // Female role primary color — from AppColors
  static const Color _roleColor = AppColors.femaleColor;
  static const Color _bgColor = AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    final FemaleDiscoverController controller = Get.put(
      FemaleDiscoverController(),
    );
    Get.put(FemaleRequestSendController());
    Get.put(FemaleRequestCancelController());
    Get.put(FemaleRequestAcceptController());

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
                  if (controller.selectedCategory.value == 'Sisters') {
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
                      'Ask Sister') {
                    return const AskSisterUI();
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

  Widget _buildMainCategories(FemaleDiscoverController controller) {
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
                        ? Border.all(color: AppColors.femaleColor, width: 1)
                        : null,
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: isSelected
                          ? AppColors.titleColor
                          : const Color(0xFFD18E8E),
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

  Widget _buildSearchBar(FemaleDiscoverController controller) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        onChanged: (value) => controller.search(value),
        decoration: InputDecoration(
          hintText: 'Search Sisters...',
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

  Widget _buildFilterTabs(FemaleDiscoverController controller) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tab(
              'Near Me',
              controller.selectedTab.value == DiscoverTab.nearMe,
              () => controller.changeTab(DiscoverTab.nearMe),
            ),
            SizedBox(width: 10.w),
            _tab(
              'New Reverts',
              controller.selectedTab.value == DiscoverTab.newReverts,
              () => controller.changeTab(DiscoverTab.newReverts),
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
            color: isSelected ? _roleColor : const Color(0xFFA6864D),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilesGrid(FemaleDiscoverController controller) {
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
              controller.filteredSisters.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _roleColor),
            );
          }

          if (controller.filteredSisters.isEmpty) {
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
                    'No Sisters Found',
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
            onRefresh: () => controller.fetchSisters(),
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
              itemCount: controller.filteredSisters.length,
              itemBuilder: (context, index) {
                final sister = controller.filteredSisters[index];
                return SisterCard(
                  sister: sister,
                  index: index,
                  onConnectPressed: () =>
                      Get.find<FemaleRequestSendController>().sendRequest(
                        sister.id,
                      ),
                  onCancelPressed: () {
                    if (sister.connectionId != null) {
                      Get.find<FemaleRequestCancelController>().cancelRequest(
                        sister.id,
                        sister.connectionId!,
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Connection ID is missing. Cannot cancel.",
                      );
                    }
                  },
                  onConfirmPressed: () {
                    if (sister.connectionId != null) {
                      Get.find<FemaleRequestAcceptController>().acceptRequest(
                        sister.id,
                        sister.connectionId!,
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
