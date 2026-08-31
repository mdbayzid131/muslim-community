import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/prayer_repository.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';
import 'package:muslim_community/modules/home/controller/home_controller.dart';
import 'package:muslim_community/modules/home/controller/prayer_settings_controller.dart';
import 'package:muslim_community/modules/home/controller/prayer_time_controller.dart';
import 'package:muslim_community/modules/home/controller/qibla_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QiblaController>(() => QiblaController());
    Get.lazyPut<PrayerTimeController>(
      () => PrayerTimeController(
        prayerRepository: Get.isRegistered<PrayerRepository>()
            ? Get.find<PrayerRepository>()
            : null,
      ),
    );
    Get.lazyPut<PrayerSettingsController>(() => PrayerSettingsController());
    Get.lazyPut<HomeController>(
      () => HomeController(
        userRepository: Get.isRegistered<UserRepository>()
            ? Get.find<UserRepository>()
            : null,
      ),
    );
  }
}
