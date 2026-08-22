import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:muslim_community/female_role/home/service/payertimeservice.dart';

class FemalePrayerTimeController extends GetxController {
  final FemalePrayerTimeService _service = FemalePrayerTimeService();

  var isLoading = false.obs;
  var prayerTimings = <String, String>{}.obs;
  var todayDate = "".obs;
  var hijriDate = "".obs;
  var nextPrayerName = "".obs;
  var nextPrayerTime = "".obs;

  Map<String, String> rawTimings = {};

  Future<void> fetchPrayerTimes(double lat, double lng) async {
    isLoading.value = true;
    bool fetchedFromAladhan = false;

    // 1. Fetch accurate local prayer times directly using coordinates
    try {
      final aladhanUri = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lng&method=3&latitudeAdjustmentMethod=3',
      );
      final aladhanRes = await http.get(aladhanUri).timeout(const Duration(seconds: 5));
      if (aladhanRes.statusCode == 200) {
        final data = jsonDecode(aladhanRes.body);
        if (data['code'] == 200 && data['data'] != null && data['data']['timings'] != null) {
          final timings = data['data']['timings'];
          rawTimings = {
            'Fajr': timings['Fajr'] ?? '',
            'Sunrise': timings['Sunrise'] ?? '',
            'Dhuhr': timings['Dhuhr'] ?? '',
            'Asr': timings['Asr'] ?? '',
            'Maghrib': timings['Maghrib'] ?? '',
            'Isha': timings['Isha'] ?? '',
          };

          prayerTimings.value = {
            'Fajr': _formatTo12Hour(rawTimings['Fajr']!),
            'Sunrise': _formatTo12Hour(rawTimings['Sunrise']!),
            'Dhuhr': _formatTo12Hour(rawTimings['Dhuhr']!),
            'Asr': _formatTo12Hour(rawTimings['Asr']!),
            'Maghrib': _formatTo12Hour(rawTimings['Maghrib']!),
            'Isha': _formatTo12Hour(rawTimings['Isha']!),
          };

          _calculateNextPrayer();
          fetchedFromAladhan = true;
        }
      }
    } catch (e) {
      debugPrint("Direct Aladhan fetch failed, falling back to backend: $e");
    }

    // 2. Fallback to custom backend endpoint if direct fetch failed
    if (!fetchedFromAladhan) {
      try {
        final response = await _service.getPrayerTimes(lat, lng);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true && data['data'] != null) {
            final resData = data['data'];
            final timings = resData['timings'];

            if (timings != null) {
              rawTimings = {
                'Fajr': timings['fajr'] ?? timings['Fajr'] ?? '',
                'Sunrise': timings['sunrise'] ?? timings['Sunrise'] ?? '',
                'Dhuhr': timings['dhuhr'] ?? timings['Dhuhr'] ?? '',
                'Asr': timings['asr'] ?? timings['Asr'] ?? '',
                'Maghrib': timings['maghrib'] ?? timings['Maghrib'] ?? '',
                'Isha': timings['isha'] ?? timings['Isha'] ?? '',
              };

              prayerTimings.value = {
                'Fajr': _formatTo12Hour(rawTimings['Fajr']!),
                'Sunrise': _formatTo12Hour(rawTimings['Sunrise']!),
                'Dhuhr': _formatTo12Hour(rawTimings['Dhuhr']!),
                'Asr': _formatTo12Hour(rawTimings['Asr']!),
                'Maghrib': _formatTo12Hour(rawTimings['Maghrib']!),
                'Isha': _formatTo12Hour(rawTimings['Isha']!),
              };

              _calculateNextPrayer();
            }

            todayDate.value = resData['weekday'] ?? "";
            hijriDate.value = resData['hijriDate'] ?? "";
          }
        }
      } catch (e) {
        debugPrint("Error fetching female prayer times from backend: $e");
      }
    }

    isLoading.value = false;
  }

  String _formatTo12Hour(String timeStr) {
    if (timeStr.isEmpty) return "--:--";
    if (timeStr.toLowerCase().contains("am") || timeStr.toLowerCase().contains("pm")) {
      return timeStr;
    }
    try {
      final parts = timeStr.split(":");
      if (parts.length < 2) return timeStr;
      int hour = int.parse(parts[0].trim());
      int minute = int.parse(parts[1].split(" ")[0].trim());
      final dt = DateTime(2026, 1, 1, hour, minute);
      return DateFormat("h:mm a").format(dt);
    } catch (e) {
      return timeStr;
    }
  }

  void _calculateNextPrayer() {
    if (rawTimings.isEmpty) return;

    final now = DateTime.now();

    String? nextName;
    String? nextTime;
    DateTime? minDiffTime;

    rawTimings.forEach((name, time) {
      if (name == 'Sunrise' || time.isEmpty) return;

      try {
        final prayerTimeParts = time.split(':');
        final hour = int.parse(prayerTimeParts[0].trim());
        final minute = int.parse(prayerTimeParts[1].split(" ")[0].trim());

        final prayerDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        if (prayerDateTime.isAfter(now)) {
          if (minDiffTime == null || prayerDateTime.isBefore(minDiffTime!)) {
            minDiffTime = prayerDateTime;
            nextName = name;
            nextTime = prayerTimings[name];
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
    nextPrayerTime.value = nextTime ?? "--:--";
  }
}
