import 'package:muslim_community/config/constants/api_constants.dart';

class LearningContentModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String category;
  final int durationInSeconds;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLiked;

  LearningContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.category,
    required this.durationInSeconds,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    this.isLiked = false,
  });

  factory LearningContentModel.fromJson(Map<String, dynamic> json) {
    final rawVideoUrl = json['videoUrl'] ?? json['video'] ?? json['mediaUrl'] ?? '';
    final rawThumbUrl = json['thumbnailUrl'] ?? json['thumbnail'] ?? json['image'] ?? '';

    return LearningContentModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString().trim() ?? '',
      description: json['description']?.toString().trim() ?? '',
      videoUrl: ApiConstants.getVideoUrl(rawVideoUrl.toString()),
      thumbnailUrl: ApiConstants.getImageUrl(rawThumbUrl.toString()),
      category: json['category']?.toString().trim() ?? 'General',
      durationInSeconds: int.tryParse(json['durationInSeconds']?.toString() ?? '') ??
          int.tryParse(json['duration']?.toString() ?? '') ??
          0,
      likesCount: int.tryParse(json['likesCount']?.toString() ?? '') ??
          int.tryParse(json['likes']?.toString() ?? '') ??
          0,
      commentsCount: int.tryParse(json['commentsCount']?.toString() ?? '') ??
          int.tryParse(json['comments']?.toString() ?? '') ??
          0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isLiked: json['isLiked'] == true || json['isLiked'] == 1,
    );
  }

  LearningContentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnailUrl,
    String? category,
    int? durationInSeconds,
    int? likesCount,
    int? commentsCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return LearningContentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  String get durationText {
    if (durationInSeconds <= 0) return '';
    final minutes = (durationInSeconds / 60).floor();
    final seconds = durationInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
