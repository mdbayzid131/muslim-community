import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/ask_imam_repository.dart';
import 'package:muslim_community/data/repositories/chat_repository.dart';
import 'package:muslim_community/data/repositories/connection_repository.dart';
import 'package:muslim_community/data/repositories/group_repository.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';
import 'package:muslim_community/data/repositories/prayer_repository.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';
import 'package:muslim_community/modules/ask_imam/controller/ask_imam_controller.dart';
import 'package:muslim_community/modules/discover/controller/discover_controller.dart';
import 'package:muslim_community/modules/group/controller/group_controller.dart';
import 'package:muslim_community/modules/home/controller/home_controller.dart';
import 'package:muslim_community/modules/home/controller/prayer_settings_controller.dart';
import 'package:muslim_community/modules/home/controller/prayer_time_controller.dart';
import 'package:muslim_community/modules/home/controller/qibla_controller.dart';
import 'package:muslim_community/modules/messages/controller/messages_controller.dart';
import 'package:muslim_community/modules/navigation/controller/navigation_controller.dart';
import 'package:muslim_community/modules/prayer_guide/controller/prayer_guide_controller.dart';
import 'package:muslim_community/modules/profile/controller/profile_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<QiblaController>(() => QiblaController());
    Get.lazyPut<PrayerTimeController>(
      () => PrayerTimeController(
        prayerRepository: Get.find<PrayerRepository>(),
      ),
    );
    Get.lazyPut<PrayerSettingsController>(() => PrayerSettingsController());
    Get.lazyPut<HomeController>(
      () => HomeController(
        userRepository: Get.find<UserRepository>(),
      ),
    );
    Get.lazyPut<GroupController>(
      () => GroupController(
        groupRepository: Get.find<GroupRepository>(),
      ),
    );
    Get.lazyPut<DiscoverController>(
      () => DiscoverController(
        userRepository: Get.find<UserRepository>(),
        connectionRepository: Get.find<ConnectionRepository>(),
      ),
    );
    Get.lazyPut<MessagesController>(
      () => MessagesController(
        chatRepository: Get.find<ChatRepository>(),
      ),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        userRepository: Get.find<UserRepository>(),
      ),
    );
    Get.lazyPut<AskImamController>(
      () => AskImamController(
        askImamRepository: Get.find<AskImamRepository>(),
      ),
    );
    Get.lazyPut<PrayerGuideController>(
      () => PrayerGuideController(
        learningRepository: Get.find<LearningRepository>(),
      ),
    );
  }
}
