import 'package:dio/dio.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/core/services/api_client.dart';

class KhutbaRepository {
  final ApiClient apiClient;

  KhutbaRepository({required this.apiClient});

  Future<Response> getKhutbahs({int page = 1, int limit = 10, String? search}) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) query['search'] = search;

    return await apiClient.getData(
      ApiConstants.khutba,
      query: query,
    );
  }

  Future<Response> getKhutbahDetails(String khutbaId) async {
    return await apiClient.getData(
      ApiConstants.khutbaDetails(khutbaId),
    );
  }
}
