import 'package:get/get.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';
import 'package:muslim_community/modules/prayer_guide/controller/prayer_guide_controller.dart';

class PrayerGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrayerGuideController>(
      () => PrayerGuideController(
        learningRepository: Get.find<LearningRepository>(),
      ),
    );
  }
}
