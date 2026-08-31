import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/core/services/auth_service.dart';

class SplashController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController introController;
  late AnimationController rotationController;
  late AnimationController pulseController;
  late AnimationController progressController;

  late Animation<double> logoScale;
  late Animation<double> logoFade;
  late Animation<double> bgPatternFade;
  late Animation<double> titleFade;
  late Animation<double> titleSlide;
  late Animation<double> dividerWidthPercent;
  late Animation<double> quoteFade;
  late Animation<double> quoteSlide;
  late Animation<double> loadingFade;

  late Animation<double> logoGlow;
  late Animation<double> rotationAngle;

  @override
  void onInit() {
    super.onInit();

    introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );

    logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    bgPatternFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.15, 0.55, curve: Curves.easeIn),
      ),
    );

    titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    titleSlide = Tween<double>(begin: 25.0, end: 0.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    dividerWidthPercent = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
      ),
    );

    quoteFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    quoteSlide = Tween<double>(begin: 15.0, end: 0.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: introController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    logoGlow = Tween<double>(begin: 0.3, end: 0.85).animate(
      CurvedAnimation(
        parent: pulseController,
        curve: Curves.easeInOut,
      ),
    );

    rotationAngle = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      rotationController,
    );

    introController.forward();

    progressController.forward().then((_) {
      navigateToNext();
    });
  }

  void navigateToNext() async {
    final authService = Get.find<AuthService>();
    await authService.checkAuthStatus();

    await Future.delayed(const Duration(milliseconds: 300));

    if (authService.isLoggedIn) {
      final role = authService.userRole;
      if (role == 'male') {
        Get.offAllNamed(AppRoutes.maleNavbar);
      } else if (role == 'female') {
        Get.offAllNamed(AppRoutes.femaleNavbar);
      } else if (role == 'jumma') {
        Get.offAllNamed(AppRoutes.jummaNavbar);
      } else {
        Get.offAllNamed(AppRoutes.selectRole);
      }
    } else {
      Get.offAllNamed(AppRoutes.selectRole);
    }
  }

  @override
  void onClose() {
    introController.dispose();
    rotationController.dispose();
    pulseController.dispose();
    progressController.dispose();
    super.onClose();
  }
}
