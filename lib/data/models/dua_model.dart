import 'package:muslim_community/config/constants/api_constants.dart';

class DuaModel {
  final String id;
  final String title;
  final String waqt;
  final String details;
  final String arabic;
  final String transliteration;
  final String translation;
  final String audioUrl;
  final String reference;
  final String category;
  final bool isDeleted;
  final DateTime createdAt;

  DuaModel({
    required this.id,
    required this.title,
    required this.waqt,
    required this.details,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.audioUrl,
    required this.reference,
    required this.category,
    this.isDeleted = false,
    required this.createdAt,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    final rawAudio = json['audioUrl'] ?? json['audio'] ?? json['mediaUrl'] ?? '';
    final rawArabic = json['arabic'] ?? json['arabicText'] ?? json['arabic_text'] ?? '';
    final rawTransliteration = json['transliteration'] ?? json['pronunciation'] ?? '';
    final rawTranslation = json['translation'] ?? json['meaning'] ?? json['details'] ?? '';
    final rawDetails = json['details'] ?? json['description'] ?? json['meaning'] ?? '';
    final rawRef = json['reference'] ?? json['source'] ?? json['hadith'] ?? '';
    final rawCategory = json['category'] ?? json['type'] ?? 'General';

    return DuaModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString().trim() ?? '',
      waqt: json['waqt']?.toString().trim() ?? '',
      details: rawDetails.toString().trim(),
      arabic: rawArabic.toString().trim(),
      transliteration: rawTransliteration.toString().trim(),
      translation: rawTranslation.toString().trim(),
      audioUrl: ApiConstants.getVideoUrl(rawAudio.toString()),
      reference: rawRef.toString().trim(),
      category: rawCategory.toString().trim(),
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'waqt': waqt,
      'details': details,
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'audioUrl': audioUrl,
      'reference': reference,
      'category': category,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
