import 'package:get/get.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/widgets/coming_soon_dialog.dart';

class SelectRoleController extends GetxController {
  final selectedRole = "".obs;

  void selectRole(String role) async {
    selectedRole.value = role;

    if (role == 'male' || role == 'BROTHER') {
      await StorageService.setString(StorageConstants.userRole, role);
      Get.toNamed(AppRoutes.maleLogin, arguments: {'role': 'male'});
    } else if (role == 'female' || role == 'SISTER') {
      await StorageService.setString(StorageConstants.userRole, role);
      Get.toNamed(AppRoutes.femaleLogin, arguments: {'role': 'female'});
    } else if (role == 'jumma' || role == 'JUMMA') {
      showComingSoonDialog(primaryColor: AppColors.jummaColor);
    } else {
      await StorageService.setString(StorageConstants.userRole, role);
      Get.toNamed(AppRoutes.login, arguments: {'role': role});
    }
  }
}
