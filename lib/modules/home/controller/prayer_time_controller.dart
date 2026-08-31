import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:muslim_community/core/services/azan_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/prayer_time_model.dart';
import 'package:muslim_community/data/repositories/prayer_repository.dart';

class PrayerTimeController extends GetxController {
  final PrayerRepository? prayerRepository;

  PrayerTimeController({this.prayerRepository});

  final isLoading = true.obs;
  final prayerTimes = Rxn<PrayerTimeModel>();
  final fajr = "--:--".obs;
  final sunrise = "--:--".obs;
  final dhuhr = "--:--".obs;
  final asr = "--:--".obs;
  final maghrib = "--:--".obs;
  final isha = "--:--".obs;

  final todayDate = "".obs;
  final hijriDate = "".obs;
  final gregorianDate = "".obs;
  final nextPrayerName = "".obs;
  final nextPrayerTime = "".obs;
  final timeRemaining = "".obs;

  Map<String, String> get prayerTimings => {
        'Fajr': fajr.value,
        'Sunrise': sunrise.value,
        'Dhuhr': dhuhr.value,
        'Asr': asr.value,
        'Maghrib': maghrib.value,
        'Isha': isha.value,
      };

  @override
  void onInit() {
    super.onInit();
    todayDate.value = DateFormat('MMM d').format(DateTime.now());
    gregorianDate.value =
        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  }

  Future<void> fetchPrayerTimes(double lat, double lng) async {
    isLoading.value = true;
    try {
      final now = DateTime.now();
      final dateStr = DateFormat("dd-MM-yyyy").format(now);
      final url =
          "https://api.aladhan.com/v1/timings/$dateStr?latitude=$lat&longitude=$lng&method=2";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timings = data['data']['timings'];
        final date = data['data']['date'];

        fajr.value = _formatTime(timings['Fajr']);
        sunrise.value = _formatTime(timings['Sunrise']);
        dhuhr.value = _formatTime(timings['Dhuhr']);
        asr.value = _formatTime(timings['Asr']);
        maghrib.value = _formatTime(timings['Maghrib']);
        isha.value = _formatTime(timings['Isha']);

        final hijri = date['hijri'];
        hijriDate.value =
            "${hijri['day']} ${hijri['month']['en']} ${hijri['year']} AH";

        prayerTimes.value = PrayerTimeModel.fromJson(timings);

        _calculateNextPrayer(timings);

        // Schedule Azan if service is available
        if (Get.isRegistered<AzanService>()) {
          Get.find<AzanService>().scheduleAllAzans({
            'Fajr': (timings['Fajr'] ?? '').toString(),
            'Dhuhr': (timings['Dhuhr'] ?? '').toString(),
            'Asr': (timings['Asr'] ?? '').toString(),
            'Maghrib': (timings['Maghrib'] ?? '').toString(),
            'Isha': (timings['Isha'] ?? '').toString(),
          });
        }
      }
    } catch (e) {
      Helpers.error("Prayer times error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String _formatTime(String rawTime) {
    try {
      final parts = rawTime.split(" ")[0].split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, hour, minute);
      return DateFormat("h:mm a").format(dt);
    } catch (e) {
      return rawTime;
    }
  }

  void _calculateNextPrayer(Map<String, dynamic> timings) {
    try {
      final now = DateTime.now();
      final prayers = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

      for (var name in prayers) {
        final raw = timings[name].toString().split(" ")[0];
        final parts = raw.split(":");
        final prayerTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );

        if (prayerTime.isAfter(now)) {
          nextPrayerName.value = name;
          nextPrayerTime.value = _formatTime(timings[name]);
          final diff = prayerTime.difference(now);
          final hours = diff.inHours;
          final mins = diff.inMinutes % 60;
          timeRemaining.value = hours > 0 ? "${hours}h ${mins}m" : "${mins}m";
          return;
        }
      }

      // If all passed today, next is tomorrow's Fajr
      nextPrayerName.value = "Fajr";
      nextPrayerTime.value = _formatTime(timings['Fajr']);
      timeRemaining.value = "Tomorrow";
    } catch (e) {
      Helpers.error("Next prayer calc error: $e");
    }
  }
}
