import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/services/socket_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/chat_message_model.dart';
import 'package:muslim_community/data/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository;

  ChatController({required this.chatRepository});

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final messages = <ChatMessageModel>[].obs;
  final isLoading = false.obs;
  final isOtherUserOnline = false.obs;
  final hasNextPage = false.obs;
  final isMoreLoading = false.obs;

  String? currentChatId;
  String? otherParticipantId;
  String? nextCursor;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isMoreLoading.value &&
        hasNextPage.value) {
      if (currentChatId != null) {
        loadMoreMessages(currentChatId!);
      }
    }
  }

  void setupSocket(String chatId, {bool initialOnline = false}) {
    currentChatId = chatId;
    isOtherUserOnline.value = initialOnline;
    final socket = Get.find<SocketService>();

    // Clear any previous listeners
    _cleanupSocketListeners(socket);

    void joinRoom() {
      try {
        socket.emit('JOIN_CHAT', {'chatId': chatId});
        socket.emit('join', {'chatId': chatId});
        socket.emit('join_chat', chatId);
        socket.emit('join-chat', chatId);
        socket.emit('joinRoom', chatId);
        socket.emit('join_room', chatId);
        socket.emit('join_room', {'chatId': chatId, 'roomId': chatId});
      } catch (e) {
        Helpers.debug('Error joining room: $e');
      }
    }

    if (!socket.isConnected) {
      socket.connect().then((_) {
        joinRoom();
      }).catchError((e) {
        Helpers.debug('Socket connect error in setupSocket: $e');
      });
    } else {
      joinRoom();
    }

    void handleIncomingMessage(dynamic data) {
      if (data == null) return;
      try {
        dynamic msgData = data;
        if (data is Map) {
          if (data['data'] is Map) {
            msgData = data['data'];
          } else if (data['message'] is Map) {
            msgData = data['message'];
          }
        }

        final currentUserId = Get.find<AuthService>().userId;
        final newMsg = ChatMessageModel.fromJson(
          Map<String, dynamic>.from(msgData is Map ? msgData : {}),
          currentUserId,
          otherParticipantId: otherParticipantId,
        );

        final idx = messages.indexWhere((m) =>
            m.id == newMsg.id ||
            (m.id.startsWith('temp_') && m.text == newMsg.text && m.isMe));

        if (idx != -1) {
          messages[idx] = newMsg;
          messages.refresh();
        } else {
          final msgChatId = (msgData['chatId'] ?? msgData['chatid'] ?? msgData['conversationId'] ?? '').toString();
          if (msgChatId.isEmpty || msgChatId == currentChatId) {
            messages.insert(0, newMsg);
          }
        }
      } catch (e) {
        Helpers.debug('Error handling incoming socket message: $e');
      }
    }

    // Register all standard real-time message events
    socket.on('MESSAGE_SENT', handleIncomingMessage);
    socket.on('message_sent', handleIncomingMessage);
    socket.on('NEW_MESSAGE', handleIncomingMessage);
    socket.on('new_message', handleIncomingMessage);
    socket.on('new-message', handleIncomingMessage);
    socket.on('message', handleIncomingMessage);
    socket.on('receive_message', handleIncomingMessage);

    // Online / Offline Status
    socket.on('USER_ONLINE', (data) => isOtherUserOnline.value = true);
    socket.on('user_online', (data) => isOtherUserOnline.value = true);
    socket.on('USER_OFFLINE', (data) => isOtherUserOnline.value = false);
    socket.on('user_offline', (data) => isOtherUserOnline.value = false);
  }

  void _cleanupSocketListeners(SocketService socket) {
    socket.off('MESSAGE_SENT');
    socket.off('message_sent');
    socket.off('NEW_MESSAGE');
    socket.off('new_message');
    socket.off('new-message');
    socket.off('message');
    socket.off('receive_message');
    socket.off('USER_ONLINE');
    socket.off('user_online');
    socket.off('USER_OFFLINE');
    socket.off('user_offline');
  }

  Future<void> fetchMessages(String chatId, {String? participantId}) async {
    isLoading.value = true;
    currentChatId = chatId;
    if (participantId != null && participantId.isNotEmpty) {
      otherParticipantId = participantId;
    }
    try {
      final response = await chatRepository.getMessages(chatId: chatId);
      if (response.statusCode == 200) {
        dynamic rawData = response.data['data'];
        List list = [];
        if (rawData is List) {
          list = rawData;
        } else if (rawData is Map) {
          list = (rawData['messages'] is List) ? rawData['messages'] : [];
        } else if (response.data is List) {
          list = response.data;
        }

        final currentUserId = Get.find<AuthService>().userId;
        final parsedMessages = list
            .map((e) => ChatMessageModel.fromJson(
                  e,
                  currentUserId,
                  otherParticipantId: otherParticipantId,
                ))
            .toList();

        // Sort descending by timestamp so newest is at index 0 (matching reverse: true ListView)
        parsedMessages.sort((a, b) {
          final tA = a.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
          final tB = b.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
          return tB.compareTo(tA);
        });

        messages.value = parsedMessages;

        final meta = response.data['meta'] ??
            (rawData is Map ? rawData['pagination'] : null);
        if (meta is Map) {
          hasNextPage.value = meta['hasNextPage'] ?? (meta['hasNext'] ?? false);
          nextCursor = meta['nextCursor']?.toString();
        }
      }
    } catch (e) {
      Helpers.error("Fetch messages error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreMessages(String chatId) async {
    if (nextCursor == null) return;
    isMoreLoading.value = true;
    try {
      final response = await chatRepository.getMessages(
        chatId: chatId,
        cursor: nextCursor,
      );
      if (response.statusCode == 200) {
        dynamic rawData = response.data['data'];
        List list = [];
        if (rawData is List) {
          list = rawData;
        } else if (rawData is Map) {
          list = (rawData['messages'] is List) ? rawData['messages'] : [];
        } else if (response.data is List) {
          list = response.data;
        }

        final currentUserId = Get.find<AuthService>().userId;
        final more = list
            .map((e) => ChatMessageModel.fromJson(
                  e,
                  currentUserId,
                  otherParticipantId: otherParticipantId,
                ))
            .toList();

        more.sort((a, b) {
          final tA = a.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
          final tB = b.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
          return tB.compareTo(tA);
        });

        messages.addAll(more);

        final meta = response.data['meta'] ??
            (rawData is Map ? rawData['pagination'] : null);
        if (meta is Map) {
          hasNextPage.value = meta['hasNextPage'] ?? (meta['hasNext'] ?? false);
          nextCursor = meta['nextCursor']?.toString();
        }
      }
    } catch (e) {
      Helpers.error("Load more messages error: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> sendMessage(String chatId) async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    // Optimistic message
    final tempId = "temp_${DateTime.now().millisecondsSinceEpoch}";
    final tempMsg = ChatMessageModel(
      id: tempId,
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
      status: 'sending',
    );
    messages.insert(0, tempMsg);

    try {
      final response = await chatRepository.sendMessage(
        chatId: chatId,
        message: text,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        final currentUserId = Get.find<AuthService>().userId;
        final serverMsg = ChatMessageModel.fromJson(
          data,
          currentUserId,
          otherParticipantId: otherParticipantId,
        );

        final idx = messages.indexWhere((m) => m.id == tempId);
        if (idx != -1) {
          messages[idx] = serverMsg;
          messages.refresh();
        }
      }
    } catch (e) {
      Helpers.error("Send message error: $e");
    }
  }

  @override
  void onClose() {
    if (Get.isRegistered<SocketService>()) {
      _cleanupSocketListeners(Get.find<SocketService>());
    }
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
