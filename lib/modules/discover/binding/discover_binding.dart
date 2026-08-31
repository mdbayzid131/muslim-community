import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';
import 'package:muslim_community/modules/discover/controller/discover_controller.dart';

class DiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiscoverController>(
      () => DiscoverController(
        userRepository: Get.find<UserRepository>(),
        connectionRepository: Get.find<ConnectionRepository>(),
      ),
    );
  }
}
