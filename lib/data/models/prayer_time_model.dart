class PrayerTimeModel {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String? hijriDate;
  final String? gregorianDate;
  final String? weekday;

  PrayerTimeModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.hijriDate,
    this.gregorianDate,
    this.weekday,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] ?? json;
    return PrayerTimeModel(
      fajr: timings['Fajr'] ?? timings['fajr'] ?? '',
      sunrise: timings['Sunrise'] ?? timings['sunrise'] ?? '',
      dhuhr: timings['Dhuhr'] ?? timings['dhuhr'] ?? '',
      asr: timings['Asr'] ?? timings['asr'] ?? '',
      maghrib: timings['Maghrib'] ?? timings['maghrib'] ?? '',
      isha: timings['Isha'] ?? timings['isha'] ?? '',
      hijriDate: json['hijriDate'] ?? json['date']?['hijri']?['date'],
      gregorianDate: json['gregorianDate'] ?? json['date']?['readable'],
      weekday: json['weekday'] ?? json['date']?['gregorian']?['weekday']?['en'],
    );
  }

  Map<String, String> toMap() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }
}
