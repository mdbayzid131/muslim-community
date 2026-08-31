import 'dart:io';
import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class GroupRepository {
  final ApiClient apiClient;

  GroupRepository({required this.apiClient});

  Future<Response> getGroups() async {
    return await apiClient.getData(ApiConstants.groups);
  }

  Future<Response> getAllGroups() async {
    return await getGroups();
  }

  Future<Response> joinGroup(String groupId) async {
    return await apiClient.postData(
      '${ApiConstants.groups}/$groupId/join',
      {},
    );
  }

  Future<Response> leaveGroup(String groupId) async {
    return await apiClient.postData(
      '${ApiConstants.groups}/$groupId/leave',
      {},
    );
  }

  Future<Response> getGroupPosts(String groupId) async {
    return await apiClient.getData('${ApiConstants.groups}/$groupId/posts');
  }

  Future<Response> createGroupPost({
    required String groupId,
    required String content,
    List<File>? attachments,
  }) async {
    final endpoint = '${ApiConstants.groups}/$groupId/posts';
    if (attachments != null && attachments.isNotEmpty) {
      final multipartList = attachments
          .map((file) => MultipartBody('attachments', file))
          .toList();
      return await apiClient.postMultipartData(
        endpoint,
        {'content': content},
        multipartBody: multipartList,
      );
    }

    return await apiClient.postData(
      endpoint,
      {
        'content': content,
        'attachments': [],
      },
    );
  }

  Future<Response> createPost({
    required String groupId,
    required String content,
    List<File>? attachments,
  }) async {
    return await createGroupPost(
      groupId: groupId,
      content: content,
      attachments: attachments,
    );
  }

  Future<Response> deletePost(String postId) async {
    return await apiClient.deleteData('${ApiConstants.groupPosts}/$postId');
  }

  Future<Response> likePost(String postId) async {
    return await apiClient.postData(
      '${ApiConstants.groupPosts}/$postId/like',
      {},
    );
  }

  Future<Response> unlikePost(String postId) async {
    return await apiClient.postData(
      '${ApiConstants.groupPosts}/$postId/unlike',
      {},
    );
  }

  Future<Response> getPostComments(String postId) async {
    return await apiClient.getData('${ApiConstants.groupPosts}/$postId/comments');
  }

  Future<Response> createComment({
    required String postId,
    required String comment,
    String? parentCommentId,
  }) async {
    final body = <String, dynamic>{'comment': comment};
    if (parentCommentId != null && parentCommentId.isNotEmpty) {
      body['parentCommentId'] = parentCommentId;
    }

    return await apiClient.postData(
      '${ApiConstants.groupPosts}/$postId/comments',
      body,
    );
  }

  Future<Response> addComment({
    required String postId,
    required String comment,
    String? parentCommentId,
  }) async {
    return await createComment(
      postId: postId,
      comment: comment,
      parentCommentId: parentCommentId,
    );
  }

  Future<Response> deleteComment(String commentId) async {
    return await apiClient.deleteData('${ApiConstants.groups}/comments/$commentId');
  }
}
