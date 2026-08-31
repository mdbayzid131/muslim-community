class PrayerGuideResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<PrayerGuideStep>? data;

  PrayerGuideResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory PrayerGuideResponse.fromJson(Map<String, dynamic> json) {
    return PrayerGuideResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => PrayerGuideStep.fromJson(i))
              .toList()
          : null,
    );
  }
}

class PrayerGuideStep {
  final String? stepKey;
  final int? order;
  final String? stepName;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final bool? isPlaceholder;
  final List<Rakat>? rakats;
  final List<Verse>? verses;

  // Compatibility getters
  String get title => stepName ?? '';
  String get arabic => arabicText ?? '';
  String get instructions => '';
  String get audioUrl =>
      (verses != null && verses!.isNotEmpty) ? verses!.first.audioUrl ?? '' : '';

  PrayerGuideStep({
    this.stepKey,
    this.order,
    this.stepName,
    this.arabicText,
    this.transliteration,
    this.translation,
    this.isPlaceholder,
    this.rakats,
    this.verses,
  });

  factory PrayerGuideStep.fromJson(Map<String, dynamic> json) {
    return PrayerGuideStep(
      stepKey: json['stepKey']?.toString(),
      order: json['order'] is int
          ? json['order']
          : int.tryParse(json['order']?.toString() ?? ''),
      stepName: json['stepName']?.toString() ?? json['title']?.toString(),
      arabicText: json['arabicText']?.toString() ?? json['arabic']?.toString(),
      transliteration: json['transliteration']?.toString(),
      translation:
          json['translation']?.toString() ?? json['english']?.toString(),
      isPlaceholder: json['isPlaceholder'] == true,
      rakats: json['rakats'] != null
          ? (json['rakats'] as List).map((i) => Rakat.fromJson(i)).toList()
          : null,
      verses: json['verses'] != null
          ? (json['verses'] as List).map((i) => Verse.fromJson(i)).toList()
          : null,
    );
  }
}

class Rakat {
  final int? rakat;
  final int? surahNumber;
  final String? surahName;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final List<WordByWord>? wordByWord;
  final String? audioUrl;
  final List<Verse>? verses;

  Rakat({
    this.rakat,
    this.surahNumber,
    this.surahName,
    this.arabicText,
    this.transliteration,
    this.translation,
    this.wordByWord,
    this.audioUrl,
    this.verses,
  });

  factory Rakat.fromJson(Map<String, dynamic> json) {
    return Rakat(
      rakat: json['rakat'] is int
          ? json['rakat']
          : int.tryParse(json['rakat']?.toString() ?? ''),
      surahNumber: json['surahNumber'] is int
          ? json['surahNumber']
          : int.tryParse(json['surahNumber']?.toString() ?? ''),
      surahName: json['surahName']?.toString(),
      arabicText: json['arabicText']?.toString(),
      transliteration: json['transliteration']?.toString(),
      translation: json['translation']?.toString(),
      wordByWord: json['wordByWord'] != null
          ? (json['wordByWord'] as List)
              .map((i) => WordByWord.fromJson(i))
              .toList()
          : null,
      audioUrl: json['audioUrl']?.toString(),
      verses: json['verses'] != null
          ? (json['verses'] as List).map((i) => Verse.fromJson(i)).toList()
          : null,
    );
  }
}

class Verse {
  final int? verseNumber;
  final String? verseKey;
  final String? arabicText;
  final String? transliteration;
  final String? translation;
  final String? audioUrl;

  Verse({
    this.verseNumber,
    this.verseKey,
    this.arabicText,
    this.transliteration,
    this.translation,
    this.audioUrl,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verseNumber: json['verseNumber'] is int
          ? json['verseNumber']
          : int.tryParse(json['verseNumber']?.toString() ?? ''),
      verseKey: json['verseKey']?.toString(),
      arabicText: json['arabicText']?.toString(),
      transliteration: json['transliteration']?.toString(),
      translation: json['translation']?.toString(),
      audioUrl: json['audioUrl']?.toString(),
    );
  }
}

class WordByWord {
  final String? arabic;
  final String? transliteration;
  final String? meaning;

  WordByWord({
    this.arabic,
    this.transliteration,
    this.meaning,
  });

  factory WordByWord.fromJson(Map<String, dynamic> json) {
    return WordByWord(
      arabic: json['arabic']?.toString(),
      transliteration: json['transliteration']?.toString(),
      meaning: json['meaning']?.toString(),
    );
  }
}

typedef PrayerGuideStepModel = PrayerGuideStep;
