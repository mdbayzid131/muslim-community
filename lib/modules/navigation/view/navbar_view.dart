import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
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
    final roleLabel = role == 'female'
        ? 'Sister'
        : (role == 'jumma' ? 'Imam' : 'Brother');

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
                        assetPath: ImagePaths.homeNav,
                        label: 'Home',
                        index: 0,
                        activeColor: roleColor,
                      ),
                      _buildNavbarItem(
                        assetPath: ImagePaths.messagesNav,
                        label: 'Ask $roleLabel',
                        index: 1,
                        activeColor: roleColor,
                      ),
                      _buildNavbarItem(
                        assetPath: ImagePaths.profileNav,
                        label: 'Profile',
                        index: 2,
                        activeColor: roleColor,
                      ),
                    ]
                  : [
                      _buildNavbarItem(
                        assetPath: ImagePaths.homeNav,
                        label: 'Home',
                        index: 0,
                        activeColor: roleColor,
                      ),
                      _buildNavbarItem(
                        assetPath: ImagePaths.discoverNav,
                        label: 'Discover',
                        index: 1,
                        activeColor: roleColor,
                      ),
                      _buildNavbarItem(
                        assetPath: ImagePaths.messagesNav,
                        label: 'Message',
                        index: 2,
                        activeColor: roleColor,
                      ),
                      _buildNavbarItem(
                        assetPath: ImagePaths.groupNav,
                        label: 'Group',
                        index: 3,
                        activeColor: roleColor,
                      ),
                      _buildNavbarItem(
                        assetPath: ImagePaths.profileNav,
                        label: 'Profile',
                        index: 4,
                        activeColor: roleColor,
                      ),
                    ],
            );
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavbarItem({
    required String assetPath,
    required String label,
    required int index,
    required Color activeColor,
  }) {
    final unselectedColor = const Color(0xFFA6864D).withValues(alpha: 0.7);
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: SvgPicture.asset(
          assetPath,
          width: 24.sp,
          height: 24.sp,
          colorFilter: ColorFilter.mode(
            unselectedColor,
            BlendMode.srcIn,
          ),
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
          SizedBox(height: 3.h),
          SvgPicture.asset(
            assetPath,
            width: 24.sp,
            height: 24.sp,
            colorFilter: ColorFilter.mode(
              activeColor,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
