import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserRepository userRepository;

  ProfileController({required this.userRepository});

  final user = Rxn<UserModel>();
  final isLoading = false.obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await userRepository.getProfile();
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        user.value = UserModel.fromJson(data);
      }
    } catch (e) {
      Helpers.error("Fetch profile error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await Get.find<AuthService>().logout();
  }
}
