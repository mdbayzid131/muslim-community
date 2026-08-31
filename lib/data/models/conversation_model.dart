import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/utils/date_formatter.dart';

class ConversationModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isVerified;
  final bool isGroup;
  final String imageUrl;
  final String? participantId;
  final bool isOnline;
  final DateTime? timestamp;

  ConversationModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isVerified = false,
    this.isGroup = false,
    this.imageUrl = '',
    this.participantId,
    this.isOnline = false,
    this.timestamp,
  });

  String get userName => name;
  String get userImage => imageUrl;

  factory ConversationModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    final List<dynamic> participants = json['participants'] ?? [];

    Map<String, dynamic>? otherParticipant;
    if (participants.isNotEmpty) {
      for (var p in participants) {
        final pid = p['id'] ?? p['_id'] ?? p['userId'];
        if (pid != null && pid.toString() != currentUserId) {
          otherParticipant = p;
          break;
        }
      }
      otherParticipant ??= participants[0];
    }

    final lastMsgObj = json['lastMessage'];
    String lastText = 'No messages yet';
    DateTime? rawTimestamp;

    if (lastMsgObj is Map) {
      lastText =
          lastMsgObj['text'] ?? lastMsgObj['content'] ?? 'No messages yet';
      if (lastMsgObj['createdAt'] != null) {
        rawTimestamp = DateTime.tryParse(lastMsgObj['createdAt'].toString());
      }
    } else if (json['updatedAt'] != null) {
      rawTimestamp = DateTime.tryParse(json['updatedAt'].toString());
    } else if (json['createdAt'] != null) {
      rawTimestamp = DateTime.tryParse(json['createdAt'].toString());
    }

    String uImage = otherParticipant?['profileImage']?.toString() ??
        otherParticipant?['image']?.toString() ??
        otherParticipant?['avatar']?.toString() ??
        otherParticipant?['profile_image']?.toString() ??
        '';

    if (uImage.isNotEmpty) {
      uImage = ApiConstants.getImageUrl(uImage);
    }

    final online = otherParticipant?['isOnline'] == true ||
        otherParticipant?['online'] == true;

    return ConversationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: otherParticipant?['name']?.toString() ??
          otherParticipant?['fullName']?.toString() ??
          'Unknown',
      lastMessage: lastText,
      time: rawTimestamp != null
          ? DateFormatter.formatChatTime(rawTimestamp.toIso8601String())
          : '',
      unreadCount: json['unreadCount'] ?? 0,
      imageUrl: uImage,
      participantId: otherParticipant?['id']?.toString() ??
          otherParticipant?['_id']?.toString() ??
          otherParticipant?['userId']?.toString(),
      isOnline: online,
      timestamp: rawTimestamp,
    );
  }
}
