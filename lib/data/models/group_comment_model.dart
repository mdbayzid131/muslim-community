import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/utils/date_formatter.dart';

class GroupCommentModel {
  final String id;
  final String content;
  final String userName;
  final String userImage;
  final String? parentCommentId;
  final String createdAt;
  final String userId;

  GroupCommentModel({
    required this.id,
    required this.content,
    required this.userName,
    required this.userImage,
    this.parentCommentId,
    required this.createdAt,
    required this.userId,
  });

  factory GroupCommentModel.fromJson(Map<String, dynamic> json) {
    final rawUser = json['userId'] ?? json['user'];
    String name = 'User';
    String image = '';
    String uId = '';

    if (rawUser is Map) {
      name = rawUser['name'] ?? rawUser['fullName'] ?? 'User';
      image = rawUser['profileImage'] ?? '';
      uId = rawUser['id'] ?? rawUser['_id'] ?? '';
    } else if (rawUser is String) {
      name = json['userName'] ?? 'User';
      image = json['userImage'] ?? '';
      uId = rawUser;
    } else {
      uId = json['userId']?.toString() ?? '';
    }

    if (image.isNotEmpty) {
      image = ApiConstants.getImageUrl(image);
    }

    return GroupCommentModel(
      id: json['id'] ?? json['_id'] ?? '',
      content: json['comment'] ?? json['content'] ?? '',
      userName: name,
      userImage: image,
      parentCommentId: json['parentCommentId'],
      createdAt: DateFormatter.formatPostTime(json['createdAt'] ?? ''),
      userId: uId,
    );
  }
}
