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

  void setupSocket(String chatId) {
    currentChatId = chatId;
    final socket = Get.find<SocketService>();

    socket.emit('JOIN_CHAT', {'chatId': chatId});

    socket.on('MESSAGE_SENT', (data) {
      if (data != null) {
        final currentUserId =
            Get.find<AuthService>().currentUser.value?.id ?? '';
        final newMsg = ChatMessageModel.fromJson(data, currentUserId);

        final idx = messages.indexWhere((m) =>
            m.id == newMsg.id ||
            (m.id.startsWith('temp_') && m.text == newMsg.text && m.isMe));

        if (idx != -1) {
          messages[idx] = newMsg;
          messages.refresh();
        } else {
          final msgChatId = (data['chatId'] ?? data['chatid'] ?? '').toString();
          if (msgChatId.isEmpty || msgChatId == currentChatId) {
            messages.insert(0, newMsg);
          }
        }
      }
    });

    socket.on('USER_ONLINE', (data) {
      isOtherUserOnline.value = true;
    });

    socket.on('USER_OFFLINE', (data) {
      isOtherUserOnline.value = false;
    });
  }

  Future<void> fetchMessages(String chatId) async {
    isLoading.value = true;
    currentChatId = chatId;
    try {
      final response = await chatRepository.getMessages(chatId: chatId);
      if (response.statusCode == 200) {
        final List list = response.data['data']?['messages'] ??
            response.data['data'] ??
            response.data ??
            [];
        final currentUserId =
            Get.find<AuthService>().currentUser.value?.id ?? '';
        messages.value =
            list.map((e) => ChatMessageModel.fromJson(e, currentUserId)).toList();

        final pagination = response.data['data']?['pagination'];
        if (pagination != null) {
          hasNextPage.value = pagination['hasNextPage'] ?? false;
          nextCursor = pagination['nextCursor'];
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
        final List list = response.data['data']?['messages'] ?? [];
        final currentUserId =
            Get.find<AuthService>().currentUser.value?.id ?? '';
        final more =
            list.map((e) => ChatMessageModel.fromJson(e, currentUserId)).toList();
        messages.addAll(more);

        final pagination = response.data['data']?['pagination'];
        if (pagination != null) {
          hasNextPage.value = pagination['hasNextPage'] ?? false;
          nextCursor = pagination['nextCursor'];
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
        final currentUserId =
            Get.find<AuthService>().currentUser.value?.id ?? '';
        final serverMsg = ChatMessageModel.fromJson(data, currentUserId);

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
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
