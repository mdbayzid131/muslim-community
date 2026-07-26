import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/notifications/model/notification_model.dart';
import 'package:muslim_community/male_role/notifications/service/male_connection_service.dart';
import 'package:muslim_community/appcolore.dart';

class MaleNotificationController extends GetxController {
  final MaleConnectionService _service = MaleConnectionService();
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await _service.getMyNotifications();
      print("Notifications API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];

        notifications.value = data.map((item) {
          // Map API fields to NotificationModel
          return NotificationModel(
            id: (item['_id'] ?? item['id'] ?? '').toString(),
            title: item['title'] ?? 'Notification',
            body: item['message'] ?? item['body'] ?? '',
            timeAgo: _formatTimeAgo(item['createdAt']),
            icon: _getIconForType(item['type']),
            iconColor: AppColors.maleColor,
            iconBackgroundColor: AppColors.maleColor.withValues(alpha: 0.1),
            isUnread: item['isRead'] == false,
          );
        }).toList();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _service.markNotificationAsRead(notificationId);
      if (response.statusCode == 200) {
        // Local update for immediate feedback
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          // Re-create the object with isUnread = false
          final old = notifications[index];
          notifications[index] = NotificationModel(
            id: old.id,
            title: old.title,
            body: old.body,
            timeAgo: old.timeAgo,
            icon: old.icon,
            iconColor: old.iconColor,
            iconBackgroundColor: old.iconBackgroundColor,
            isUnread: false,
          );
          notifications.refresh();
        }
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  String _formatTimeAgo(String? dateStr) {
    if (dateStr == null) return 'Recently';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return 'Recently';
    }
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'prayer':
        return Icons.access_time_filled;
      case 'connection':
        return Icons.person_add_alt_1_rounded;
      case 'event':
        return Icons.calendar_today_rounded;
      case 'message':
        return Icons.chat_bubble_outline_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await _service.markAllNotificationsAsRead();
      if (response.statusCode == 200) {
        // Local update for all notifications
        notifications.value = notifications.map((n) {
          return NotificationModel(
            id: n.id,
            title: n.title,
            body: n.body,
            timeAgo: n.timeAgo,
            icon: n.icon,
            iconColor: n.iconColor,
            iconBackgroundColor: n.iconBackgroundColor,
            isUnread: false,
          );
        }).toList();
        notifications.refresh();
      }
    } catch (e) {
      print("Error marking all notifications as read: $e");
    }
  }
}
