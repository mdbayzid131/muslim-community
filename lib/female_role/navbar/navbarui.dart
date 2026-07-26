import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/appcolore.dart';
import 'package:muslim_community/female_role/discover/ui/femalediscoverui.dart';
import 'package:muslim_community/female_role/group/ui/femalegroupui.dart';
import 'package:muslim_community/female_role/home/ui/femalehomeui.dart';
import 'package:muslim_community/female_role/messages/ui/femalemessagesui.dart';
import 'package:muslim_community/female_role/navbar/navbarcontroller.dart';
import 'package:muslim_community/female_role/profile/ui/femaleprofileui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FemaleNavbarUI extends StatelessWidget {
  const FemaleNavbarUI({super.key});

  @override
  Widget build(BuildContext context) {
    final FemaleNavbarController controller = Get.put(FemaleNavbarController());

    final List<Widget> screens = [
      const FemaleHomeUI(),
      const FemaleDiscoverUI(),
      const FemaleMessagesUI(),
      const FemaleGroupUI(),
      const FemaleProfileUI(),
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
            selectedItemColor: AppColors.femaleColor,
            unselectedItemColor: const Color(0xFFA6864D).withValues(alpha: 0.7),
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
                AppColors.femaleColor,
              ),
              _buildNavbarItem(
                'assets/icons/Discovernav.png',
                'Discover',
                1,
                AppColors.femaleColor,
              ),
              _buildNavbarItem(
                'assets/icons/Messagesnav.png',
                'Message',
                2,
                AppColors.femaleColor,
              ),
              _buildNavbarItem(
                'assets/icons/groupnav.png',
                'Group',
                3,
                AppColors.femaleColor,
              ),
              _buildNavbarItem(
                'assets/icons/profilenav.png',
                'Profile',
                4,
                AppColors.femaleColor,
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
