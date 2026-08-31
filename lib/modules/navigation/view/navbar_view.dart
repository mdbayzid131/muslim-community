import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/modules/ask_imam/view/ask_imam_view.dart';
import 'package:muslim_community/modules/discover/view/discover_view.dart';
import 'package:muslim_community/modules/group/view/group_view.dart';
import 'package:muslim_community/modules/home/view/home_view.dart';
import 'package:muslim_community/modules/home/view/jumma_home_view.dart';
import 'package:muslim_community/modules/messages/view/messages_view.dart';
import 'package:muslim_community/modules/navigation/controller/navigation_controller.dart';
import 'package:muslim_community/modules/profile/view/profile_view.dart';

class NavbarView extends GetView<NavigationController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Get.find<AuthService>().userRole;
    final isJumma = role == 'jumma';
    final roleColor = AppColors.getRoleColor(role);

    // Screen order matching original app:
    // 0: Home, 1: Discover, 2: Message, 3: Group, 4: Profile
    final List<Widget> screens = isJumma
        ? const [
            JummaHomeView(),
            AskImamView(),
            ProfileView(),
          ]
        : const [
            HomeView(),
            DiscoverView(),
            MessagesView(),
            GroupView(),
            ProfileView(),
          ];

    return Scaffold(
      body: Obx(() {
        final curIdx =
            controller.currentIndex.value.clamp(0, screens.length - 1);
        return screens[curIdx];
      }),
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
          () {
            final curIdx =
                controller.currentIndex.value.clamp(0, screens.length - 1);

            return BottomNavigationBar(
              currentIndex: curIdx,
              onTap: controller.changeIndex,
              selectedItemColor: roleColor,
              unselectedItemColor:
                  const Color(0xFFA6864D).withValues(alpha: 0.7),
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
              items: isJumma
                  ? [
                      _buildNavbarItem(
                        'assets/icons/homenav.png',
                        'Home',
                        0,
                        roleColor,
                      ),
                      _buildNavbarItem(
                        'assets/icons/Messagesnav.png',
                        'Ask Imam',
                        1,
                        roleColor,
                      ),
                      _buildNavbarItem(
                        'assets/icons/profilenav.png',
                        'Profile',
                        2,
                        roleColor,
                      ),
                    ]
                  : [
                      _buildNavbarItem(
                        'assets/icons/homenav.png',
                        'Home',
                        0,
                        roleColor,
                      ),
                      _buildNavbarItem(
                        'assets/icons/Discovernav.png',
                        'Discover',
                        1,
                        roleColor,
                      ),
                      _buildNavbarItem(
                        'assets/icons/Messagesnav.png',
                        'Message',
                        2,
                        roleColor,
                      ),
                      _buildNavbarItem(
                        'assets/icons/groupnav.png',
                        'Group',
                        3,
                        roleColor,
                      ),
                      _buildNavbarItem(
                        'assets/icons/profilenav.png',
                        'Profile',
                        4,
                        roleColor,
                      ),
                    ],
            );
          },
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
