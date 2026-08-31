import 'package:get/get.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/core/services/storage_service.dart';

class PrayerSettingsController extends GetxController {
  final isAutoDetectLocation = true.obs;

  final fajrNotification = "Off".obs;
  final sunriseNotification = "Silent".obs;
  final dhuhrNotification = "Off".obs;
  final asrNotification = "Adhan".obs;
  final maghribNotification = "Adhan".obs;
  final ishaNotification = "Adhan".obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final f = await StorageService.getString(StorageConstants.fajrAzan);
    if (f.isNotEmpty) fajrNotification.value = f;

    final d = await StorageService.getString(StorageConstants.dhuhrAzan);
    if (d.isNotEmpty) dhuhrNotification.value = d;

    final a = await StorageService.getString(StorageConstants.asrAzan);
    if (a.isNotEmpty) asrNotification.value = a;

    final m = await StorageService.getString(StorageConstants.maghribAzan);
    if (m.isNotEmpty) maghribNotification.value = m;

    final i = await StorageService.getString(StorageConstants.ishaAzan);
    if (i.isNotEmpty) ishaNotification.value = i;
  }

  void toggleAutoDetectLocation() {
    isAutoDetectLocation.value = !isAutoDetectLocation.value;
  }

  void toggleNotification(RxString notification, String key) {
    if (notification.value == "Off" || notification.value == "Silent") {
      notification.value = "Adhan";
    } else {
      notification.value = "Off";
    }
    StorageService.setString(key, notification.value);
  }
}
