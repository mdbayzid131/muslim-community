import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/dua_repository.dart';
import 'package:muslim_community/modules/dua/controller/dua_controller.dart';

class DuaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DuaController>(
      () => DuaController(
        duaRepository: Get.find<DuaRepository>(),
      ),
    );
  }
}
