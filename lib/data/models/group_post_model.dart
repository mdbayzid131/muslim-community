import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/utils/date_formatter.dart';

class GroupPostModel {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String userImage;
  final String content;
  final List<String> attachments;
  final int likesCount;
  final int commentsCount;
  final bool isPinned;
  final bool isLiked;
  final String createdAt;

  GroupPostModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.attachments,
    required this.likesCount,
    required this.commentsCount,
    required this.isPinned,
    required this.isLiked,
    required this.createdAt,
  });

  List<String> get images => attachments;
  int get likeCount => likesCount;
  int get commentCount => commentsCount;

  GroupPostModel copyWith({
    String? id,
    String? groupId,
    String? userId,
    String? userName,
    String? userImage,
    String? content,
    List<String>? attachments,
    int? likesCount,
    int? commentsCount,
    bool? isPinned,
    bool? isLiked,
    String? createdAt,
  }) {
    return GroupPostModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isPinned: isPinned ?? this.isPinned,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory GroupPostModel.fromJson(Map<String, dynamic> json) {
    final userVal =
        json['userId'] ?? json['user'] ?? json['author'] ?? json['creator'];
    String uId = '';
    String uName = 'User';
    String uImage = '';

    if (userVal is Map) {
      uId = userVal['id']?.toString() ?? userVal['_id']?.toString() ?? '';
      uName = userVal['name']?.toString() ??
          userVal['username']?.toString() ??
          'User';
      uImage = userVal['profileImage']?.toString() ??
          userVal['image']?.toString() ??
          userVal['avatar']?.toString() ??
          '';
    } else if (userVal is String) {
      uId = userVal;
    }

    if (uImage.isNotEmpty) {
      uImage = ApiConstants.getImageUrl(uImage);
    }

    List<String> imagesList = [];
    if (json['images'] is List) {
      imagesList = (json['images'] as List)
          .map((e) => ApiConstants.getImageUrl(e.toString()))
          .toList();
    } else if (json['attachments'] is List) {
      imagesList = (json['attachments'] as List)
          .map((e) => ApiConstants.getImageUrl(e.toString()))
          .toList();
    }

    return GroupPostModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      groupId: json['groupId']?.toString() ?? '',
      userId: uId,
      userName: uName,
      userImage: uImage,
      content: json['content']?.toString() ?? '',
      attachments: imagesList,
      likesCount: json['likesCount'] is int
          ? json['likesCount']
          : int.tryParse(json['likesCount']?.toString() ?? json['likeCount']?.toString() ?? '0') ?? 0,
      commentsCount: json['commentsCount'] is int
          ? json['commentsCount']
          : int.tryParse(json['commentsCount']?.toString() ?? json['commentCount']?.toString() ?? '0') ?? 0,
      isPinned: json['isPinned'] == true,
      isLiked: json['isLiked'] == true,
      createdAt:
          DateFormatter.formatPostTime(json['createdAt']?.toString() ?? ''),
    );
  }
}
