import 'package:muslim_community/config/constants/api_constants.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? type;
  final bool isRead;
  final DateTime? createdAt;
  final String? actorId;
  final String? actorName;
  final String? actorImage;
  final String? subjectType;
  final String? subjectId;
  final String? chatId;
  final List<String> actions;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    this.isRead = false,
    this.createdAt,
    this.actorId,
    this.actorName,
    this.actorImage,
    this.subjectType,
    this.subjectId,
    this.chatId,
    this.actions = const [],
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime? created;
    if (json['createdAt'] != null) {
      created = DateTime.tryParse(json['createdAt'].toString());
    }

    final actor = json['actor'];
    String? aId;
    String? aName;
    String? aImage;
    if (actor is Map) {
      aId = actor['id']?.toString() ?? actor['_id']?.toString();
      aName = actor['name']?.toString() ?? actor['fullName']?.toString();
      final rawImg = actor['profileImage']?.toString() ??
          actor['avatar']?.toString() ??
          actor['image']?.toString();
      aImage = ApiConstants.getImageUrl(rawImg);
    }

    final subject = json['subject'];
    String? sType;
    String? sId;
    String? cId;
    if (subject is Map) {
      sType = subject['type']?.toString();
      sId = subject['id']?.toString() ?? subject['_id']?.toString();
      cId = subject['chatId']?.toString();
    }

    final actionsList = <String>[];
    if (json['actions'] is List) {
      for (var a in (json['actions'] as List)) {
        if (a is Map && a['type'] != null) {
          actionsList.add(a['type'].toString());
        } else if (a is String) {
          actionsList.add(a);
        }
      }
    }

    String title = json['title']?.toString() ?? '';
    String body = json['body']?.toString() ??
        json['message']?.toString() ??
        json['content']?.toString() ??
        '';

    if (title.isEmpty) {
      if (aName != null && aName.isNotEmpty) {
        title = aName;
      } else if (sType != null && sType.isNotEmpty) {
        title = sType;
      } else {
        title = 'Notification';
      }
    }

    if (body.isEmpty) {
      final subjectLower = (sType ?? '').toLowerCase();
      if (subjectLower.contains('connection')) {
        body = (aName != null && aName.isNotEmpty)
            ? 'Connected with you'
            : 'You have a new connection';
      } else if (subjectLower.contains('message') ||
          subjectLower.contains('chat')) {
        body = (aName != null && aName.isNotEmpty)
            ? '$aName sent you a message'
            : 'You have a new message';
      } else if (subjectLower.contains('post')) {
        body = (aName != null && aName.isNotEmpty)
            ? '$aName shared a new post'
            : 'New post in your group';
      } else if (subjectLower.contains('comment')) {
        body = (aName != null && aName.isNotEmpty)
            ? '$aName commented on a post'
            : 'New comment on a post';
      } else {
        body = 'You have a new update';
      }
    }

    return NotificationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: title,
      body: body,
      type: json['type']?.toString() ?? sType,
      isRead: json['isRead'] == true || json['read'] == true,
      createdAt: created,
      actorId: aId,
      actorName: aName,
      actorImage: aImage,
      subjectType: sType,
      subjectId: sId,
      chatId: cId,
      actions: actionsList,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    String? actorId,
    String? actorName,
    String? actorImage,
    String? subjectType,
    String? subjectId,
    String? chatId,
    List<String>? actions,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      actorId: actorId ?? this.actorId,
      actorName: actorName ?? this.actorName,
      actorImage: actorImage ?? this.actorImage,
      subjectType: subjectType ?? this.subjectType,
      subjectId: subjectId ?? this.subjectId,
      chatId: chatId ?? this.chatId,
      actions: actions ?? this.actions,
    );
  }
}
