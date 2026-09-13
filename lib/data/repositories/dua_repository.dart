import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class DuaRepository {
  final ApiClient apiClient;

  DuaRepository({required this.apiClient});

  Future<Response> getDuas({
    String? waqt,
    String? category,
    String? search,
    int page = 1,
    int limit = 50,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    if (waqt != null && waqt.isNotEmpty && waqt.toLowerCase() != 'all') {
      queryParams['waqt'] = waqt;
    }

    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      queryParams['category'] = category;
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    return await apiClient.getData(
      ApiConstants.duas,
      query: queryParams,
    );
  }

  Future<Response> getDuaDetails(String id) async {
    return await apiClient.getData(ApiConstants.duaDetails(id));
  }
}
