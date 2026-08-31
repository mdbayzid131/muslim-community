import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';
import 'package:muslim_community/data/repositories/notification_repository.dart';
import 'package:muslim_community/modules/notifications/controller/notifications_controller.dart';
import 'package:muslim_community/modules/notifications/controller/pending_request_controller.dart';
import 'package:muslim_community/modules/notifications/controller/sent_request_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(
        notificationRepository: Get.find<NotificationRepository>(),
      ),
    );
    Get.lazyPut<PendingRequestController>(
      () => PendingRequestController(
        connectionRepository: Get.find<ConnectionRepository>(),
      ),
    );
    Get.lazyPut<SentRequestController>(
      () => SentRequestController(
        connectionRepository: Get.find<ConnectionRepository>(),
      ),
    );
  }
}
