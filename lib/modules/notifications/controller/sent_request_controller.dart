import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';

class SentRequestController extends GetxController {
  final ConnectionRepository connectionRepository;

  SentRequestController({required this.connectionRepository});

  final sentRequests = <UserModel>[].obs;
  final isLoading = false.obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchSentRequests();
  }

  Future<void> fetchSentRequests() async {
    isLoading.value = true;
    try {
      final response = await connectionRepository.getSentRequests();
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        sentRequests.value = list.map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Fetch sent requests error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelRequest(String userId) async {
    try {
      final response =
          await connectionRepository.cancelConnectionRequest(receiverId: userId);
      if (response.statusCode == 200) {
        Helpers.showSuccess("Request cancelled");
        sentRequests.removeWhere((u) => u.id == userId);
      }
    } catch (e) {
      Helpers.error("Cancel request error: $e");
    }
  }
}
