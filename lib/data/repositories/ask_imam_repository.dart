import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class AskImamRepository {
  final ApiClient apiClient;

  AskImamRepository({required this.apiClient});

  Future<Response> askQuestion({
    required String question,
    required String userRole,
  }) async {
    return await apiClient.postData(
      ApiConstants.askQuestion,
      {
        'question': question,
        'userRole': userRole,
      },
    );
  }

  Future<Response> submitQuestion({
    required String title,
    required String question,
    String? category,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'question': question,
    };
    if (category != null) body['category'] = category;

    return await apiClient.postData(ApiConstants.askQuestion, body);
  }

  Future<Response> getMyQuestions({int page = 1, int limit = 10}) async {
    return await apiClient.getData(
      ApiConstants.myQuestions,
      query: {'page': page, 'limit': limit},
    );
  }
}
