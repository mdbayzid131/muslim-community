import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muslim_community/app_config.dart';
import 'package:muslim_community/services/tokenservice.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class FemaleGetAllGroupService {
  final TokenService _tokenService = TokenService();

  Future<http.Response> getAllGroups() async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse(AppConfig.groupsEndpoint);

    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> getGroupPosts(String groupId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse("${AppConfig.groupsEndpoint}/$groupId/posts");

    return await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> joinGroup(String groupId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.groupsEndpoint}/$groupId/join');

    return await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> leaveGroup(String groupId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.groupsEndpoint}/$groupId/leave');

    return await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> createGroupPost(
    String groupId,
    String content, {
    List<String>? imagePaths,
  }) async {
    final token = await _tokenService.getToken();
    // Using the specific path shown in screenshot: {{baseUrl}}/groups/{{groupId}}/posts
    final uri = Uri.parse("${AppConfig.groupsEndpoint}/$groupId/posts");

    // If no images, use regular JSON post
    if (imagePaths == null || imagePaths.isEmpty) {
      return await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'content': content, 'attachments': []}),
      );
    }

    // If images present, use MultipartRequest
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({'Authorization': 'Bearer $token'});

    request.fields['content'] = content;

    for (String path in imagePaths) {
      final mimeTypeData = lookupMimeType(path)?.split('/');
      final mimeType = mimeTypeData != null ? mimeTypeData[0] : 'image';
      final mimeSubType = mimeTypeData != null ? mimeTypeData[1] : 'jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          'attachments',
          path,
          contentType: MediaType(mimeType, mimeSubType),
        ),
      );
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> deletePost(String postId) async {
    final token = await _tokenService.getToken();
    final url = AppConfig.deletePostEndpoint.replaceAll('{postId}', postId);
    final uri = Uri.parse(url);

    return await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> deleteComment(String commentId) async {
    final token = await _tokenService.getToken();
    final url = AppConfig.deleteCommentEndpoint.replaceAll(
      '{commentId}',
      commentId,
    );
    final uri = Uri.parse(url);

    return await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> likePost(String postId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.groupPostsEndpoint}/$postId/like');

    return await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> getPostComments(String postId) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.groupPostsEndpoint}/$postId/comments');

    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> addPostComment(
    String postId,
    String comment, {
    String? parentCommentId,
  }) async {
    final token = await _tokenService.getToken();
    final uri = Uri.parse('${AppConfig.groupPostsEndpoint}/$postId/comments');

    return await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'comment': comment,
        if (parentCommentId != null) 'parentCommentId': parentCommentId,
      }),
    );
  }
}
