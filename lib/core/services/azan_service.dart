import 'dart:async';
import 'package:get/get.dart';
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
  final currentlyPlayingPrayer = "".obs;
  final isPreviewPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        isPreviewPlaying.value = false;
        currentlyPlayingPrayer.value = "";
      }
    });
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

      final rawTime = prayerTimings[prayerName];
      if (rawTime != null && rawTime.trim().isNotEmpty) {
        final cleanTime = rawTime.trim().split(' ').first;
        final timeParts = cleanTime.split(':');

        bool isMatch = false;
        if (timeParts.length >= 2) {
          final pHour = int.tryParse(timeParts[0]);
          final pMin = int.tryParse(timeParts[1]);

          if (pHour != null && pMin != null) {
            if (now.hour == pHour && now.minute == pMin) {
              isMatch = true;
            }
          }
        }

        if (isMatch) {
          final setting = await StorageService.getString(settingsKey);
          bool isEnabled;
          if (setting.isEmpty) {
            isEnabled = (prayerName == 'Asr' ||
                prayerName == 'Maghrib' ||
                prayerName == 'Isha');
          } else {
            isEnabled = setting == "Adhan";
          }

          if (isEnabled) {
            _playAzan(prayerName == 'Fajr');
            await Future.delayed(const Duration(minutes: 1));
            break;
          }
        }
      }
    }
  }

  Future<void> _playAzan(bool isFajr) async {
    try {
      final assetPath = isFajr ? ImagePaths.fajrAzan : ImagePaths.azan1;
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      Helpers.error('Error playing Azan: $e');
    }
  }

  Future<void> toggleAzanPreview(String prayerName, {bool isFajr = false}) async {
    try {
      if (isPreviewPlaying.value && currentlyPlayingPrayer.value == prayerName) {
        await stopAzan();
        return;
      }

      await _player.stop();
      currentlyPlayingPrayer.value = prayerName;
      isPreviewPlaying.value = true;

      final assetPath = isFajr ? ImagePaths.fajrAzan : ImagePaths.azan1;
      await _player.setAsset(assetPath);
      await _player.play();
    } catch (e) {
      isPreviewPlaying.value = false;
      currentlyPlayingPrayer.value = "";
      Helpers.error('Error playing Azan preview: $e');
    }
  }

  Future<void> playAzanPreview({bool isFajr = false}) async {
    await toggleAzanPreview("Preview", isFajr: isFajr);
  }

  Future<void> stopAzan() async {
    try {
      await _player.stop();
    } catch (_) {}
    isPreviewPlaying.value = false;
    currentlyPlayingPrayer.value = "";
  }
}
