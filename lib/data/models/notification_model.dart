class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? type;
  final bool isRead;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime? created;
    if (json['createdAt'] != null) {
      created = DateTime.tryParse(json['createdAt'].toString());
    }

    return NotificationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Notification',
      body: json['body']?.toString() ??
          json['message']?.toString() ??
          json['content']?.toString() ??
          '',
      type: json['type']?.toString(),
      isRead: json['isRead'] == true || json['read'] == true,
      createdAt: created,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
