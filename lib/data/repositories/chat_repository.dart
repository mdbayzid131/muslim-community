import 'dart:io';
import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class ChatRepository {
  final ApiClient apiClient;

  ChatRepository({required this.apiClient});

  Future<Response> getChats() async {
    return await apiClient.getData(ApiConstants.chats);
  }

  Future<Response> getChatList() async {
    return await getChats();
  }

  Future<Response> getChatMessages(String chatId,
      {int page = 1, int limit = 50, String? cursor}) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (cursor != null) query['cursor'] = cursor;

    return await apiClient.getData(
      ApiConstants.chatMessages(chatId),
      query: query,
    );
  }

  Future<Response> getMessages({required String chatId, String? cursor}) async {
    return await getChatMessages(chatId, cursor: cursor);
  }

  Future<Response> sendMessage({
    required String chatId,
    required String message,
    String? recipientId,
  }) async {
    final body = <String, dynamic>{
      'chatId': chatId,
      'text': message,
      'content': message,
    };
    if (recipientId != null) body['recipientId'] = recipientId;

    return await apiClient.postData(ApiConstants.messages, body);
  }

  Future<Response> sendImageMessage({
    required String chatId,
    required String filePath,
    String? recipientId,
  }) async {
    final body = <String, dynamic>{'chatId': chatId, 'type': 'image'};
    if (recipientId != null) body['recipientId'] = recipientId;

    return await apiClient.postMultipartData(
      ApiConstants.messages,
      body,
      multipartBody: [MultipartBody('image', File(filePath))],
    );
  }

  Future<Response> markChatAsRead(String chatId) async {
    return await apiClient.patchData(ApiConstants.markChatRead(chatId), {});
  }
}
