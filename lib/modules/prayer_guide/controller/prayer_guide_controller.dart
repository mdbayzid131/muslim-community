import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/prayer_guide_model.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';

class PrayerGuideController extends GetxController {
  final LearningRepository learningRepository;

  PrayerGuideController({required this.learningRepository});

  final isLoading = false.obs;
  final errorMessage = "".obs;
  final prayerGuideSteps = <PrayerGuideStepModel>[].obs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final isPlaying = false.obs;
  final activeAudioUrl = "".obs;
  RxString get currentlyPlayingUrl => activeAudioUrl;

  String get userRole =>
      Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
  Color get roleColor => AppColors.getRoleColor(userRole);
  bool get isMale => userRole != 'female';

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.pause();
        _audioPlayer.seek(Duration.zero);
        isPlaying.value = false;
      }
    });
  }

  Future<void> fetchPrayerGuide(String waqt) async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      final response = await learningRepository.getPrayerGuide(waqt);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['success'] == true) {
          final model =
              PrayerGuideResponse.fromJson(Map<String, dynamic>.from(data));
          if (model.data != null && model.data!.isNotEmpty) {
            prayerGuideSteps.value = model.data!;
          } else {
            errorMessage.value = "No data available";
          }
        } else if (data is List) {
          prayerGuideSteps.value =
              data.map((e) => PrayerGuideStep.fromJson(e)).toList();
        } else {
          errorMessage.value =
              data['message']?.toString() ?? "Failed to load prayer guide";
        }
      } else {
        errorMessage.value = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      Helpers.error("Fetch prayer guide error: $e");
      errorMessage.value = "An error occurred while loading prayer guide";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playAudio(String url) async {
    if (url.isEmpty) {
      Helpers.showError("Audio not available for this step");
      return;
    }

    try {
      if (activeAudioUrl.value == url) {
        if (_audioPlayer.playing) {
          await _audioPlayer.pause();
          isPlaying.value = false;
        } else {
          await _audioPlayer.play();
          isPlaying.value = true;
        }
        return;
      }

      // Check if URL is from dummy/unregistered domain
      String targetUrl = url;
      if (url.contains('cdn.syaapp.com')) {
        // Handle known fallbacks if available
        if (url.contains('fatiha') || url.contains('al-fatihah')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3';
        } else if (url.contains('ikhlas')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/112.mp3';
        } else if (url.contains('falaq')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/113.mp3';
        } else if (url.contains('nas') || url.contains('naas')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/114.mp3';
        } else {
          Helpers.showError("Audio file is not yet uploaded to the server");
          return;
        }
      }

      activeAudioUrl.value = url;
      isPlaying.value = true;

      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      await _audioPlayer.setUrl(
        targetUrl,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
        },
      );
      await _audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      Helpers.error("Play audio error: $e");
      Helpers.showError("Unable to play audio from server");
      activeAudioUrl.value = "";
      isPlaying.value = false;
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    activeAudioUrl.value = "";
    isPlaying.value = false;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
