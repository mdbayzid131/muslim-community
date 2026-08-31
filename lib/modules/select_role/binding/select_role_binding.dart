import 'package:get/get.dart';
import 'package:muslim_community/modules/select_role/controller/select_role_controller.dart';

class SelectRoleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectRoleController>(() => SelectRoleController());
  }
}
