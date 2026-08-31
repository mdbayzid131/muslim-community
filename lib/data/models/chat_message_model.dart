import 'package:muslim_community/core/utils/date_formatter.dart';

enum MessageStatus { sent, delivered, read }

class ChatConversationModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String? imageUrl;
  final int unreadCount;
  final bool isVerified;
  final bool isOnline;

  ChatConversationModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.imageUrl,
    this.unreadCount = 0,
    this.isVerified = false,
    this.isOnline = false,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json['participant'] ?? json['recipient'] ?? {};
    final lastMsg = json['lastMessage'] ?? json['message'] ?? '';

    return ChatConversationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: user is Map
          ? (user['name'] ?? user['fullName'] ?? 'Brother').toString()
          : (json['name'] ?? 'Brother').toString(),
      lastMessage: lastMsg is Map
          ? (lastMsg['text'] ?? lastMsg['content'] ?? '').toString()
          : lastMsg.toString(),
      time: DateFormatter.formatChatTime(
          json['updatedAt'] ?? json['createdAt'] ?? ''),
      imageUrl: user is Map ? user['profileImage']?.toString() : null,
      unreadCount: json['unreadCount'] is int
          ? json['unreadCount']
          : int.tryParse(json['unreadCount']?.toString() ?? '0') ?? 0,
      isVerified: user is Map && (user['isVerified'] == true),
      isOnline: user is Map && (user['isOnline'] == true),
    );
  }
}

class ChatMessageModel {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  final String? senderId;
  final String? senderName;
  final DateTime? timestamp;
  MessageStatus status;

  ChatMessageModel({
    required this.id,
    required this.text,
    String? time,
    required this.isMe,
    this.senderId,
    this.senderName,
    this.timestamp,
    dynamic status = MessageStatus.sent,
  })  : time = time ??
            DateFormatter.formatChatTime(
                timestamp?.toIso8601String() ?? DateTime.now().toIso8601String()),
        status = status is MessageStatus
            ? status
            : (status.toString().toLowerCase() == 'delivered'
                ? MessageStatus.delivered
                : (status.toString().toLowerCase() == 'read'
                    ? MessageStatus.read
                    : MessageStatus.sent));

  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    String sId = (json['senderId'] ??
            json['userId'] ??
            json['creatorId'] ??
            json['from'] ??
            '')
        .toString();
    String sName = (json['senderName'] ?? json['userName'] ?? '').toString();

    final senderData =
        json['sender'] ?? json['creator'] ?? json['user'] ?? json['author'];

    if (senderData is Map) {
      final idValue =
          senderData['id'] ?? senderData['_id'] ?? senderData['userId'];
      if (idValue != null) sId = idValue.toString();

      final nameValue = senderData['name'] ??
          senderData['fullName'] ??
          senderData['userName'];
      if (nameValue != null) sName = nameValue.toString();
    } else if (senderData is String && sId.isEmpty) {
      sId = senderData;
    }

    if (sId.isEmpty || sId == 'null') {
      json.forEach((key, value) {
        if (value is String &&
            value.length == 24 &&
            RegExp(r'^[0-9a-fA-F]+$').hasMatch(value)) {
          final lowKey = key.toLowerCase();
          if (lowKey.contains('id') ||
              lowKey.contains('user') ||
              lowKey.contains('sender') ||
              lowKey.contains('creator') ||
              lowKey.contains('from')) {
            sId = value;
          }
        }
      });
    }

    sId = sId.trim();
    if (sId == 'null' || sId.isEmpty) sId = '';
    if (sName.isEmpty || sName == 'null') sName = 'User';

    bool isMe = false;
    if (sId.isNotEmpty && currentUserId.isNotEmpty) {
      isMe = sId.toLowerCase() == currentUserId.trim().toLowerCase();
    }

    MessageStatus msgStatus = MessageStatus.sent;
    if (json['isRead'] == true ||
        (json['readBy'] != null && (json['readBy'] as List).isNotEmpty) ||
        json['status'] == 'read') {
      msgStatus = MessageStatus.read;
    } else if (json['isDelivered'] == true ||
        json['deliveredAt'] != null ||
        json['status'] == 'delivered') {
      msgStatus = MessageStatus.delivered;
    }

    DateTime? createdTime;
    if (json['createdAt'] != null) {
      createdTime = DateTime.tryParse(json['createdAt'].toString());
    }

    return ChatMessageModel(
      id: (json['id'] ??
              json['_id'] ??
              json['messageId'] ??
              DateTime.now().millisecondsSinceEpoch.toString())
          .toString(),
      text: (json['text'] ?? json['content'] ?? json['message'] ?? '')
          .toString(),
      time: DateFormatter.formatChatTime(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isMe: isMe,
      senderId: sId,
      senderName: sName,
      timestamp: createdTime ?? DateTime.now(),
      status: msgStatus,
    );
  }

  factory ChatMessageModel.optimistic({
    required String text,
    required String myId,
    required String myName,
  }) {
    final now = DateTime.now();
    return ChatMessageModel(
      id: 'temp_${now.millisecondsSinceEpoch}',
      text: text,
      time: DateFormatter.formatChatTime(now.toIso8601String()),
      isMe: true,
      senderId: myId,
      senderName: myName,
      timestamp: now,
      status: MessageStatus.sent,
    );
  }
}
