import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/auth_repository.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';
import 'package:muslim_community/modules/profile/controller/change_password_controller.dart';
import 'package:muslim_community/modules/profile/controller/personal_info_controller.dart';
import 'package:muslim_community/modules/profile/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(userRepository: Get.find<UserRepository>()),
    );
    Get.lazyPut<PersonalInfoController>(
      () => PersonalInfoController(userRepository: Get.find<UserRepository>()),
    );
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(authRepository: Get.find<AuthRepository>()),
    );
  }
}
