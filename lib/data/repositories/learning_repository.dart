import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class LearningRepository {
  final ApiClient apiClient;

  LearningRepository({required this.apiClient});

  Future<Response> getLearningContents({
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (category != null) query['category'] = category;

    return await apiClient.getData(
      ApiConstants.learningContents,
      query: query,
    );
  }

  Future<Response> getKhutbahs({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.learningContents,
      query: {'category': 'khutbah', 'page': page, 'limit': limit},
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

  Future<Response> addComment(String contentId, String comment) async {
    return await apiClient.postData(
      ApiConstants.learningComments(contentId),
      {'comment': comment},
    );
  }

  Future<Response> deleteComment(String commentId) async {
    return await apiClient.deleteData(
      ApiConstants.deleteLearningComment(commentId),
    );
  }
}
