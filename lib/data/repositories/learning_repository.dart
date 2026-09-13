import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class LearningRepository {
  final ApiClient apiClient;

  LearningRepository({required this.apiClient});

  Future<Response> getLearningContents({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      query['category'] = category;
    }
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    return await apiClient.getData(
      ApiConstants.learningContents,
      query: query,
    );
  }

  Future<Response> getContentDetails(String contentId) async {
    return await apiClient.getData(
      ApiConstants.learningContentDetails(contentId),
    );
  }

  Future<Response> getKhutbahs({int page = 1, int limit = 10, String? search}) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) query['search'] = search;

    return await apiClient.getData(
      ApiConstants.khutba,
      query: query,
    );
  }

  Future<Response> getPrayerGuide(String waqt) async {
    return await apiClient.getData(
      ApiConstants.namazGuide(waqt),
    );
  }

  Future<Response> likeContent(String contentId) async {
    return await apiClient.postData(
      ApiConstants.likeLearningContent(contentId),
      {},
    );
  }

  Future<Response> getComments(String contentId) async {
    return await apiClient.getData(
      ApiConstants.learningComments(contentId),
    );
  }

  Future<Response> addComment(
    String contentId,
    String comment, {
    String? parentCommentId,
  }) async {
    final Map<String, dynamic> data = {'comment': comment};
    if (parentCommentId != null && parentCommentId.isNotEmpty) {
      data['parentCommentId'] = parentCommentId;
    }
    return await apiClient.postData(
      ApiConstants.learningComments(contentId),
      data,
    );
  }

  Future<Response> deleteComment(String commentId) async {
    return await apiClient.deleteData(
      ApiConstants.deleteLearningComment(commentId),
    );
  }
}
