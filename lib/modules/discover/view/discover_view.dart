import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/modules/ask_imam/view/ask_imam_view.dart';
import 'package:muslim_community/modules/discover/controller/discover_controller.dart';
import 'package:muslim_community/modules/discover/view/learning_view.dart';
import 'package:muslim_community/modules/discover/view/mosques_view.dart';
import 'package:muslim_community/modules/discover/widgets/member_card.dart';
import 'package:muslim_community/modules/profile/view/profile_details_view.dart';

class DiscoverView extends GetView<DiscoverController> {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final roleColor = AppColors.getRoleColor(controller.userRole);

      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
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
                _buildMainCategories(roleColor),
                SizedBox(height: 20.h),
                Expanded(
                  child: Obx(() {
                    final cat = controller.selectedCategory.value;
                    if (cat == 'Brothers' || cat == 'Sisters' || cat == 'Members') {
                      return Column(
                        children: [
                          _buildSearchBar(roleColor),
                          SizedBox(height: 20.h),
                          _buildFilterTabs(roleColor),
                          SizedBox(height: 20.h),
                          _buildProfilesGrid(roleColor),
                        ],
                      );
                    } else if (cat == 'Learning') {
                      return const LearningView();
                    } else if (cat == 'Mosques') {
                      return const MosquesView();
                    } else if (cat == 'Ask Brother' || cat == 'Ask Sister' || cat == 'Ask Imam') {
                      return const AskImamView();
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMainCategories(Color roleColor) {
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
            children: controller.categories.map((category) {
              final isSelected = currentSelection == category;

              return GestureDetector(
                onTap: () {
                  if (category == 'Jumma') {
                    _showComingSoonDialog();
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
                        ? Border.all(color: roleColor, width: 1)
                        : null,
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: isSelected
                          ? AppColors.titleColor
                          : const Color(0xFF5B7C99),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
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

  Widget _buildSearchBar(Color roleColor) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        onChanged: (value) => controller.search(value),
        decoration: InputDecoration(
          hintText: controller.userRole == 'female'
              ? 'Search Sisters...'
              : 'Search Brothers...',
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.withValues(alpha: 0.5),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: roleColor.withValues(alpha: 0.5),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(Color roleColor) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tab(
              'Near Me',
              controller.selectedSubTab.value == DiscoverSubTab.nearMe,
              roleColor,
              () => controller.changeSubTab(DiscoverSubTab.nearMe),
            ),
            SizedBox(width: 10.w),
            _tab(
              'New Reverts',
              controller.selectedSubTab.value == DiscoverSubTab.newReverts,
              roleColor,
              () => controller.changeSubTab(DiscoverSubTab.newReverts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(
    String label,
    bool isSelected,
    Color roleColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected
                ? roleColor.withValues(alpha: 0.4)
                : const Color(0xFFA6864D).withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? roleColor : const Color(0xFFA6864D),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilesGrid(Color roleColor) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value && controller.members.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: roleColor),
          );
        }

        if (controller.members.isEmpty) {
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
                  controller.userRole == 'female'
                      ? 'No Sisters Found'
                      : 'No Brothers Found',
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
          onRefresh: () => controller.fetchMembers(isRefresh: true),
          color: roleColor,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 20.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: controller.members.length,
            itemBuilder: (context, index) {
              final member = controller.members[index];
              return MemberCard(
                user: member,
                index: index,
                onTap: () => Get.to(() => ProfileDetailsView(user: member)),
                onConnect: () => controller.sendConnectionRequest(member.id),
                onCancel: () => controller.cancelConnectionRequest(
                  member.id,
                  member.connectionId,
                ),
                onConfirm: () => controller.acceptConnection(
                  member.id,
                  member.connectionId,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showComingSoonDialog() {
    Get.dialog(
      Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 50.sp,
                color: AppColors.goldColor,
              ),
              SizedBox(height: 15.h),
              Text(
                "Coming Soon",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "This feature is under development and will be available in the upcoming release.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppColors.bodyColor,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
