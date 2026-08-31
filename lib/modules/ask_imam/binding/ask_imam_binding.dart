import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/ask_imam_repository.dart';
import 'package:muslim_community/modules/ask_imam/controller/ask_imam_controller.dart';

class AskImamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AskImamController>(
      () => AskImamController(
        askImamRepository: Get.find<AskImamRepository>(),
      ),
    );
  }
}
