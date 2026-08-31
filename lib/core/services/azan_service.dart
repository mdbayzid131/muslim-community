import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/config/constants/image_paths.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';

class AzanService extends GetxService {
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;

  // Observable prayer timings map to decouple from specific controllers
  final RxMap<String, String> prayerTimings = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _player.dispose();
    super.onClose();
  }

  void updateTimings(Map<String, String> timings) {
    prayerTimings.assignAll(timings);
  }

  void scheduleAllAzans(Map<String, String> timings) {
    updateTimings(timings);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkAndPlayAzan();
    });
  }

  Future<void> _checkAndPlayAzan() async {
    if (prayerTimings.isEmpty) return;

    final now = DateTime.now();
    final currentTimeStr = DateFormat("HH:mm").format(now);

    final prayerKeys = {
      'Fajr': StorageConstants.fajrAzan,
      'Dhuhr': StorageConstants.dhuhrAzan,
      'Asr': StorageConstants.asrAzan,
      'Maghrib': StorageConstants.maghribAzan,
      'Isha': StorageConstants.ishaAzan,
    };

    for (var entry in prayerKeys.entries) {
      final prayerName = entry.key;
      final settingsKey = entry.value;

      final prayerTime = prayerTimings[prayerName];
      if (prayerTime != null && prayerTime.trim() == currentTimeStr) {
        final setting = await StorageService.getString(settingsKey);
        final isEnabled = setting == "Adhan";

        if (isEnabled) {
          _playAzan(prayerName == 'Fajr');
          await Future.delayed(const Duration(minutes: 1));
          break;
        }
      }
    }
  }

  Future<void> _playAzan(bool isFajr) async {
    try {
      final assetPath = isFajr ? ImagePaths.fajrAzan : ImagePaths.azan1;
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      Helpers.error('Error playing Azan: $e');
    }
  }

  Future<void> stopAzan() async {
    await _player.stop();
  }
}
