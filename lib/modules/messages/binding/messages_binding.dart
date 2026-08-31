import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/chat_repository.dart';
import 'package:muslim_community/modules/messages/controller/chat_controller.dart';
import 'package:muslim_community/modules/messages/controller/messages_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagesController>(
      () => MessagesController(chatRepository: Get.find<ChatRepository>()),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(chatRepository: Get.find<ChatRepository>()),
    );
  }
}
