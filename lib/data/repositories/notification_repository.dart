import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class NotificationRepository {
  final ApiClient apiClient;

  NotificationRepository({required this.apiClient});

  Future<Response> getNotifications() async {
    return await apiClient.getData(ApiConstants.notifications);
  }

  Future<Response> getMyNotifications() async {
    return await getNotifications();
  }

  Future<Response> markAsRead(String notificationId) async {
    return await apiClient.patchData(
      ApiConstants.markNotificationRead(notificationId),
      {},
    );
  }

  Future<Response> markNotificationAsRead(String notificationId) async {
    return await markAsRead(notificationId);
  }

  Future<Response> markAllNotificationsAsRead() async {
    return await apiClient.patchData(
      ApiConstants.markAllNotificationsRead,
      {},
    );
  }
}
