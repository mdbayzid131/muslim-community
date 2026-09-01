import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/services/socket_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/conversation_model.dart';
import 'package:muslim_community/data/repositories/chat_repository.dart';

class MessagesController extends GetxController {
  final ChatRepository chatRepository;

  MessagesController({required this.chatRepository});

  final conversations = <ConversationModel>[].obs;
  final filteredConversations = <ConversationModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    if (!Get.isRegistered<SocketService>()) return;
    final socket = Get.find<SocketService>();

    void onNewMessage(dynamic data) {
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

        final chatId = (msgData['chatId'] ??
                msgData['chatid'] ??
                msgData['conversationId'] ??
                msgData['id'])
            ?.toString();
        final text = (msgData['text'] ??
                msgData['content'] ??
                msgData['message'] ??
                '')
            ?.toString();

        if (chatId != null && chatId.isNotEmpty) {
          final idx = conversations.indexWhere((c) => c.id == chatId);
          if (idx != -1) {
            final old = conversations[idx];
            final updated = ConversationModel(
              id: old.id,
              name: old.name,
              lastMessage: (text != null && text.isNotEmpty)
                  ? text
                  : old.lastMessage,
              time: 'Just now',
              unreadCount: old.unreadCount + 1,
              imageUrl: old.imageUrl,
              participantId: old.participantId,
              isOnline: old.isOnline,
              isVerified: old.isVerified,
              isGroup: old.isGroup,
              timestamp: DateTime.now(),
            );
            conversations.removeAt(idx);
            conversations.insert(0, updated);
            searchMessages(searchQuery.value);
          } else {
            // New conversation arrived, refresh list from server
            fetchChatList();
          }
        }
      } catch (e) {
        Helpers.debug('Error processing socket message in MessagesController: $e');
      }
    }

    socket.on('NEW_MESSAGE', onNewMessage);
    socket.on('new_message', onNewMessage);
    socket.on('MESSAGE_SENT', onNewMessage);
    socket.on('message_sent', onNewMessage);
    socket.on('receive_message', onNewMessage);
  }

  Future<void> fetchChatList() async {
    isLoading.value = true;
    try {
      final response = await chatRepository.getChatList();
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        final currentUserId =
            Get.find<AuthService>().currentUser.value?.id ?? '';
        final parsed = list
            .map((json) => ConversationModel.fromJson(json, currentUserId))
            .toList();

        conversations.value = parsed;
        searchMessages(searchQuery.value);
      }
    } catch (e) {
      Helpers.error("Fetch chat list error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchMessages(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredConversations.assignAll(conversations);
    } else {
      filteredConversations.assignAll(
        conversations.where(
          (c) => c.userName.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  @override
  void onClose() {
    if (Get.isRegistered<SocketService>()) {
      final socket = Get.find<SocketService>();
      socket.off('NEW_MESSAGE');
      socket.off('new_message');
      socket.off('MESSAGE_SENT');
      socket.off('message_sent');
      socket.off('receive_message');
    }
    super.onClose();
  }
}
