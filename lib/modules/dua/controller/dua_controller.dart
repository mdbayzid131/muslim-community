import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/dua_model.dart';
import 'package:muslim_community/data/repositories/dua_repository.dart';
import 'package:muslim_community/modules/home/controller/prayer_time_controller.dart';

class DuaController extends GetxController {
  final DuaRepository duaRepository;

  DuaController({required this.duaRepository});

  final isLoading = true.obs;
  final isDetailLoading = false.obs;

  final duas = <DuaModel>[].obs;
  final dailyDua = Rxn<DuaModel>();
  final selectedDua = Rxn<DuaModel>();

  final selectedWaqt = "All".obs;
  final searchQuery = "".obs;

  final waqtFilters = <String>[
    "All",
    "Fajr",
    "Zuhr",
    "Asr",
    "Maghrib",
    "Isha",
  ].obs;

  // Audio Player State
  final AudioPlayer audioPlayer = AudioPlayer();
  final isPlaying = false.obs;
  final currentlyPlayingDuaId = RxnString();
  final audioPosition = Duration.zero.obs;
  final audioDuration = Duration.zero.obs;

  String get userRole => Get.isRegistered<AuthService>()
      ? Get.find<AuthService>().userRole
      : 'male';
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    _initAudioPlayer();
    fetchDuas();
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void _initAudioPlayer() {
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        stopAudio();
      }
    });

    audioPlayer.positionStream.listen((pos) {
      audioPosition.value = pos;
    });

    audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        audioDuration.value = dur;
      }
    });
  }

  void setWaqt(String waqt) {
    if (selectedWaqt.value != waqt) {
      selectedWaqt.value = waqt;
      fetchDuas();
    }
  }

  void search(String query) {
    searchQuery.value = query;
    fetchDuas();
  }

  Future<void> fetchDuas({bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      final response = await duaRepository.getDuas(
        waqt: selectedWaqt.value,
        search: searchQuery.value,
        page: 1,
        limit: 50,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic resData = response.data;
        dynamic listData = resData;

        if (resData is Map) {
          if (resData['data'] is List) {
            listData = resData['data'];
          } else if (resData['data'] is Map &&
              resData['data']['data'] is List) {
            listData = resData['data']['data'];
          } else if (resData['data'] is Map &&
              resData['data']['result'] is List) {
            listData = resData['data']['result'];
          } else if (resData['result'] is List) {
            listData = resData['result'];
          }
        }

        if (listData is List) {
          final fetched = listData
              .map((e) => DuaModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          duas.value = fetched;
          _determineDailyDua(fetched);
        }
      }
    } catch (e) {
      Helpers.error("Fetch Duas error: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  void _determineDailyDua(List<DuaModel> allDuas) {
    if (allDuas.isEmpty) return;

    // Check if PrayerTimeController has current/next prayer name
    String currentWaqt = "";
    if (Get.isRegistered<PrayerTimeController>()) {
      currentWaqt = Get.find<PrayerTimeController>().nextPrayerName.value;
    }

    if (currentWaqt.isNotEmpty) {
      final normalizedWaqt = currentWaqt.toLowerCase() == 'dhuhr'
          ? 'zuhr'
          : currentWaqt.toLowerCase();
      final match = allDuas.firstWhereOrNull((d) {
        final dWaqt = d.waqt.toLowerCase() == 'dhuhr'
            ? 'zuhr'
            : d.waqt.toLowerCase();
        return dWaqt == normalizedWaqt;
      });
      if (match != null) {
        dailyDua.value = match;
        return;
      }
    }

    // Fallback: Pick first or matching daily
    final dailyMatch = allDuas.firstWhereOrNull(
      (d) =>
          d.waqt.toLowerCase().contains('daily') ||
          d.category.toLowerCase().contains('daily'),
    );

    dailyDua.value = dailyMatch ?? allDuas.first;
  }

  Future<void> fetchDuaDetails(String id) async {
    isDetailLoading.value = true;
    try {
      final response = await duaRepository.getDuaDetails(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        if (data is Map) {
          selectedDua.value = DuaModel.fromJson(
            Map<String, dynamic>.from(data),
          );
        }
      }
    } catch (e) {
      Helpers.error("Fetch Dua details error: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> toggleAudio(DuaModel dua) async {
    final audioUrl = dua.audioUrl;
    if (audioUrl.isEmpty) {
      Helpers.showInfo("Audio recitation is not available for this Dua.");
      return;
    }

    try {
      if (currentlyPlayingDuaId.value == dua.id && isPlaying.value) {
        await audioPlayer.pause();
        return;
      } else if (currentlyPlayingDuaId.value == dua.id && !isPlaying.value) {
        await audioPlayer.play();
        return;
      }

      await audioPlayer.stop();
      currentlyPlayingDuaId.value = dua.id;

      await audioPlayer.setUrl(
        audioUrl,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      await audioPlayer.play();
    } catch (e) {
      debugPrint("Audio play error: $e");
      stopAudio();
      Helpers.showError("Failed to play Dua audio");
    }
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    currentlyPlayingDuaId.value = null;
    isPlaying.value = false;
    audioPosition.value = Duration.zero;
  }

  void copyDuaText(DuaModel dua) {
    final buffer = StringBuffer();
    if (dua.title.isNotEmpty) buffer.writeln("🤲 ${dua.title}");
    if (dua.arabic.isNotEmpty) buffer.writeln("\n${dua.arabic}");
    if (dua.transliteration.isNotEmpty)
      buffer.writeln("\nPronunciation: ${dua.transliteration}");
    if (dua.translation.isNotEmpty)
      buffer.writeln("\nMeaning: ${dua.translation}");
    if (dua.reference.isNotEmpty)
      buffer.writeln("\nReference: ${dua.reference}");

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    Helpers.showSuccess("Dua copied to clipboard!");
  }
}
