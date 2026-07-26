import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/male_role/discover/ui/malediscoverui.dart';
import 'package:muslim_community/male_role/group/ui/malegroupui.dart';
import 'package:muslim_community/male_role/home/ui/malehomeui.dart';
import 'package:muslim_community/male_role/messages/ui/malemessagesui.dart';
import 'package:muslim_community/male_role/navbar/navbarcontroller.dart';
import 'package:muslim_community/male_role/profile/ui/maleprofileui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaleNavbarUI extends StatelessWidget {
  const MaleNavbarUI({super.key});

  @override
  Widget build(BuildContext context) {
    final MaleNavbarController controller = Get.put(MaleNavbarController());

    final List<Widget> screens = [
      const MaleHomeUI(),
      const MaleDiscoverUI(),
      const MaleMessagesUI(),
      const MaleGroupUI(),
      const MaleProfileUI(),
    ];

    return Scaffold(
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
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
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            selectedItemColor: AppColors.maleColor,
            unselectedItemColor: const Color(0xFFA6864D).withOpacity(
              0.7,
            ), // Using a brownish color for unselected labels as in image
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: TextStyle(fontSize: 12.sp),
            items: [
              _buildNavbarItem(
                'assets/icons/homenav.png',
                'Home',
                0,
                AppColors.maleColor,
              ),
              _buildNavbarItem(
                'assets/icons/Discovernav.png',
                'Discover',
                1,
                AppColors.maleColor,
              ),
              _buildNavbarItem(
                'assets/icons/Messagesnav.png',
                'Message',
                2,
                AppColors.maleColor,
              ),
              _buildNavbarItem(
                'assets/icons/groupnav.png',
                'Group',
                3,
                AppColors.maleColor,
              ),
              _buildNavbarItem(
                'assets/icons/profilenav.png',
                'Profile',
                4,
                AppColors.maleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavbarItem(
    String assetPath,
    String label,
    int index,
    Color activeColor,
  ) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Image.asset(
          assetPath,
          width: 24.w,
          height: 24.w,
          color: const Color(0xFFA6864D).withValues(alpha: 0.7),
        ),
      ),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: activeColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 4.h),
          Image.asset(assetPath, width: 24.w, height: 24.w, color: activeColor),
        ],
      ),
      label: label,
    );
  }
}
