import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/auth_repository.dart';
import 'package:muslim_community/modules/auth/controller/auth_controller.dart';
import 'package:muslim_community/modules/auth/controller/forgot_password_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find<AuthRepository>()),
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
