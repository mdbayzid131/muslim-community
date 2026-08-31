import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';

class PendingRequestController extends GetxController {
  final ConnectionRepository connectionRepository;

  PendingRequestController({required this.connectionRepository});

  final pendingRequests = <UserModel>[].obs;
  final isLoading = false.obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  Future<void> fetchPendingRequests() async {
    isLoading.value = true;
    try {
      final response = await connectionRepository.getPendingRequests();
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        pendingRequests.value =
            list.map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Fetch pending requests error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(String userId) async {
    try {
      final response =
          await connectionRepository.acceptConnectionRequest(senderId: userId);
      if (response.statusCode == 200) {
        Helpers.showSuccess("Connection accepted");
        pendingRequests.removeWhere((u) => u.id == userId);
      }
    } catch (e) {
      Helpers.error("Accept request error: $e");
    }
  }

  Future<void> declineRequest(String userId) async {
    try {
      final response =
          await connectionRepository.rejectConnectionRequest(senderId: userId);
      if (response.statusCode == 200) {
        Helpers.showSuccess("Request declined");
        pendingRequests.removeWhere((u) => u.id == userId);
      }
    } catch (e) {
      Helpers.error("Decline request error: $e");
    }
  }
}
