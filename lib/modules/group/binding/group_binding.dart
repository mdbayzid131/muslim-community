import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/group_repository.dart';
import 'package:muslim_community/modules/group/controller/group_controller.dart';

class GroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupController>(
      () => GroupController(groupRepository: Get.find<GroupRepository>()),
    );
  }
}
