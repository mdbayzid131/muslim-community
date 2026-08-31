import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/notification_model.dart';
import 'package:muslim_community/data/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  final NotificationRepository notificationRepository;

  NotificationsController({required this.notificationRepository});

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  String get userRole =>
      Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await notificationRepository.getNotifications();
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        notifications.value =
            list.map((e) => NotificationModel.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Fetch notifications error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await notificationRepository.markAsRead(id);
      final idx = notifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        notifications[idx] = notifications[idx].copyWith(isRead: true);
      }
    } catch (e) {
      Helpers.error("Mark as read error: $e");
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await notificationRepository.markAllNotificationsAsRead();
      notifications.value =
          notifications.map((n) => n.copyWith(isRead: true)).toList();
    } catch (e) {
      Helpers.error("Mark all as read error: $e");
    }
  }
}
