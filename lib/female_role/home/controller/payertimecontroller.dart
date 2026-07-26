import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/female_role/home/service/payertimeservice.dart';

class FemalePrayerTimeController extends GetxController {
  final FemalePrayerTimeService _service = FemalePrayerTimeService();

  var isLoading = false.obs;
  var prayerTimings = <String, String>{}.obs;
  var todayDate = "".obs;
  var hijriDate = "".obs;
  var nextPrayerName = "".obs;
  var nextPrayerTime = "".obs;

  Future<void> fetchPrayerTimes(double lat, double lng) async {
    isLoading.value = true;
    try {
      final response = await _service.getPrayerTimes(lat, lng);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final resData = data['data'];
          final timings = resData['timings'];

          if (timings != null) {
            // API returns lowercase keys (fajr, sunrise, etc.)
            prayerTimings.value = {
              'Fajr': timings['fajr'] ?? timings['Fajr'] ?? '',
              'Sunrise': timings['sunrise'] ?? timings['Sunrise'] ?? '',
              'Dhuhr': timings['dhuhr'] ?? timings['Dhuhr'] ?? '',
              'Asr': timings['asr'] ?? timings['Asr'] ?? '',
              'Maghrib': timings['maghrib'] ?? timings['Maghrib'] ?? '',
              'Isha': timings['isha'] ?? timings['Isha'] ?? '',
            };

            _calculateNextPrayer();
          }

          todayDate.value = resData['weekday'] ?? "";
          hijriDate.value = resData['hijriDate'] ?? "";
        }
      }
    } catch (e) {
      debugPrint("Error fetching female prayer times: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateNextPrayer() {
    if (prayerTimings.isEmpty) return;

    final now = DateTime.now();

    String? nextName;
    String? nextTime;
    DateTime? minDiffTime;

    prayerTimings.forEach((name, time) {
      if (name == 'Sunrise') return;

      try {
        final prayerTimeParts = time.split(':');
        final prayerDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(prayerTimeParts[0]),
          int.parse(prayerTimeParts[1]),
        );

        if (prayerDateTime.isAfter(now)) {
          if (minDiffTime == null || prayerDateTime.isBefore(minDiffTime!)) {
            minDiffTime = prayerDateTime;
            nextName = name;
            nextTime = time;
          }
        }
      } catch (e) {
        debugPrint("Error parsing time for $name: $e");
      }
    });

    if (nextName == null) {
      nextName = "Fajr";
      nextTime = prayerTimings['Fajr'];
    }

    nextPrayerName.value = nextName!;
    nextPrayerTime.value = nextTime!;
  }
}
