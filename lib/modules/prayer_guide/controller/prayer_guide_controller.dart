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
  final isAudioBuffering = false.obs;
  String? _loadedUrl;
  RxString get currentlyPlayingUrl => activeAudioUrl;

  String get userRole =>
      Get.isRegistered<AuthService>() ? Get.find<AuthService>().userRole : 'male';
  Color get roleColor => AppColors.getRoleColor(userRole);
  bool get isMale => userRole != 'female';

  @override
  void onInit() {
    super.onInit();
    _audioPlayer.playerStateStream.listen((state) {
      // NEVER show buffer spinner while audio is actively playing
      final isBuffering = !state.playing &&
          (state.processingState == ProcessingState.buffering ||
              state.processingState == ProcessingState.loading);
      isAudioBuffering.value = isBuffering;
      isPlaying.value = state.playing;

      if (state.processingState == ProcessingState.completed) {
        _audioPlayer.pause();
        _audioPlayer.seek(Duration.zero);
        isPlaying.value = false;
        isAudioBuffering.value = false;
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
      // 1. Prevent duplicate requests while buffering
      if (isAudioBuffering.value && activeAudioUrl.value == url) {
        return;
      }

      // 2. If the audio is ALREADY loaded in the player (even if completed or paused):
      if (_loadedUrl == url) {
        activeAudioUrl.value = url;
        if (_audioPlayer.playing) {
          await _audioPlayer.pause();
          isPlaying.value = false;
        } else {
          // If completed or at end, restart from beginning instantly
          if (_audioPlayer.processingState == ProcessingState.completed) {
            await _audioPlayer.seek(Duration.zero);
          }
          await _audioPlayer.play();
          isPlaying.value = true;
        }
        return;
      }

      // 3. New audio selected: stop current and prepare to load
      activeAudioUrl.value = url;
      isAudioBuffering.value = true;
      isPlaying.value = false;

      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      // Resolve URL & fallback
      String targetUrl = url;
      if (url.contains('cdn.syaapp.com')) {
        if (url.contains('fatiha') || url.contains('al-fatihah')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3';
        } else if (url.contains('ikhlas')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/112.mp3';
        } else if (url.contains('falaq')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/113.mp3';
        } else if (url.contains('nas') || url.contains('naas')) {
          targetUrl = 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/114.mp3';
        } else {
          isAudioBuffering.value = false;
          activeAudioUrl.value = "";
          Helpers.showError("Audio file is not yet uploaded to the server");
          return;
        }
      }

      // Use LockCachingAudioSource for permanent local disk caching
      try {
        // ignore: experimental_member_use
        final audioSource = LockCachingAudioSource(
          Uri.parse(targetUrl),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
          },
        );
        await _audioPlayer.setAudioSource(audioSource);
      } catch (_) {
        // Fallback to standard setUrl if cache source fails
        await _audioPlayer.setUrl(
          targetUrl,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
          },
        );
      }

      _loadedUrl = url;

      // Verify user didn't select another audio while loading
      if (activeAudioUrl.value == url) {
        await _audioPlayer.play();
        isAudioBuffering.value = false;
        isPlaying.value = true;
      }
    } catch (e) {
      Helpers.error("Play audio error: $e");
      Helpers.showError("Unable to play audio from server");
      activeAudioUrl.value = "";
      _loadedUrl = null;
      isPlaying.value = false;
      isAudioBuffering.value = false;
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    activeAudioUrl.value = "";
    isPlaying.value = false;
    isAudioBuffering.value = false;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
