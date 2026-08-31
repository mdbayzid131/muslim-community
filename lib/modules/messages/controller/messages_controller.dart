import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
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
        filteredConversations.assignAll(parsed);
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
}
