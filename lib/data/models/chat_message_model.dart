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
    String currentUserId, {
    String? otherParticipantId,
  }) {
    bool? isMeFlag;
    if (json['isMe'] is bool) {
      isMeFlag = json['isMe'];
    } else if (json['is_me'] is bool) {
      isMeFlag = json['is_me'];
    } else if (json['isMine'] is bool) {
      isMeFlag = json['isMine'];
    } else if (json['is_mine'] is bool) {
      isMeFlag = json['is_mine'];
    } else if (json['isSender'] is bool) {
      isMeFlag = json['isSender'];
    } else if (json['is_sender'] is bool) {
      isMeFlag = json['is_sender'];
    }

    String extractId(dynamic val) {
      if (val == null) return '';
      if (val is Map) {
        final id = val['_id'] ??
            val['id'] ??
            val['userId'] ??
            val['senderId'] ??
            val['user_id'] ??
            val['sender_id'];
        return id?.toString() ?? '';
      }
      return val.toString();
    }

    String extractName(dynamic val) {
      if (val == null) return '';
      if (val is Map) {
        final name = val['name'] ??
            val['fullName'] ??
            val['userName'] ??
            val['displayName'];
        return name?.toString() ?? '';
      }
      return val.toString();
    }

    final senderCandidate = json['sender'] ??
        json['creator'] ??
        json['user'] ??
        json['author'] ??
        json['from'] ??
        json['senderId'] ??
        json['sender_id'] ??
        json['userId'] ??
        json['user_id'];

    String sId = extractId(senderCandidate).trim();
    if (sId == 'null') sId = '';

    String sName = '';
    if (senderCandidate is Map) {
      sName = extractName(senderCandidate).trim();
    } else {
      sName = (json['senderName'] ?? json['userName'] ?? json['name'] ?? '')
          .toString()
          .trim();
    }
    if (sName.isEmpty || sName == 'null') sName = 'User';

    bool isMe = false;
    if (isMeFlag != null) {
      isMe = isMeFlag;
    } else if (sId.isNotEmpty && currentUserId.trim().isNotEmpty) {
      isMe = sId.toLowerCase() == currentUserId.trim().toLowerCase();
    } else if (sId.isNotEmpty &&
        otherParticipantId != null &&
        otherParticipantId.trim().isNotEmpty) {
      isMe = sId.toLowerCase() != otherParticipantId.trim().toLowerCase();
    } else {
      // Smart Fallback when 'sender' field is omitted from backend JSON:
      final List readByList = (json['readBy'] is List) ? json['readBy'] : [];
      final String curId = currentUserId.trim().toLowerCase();
      final String othId = (otherParticipantId ?? '').trim().toLowerCase();

      if (othId.isNotEmpty &&
          readByList.any((e) => e.toString().trim().toLowerCase() == othId)) {
        // Recipient read this message -> Sent by ME!
        isMe = true;
      } else if (curId.isNotEmpty &&
          readByList.any((e) => e.toString().trim().toLowerCase() == curId)) {
        // I read this message -> Sent by OTHER participant!
        isMe = false;
      } else {
        isMe = false;
      }
    }

    MessageStatus msgStatus = MessageStatus.sent;
    if (json['isRead'] == true ||
        (json['readBy'] is List && (json['readBy'] as List).isNotEmpty) ||
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
