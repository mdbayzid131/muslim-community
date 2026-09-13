import 'package:muslim_community/config/constants/api_constants.dart';

class LearningCommentModel {
  final String id;
  final String content;
  final String userName;
  final String userImage;
  final String? parentCommentId;
  final DateTime createdAt;
  final String userId;

  LearningCommentModel({
    required this.id,
    required this.content,
    required this.userName,
    required this.userImage,
    this.parentCommentId,
    required this.createdAt,
    required this.userId,
  });

  factory LearningCommentModel.fromJson(Map<String, dynamic> json) {
    final rawUser = json['user'] ?? json['userId'] ?? json['author'];
    String name = 'Anonymous';
    String image = '';
    String uId = '';

    if (rawUser is Map) {
      name = rawUser['name'] ?? rawUser['fullName'] ?? rawUser['username'] ?? 'Anonymous';
      image = rawUser['profileImage'] ?? rawUser['avatar'] ?? rawUser['image'] ?? '';
      uId = rawUser['_id']?.toString() ?? rawUser['id']?.toString() ?? '';
    } else if (rawUser is String) {
      name = json['userName'] ?? json['name'] ?? 'Anonymous';
      image = json['userImage'] ?? json['profileImage'] ?? '';
      uId = rawUser;
    } else {
      name = json['userName'] ?? json['name'] ?? 'Anonymous';
      image = json['userImage'] ?? json['profileImage'] ?? '';
      uId = json['userId']?.toString() ?? json['_id']?.toString() ?? '';
    }

    return LearningCommentModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      content: json['comment']?.toString().trim() ??
          json['content']?.toString().trim() ??
          json['text']?.toString().trim() ??
          '',
      userName: name.trim().isEmpty ? 'Anonymous' : name.trim(),
      userImage: ApiConstants.getImageUrl(image),
      parentCommentId: json['parentCommentId']?.toString() ?? json['parentId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      userId: uId,
    );
  }
}
